class Subscription < ApplicationRecord
  belongs_to :customer
  has_many :teas_subscriptions
  has_many :teas, through: :teas_subscriptions

  validates :title, :price, presence: true

  enum status: [:active, :cancelled]
  enum frequency: [:weekly, :biweekly, :monthly]
end
