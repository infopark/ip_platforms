require 'spec_helper'

describe "series/edit.html.erb" do
  before(:each) do
    @serie = assign(:serie, stub_model(Serie,
      :version => 1,
      :name => "MyString"
    ))
  end

  it "renders the edit serie form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => serie_path(@serie), :method => "post" do
      assert_select "input#serie_version", :name => "serie[version]"
      assert_select "input#serie_name", :name => "serie[name]"
    end
  end
end
