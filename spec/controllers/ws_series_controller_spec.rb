require 'spec_helper'

describe WsSeriesController do

  before(:all) do
    Seed.factorydefaults
  end

  before do
    @conference = Conference.find_by_name('Black Hat DC 2011')
  end

  describe "GET index" do
    it "should give the series list" do
      auth_as_admin
      get :index
      JSON.parse(response.body).size.should == 3
      JSON.parse(response.body).first["name"].should == "ICSE"
      response.status.should == 200
    end

    it "should give the series list" do
      Serie.should_receive(:all).and_return([])
      auth_as_admin
      get :index
      response.status.should == 204
    end

    it "should fails without auth" do
      get :index
      response.status.should == 401
    end
  end

  describe "POST index" do
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

    it "should fails without auth" do
      post :create
      response.status.should == 401
    end
  end

  describe "GET #id" do
    it "should 200" do
      auth_as_admin
      get :show, :id => Serie.find_by_name("ICSE").id
      response_should(200) do |hash|
        hash["name"].should == "ICSE"
      end
    end

    it "should 404" do
      auth_as_admin
      get :show, :id => 34283787238972
      response_should(404)
    end
  end
end

