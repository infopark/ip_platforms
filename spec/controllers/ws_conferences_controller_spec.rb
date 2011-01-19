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
      response_should(400)
    end

    it 'should 403 if not series contact' do
      pending
    end
  end

  describe "GET show" do
    it "should give the conf list" do
      get(:show, :id => @conference.id)
      response_should(200) do |hash|
        hash.should == {
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

    it 'should 404 with wrong id' do
      get(:show, :id => 0)
      response_should(404)
    end
  end

  describe 'PUT update' do
    it 'should update conf' do
      put(:update, :id => @conference.id, :name => 'doofname')
      response_should(200) do |hash|
        hash['name'].should == 'doofname'
      end
      put(:update, :id => @conference.id, :name => "Black Hat DC 2011")
    end

    it 'should 400 with bad data' do
      put(:update, :id => @conference.id, :name => '')
      response_should(400)
    end

    it 'should 403 if not series contact' do
      pending
    end

    it 'should 404 with wrong id' do
      get(:update, :id => 0)
      response_should(404)
    end

    it 'should 409 if stale version' do
      pending
    end
  end

end
