Rails.application.routes.draw do
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'password_resets/new'

get 'password_resets/edit'


root 'pages#dashboard'
get 'learning', to: 'pages#learning'

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
get 'flexforward/search', to: 'flexforwards#search'
post 'flexforward/search', to: 'flexforwards#search'
get 'pricing', to: 'pages#pricing'
get 'labs', to: 'pages#labs'
get 'documents', to: 'pages#documents'
get 'vflex', to: 'pages#vflex'
get 'downloads', to: 'downloads#index'
post 'download', to: 'pages#new_dl'
get 'calculators', to: 'calculators#index'
post 'calculators', to: 'pages#new_calc'
get 'flex', to: 'pages#flexforward'
get 'mycert', to: 'pages#mycert'
get 'si', to: 'users#si'
post 'si', to: 'users#signup'
get 'user/review', to: 'users#review'
get 'user/allsignups', to: 'users#allsignups'
get 'user/learnsignups', to: 'users#learnsignups'
get 'upload', to: 'pages#upload'
patch 'upload', to: 'pages#upload_file'
get 'uploads', to: 'pages#uploads'
post 'uploads', to: 'pages#destroy_labfile'
get 'pages/download_lab', to: 'pages#download_lab'
post 'uploads', to: 'pages#destroy_labfile'
get 'rau', to: 'users#rau'
post 'rau', to: 'users#signup_rau'
get 'user/rauusers', to: 'users#rauusers'
get 'learn', to: 'users#learn'
post 'learn', to: 'users#learn_signup'


resources :currencies
resources :flexforwards
resources :certifications
get 'certification/instruction', to: 'certifications#instruction'
resources :qrcodes
get 'user/myqrs', to: 'qrcodes#myqrs'
resources :categories
resources :videos
resources :quizzes
post 'quizzes/:id', to: 'quizzes#submit_quiz'
resources :questions, except: [:show, :index]
resources :answers, except: [:show, :index]



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
