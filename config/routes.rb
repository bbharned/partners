Rails.application.routes.draw do
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

get 'password_resets/new'

get 'password_resets/edit'


root 'pages#dashboard'
get 'learning', to: 'pages#learning'
get 'reports', to: 'pages#reports'

resources :users
get 'user/company-sorted', to: 'users#company' #can possibly delete
get 'user/type', to: 'users#type' #can possibly delete
get 'user/active', to: 'users#active' #can possibly delete
get 'user/inactive', to: 'users#inactive' #can possibly delete
get 'user/lastlogin', to: 'users#lastlogin' #can possibly delete
get 'user/integrator', to: 'users#integrator' #can possibly delete
get 'user/siexpired', to: 'users#siexpired'
get 'user/siabouttoexpire', to: 'users#siabouttoexpire'
get 'user/distributor', to: 'users#distributor' #can possibly delete
get 'user/admin', to: 'users#admin'
get 'user/search', to: 'users#search'
post 'user/search', to: 'users#search'
get 'flexforward/search', to: 'flexforwards#search'
post 'flexforward/search', to: 'flexforwards#search'
get 'pricing', to: 'pages#pricing'
get 'labs', to: 'pages#labs'
get 'documents', to: 'pages#documents'
get 'vflex', to: 'pages#vflex'
get 'pinpoint', to: 'pages#pinpoint'
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
get 'user/videousers', to: 'users#videousers'
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
resources :licenses

resources :hardwares
get 'tmc', to: 'pages#tmc'
resources :hardwares, :path => "hardware"
resources :makers
resources :hwstatuses
resources :hwtypes
resources :firmwares
get 'terminals', to: 'terminals#index'
get 'terminals/:id', to: 'terminals#show', as: 'terminal'

resources :termnotes, except: [:show, :index]

resources :evtcategories
resources :venues
resources :events
get 'event/admin', to: 'events#admin'
post 'events/:id', to: 'events#register'
post 'events/:id/reg_cancel', to: 'events#reg_cancel', as: 'reg_cancel'
get 'user/eventusers', to: 'users#eventusers'
get 'event/hosted', to: 'events#hosted'

resources :tags

get 'evt/:id', to: 'users#evt', as: 'evt'
post 'evt', to: 'users#signup_evt'

get 'events/:id/checkin', to: 'event_attendees#checkin', as: 'checkin'
post 'events/:id/checkin', to: 'event_attendees#attended'

get 'events/:id/sms', to: 'event_attendees#sms', as: 'sms'
post 'events/:id/sms', to: 'event_attendees#sendit'
post 'events/:id/deregister', to: 'event_attendees#destroy', as: 'deregister'

get 'eventattendees/new', to: 'event_attendees#new', as: 'new'
post 'eventattendees/new', to: 'event_attendees#create'

resources :demokits

get 'flexforward', to: 'flexforwards#saved'
get 'flexsaved', to: 'flexforwards#saved'
get 'flexforward/totals', to: 'flexforwards#totals'
get 'flexforward/usertotals', to: 'flexforwards#usertotals'
get 'flexforward/byname', to: 'flexforwards#byname'
get 'flexforward/userbyname', to: 'flexforwards#userbyname'
get 'flexforward/byuser', to: 'flexforwards#byuser'
get 'flexforward/bydate', to: 'flexforwards#bydate'

resources :companies
get 'company/search', to: 'companies#search'
post 'company/search', to: 'companies#search'
resources :companies do
  resources :addaddresses, only: [:new, :create, :edit, :update, :destroy]
end

resources :listings
get 'listing/integrators', to: 'listings#integrators'
post 'listing/integrators', to: 'listings#integrators'
get 'listing/distributors', to: 'listings#distributors'
post 'listing/distributors', to: 'listings#distributors'

get 'login', to: 'sessions#new'
post 'login', to: 'sessions#create'
delete 'logout', to: 'sessions#destroy'

resources :password_resets, only: [:new, :create, :edit, :update]


resources :features
#get 'matrix', to: 'features#index'
resources :tmversions, except: [:show]
resources :tmprereqs, except: [:show]
resources :firmwarebuilds, except: [:show]

get 'userbadges', to: 'userbadges#index'

end
