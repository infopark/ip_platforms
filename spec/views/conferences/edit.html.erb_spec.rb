require 'spec_helper'

describe "conferences/edit.html.erb" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
      :version => 1,
      :name => "MyString",
      :creator_id => 1,
      :series_id => 1,
      :description => "MyString",
      :location => "MyString",
      :gps => "MyString",
      :venue => "MyString",
      :accomodation => "MyString",
      :howtofind => "MyString"
    ))
  end

  it "renders the edit conference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => conference_path(@conference), :method => "post" do
      assert_select "input#conference_version", :name => "conference[version]"
      assert_select "input#conference_name", :name => "conference[name]"
      assert_select "input#conference_creator_id", :name => "conference[creator_id]"
      assert_select "input#conference_series_id", :name => "conference[series_id]"
      assert_select "input#conference_description", :name => "conference[description]"
      assert_select "input#conference_location", :name => "conference[location]"
      assert_select "input#conference_gps", :name => "conference[gps]"
      assert_select "input#conference_venue", :name => "conference[venue]"
      assert_select "input#conference_accomodation", :name => "conference[accomodation]"
      assert_select "input#conference_howtofind", :name => "conference[howtofind]"
    end
  end
end
