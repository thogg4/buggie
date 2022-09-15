class Number < ApplicationRecord
  has_many :items

  def send_out_items
    return if items.not_complete.empty?

    message = items.not_complete.items_stringified_for_message

    ItemNotification
      .with(message: message)
      .deliver(self)
  end
end
