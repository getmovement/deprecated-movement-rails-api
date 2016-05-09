require "movement_api/push_notifications/ios_notifier"

module MovementApi
  module PushNotifications
    class Notifier
      def self.ping_user(user: nil)
        Device.where(user: user).each do |device|
          ios_notifier.send_to_device(device_token: device.token, message: "Ping!")
        end
      end

      def self.ios_notifier
        IOSNotifier.new
      end
    end
  end
end
