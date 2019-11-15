# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users, controllers: {
    invitations: 'invitations'
  }, skip: [:registrations]

  ActiveAdmin.routes(self)
  as :user do
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    put 'users' => 'devise/registrations#update', as: 'user_registration'
  end

  resources :blockouts, except: %i[index new edit show]
  resources :needs do
    resources :shifts, except: %i[new]
  end

  root to: 'needs#index'
end
