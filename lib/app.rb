require 'sinatra'

class PastaBnB < Sinatra::Base
  def render_template name
    erb name, layout: :layout
  end

  get '/example' do
    render_template :example
  end

  get '/viewing' do
    render_template :viewing_single_space
  end

end