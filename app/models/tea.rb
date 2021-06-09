class Tea < ApplicationRecord
  validates :title, :description, :temperature, :brew_time, presence: true

  has_many :teas_subscriptions
  has_many :subscriptions, through: :teas_subscriptions
end
