require 'spec_helper'

describe "calendars/new.html.erb" do
  before(:each) do
    assign(:calendar, stub_model(Calendar,
      :member_id => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new calendar form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => calendars_path, :method => "post" do
      assert_select "input#calendar_member_id", :name => "calendar[member_id]"
      assert_select "input#calendar_name", :name => "calendar[name]"
    end
  end
end
