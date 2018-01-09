require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'sequel'

configure do
  DB = Sequel.sqlite('databasepath',{})
  unless DB.table_exists?(:items)  
    DB.create_table :items do
      primary_key :id
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
  data = {text: params[:form], create_date: Time.now}
  settings.items.insert(data)
  content_type :json
  @data = data.to_json
end