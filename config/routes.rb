QAuth::Application.routes.draw do

  ## ----------
  ## APIs
  ## ----------

  # Login / Logout
  post    '/api/v1/sign_in'  =>  "api/v1/authentications#create",  :as => :api_sign_in
  delete  '/api/v1/sign_out' =>  "api/v1/authentications#destroy", :as => :api_sign_out

  # My Profile
  get    '/api/v1/my_profile'       =>  "api/v1/my_profile#my_profile",   :as => :api_my_profile
  put    '/api/v1/update_profile'   =>  "api/v1/my_profile#update",       :as => :api_update_profile

  # Members API
  get    '/api/v1/members'            =>  "api/v1/members#index",  :as => :api_members
  get    '/api/v1/members/:id'        =>  "api/v1/members#show",   :as => :api_member


  #department API
  get    '/api/v1/departments'            =>  "api/v1/departments#index",  :as => :api_departments
  get    '/api/v1/department/:id'            =>  "api/v1/departments#show",  :as => :api_department

  #Designation API
  get    '/api/v1/designations'            =>  "api/v1/designations#index",  :as => :api_designations
  get    '/api/v1/designation/:id'        =>  "api/v1/designations#show",   :as => :api_designation

  # ------------
  # Public pages
  # ------------

  root :to => 'public/user_sessions#sign_in'

  # Sign In URLs for users
  get     '/sign_in',         to: "public/user_sessions#sign_in",         as:  :sign_in
  post    '/create_session',  to: "public/user_sessions#create_session",  as:  :create_session
  get     '/forgot_password_form', to: "public/user_sessions#forgot_password_form", as:  :forgot_password_form
  post  '/forgot_password', to: "public/user_sessions#forgot_password", as: :forgot_password
  get   '/reset_password_form/:id',  to: "public/user_sessions#reset_password_form",  as:  :reset_password_form
  put  '/reset_password_update/:id',   to: "public/user_sessions#reset_password_update", as: :reset_password_update
  # Logout Url
  delete  '/sign_out' ,       to: "public/user_sessions#sign_out",        as:  :sign_out
  
  # Backdoor URLS
  get  '/backdoor',           to: "backdoor#index", as:  :backdoor
  put  '/backdoor/enter/:id',     to: "backdoor#enter", as:  :backdoor_entry
  

  # ------------
  # Admin pages
  # ------------

  namespace :admin do
    resources :users do
      member do
        put :masquerade, as: :masquerade
        put :update_status, as:  :update_status
        put :make_admin, as:  :make_admin
        put :make_super_admin, as:  :make_super_admin
        put :remove_admin, as:  :remove_admin
        put :remove_super_admin, as:  :remove_super_admin
      end
    end

    resources :projects do
      get :change_status, on: :member
      resources :roles, :only=>[:new, :create, :destroy]
      resources :project_links
    end

    resources :images do
      member do
        put :crop
      end
    end
    resources :departments
    resources :designations

 end

  # ------------
  # User pages
  # ------------

  namespace :users do
    get   '/dashboard',         to: "dashboard#index",  as:   :dashboard
    get   '/settings',          to: "settings#index",   as:   :settings
    get   '/profile',           to: "profile#index",    as:   :profile
    get   '/edit',              to: "profile#edit",     as:   :edit
    put   '/update',            to: "profile#update",   as:   :update
    get   '/members',           to: "members#index",    as:   :members
    get   '/member/:id',        to: "members#show",     as:   :member
    
    resources :images do
      member do
        put :crop
      end
    end
  end

  # User Pages for teams and user profiles
  get   '/team',               to: "user/team#index",   as:  :team
  get   '/profiles/:username',  to: "user/team#show",    as:  :profile

  # API Test Page
  get '/admin/api/documentation', to: "admin/api_doc#index",   as:  :admin_api_doc


end
