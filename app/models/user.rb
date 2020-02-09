class User < ApplicationRecord
  # @!group Scopes

  # @!method only_deleted
  #   @!scope class
  #   @return [ActiveRecord::Relation]
  # @!method without_deleted
  #   @!scope class
  #   @return [ActiveRecord::Relation]
  # @!method with_deleted
  #   @!scope class
  #   @return [ActiveRecord::Relation]
  acts_as_paranoid column: :deleted, sentinel_value: false

  # @!method registered
  #   Lists registered users.
  #   @!scope class
  #   @return [ActiveRecord::Relation]
  scope :registered, -> { where(registered: true) }

  # @!endgroup
end
