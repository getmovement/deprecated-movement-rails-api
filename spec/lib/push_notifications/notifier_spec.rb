require "rails_helper"
require "movement_api/push_notifications/notifier"
require "movement_api/push_notifications/ios_notifier"

module MovementApi
  module PushNotifications
    describe Notifier do
      describe ".ping_user" do
        let(:user) { create(:user) }

        let(:ios_notifier) { double("IOSNotifier") }

        before do
          allow(Notifier).to receive(:ios_notifier).and_return(ios_notifier)
        end

        context "when user has just one device" do
          before do
            create(:device, user: user, token: "123")
          end

          it "sends notification to the user's device" do
            expect(ios_notifier).
              to receive(:send_to_device).
              with(message: "Ping!", device_token: "123")

            Notifier.ping_user(user: user)
          end
        end

        context "when user has multiple devices" do
          before do
            create(:device, user: user, token: "123")
            create(:device, user: user, token: "456")
          end

          it "sends a notification to each of the user's devices" do
            expect(ios_notifier).
              to receive(:send_to_device).
              once.ordered.
              with(message: "Ping!", device_token: "123")

            expect(ios_notifier).
              to receive(:send_to_device).
              once.ordered.
              with(message: "Ping!", device_token: "456")

            Notifier.ping_user(user: user)
          end
        end
      end
    end
  end
end
