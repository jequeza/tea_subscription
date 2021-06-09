class Customer < ApplicationRecord
  validates :first_name, :last_name, :email, :address, presence: true
  validates_uniqueness_of :email
  has_many :subscriptions
end
