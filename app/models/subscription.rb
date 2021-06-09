class Subscription < ApplicationRecord
  belongs_to :customer
  validates :title, :price, presence: true

  enum status: [:active, :cancelled]
  enum frequency: [:weekly, :biweekly, :monthly]
end
