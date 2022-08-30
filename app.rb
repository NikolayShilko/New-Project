##encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
def init_db                                       #инициализация базы данных
	@db= SQLite3::Database.new 'lepro.db'
	@db.results_as_hash= true                      # вывод данных бд в виде хэша
end
before do
	init_db
end
configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS POSTS (
	"id"	INTEGER,
	"created_date"	DATE,
	"content"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);'
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