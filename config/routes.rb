Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'password_resets/new'

get 'password_resets/edit'

root 'pages#dashboard'
resources :users
get 'user/company-sorted', to: 'users#company'
get 'user/type', to: 'users#type'
get 'user/inactive', to: 'users#inactive'
get 'user/lastlogin', to: 'users#lastlogin'
get 'pricing', to: 'pages#pricing'
get 'documents', to: 'pages#documents'

get 'login', to: 'sessions#new'
post 'login', to: 'sessions#create'
delete 'logout', to: 'sessions#destroy'

resources :password_resets, only: [:new, :create, :edit, :update]


end
