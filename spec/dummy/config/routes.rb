Dummy::Application.routes.draw do
  resources :examples, :only => :index
end
