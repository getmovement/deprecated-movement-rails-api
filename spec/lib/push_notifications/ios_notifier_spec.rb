require "movement_api/push_notifications/ios_notifier"

module MovementApi
  module PushNotifications
    describe IOSNotifier do
      let(:subject) { described_class.new }

      describe "#send_to_device" do
        it "uses BatchService to send a message" do
          stub_service = double("BatchService")
          allow(BatchService).to receive(:new).and_return(stub_service)
          expect(stub_service).to receive(:send_notification).
            with(user_token: "123", title: "Test title", message: "Test message")

          subject.send_to_device(token: "123", title: "Test title", message: "Test message")
        end
      end
    end
  end
end
