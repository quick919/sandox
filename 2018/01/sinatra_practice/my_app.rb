require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'securerandom'
require 'erb'

configure do
  DB = Sequel.sqlite('db/journal.db',{})
  set :article, DB[:article]
  set :tag, DB[:tag]
  set :article_tags, DB[:article_tags]
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
  @arr = settings.article.order(:create_date).all
  erb :index
end

post '/article/create' do
  now = Time.now
  article_id = SecureRandom.uuid
  data = {article_id: article_id, text: params[:form], create_date: now, update_date: now}
  settings.article.insert(data)
  params[:tags].split(",").each do |tag|
    tag_id = SecureRandom.uuid
    settings.tag.insert({tag_id: tag_id, name: tag})
    settings.article_tags.insert({article_id: article_id, tag_id: tag_id})
  end
  arr = settings.article.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end

post '/article/delete' do
  id = params[:id]
  settings.article.where({id: id}).delete
  status 200
  arr = settings.article.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end

post '/article/edit' do
  id = params[:id]
  text = params[:text]
  settings.article.where({id: id}).update({text: text, update_date: Time.now})
  status 200
  arr = settings.article.order(Sequel.desc(:update_date)).all
  @arr = arr
  output_article
end