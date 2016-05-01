Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    get '/festivals/:festival_name', to: 'festivals#show', :constraints => { :festival_name => /.*/} # allow slash and dot
  end
end