class Item < ApplicationRecord
  belongs_to :number

  scope :not_complete, -> { where(complete: false) }

  scope :items_stringified_for_message, -> {
    items = map { |item| "[#{item.code}] #{item.text}" }.join("\n")
  }
end
