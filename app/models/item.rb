class Item < ApplicationRecord
  belongs_to :number

  scope :not_complete, -> { where(complete: false) }
end
