require 'spec_helper'

describe WsConferencesController do

  before(:all) do
    Seed.factorydefaults
  end

  before do
    @conference = Conference.find_by_name('Black Hat DC 2011')
  end

  describe "POST create" do
  end

  describe "GET show" do
    it "should give the conf list" do
      auth_as_admin
      get(:show, :id => @conference.id)
      JSON.parse(response.body).should == {
        "name"=>"Black Hat DC 2011",
        "location"=>"2799 Jefferson Davis Hwy, Arlington, VA 22202, United States",
        "enddate"=>"2011-01-19",
        "creator"=> {"details"=>"http://test.host/ws/members/mzuckerberg",
   "username"=>"mzuckerberg"},
 "accomodation"=>nil,
 "id"=>4,
 "howtofind"=>nil,
 "version"=>"0",
 "venue"=>"Hyatt Regency Crystal Hotel",
 "description"=>
  "The Black Hat Conference is a computer security conference that brings together a variety of people interested in information security. Representatives of federal agencies and corporations attend along with hackers. The Briefings take place regularly in Las Vegas, Barcelona (previously Amsterdam) and Tokyo. An event dedicated to the Federal Agencies is organized in Washington, D.C..",
 "categories"=>
  [{"name"=>"Technology", "details"=>"http://test.host/ws/categories/10"},
   {"name"=>"IT-Security", "details"=>"http://test.host/ws/categories/13"}],
 "startdate"=>"2011-01-16",
 "gps"=>"38.52N,77.6W"}
    end

    it "should fails without auth" do
      get(:show, :id => @conference.id)
      response.status.should == 401
    end
  end

  describe 'PUT update' do
  end

end

