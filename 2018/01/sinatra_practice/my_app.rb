require 'sinatra'
require 'sinatra/reloader'
require 'json'

arr = []
get '/' do
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