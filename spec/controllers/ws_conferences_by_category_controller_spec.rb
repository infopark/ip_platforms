require 'spec_helper'

describe WsConferencesByCategoryController do

  before(:all) do
    Seed.factorydefaults
  end

  describe "GET show" do
    it "should give the conf list" do
      auth_as_admin
      get(:show, :id => Category.find_by_name('IT-Security'))
      response_should(200) do |array|
        array.size.should == 4
        array.map {|h| h['name']}.should == [
          "26C3 - Here Be Dragons",
          "27C3 - We come in peace",
          "28C3 - ...",
          "Black Hat DC 2011",
        ]
      end
    end

    it "should fails without auth" do
      get(:show, :id => Category.find_by_name('IT-Security'))
      response.status.should == 401
    end
  end

end
