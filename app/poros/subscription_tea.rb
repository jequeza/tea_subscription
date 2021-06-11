class SubscriptionTea
  attr_reader :id,
              :title,
              :temperature,
              :brew_time,
              :description,
              :teas

  def initialize(subscription)
    @id = subscription.id
    @title = subscription.title
    @price = subscription.price
    @frequency = subscription.frequency
    @status = subscription.status
    @teas = subscription.teas
  end
end