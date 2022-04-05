require 'sinatra'

class PastaBnB < Sinatra::Base
  def render_template name
    erb name, layout: :layout
  end

  get '/example' do
    render_template :example
  end

  get '/view_spaces' do
    render_template :all_spaces
  end
end