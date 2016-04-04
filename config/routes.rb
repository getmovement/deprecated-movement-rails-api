Rails.application.routes.draw do
  use_doorkeeper
  root "mailchimp#index"
  post "mailchimp/subscribe", to: "mailchimp#subscribe"

  constraints subdomain: "api" do
    get "ping", to: "ping#index"
    resources :users, only: [:show, :create]
  end
end
