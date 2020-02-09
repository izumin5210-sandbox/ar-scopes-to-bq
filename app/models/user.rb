class User < ApplicationRecord
  acts_as_paranoid column: :deleted, sentinel_value: false
  scope :registered, -> { where(registered: true) }
end
