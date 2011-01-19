require 'spec_helper'

describe WsMemberContactsController do

  before(:all) do
    Seed.factorydefaults
  end

  before do
    @member = Member.find_by_username('sjobs')
    @admin = Member.find_by_username('admin')
    auth_as_admin
  end

  describe "POST create" do
    it 'should 204' do
      post(:create, :member_id => @member.username, :username => 'admin',
          :positive => 1)
      response_should(204)
      @member.reload.friend_requests_received.should include(@admin)
    end

    it 'should 204 if positive false' do
      post(:create, :member_id => @member.username, :username => 'admin',
          :positive => false)
      response_should(204)
      @member.reload.friend_requests_received.should_not include(@admin)
    end

    it 'should 400 if no positive param' do
      post(:create, :member_id => @member.username, :username => 'sjobs')
      response_should(400)
    end

    it 'should 404 with wrong id' do
      post(:create, :member_id => 0)
      response_should(404)
    end
  end

  describe "GET index" do
    it "should 200 if friends" do
      @member.friends << Member.find_by_username('sballmer')
      get(:index, :member_id => @member.username)
      response_should(200) do |hash|
        hash.should == [
          {
            "details"=>"http://test.host/ws/members/sballmer",
            "username"=>"sballmer",
            "status"=>"no_contact",
          }
        ]
      end
      @member.friends.clear
    end

    it "should 204 if no friends" do
      get(:index, :member_id => @member.username)
      response_should(204)
    end

    it 'should 404 with wrong id' do
      get(:index, :member_id => 0)
      response_should(404)
    end
  end

end

