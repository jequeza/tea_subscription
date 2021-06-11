class SubscriptionsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :customer, :subscriptions
end