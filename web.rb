require 'sinatra'
require 'sinatra/cookies'

get '/' do
  cookies[:foo] = "bar"
  "Hello, world"
end
