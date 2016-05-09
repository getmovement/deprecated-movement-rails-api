require "rails_helper"

describe AddFacebookFriendsWorker do
  let(:original_user) { create(:user, facebook_id: "id_1", facebook_access_token: "token") }
  let(:friend_user) { create(:user, facebook_id: "id_2") }

  let(:facebook_service) { double("FacebookService", facebook_friend_ids: ["id_2"]) }

  def follower_status
    [original_user.following?(friend_user), friend_user.following?(original_user)]
  end

  before do
    allow(FacebookService).to receive(:from_user).and_return(facebook_service)
  end

  it "adds friends from facebook" do
    expect { subject.perform(original_user.id) }.
      to change { follower_status }.from([false, false]).to([true, true])
  end
end
