require 'sinatra'
require_relative 'wrappers/database'
require 'uri'

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

  get '/login' do
    redirect '/example' unless session[:user].nil?
    render_template :login
  end

  post '/login' do
    redirect '/example' unless session[:user].nil?
    redirect '/login?err=missing' if %i[username password].any? { |it| params[it].nil? }
    redirect '/login?err=incorrect' unless User.verify_password(params[:username], params[:password])
    session[:user] = params[:username]
    redirect '/example'
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
    unless params[:email] =~ URI::MailTo::EMAIL_REGEXP && params[:telephone] =~ /\+?\d+[-\d]+\d/
      redirect '/signup?err=invalid'
    end
    user = User.new(ERB::Util.html_escape(params[:username]),
                    ERB::Util.html_escape(params[:first_name]),
                    ERB::Util.html_escape(params[:last_name]),
                    params[:email],
                    params[:telephone])

    User.create_user(user, params[:password])
    session[:user] = user.username
    redirect '/example'
  end

  get '/logout' do
    session[:user] = nil
    redirect '/example'
  end

 
  get '/create' do
    redirect '/example' unless session[:user].nil?
    render_template :create_new_space
  end

  post '/create' do
    redirect '/example' unless session[:user].nil?
    insert_space(Space.new(nil, params[:name], params[:owner], params[:desciption], params[:price_per_night], params[:available_start],params[:available_end]))
    render_template :create_new_space
    redirect '/example'
  end

end