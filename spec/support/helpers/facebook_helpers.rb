module FacebookHelpers
  def create_facebook_test_user(params = "email,user_friends")
    test_users = Koala::Facebook::TestUsers.new(
      app_id: ENV["FACEBOOK_APP_ID"],
      secret: ENV["FACEBOOK_APP_SECRET"]
    )

    test_users.create(true, params)
  end

  def create_facebook_access_token(facebook_user)
    oauth = Koala::Facebook::OAuth.new(
      ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"], ENV["FACEBOOK_REDIRECT_URL"])

    short_lived_token = facebook_user["access_token"]
    long_lived_token_info = oauth.exchange_access_token_info(short_lived_token)
    facebook_auth_code = oauth.generate_client_code(long_lived_token_info["access_token"])
    access_token_info = oauth.get_access_token_info(facebook_auth_code)

    access_token_info["access_token"] ||
      JSON.parse(access_token_info.keys[0])["access_token"]
  end
end
