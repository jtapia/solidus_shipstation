require 'spec_helper'

describe Spree::ShipstationController do
  before do
    controller.stub(check_authorization: false, spree_current_user: FactoryGirl.create(:user))
    @request.accept = 'application/xml'
  end

  context "export" do
    before do
      Spree::Shipment.stub_chain(:exportable, :between).with(Time.new(2013, 12, 31,  8, 0, 0, "+00:00"),
                                                             Time.new(2014,  1, 13, 23, 0, 0, "+00:00"))
                                                       .and_return(:some_shipments)

      get :export, start_date: '12/31/2013 8:00', end_date: '1/13/2014 23:00', use_route: :spree
    end

    specify { response.should be_success }
    specify { assigns(:shipments).should == :some_shipments}
  end

  context "shipnotify" do
    before do
      get :shipnotify, use_route: :spree
    end

    specify { response.should be_success }
    specify { response.body.should =~ /success/ }
  end

  it "doesnt know unknown" do
    expect { get :unknown, use_route: :spree }.to raise_error(AbstractController::ActionNotFound)
  end
end
