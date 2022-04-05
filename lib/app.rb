require 'sinatra'
require_relative 'wrappers/database'

Database.init('pastabnb')

class PastaBnB < Sinatra::Base
  enable :sessions

  def render_template name
    @user = User.get_by_username(session[:user]) unless session[:user].nil?
    erb name, layout: :layout
  end

  get '/example' do
    render_template :example
  end

  get '/signup' do
    redirect '/example' unless session[:user].nil?
    render_template :signup
  end

  post '/signup' do
    redirect '/' unless session[:user].nil?
    if %i[username first_name last_name email telephone password].any? { |it| params[it].nil? }
      redirect '/signup?err=missing'
    end
    redirect '/signup?err=taken' unless User.get_by_username(params[:username]).nil?
    user = User.new(params[:username], params[:first_name], params[:last_name], params[:email], params[:telephone])

    User.create_user(user, params[:password])
    session[:user] = user.username
    redirect '/example'
  end
end