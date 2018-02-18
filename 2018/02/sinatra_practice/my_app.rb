require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'
require 'securerandom'
require 'erb'
require_relative 'models/article'
require_relative 'models/tag'

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
  set :per_page, 10
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

get '/articles' do
  page = 1
  page = params[:page].to_i unless params[:page].nil?
  @current_page = page
  @articles = Article.fetch_articles(settings.per_page, page)
  @pages = Article.fetch_number_of_pages(settings.per_page)
  if params[:page].nil?
    erb :index
  else
    output_article
  end
end

post '/articles/create' do
  now = Time.now
  data = { text: params[:form], create_date: now, update_date: now}
  settings.db.transaction do
    article_id = settings.article.insert(data)
    create_article_tag(params[:tags], article_id)
  end
  page = 1
  @current_page = page
  @articles = Article.fetch_articles(settings.per_page, page)
  @pages = Article.fetch_number_of_pages(settings.per_page)
  output_article
end

post '/articles/delete' do
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
  page = 1
  @current_page = page
  @articles = Article.fetch_articles(settings.per_page, page)
  @pages = Article.fetch_number_of_pages(settings.per_page)
  output_article
end

post '/articles/edit' do
  article_id = params[:id]
  text = params[:text]
  settings.db.transaction do
    settings.article.where({article_id: article_id}).update({text: text, update_date: Time.now})
    settings.article_tags.where({article_id: article_id}).delete
    create_article_tag(params[:tags], article_id)
  end
  status 200
  page = 1
  @current_page = page
  @articles = Article.fetch_articles(settings.per_page, page)
  @pages = Article.fetch_number_of_pages(settings.per_page)
  output_article
end

get '/search' do
  @current_page = 1
  @articles = Article.fetch_articles(settings.per_page, 1, params[:searchText])
  @pages = Article.fetch_search_articles_count(settings.per_page, 1, params[:searchText])
  output_article
end

private

def create_article_tag(tags, article_id)
  tags.split(",").each do |tag|
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