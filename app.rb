require 'sinatra'
require 'sinatra/activerecord'

configure(:development){set :database, "sqlite3:blog.sqlite3"}

require './models'

set :sessions, true
require 'bundler/setup'
require 'rack-flash'
use Rack::Flash, :sweep => true

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])

	end
end
get '/' do
	redirect '/sign-in'
end


get '/sign-in' do
	erb :sign_in
end

post '/sign-in-process' do
@user = User.find_by_username params[:username]
if @user && @user.password == params[:password]
	session[:user_id] = @user.id
	flash[:message] = "You have logged in successfully<br>"
	redirect '/home'
else
	flash[:message] = "You've failed to log in<br>"
	redirect '/sign-in'
end
end

get '/home' do
	@user = User.find(session[:user_id])
	@posts = Post.all()
	erb :home
end

get '/sign-up' do
	erb :sign_up
end

post '/sign-up-process' do
	a= User.create(username: params[:username], email: params[:email], password: params[:password])
	flash[:message] = "You have signed up successfully<br>"
	session[:user_id] = a.id
	redirect '/home'

end

post '/newpost' do

	@song = params[:song]
	@song_array = @song.split('=')
	@song = @song_array[1]
	Post.create(content:params[:content], song:@song, user_id:session[:user_id], genre:params[:genre])
	redirect '/home'
	flash[:message] = "You Just Posted A Wylt"
end

get '/prof/:username' do
	@user = User.find_by_username(params[:username])
	@post = Post.where(user_id:@user.id)
	puts "asdf;lsadflkj"
	puts @post
	erb :prof
end

get '/genre/:id' do 
	a = Genre.find(params[:id])
	@user = User.find(session[:user_id])
	@posts = Post.where(genre:a.name)
	erb :genre
end

get '/signout' do
	session[:user_id] = nil
	redirect '/sign-in'

end