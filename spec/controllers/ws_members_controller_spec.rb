require 'spec_helper'

describe WsMembersController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "POST /" do
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

  describe "GET /{username}" do
    it "should 200" do
      auth_as_admin
      get :show, :id => "admin"
      response_should(200) do |hash|
        hash["username"].should == "admin"
      end
    end

    it "should 404" do
      auth_as_admin
      get :show, :id => "chupacabra"
      response.status.should == 404
    end
  end

  describe 'PUT update' do
    before do
      @member = Member.find_by_username("admin")
    end

    it 'should update conf' do
      auth_as_admin
      put :update, :id => "admin", :fullname => "Kostiantyn", :email => "kostiaka@infopark.de",
          :town => "München", :country => "DE", :password => "test"
      response_should(200) do |hash|
        hash['username'].should == "admin"
        hash['town'].should == "München"
      end
    end

    it 'should 400 with bad data' do
      auth_as_admin
      put :update, :id => "admin", :username => ""
      response_should(400)
    end

    it 'should 403 if not series contact' do
      auth_as_admin
      put :update, :id => "bgates", :fullname => "Kostiantyn", :email => "kostiaka@infopark.de",
          :town => "Berlin", :country => "DE", :password => "test"
      response_should(403)
    end

    it 'should 404 with wrong id' do
      auth_as_admin
      put :update, :id => "chupacabra", :fullname => "Kostiantyn", :email => "kostiaka@infopark.de",
          :town => "Berlin", :country => "DE", :password => "test"
      response_should(404)
    end

    it 'should 409 if stale version' do
      auth_as_admin
      put :update, :id => "admin", :fullname => "Kostiantyn", :email => "kostiaka@infopark.de",
          :town => "Berlin", :country => "DE", :password => "test", :version => -1
      response_should(409)
    end
  end
end
