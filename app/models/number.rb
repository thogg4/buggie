class Number < ApplicationRecord
  has_many :items

  def send_out_items
    items_to_send = items.not_complete.map { |item| "#{item.code} #{item.text}" }.join("\n")

    ItemNotification
      .with(message: "#{Twemoji.render_unicode(RESPONSES.sample)}\n#{items_to_send}")
  end
end
