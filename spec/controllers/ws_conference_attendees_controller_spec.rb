require 'spec_helper'

describe WsConferenceAttendeesController do

  before(:all) do
    Seed.factorydefaults
  end

  before do
    @conference = Conference.find_by_name('Black Hat DC 2011')
    auth_as_admin
  end

  describe "POST create" do
    it 'should create the attendee' do
      post(:create, :conference_id => @conference.id, :username => 'admin')
      response_should(204)
    end

    it 'should 403 if not self' do
      post(:create, :conference_id => @conference.id, :username => 'sjobs')
      response_should(403)
    end

    it 'should 404 with wrong id' do
      post(:create, :conference_id => 0)
      response_should(404)
    end
  end

  describe "GET index" do
    it "should 200 if attendees" do
      @conference.participants << Member.first
      get(:index, :conference_id => @conference.id)
      response_should(200) do |hash|
        hash.should == [
          {
            "details"=>"http://test.host/ws/members/admin",
            "username"=>"admin",
          }
        ]
      end
      @conference.participants.clear
    end

    it "should 204 if no attendees" do
      get(:index, :conference_id => @conference.id)
      response_should(204)
    end

    it 'should 404 with wrong id' do
      get(:index, :conference_id => 0)
      response_should(404)
    end
  end

  describe 'DELETE destroy' do
    it 'should 204' do
      delete(:destroy, :conference_id => @conference.id, :id => 'admin')
      response_should(204)
    end

    it 'should 403 if not self' do
      delete(:destroy, :conference_id => @conference.id, :id => 'sjobs')
    end

    it 'should 404 with wrong id' do
      delete(:destroy, :conference_id => 0, :id => 'sjobs')
      response_should(404)
    end
  end

end

