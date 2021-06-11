class Api::V1::SubscriptionsController < ApplicationController

  def index
    customer = Customer.find(params[:customer_id])
    customer_subscriptions = CustomerSubscription.new(customer)
    serialize_subscriptions = SubscriptionsSerializer.new(customer_subscriptions)
    render json: serialize_subscriptions, status: 200
  end

  def create
    customer = Customer.find(params[:customer_id])
    customer_subscription = customer.subscriptions.create!(subscription_params)
    customer_tea_subscription = TeasSubscription.create!(subscription_id: customer_subscription.id, tea_id: params[:tea_id])
    render json: {message: 'Sucessfully subscribed'}, status: 201
  end

  def destroy
    subscription = Subscription.find(params[:id])
    tea = Tea.find(params[:tea_id])
    tea_subscription = TeasSubscription.find_by(subscription_id: subscription.id, tea_id: tea.id)
    if tea_subscription && subscription.teas.length == 1
      tea_subscription.destroy
      subscription.destroy
      render json: {message: 'Sucessfully unsubscribed'}, status: 200
    elsif tea_subscription
      tea_subscription.destroy
      render json: {message: 'Sucessfully unsubscribed'}, status: 200
    end
  end

  private
    def subscription_params
      params[:subscription][:status] = 0
      params[:subscription].permit(:title, :price, :status, :frequency)
    end
end