require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'securerandom'
require 'erb'

configure do
  DB = Sequel.sqlite('db/journal.db',{})
  set :db, DB
  set :article, DB[:article]
  set :tag, DB[:tag]
  set :article_tags, DB[:article_tags]
  log_dir = "log"
  FileUtils.mkdir(log_dir) unless FileTest.exist?(log_dir)
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
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
  settings.db.transaction do
    article_id = settings.article.insert(data)
    params[:tags].split(",").each do |tag|
      tag_id = ""
      query = settings.tag.where({name: tag})
      if query.count > 0
        tag_id = query.first[:tag_id]
      else
        tag_id = settings.tag.insert({name: tag})
      end
      settings.article_tags.insert({article_id: article_id, tag_id: tag_id})
    end
  end
  arr = settings.article.order(Sequel.desc(:update_date)).all
  article_tags = settings.article_tags.left_join(:tag, :tag_id => :tag_id).all
  @merged_tag = merge_tag(article_tags)
  @articles = arr
  output_article
end

post '/article/delete' do
  article_id = params[:id]
  article_tags = settings.article_tags.where({article_id: article_id}).all
  settings.db.transaction do
    article_tags.each do |article_tag|
      article_id = article_tag[:article_id]
      tag_id = article_tag[:tag_id]
      settings.article_tags.where({article_id: article_id, tag_id: tag_id}).delete
    end
    settings.article.where({article_id: article_id}).delete
  end
  status 200
  arr = settings.article.order(Sequel.desc(:update_date)).all
  article_tags = settings.article_tags.left_join(:tag, :tag_id => :tag_id).all
  @merged_tag = merge_tag(article_tags)
  @articles = arr
  output_article
end

post '/article/edit' do
  article_id = params[:id]
  text = params[:text]
  settings.db.transaction do
    settings.article.where({article_id: article_id}).update({text: text, update_date: Time.now})
  end
  status 200
  arr = settings.article.order(Sequel.desc(:update_date)).all
  article_tags = settings.article_tags.left_join(:tag, :tag_id => :tag_id).all
  @merged_tag = merge_tag(article_tags)
  @articles = arr
  output_article
end