Rails.application.routes.draw do
  root 'mailchimp#index'
  post 'mailchimp/subscribe' => 'mailchimp#subscribe'
end
