##encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
def init_db
	@db=SQLite3::Database.new 'lepro.db'
	@db.results_as_hash= true
end
get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end
get '/Newpost' do
 erb :New
end
post '/New' do
  @content=params[:content]

erb "Вы ввели данные #{@content}"
end