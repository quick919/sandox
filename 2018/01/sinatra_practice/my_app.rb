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
     end
  end

  set :items, DB[:items]
end

get '/' do
  @arr = settings.items.order(:create_date).all
  erb :index
end

post '/form' do
  data = {id: SecureRandom.uuid, text: params[:form], create_date: Time.now}
  settings.items.insert(data)
  arr = settings.items.order(:create_date).all
  @arr = arr
  file_data = nil
  File.open('views/article.erb') do |file|
    file_data = file.read
  end
  ERB.new(file_data).result(binding)
end

post '/item/delete' do
  id = params[:id]
  settings.items.where({id: id}).delete
  status 200
  arr = settings.items.order(:create_date).all
  @arr = arr
  file_data = nil
  File.open('views/article.erb') do |file|
    file_data = file.read
  end
  ERB.new(file_data).result(binding)
end

post '/item/edit' do
  id = params[:id]
  text = params[:text]
  settings.items.where({id: id}).update({text: text})
  status 200
  arr = settings.items.order(:create_date).all
  @arr = arr
  file_data = nil
  File.open('views/article.erb') do |file|
    file_data = file.read
  end
  ERB.new(file_data).result(binding)
end