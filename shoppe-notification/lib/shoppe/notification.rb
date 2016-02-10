require "shoppe/notification/engine"
require "shoppe/notification/version"

module Shoppe
  module Notification
    # Your code goes here...
    def self.setup
      Shoppe::Order.before_confirmation do
        Shoppe::NotificationMailer.order_received(self).deliver_now
      end
    end
  end
end
