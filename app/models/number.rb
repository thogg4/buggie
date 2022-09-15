class Number < ApplicationRecord
  HOURS_TO_SEND = [8, 10, 12, 2, 4, 6, 8, 10]
  has_many :items

  def send_out_items
    return if items.not_complete.empty?

    message = items.not_complete.items_stringified_for_message

    Time.use_zone('Eastern Time (US & Canada)') do
      return unless HOURS_TO_SEND.include?(Time.now.hour)

      ItemNotification
        .with(message: message)
        .deliver(self)
    end
  end
end
