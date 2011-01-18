require 'spec_helper'

describe "conferences/index.html.erb" do
  before(:each) do
    assign(:conferences, [
      stub_model(Conference,
        :version => 1,
        :name => "Name",
        :creator_id => 1,
        :serie_id => 1,
        :description => "Description",
        :location => "Location",
        :gps => "Gps",
        :venue => "Venue",
        :accomodation => "Accomodation",
        :howtofind => "Howtofind"
      ),
      stub_model(Conference,
        :version => 1,
        :name => "Name",
        :creator_id => 1,
        :serie_id => 1,
        :description => "Description",
        :location => "Location",
        :gps => "Gps",
        :venue => "Venue",
        :accomodation => "Accomodation",
        :howtofind => "Howtofind"
      )
    ])
  end

  it "renders a list of conferences" do
    pending
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Gps".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Venue".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Accomodation".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Howtofind".to_s, :count => 2
  end
end
