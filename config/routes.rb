Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'password_resets/new'

get 'password_resets/edit'

root 'pages#dashboard'
resources :users
get 'user/company-sorted', to: 'users#company'
get 'user/type', to: 'users#type'
get 'user/active', to: 'users#active'
get 'user/inactive', to: 'users#inactive'
get 'user/lastlogin', to: 'users#lastlogin'
get 'user/integrator', to: 'users#integrator'
get 'user/distributor', to: 'users#distributor'
get 'user/admin', to: 'users#admin'
get 'user/search', to: 'users#search'
post 'user/search', to: 'users#search'
get 'pricing', to: 'pages#pricing'
get 'documents', to: 'pages#documents'
get 'vflex', to: 'pages#vflex'
get 'downloads', to: 'downloads#index'
post 'download', to: 'pages#new_dl'
get 'calculators', to: 'calculators#index'
post 'calculators', to: 'pages#new_calc'
get 'flex', to: 'pages#flexforward'
get 'mycert', to: 'pages#mycert'

resources :currencies
resources :flexforwards
resources :certifications
get 'certification/instruction', to: 'certifications#instruction'


get 'flexforward', to: 'flexforwards#saved'
get 'flexsaved', to: 'flexforwards#saved'
get 'flexforward/totals', to: 'flexforwards#totals'
get 'flexforward/usertotals', to: 'flexforwards#usertotals'
get 'flexforward/byname', to: 'flexforwards#byname'
get 'flexforward/userbyname', to: 'flexforwards#userbyname'
get 'flexforward/byuser', to: 'flexforwards#byuser'
get 'flexforward/bydate', to: 'flexforwards#bydate'

get 'login', to: 'sessions#new'
post 'login', to: 'sessions#create'
delete 'logout', to: 'sessions#destroy'

resources :password_resets, only: [:new, :create, :edit, :update]


end
