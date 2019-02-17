# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users do
      collection do
        get 'reports' => 'users#reports'
      end
      get 'reports' => 'users#reports'
    end
    resources :offices do
      collection do
        get 'reports' => 'offices#reports'
      end
      get 'reports' => 'offices#reports'
    end
    resources :age_ranges
    resources :races
    resources :languages

    root to: 'users#index'
  end

  devise_for :users, controllers: {
    invitations: 'invitations'
  }, skip: [:registrations]

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
