Rails.application.routes.draw do
  root :to => "tasks#index"
  get '/tasks', to: 'tasks#index'
end