class User < ApplicationRecord
  acts_as_paranoid column: :deleted, sentinel_value: false

  # @!group Scopes

  # @!method registered
  #   Lists registered users.
  #   @!scope class
  #   @return [ActiveRecord::Relation]
  scope :registered, -> { where(registered: true) }

  # @!endgroup
end
