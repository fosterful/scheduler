# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users, controllers: {
    invitations: 'invitations'
  }, skip: [:registrations]

  ActiveAdmin.routes(self)
  as :user do
    get 'users/edit' => 'registrations#edit', as: 'edit_user_registration'
    get 'vaccination_status' => 'registrations#vaccination_status'
    put 'users' => 'registrations#update', as: 'user_registration'
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

  resources :shift_surveys, param: :token

  get 'verify' => 'verifications#index', as: :verify
  post 'send_code' => 'verifications#send_code', as: :send_code
  post 'check_code' => 'verifications#check_code', as: :check_code

  get 'dashboard/reports' => 'dashboard#reports'
  get 'dashboard/download_report' => 'dashboard#download_report'
  get 'dashboard/users' => 'dashboard#users'

  root to: 'needs#index'
end
