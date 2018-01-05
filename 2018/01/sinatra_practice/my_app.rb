require 'sinatra'

get '/' do
  'Hello,World!'
end

get '/index' do
  erb :index
end