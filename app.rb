##encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
def init_db                                       #создание базы данных
	@db= SQLite3::Database.new 'lepro.db'
	@db.results_as_hash= true                      # вывод данных бд в виде хэша
end
before do
	init_db                                         #инициализация базы данных в отдельном методе
end
#configure вызывается каждый раз при конфигурации приложения
#перезагрузке страницы и обновлении кода     

configure do                                          #создание таблицы базы данных POSTS если не существует 
	init_db                                          #инициализация базы данных
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
post '/New' do                     #обработчик post запроса.
  @content=params[:content]        #получение переменнной из post запроса

erb "Вы ввели данные #{@content}"
if @content.length <=0            #обработчик ошибок 
	@error='Введите текст!'
	return erb :New
end
end