Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: "tokens"
  end

  root "mailchimp#index"
  post "mailchimp/subscribe", to: "mailchimp#subscribe"

  constraints subdomain: "api" do
    get "ping", to: "ping#index"

    resources :addresses, except: [:new, :edit]

    patch "users/me", to: "users#update_authenticated_user"
    resources :users, only: [:show, :create] do
      post :forgot_password, on: :collection
      post :reset_password, on: :collection
    end

    resources :campaign_volunteers, only: [:index, :create]
    resources :campaigns, only: [:show]
  end
end
