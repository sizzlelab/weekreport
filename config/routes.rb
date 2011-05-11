Weekreport::Application.routes.draw do
  resources :messages
  resources :teams
  match '/' => 'messages#new'
  match '/:controller(/:action(/:id))'
end
