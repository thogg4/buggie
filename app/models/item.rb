class Item < ApplicationRecord
  THUMBS = '1F44D'
  ROCK = '1F918'
  HANG = '1F919'
  OK = '1F44C' 
  RESPONSES = [THUMBS, ROCK, HANG, OK]

  belongs_to :number

  scope :not_complete, -> { where(complete: false) }

  scope :items_stringified_for_message, -> {
    items = map { |item| "[#{item.code}] #{item.text}" }.join("\n")
    items.prepend("#{Twemoji.render_unicode(RESPONSES.sample)}\n")
  }
end
