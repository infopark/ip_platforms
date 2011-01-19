require 'spec_helper'

describe WsMembersController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "GET /" do
    it "should 200" do
      auth_as_admin
      post :create, :username => "kostia", :fullname => "Kostiantyn", :email => "kostiaka@infopark.de",
          :town => "Berlin", :country => "DE", :password => "test"
      response_should(200) do |hash|
        hash["username"].should == "kostia"
      end
    end

    it "should 400" do
      auth_as_admin
      post :create
      response.status.should == 400
    end
  end
end
