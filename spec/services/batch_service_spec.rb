require "rails_helper"

describe BatchService do
  let(:subject) { described_class.new }

  describe "#send_notification" do
    it "sends a push notification POST request to the batch API",
       vcr: { cassette_name: "batch/send_success" } do
      result = subject.send_notification(
        title: "Test title", message: "Test message", user_token: "test_token_123")
      expect(result).not_to be nil
      expect(result).to be_a String

      assert_requested(
        :post, "https://api.batch.com/1.0/#{ENV['BATCH_API_KEY']}/transactional/send",
        headers: {
          "Content-Type" => "application/json",
          "X-Authorization" => ENV["BATCH_REST_API_KEY"] },
        body: {
          group_id: "All",
          recipients: { tokens: ["test_token_123"] },
          message: { title: "Test title", body: "Test message" } },
        times: 1
      )
    end
  end
end
