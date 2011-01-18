require 'spec_helper'

describe "series/new.html.erb" do
  before(:each) do
    assign(:serie, stub_model(Serie,
      :version => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new serie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => series_path, :method => "post" do
      assert_select "input#serie_version", :name => "serie[version]"
      assert_select "input#serie_name", :name => "serie[name]"
    end
  end
end
