require 'spec_helper'

describe WsConferencesByCategoryController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "GET show" do
    it "should give the conf list" do
      auth_as_admin
      get(:show, :id => Category.find_by_name('IT-Security'))
      JSON.parse(response.body).should == [
          {
            "name"=>"26C3 - Here Be Dragons",
            "details"=>"http://test.host/ws/conferences/1",
          },
          {
            "name"=>"27C3 - We come in peace",
            "details"=>"http://test.host/ws/conferences/2",
          },
          {
            "name"=>"28C3 - ...",
            "details"=>"http://test.host/ws/conferences/3",
          },
          {
            "name"=>"Black Hat DC 2011",
            "details"=>"http://test.host/ws/conferences/4",
          },
      ]
    end

    it "should fails without auth" do
      get(:show, :id => Category.find_by_name('IT-Security'))
      response.status.should == 401
    end
  end

end
