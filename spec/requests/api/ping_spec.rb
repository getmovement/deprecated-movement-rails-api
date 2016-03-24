require "rails_helper"

describe "Ping API" do
  it "gets a pong when pinging unauthed" do
    get "#{host}/ping"

    expect(last_response.status).to eq 200
    expect(json.ping).to eq "pong"
  end

  it "pongs the user email when authed" do
    user = create(:user, password: "password")
    token = authenticate(email: user.email, password: "password")

    authenticated_get "ping", nil, token

    expect(last_response.status).to eq 200
    expect(json.ping).to eq user.email
  end
end
