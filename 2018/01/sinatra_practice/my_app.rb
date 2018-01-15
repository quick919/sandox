require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'securerandom'
require 'erb'

configure do
  DB = Sequel.sqlite('databasepath',{})
  unless DB.table_exists?(:items)  
    DB.create_table :items do
      unrestrict_primary_key :id
      String :text
      DateTime :create_date
      DateTime :update_date
     end
  end

  set :items, DB[:items]
end

helpers do
  def output_article
    file_data = nil
    File.open('views/article.erb') do |file|
      file_data = file.read
    end
    ERB.new(file_data).result(binding)
  end
end

get '/' do
  @arr = settings.items.order(:create_date).all
  erb :index
end

post '/item/create' do
  now = Time.now
  data = {id: SecureRandom.uuid, text: params[:form], create_date: now, update_date: now}
  settings.items.insert(data)
  arr = settings.items.order(:create_date).all
  @arr = arr
  output_article
end

post '/item/delete' do
  id = params[:id]
  settings.items.where({id: id}).delete
  status 200
  arr = settings.items.order(:create_date).all
  @arr = arr
  output_article
end

post '/item/edit' do
  id = params[:id]
  text = params[:text]
  settings.items.where({id: id}).update({text: text, update_date: Time.now})
  status 200
  arr = settings.items.order(:create_date).all
  @arr = arr
  output_article
end