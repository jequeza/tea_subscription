require 'rails_helper'

RSpec.describe 'Customer Tea Subscription Request', type: :request do
  describe 'happy path' do
    it "subscribes a customer to a tea subscription" do
      customer = create(:customer)
      tea = create(:tea)
      data = { customer_id: customer.id,
               tea_id: tea.id,
               subscription: { frequency: "monthly",
               title: "Detox",
               price: 12.99 }
             }

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: JSON.generate(data)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(subscription).to have_key(:message)
      expect(subscription[:message]).to eq('Sucessfully subscribed')
      expect(response.status).to eq(201)
    end
  end

  describe "sad path" do
    it "needs frequency attribute" do
      customer = create(:customer)
      tea = create(:tea)
      data = { customer_id: customer.id,
               tea_id: tea.id,
               subscription: {
               title: "Detox",
               price: 12.99 }
             }

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: JSON.generate(data)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(subscription).to_not have_key(:message)
      expect(subscription).to have_key(:error)
      expect(subscription[:error]).to eq("Validation failed: Frequency can't be blank")
      expect(response.status).to eq(400)
    end

    it "needs title attribute" do
      customer = create(:customer)
      tea = create(:tea)
      data = { customer_id: customer.id,
               tea_id: tea.id,
               subscription: { frequency: "monthly",
               price: 12.99 }
             }

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: JSON.generate(data)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(subscription).to_not have_key(:message)
      expect(subscription).to have_key(:error)
      expect(subscription[:error]).to eq("Validation failed: Title can't be blank")
      expect(response.status).to eq(400)
    end

    it "needs price attribute" do
      customer = create(:customer)
      tea = create(:tea)
      data = { customer_id: customer.id,
               tea_id: tea.id,
               subscription: { frequency: "monthly",
               title: "Hello World" }
             }

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: JSON.generate(data)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(subscription).to_not have_key(:message)
      expect(subscription).to have_key(:error)
      expect(subscription[:error]).to eq("Validation failed: Price can't be blank")
      expect(response.status).to eq(400)
    end

    it "needs customer id" do
      tea = create(:tea)
      data = { tea_id: tea.id,
               subscription: {
                 frequency: "monthly",
                 price: 5.90,
                 title: "Hello World" }
             }

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}

      post "/api/v1/subscriptions", headers: headers, params: JSON.generate(data)

      subscription = JSON.parse(response.body, symbolize_names: true)
      expect(response).to_not be_successful
      expect(subscription).to_not have_key(:message)
      expect(subscription).to have_key(:error)
      expect(subscription[:error]).to eq("Couldn't find Customer without an ID")
      expect(response.status).to eq(400)
    end

    it "needs data" do

      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      post "/api/v1/subscriptions", headers: headers
      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(subscription).to_not have_key(:message)
      expect(subscription).to have_key(:error)
      expect(subscription[:error]).to eq("Couldn't find Customer without an ID")
      expect(response.status).to eq(400)
    end
  end
end