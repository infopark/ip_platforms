require 'spec_helper'

describe WsConferencesController do

  before(:all) do
    Seed.factorydefaults
  end

  before do
    @conference = Conference.find_by_name('Black Hat DC 2011')
    auth_as_admin
  end

  describe "POST create" do
    it 'should create the conf' do
      post(:create, :name => 'doof', :startdate => Date.today,
          :enddate => Date.today,
          :description => 'description')
      response_should(200) do |hash|
        hash['name'].should == 'doof'
      end
    end

    it 'should 400 with bad data' do
      post(:create, :name => 'doof')
      response.status.should == 400
    end
  end

  describe "GET show" do
    it "should give the conf list" do
      get(:show, :id => @conference.id)
      JSON.parse(response.body).should == {
        "name"=>"Black Hat DC 2011",
        "location"=>"2799 Jefferson Davis Hwy, Arlington, VA 22202, United States",
        "enddate"=>"2011-01-19",
        "creator"=> {
          "details"=>"http://test.host/ws/members/mzuckerberg",
          "username"=>"mzuckerberg"
        },
       "accomodation"=>nil,
       "id"=>4,
       "howtofind"=>nil,
       "version"=>"0",
       "venue"=>"Hyatt Regency Crystal Hotel",
       "description"=>"The Black Hat Conference is a computer security conference that brings together a variety of people interested in information security. Representatives of federal agencies and corporations attend along with hackers. The Briefings take place regularly in Las Vegas, Barcelona (previously Amsterdam) and Tokyo. An event dedicated to the Federal Agencies is organized in Washington, D.C..",
       "categories"=> [
         {
           "name"=>"Technology",
           "details"=>"http://test.host/ws/categories/10"
         },
         {
           "name"=>"IT-Security",
           "details"=>"http://test.host/ws/categories/13"
         }
       ],
       "startdate"=>"2011-01-16",
       "gps"=>"38.52N,77.6W",
      }
    end
  end

  describe 'PUT update' do
  end

end

