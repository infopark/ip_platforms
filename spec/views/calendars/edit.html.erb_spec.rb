require 'spec_helper'

describe "calendars/edit.html.erb" do
  before(:each) do
    @calendar = assign(:calendar, stub_model(Calendar,
      :member_id => 1,
      :name => "MyString"
    ))
  end

  it "renders the edit calendar form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => calendar_path(@calendar), :method => "post" do
      assert_select "input#calendar_member_id", :name => "calendar[member_id]"
      assert_select "input#calendar_name", :name => "calendar[name]"
    end
  end
end
