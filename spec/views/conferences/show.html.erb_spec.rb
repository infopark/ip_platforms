require 'spec_helper'

describe "conferences/show.html.erb" do
  before(:each) do
    @conference = assign(:conference, stub_model(Conference,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Location/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gps/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Venue/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Accomodation/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Howtofind/)
  end
end
