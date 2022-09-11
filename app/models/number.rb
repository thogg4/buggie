class Number < ApplicationRecord
  THUMBS = '1F44D'
  ROCK = '1F918'
  HANG = '1F919'
  OK = '1F44C' 
  RESPONSES = [THUMBS, ROCK, HANG, OK]

  has_many :items

  def send_out_items
    items_to_send = items.not_complete.map { |item| "[#{item.code}] #{item.text}" }.join("\n")

    return if items_to_send.blank?

    ItemNotification
      .with(message: "#{Twemoji.render_unicode(RESPONSES.sample)}\n#{items_to_send}")
      .deliver(self)
  end
end
