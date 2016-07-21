Rails.application.routes.draw do

  devise_for :users
  # You can have the root of your site routed with "root"
  root 'welcome#index'


  resources :users
  resources :scenarios

  get 'welcome/index'
  get 'admin/index'

  resources :events do
    resources :user_events
    resources :sessions do
      resources :tables do
        resources :registration_tables
        resources :game_masters
      end
    end
  end
# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".
end
