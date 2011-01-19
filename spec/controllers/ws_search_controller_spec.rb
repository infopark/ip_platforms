require 'spec_helper'

describe WsSearchController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "GET /{query}" do
    it "should 200" do
      auth_as_user
      get :show, :id => "science"
      response_should(200) do |hash|
        hash.size.should == 3
        hash.first["name"].should == "ICCFMS 2011 : International Conference on Communication, Film and Media Sciences"
      end
    end

    it "should 204" do
      Conference.should_receive(:extended_search).and_return([])
      auth_as_user
      get :show, :id => "asdjklksajd"
      response.status.should == 204
    end
  end
end
