require 'spec_helper'

describe WsConferencesController do

  before do
    Seed.factorydefaults
    @admin = Member.find_by_username('admin')
    @conference = Conference.find_by_name('Black Hat DC 2011')
    @serie = Serie.find_by_name('ICSE')
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
      post(:create, :name => 'doof', :startdate => Date.today,
          :enddate => Date.today,
          :series => {:name => @serie.name},
          :description => 'description')
      response_should(403)
    end

    it 'should 200 if series contact' do
      @serie.contacts << @admin
      post(:create, :name => 'doof', :startdate => Date.today,
          :enddate => Date.today,
          :series => {:name => @serie.name},
          :description => 'description')
      response_should(200)
    end
  end

  describe "GET show" do
    it "should 200" do
      get(:show, :id => @conference.id)
      response_should(200) do |hash|
        hash['name'].should == "Black Hat DC 2011"
        hash["enddate"].should == "2011-01-19"
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
      put(:update, :id => @conference.id,
          :series => {:name => @serie.name})
      response_should(403)
    end

    it 'should 200 if series contact' do
      @serie.contacts << @admin
      put(:update, :id => @conference.id,
          :series => {:name => @serie.name})
      response_should(200)
    end

    it 'should 404 with wrong id' do
      get(:update, :id => 0)
      response_should(404)
    end

    it 'should 409 if stale version' do
      put(:update, :id => @conference.id, :name => 'doofname', :version => -1)
      response_should(409)
    end
  end

end
