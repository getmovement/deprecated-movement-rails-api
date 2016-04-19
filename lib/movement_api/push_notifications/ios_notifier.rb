module MovementApi
  module PushNotifications
    class IOSNotifier
      attr_reader :app

      def initialize
      end

      def send_to_device(token: nil, message: "", title: "")
        service = BatchService.new
        service.send_notification(user_token: token, title: title, message: message)
      end
    end
  end
end
