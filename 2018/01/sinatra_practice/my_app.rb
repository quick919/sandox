require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'securerandom'
require 'erb'

configure do
  DB = Sequel.sqlite('db/article.db',{})
  set :items, DB[:items]
  set :tag, DB[:tag]
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
  params[:tags].split(",").each do |tag| 
    settings.tag.insert({name: tag})
  end
  arr = settings.items.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end

post '/item/delete' do
  id = params[:id]
  settings.items.where({id: id}).delete
  status 200
  arr = settings.items.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end

post '/item/edit' do
  id = params[:id]
  text = params[:text]
  settings.items.where({id: id}).update({text: text, update_date: Time.now})
  status 200
  arr = settings.items.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end