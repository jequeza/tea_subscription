require 'rails_helper'

RSpec.describe 'Cancel Customer Tea Subscription Request' do
  describe "happy path" do
    it "cancels an existing subscription to a tea" do
      customer = create(:customer)
      tea1 = create(:tea)
      tea2 = create(:tea)
      subscription = create(:subscription, customer_id: customer.id)
      tea1_subscription = create(:teas_subscription, subscription_id: subscription.id, tea_id: tea1.id)
      tea2_subscription = create(:teas_subscription, subscription_id: subscription.id, tea_id: tea2.id)

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      delete "/api/v1/subscriptions/#{subscription.id}?tea_id=#{tea1.id}", headers: headers

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(subscription).to have_key(:message)
      expect(subscription[:message]).to eq("Sucessfully unsubscribed")
      expect(response.status).to eq(200)
    end

    it "cancels an existing tea subscription" do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription, customer_id: customer.id)
      tea_subscription = create(:teas_subscription, subscription_id: subscription.id, tea_id: tea.id)

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      delete "/api/v1/subscriptions/#{subscription.id}?tea_id=#{tea.id}", headers: headers

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(subscription).to have_key(:message)
      expect(subscription[:message]).to eq("Sucessfully unsubscribed")
      expect(response.status).to eq(200)
    end
  end

  describe "sad path" do
    it "needs the query parameter for tea_id" do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription, customer_id: customer.id)
      tea_subscription = create(:teas_subscription, subscription_id: subscription.id, tea_id: tea.id)

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      delete "/api/v1/subscriptions/#{subscription.id}", headers: headers

      subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(subscription).to have_key(:error)
      expect(subscription).to_not have_key(:message)
      expect(subscription[:error]).to eq("Couldn't find Tea without an ID")
      expect(response.status).to eq(400)
    end

    it "needs valid subscription id" do
      customer = create(:customer)
      tea = create(:tea)
      subscription = create(:subscription, customer_id: customer.id)
      tea_subscription = create(:teas_subscription, subscription_id: subscription.id, tea_id: tea.id)

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      delete "/api/v1/subscriptions/hello?tea_id=#{tea.id}", headers: headers

      subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(subscription).to have_key(:error)
      expect(subscription).to_not have_key(:message)
      expect(subscription[:error]).to eq("Couldn't find Subscription with 'id'=hello")
      expect(response.status).to eq(400)
    end
  end
end