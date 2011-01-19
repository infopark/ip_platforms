require 'spec_helper'

describe WsCategoriesController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "GET" do
    it "should 200" do
      auth_as_admin
      get :index
      response_should(200) do |hash|
        hash.size.should == 10
        hash.first["name"].should == "Arts"
      end
    end

    it "should give the series list" do
      Category.should_receive(:where).with(:parent_id => nil).and_return([])
      auth_as_admin
      get :index
      response.status.should == 204
    end
 end

  describe "POST" do
    it "should 200" do
      auth_as_admin
      post :create, :name => "foobar"
      response_should(200) do |hash|
        hash["name"].should == "foobar"
      end
    end

    it "should 400" do
      auth_as_admin
      post :create
      response_should(400)
    end

    it "should 403" do
      auth_as_user
      post :create, :name => "foobar"
      response.status.should == 403
    end
  end

  describe "GET #id" do
    it "should 200" do
      auth_as_admin
      get :show, :id => Category.find_by_name("Arts").id
      response_should(200) do |hash|
        hash["name"].should == "Arts"
      end
    end

    it "should 404" do
      auth_as_admin
      get :show, :id => 34283787238972
      response_should(404)
    end
  end
end

