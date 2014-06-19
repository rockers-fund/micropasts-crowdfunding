require 'spec_helper'

describe Channels::ChannelsSubscribersController do
  subject{ response }
  let(:channel_subscriber){ nil }
  let(:channel){ FactoryGirl.create(:channel) }
  let(:user){ FactoryGirl.create(:user) }
  let(:current_user){ user }

  before do
    allow(request).to receive(:subdomain).and_return(channel.permalink)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe "GET show" do
    before do
      channel_subscriber
      get :show
    end

    context "when user is signed in" do
      it{ should redirect_to root_path }
    end

    context "when no user is signed in" do
      let(:current_user){ nil }
      it{ should redirect_to new_user_session_path }
    end
  end

  describe "DELETE destroy" do
    let(:channel_subscriber){ ChannelsSubscriber.create!(channel: channel, user: user) }

    context "when signed in user owns the subscription" do
      it do
        delete :destroy, id: channel_subscriber.id
        should redirect_to root_path
      end
    end

    context "when signed in user does not own the subscription" do
      let(:current_user){ FactoryGirl.create(:user) }
      it { expect { delete :destroy, id: channel_subscriber.id }.to raise_error }
    end
  end
end

