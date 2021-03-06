require 'sinatra'
require_relative 'wrappers/space'
require_relative 'wrappers/database'
require 'uri'

Database.init('pastabnb')

class PastaBnB < Sinatra::Base
  enable :sessions

  def render_template(name)
    @user = User.get_by_username(session[:user]) unless session[:user].nil?
    erb(name, layout: :layout)
  end

  get '/example' do
    render_template :example
  end

  get '/space/:id' do
    @space = Space.get_by_id(params[:id])
    render_template :view_single_space
  end

  get '/view_spaces' do
    @spaces = Space.get_spaces
    render_template :all_spaces
  end

  get '/booking_decision/:id' do
    @booking = params[:id]
    render_template :accept_reject_booking
  end

  post '/booking_accept_reject' do
    id = params[:booking_id]
    @decision = params[:booking_selection]
    Booking.set_response_from_owner(id, @decision)
    render_template :accept_booking
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

  get '/book-space/:id' do
    redirect '/example' if session[:user].nil?
    @space = Space.get_by_id(params[:id])
    render_template :book_space
  end

  post '/book-space' do
    redirect '/example' if session[:user].nil?
    @space = Space.get_by_id(params[:space_id])
    Booking.create_booking(Booking.new(nil, @space.id, session[:user], @space.available_start, nil))
    redirect '/example'
  end

  get '/create' do
    redirect '/example' if session[:user].nil?
    render_template :create_new_space
  end

  post '/create' do
    redirect '/example' if session[:user].nil?
    Space.insert_space(
      Space.new(nil, params[:name], session[:user], params[:description],
                params[:price_per_night], params[:available_start], params[:available_end])
    )
    redirect '/example'
  end
end