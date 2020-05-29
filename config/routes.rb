# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users, controllers: {
    invitations: 'invitations'
  }, skip: [:registrations]

  ActiveAdmin.routes(self)
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :blockouts, except: %i[index new edit show]
  resources :needs do
    resources :shifts, except: %i[new]
    patch 'mark_unavailable', on: :member
    post 'office_social_workers', on: :collection
  end

  get 'verify' => 'verifications#index', as: :verify
  post 'send_code' => 'verifications#send_code', as: :send_code
  post 'check_code' => 'verifications#check_code', as: :check_code

  root to: 'needs#index'
end
