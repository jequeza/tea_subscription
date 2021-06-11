class CustomerSubscription
  attr_reader :id,
              :customer,
              :subscriptions

  def initialize(customer)
    @id = customer.id
    @customer = customer
    @subscriptions = fetch_subscriptions(customer)
  end

  private
    def fetch_subscriptions(customer_obj)
      customer_obj.subscriptions.map do |subscription|
        SubscriptionTea.new(subscription)
      end
    end
end