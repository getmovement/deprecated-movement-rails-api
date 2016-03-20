require 'mailchimp'

class MailchimpController < ApplicationController

  before_action :setup_mcapi

  def index
  end

  def subscribe
    email = params[:email][:address]

    if !email.blank?
      begin
        @mc.lists.subscribe(@list_id, {'email' => email})

        respond_to do |format|
          format.json { render :json => { :message => "Success! Check your email to confirm sign up." } }
        end
      rescue Mailchimp::ListAlreadySubscribedError
        respond_to do |format|
          format.json { render :json => { :message => "#{email} is already subscribed to the list" } }
        end
      rescue Mailchimp::ListDoesNotExistError
        respond_to do |format|
          format.json { render :json => { :message => "The list could not be found." } }
        end
      rescue Mailchimp::Error => ex
				if ex.message
				  respond_to do |format|
				    format.json { render :json => { :message => "There is an error. Please enter valid email id." } }
				  end
				else
				  respond_to do |format|
				    format.json { render :json => { :message => "An unknown error occurred." } }
				  end
				end
	    end
    else
      respond_to do |format|
        format.json { render :json => { :message => "Email Address Cannot be blank. Please enter valid email id." } }
      end
    end
  end

  private
    def setup_mcapi
      @mc = Mailchimp::API.new(ENV["MAILCHIMP_API_KEY"])
      @list_id = ENV["MAILCHIMP_LIST_ID"]
    end

end
