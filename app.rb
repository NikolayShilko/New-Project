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
);'                                               #талица бд для сохранения комментариев
@db.execute 'CREATE TABLE IF NOT EXISTS Comments(  
	"id"	INTEGER,
	"created_date"	DATE,
	"content"	TEXT,
	"post_id" INTEGER,
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
  content=params[:content]        #получение переменнной из post запроса

erb "Вы ввели данные #{content}"
if content.length <=0            #обработчик ошибок 
	@error='Введите текст!'
	return erb :New
end
#добавление данных из формы в базу данных c параметром datetime
@db.execute 'insert into POSTS (content,created_date)values (?,datetime())',[content]
redirect to '/'
end

#универсальный обработчик комментариев
get '/detalis/:post_id' do

id= params[:post_id] 
#вывод данных о посте в форме detalis-толькo один пост
result=@db.execute 'select * from Posts where id=?',[id]
@row=result[0]

erb :detalis             
end
#обработчик запрсов из комментариев форма в /detalis
post '/detalis/:post_id' do
#получаем переменную из Url
post_id= params[:post_id] 
#получаем переменную из пост запроса
content= params[:content] 

erb "Вы ввели комментарий #{content} для поста #{post_id}"
end

