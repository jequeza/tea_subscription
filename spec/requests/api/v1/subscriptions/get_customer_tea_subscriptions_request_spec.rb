require 'rails_helper'

RSpec.describe 'Customer Tea Subscriptions Request', type: :request do
  describe "happy path" do
    it "returns all the customers tea subscriptions" do
      customer = create(:customer)
      tea1 = create(:tea)
      tea2 = create(:tea)
      tea3 = create(:tea)
      tea4 = create(:tea)

      subscription1 = create(:subscription, customer_id: customer.id)
      subscription2 = create(:subscription, customer_id: customer.id)
      subscription3 = create(:subscription, customer_id: customer.id)

      tea1_subscription = create(:teas_subscription, subscription_id: subscription1.id, tea_id: tea1.id)
      tea1_subscription = create(:teas_subscription, subscription_id: subscription1.id, tea_id: tea2.id)
      tea1_subscription = create(:teas_subscription, subscription_id: subscription2.id, tea_id: tea3.id)
      tea1_subscription = create(:teas_subscription, subscription_id: subscription3.id, tea_id: tea4.id)


      get "/api/v1/subscriptions?customer_id=#{customer.id}"

      subscriptions = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(subscriptions).to have_key(:data)
      expect(subscriptions[:data]).to have_key(:id)
      expect(subscriptions[:data]).to have_key(:type)
      expect(subscriptions[:data]).to have_key(:attributes)
      expect(subscriptions[:data][:type]).to eq('subscriptions')
      expect(subscriptions[:data][:attributes]).to have_key(:id)
      expect(subscriptions[:data][:attributes]).to have_key(:customer)
      expect(subscriptions[:data][:attributes]).to have_key(:subscriptions)
      expect(subscriptions[:data][:attributes][:subscriptions].length).to eq(customer.subscriptions.length)
    end
  end

  describe "sad path" do
    it "needs cutomer id query parameter" do
      get "/api/v1/subscriptions"

      subscriptions = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(subscriptions).to_not have_key(:message)
      expect(subscriptions).to have_key(:error)
      expect(subscriptions[:error]).to eq("Couldn't find Customer without an ID")
      expect(response.status).to eq(400)
    end
    it "customer id must be valid" do
      input = "aijsdfoiawj"
      get "/api/v1/subscriptions?customer_id=#{input}"

      subscriptions = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(subscriptions).to_not have_key(:message)
      expect(subscriptions).to have_key(:error)
      expect(subscriptions[:error]).to eq("Couldn't find Customer with 'id'=#{input}")
      expect(response.status).to eq(400)
    end
  end
end