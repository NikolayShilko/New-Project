###encoding: utf-8
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
	@result=@db.execute'select * from Posts order by id desc' #запись данных из бд в переменную для вывода
	erb :index	                                               #сортировка по id (order by id desc)
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
#добавление данных из формы в базу данных c параметром datetime
@db.execute 'insert into POSTS (content,created_date)values (?,datetime())',[@content]
redirect to '/'
end
#erb "You typed : #{@content}"
#универсальный обработчик комментариев
get '/detalis/:id' do

@id= params[:id] 

erb "Номер поста:#{@id}"
end

#@result=@db.execute'select * from Posts where id=?',[row]
#@x=@result[0]
#erb "Вывод информации #{@content}"



