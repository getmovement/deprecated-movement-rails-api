require "rails_helper"

describe "Users API" do
  describe "GET/users/:id"
  it "gets the user" do
    user = create(:user)
    get "#{host}/users/#{user.id}"

    expect(last_response.status).to eq 200
    expect(json).to serialize_object(user).with(UserSerializer)
  end
end
