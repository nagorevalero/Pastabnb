require 'sinatra'
require_relative 'wrappers/space'
class PastaBnB < Sinatra::Base
  def render_template name
    erb name, layout: :layout
  end

  get '/example' do
    render_template :example
  end

  get '/space/:id' do
    @space = Space.get_by_id(params[:id])
    render_template :view_single_space
  end

end