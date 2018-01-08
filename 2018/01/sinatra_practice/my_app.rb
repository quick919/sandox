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
      Date :create_date
     end
  end

  set :items, DB[:items]
end

arr = []
get '/' do
  #puts settings.items
  @arr = arr
  erb :index
end

post '/form' do
  data = params[:form]
  arr.push(data)
  @arr = arr
  content_type :json
  @data = data.to_json
end