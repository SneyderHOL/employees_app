Rails.application.routes.draw do
  resources :users
  root 'welcome#index'
  post 'users/import', to: 'users#import', as: 'import_users'
end
