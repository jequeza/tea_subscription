class Api::V1::SubscriptionsController < ApplicationController
  def create
    customer = Customer.find(params[:customer_id])
    if customer
      customer_subscription = customer.subscriptions.create!(subscription_params)
      customer_tea_subscription = TeasSubscription.create!(subscription_id: customer_subscription.id, tea_id: params[:tea_id])
      render json: {message: 'Sucessfully subscribed'}, status: 201
    else
      invalid_params
    end
  end

  private
    def subscription_params
      params[:subscription][:status] = 0
      params[:subscription].permit(:title, :price, :status, :frequency)
    end
end