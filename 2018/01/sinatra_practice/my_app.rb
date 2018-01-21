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

  def merge_tag(article_tags)
    merged_tags = {}
    article_tags.each do |article_tag|
      id = article_tag[:article_id]
      if merged_tags.include?(id)
        tags = merged_tags[id]
        tags.push(article_tag[:name])
        merged_tags[id] = tags
      else
        tags = []
        tags.push(article_tag[:name])
        merged_tags[id] = tags
      end
    end
    return merged_tags
  end
end

get '/' do
  @articles = settings.article.order(:create_date).all
  article_tags = settings.article_tags.left_join(:tag, :tag_id => :tag_id).all
  @merged_tag = merge_tag(article_tags)
  erb :index
end

post '/article/create' do
  now = Time.now
  data = { text: params[:form], create_date: now, update_date: now}
  article_id = settings.article.insert(data)
  params[:tags].split(",").each do |tag|
    tag_id = settings.tag.insert({name: tag})
    settings.article_tags.insert({article_id: article_id, tag_id: tag_id})
  end
  arr = settings.article.order(Sequel.desc(:update_date)).all
  article_tags = settings.article_tags.left_join(:tag, :tag_id => :tag_id).all
  @merged_tag = merge_tag(article_tags)
  @articles = arr
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