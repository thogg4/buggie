class Number < ApplicationRecord
  HOURS_TO_SEND = [10, 12, 14, 16, 18, 20]
  has_many :items

  def self.send_for_each
    all.each(&:send_out_items)
  end

  def send_out_items
    return if items.not_complete.empty?

    message = items.not_complete.items_stringified_for_message

    Time.use_zone('Eastern Time (US & Canada)') do
      return unless HOURS_TO_SEND.include?(Time.zone.now.hour)

      ItemNotification
        .with(message: message)
        .deliver(self)
    end
  end
end
