require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :price }
    it { should define_enum_for :status }
    it { should define_enum_for :frequency }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :teas_subscriptions }
    it { should have_many(:teas).through(:teas_subscriptions) }
  end

  describe "subscription status" do
    it "subscriptions can be active" do
      customer = create(:customer)
      subscription = create(:subscription, status: 0, customer_id: customer.id)
      expect(subscription).to be_valid
      expect(subscription.status).to eq("active")
      expect(subscription.active?).to be_truthy
      expect(subscription.cancelled?).to be_falsy
      expect(subscription.status).to_not eq("cancelled")
    end
    it "subscriptions can be cancelled" do
      customer = create(:customer)
      subscription = create(:subscription, status: 1, customer_id: customer.id)
      expect(subscription).to be_valid
      expect(subscription.status).to eq("cancelled")
      expect(subscription.active?).to be_falsy
      expect(subscription.cancelled?).to be_truthy
      expect(subscription.status).to_not eq("active")
    end
  end

  describe "subscription frequency" do
    it "subscriptions can be weekly" do
      customer = create(:customer)
      subscription = create(:subscription, frequency: 0, customer_id: customer.id)
      expect(subscription).to be_valid
      expect(subscription.frequency).to eq("weekly")
      expect(subscription.weekly?).to be_truthy
      expect(subscription.biweekly?).to be_falsy
      expect(subscription.monthly?).to be_falsy
      expect(subscription.frequency).to_not eq("biweekly")
      expect(subscription.frequency).to_not eq("monthly")
    end

    it "subscriptions can be biweekly" do
      customer = create(:customer)
      subscription = create(:subscription, frequency: 1, customer_id: customer.id)
      expect(subscription).to be_valid
      expect(subscription.frequency).to eq("biweekly")
      expect(subscription.biweekly?).to be_truthy
      expect(subscription.monthly?).to be_falsy
      expect(subscription.weekly?).to be_falsy
      expect(subscription.frequency).to_not eq("weekly")
      expect(subscription.frequency).to_not eq("monthly")
    end

    it "subscriptions can be monthly" do
      customer = create(:customer)
      subscription = create(:subscription, frequency: 2, customer_id: customer.id)
      expect(subscription).to be_valid
      expect(subscription.frequency).to eq("monthly")
      expect(subscription.monthly?).to be_truthy
      expect(subscription.biweekly?).to be_falsy
      expect(subscription.weekly?).to be_falsy
      expect(subscription.frequency).to_not eq("weekly")
      expect(subscription.frequency).to_not eq("biweekly")
    end
  end
end