require 'spec_helper'

describe "series/show.html.erb" do
  before(:each) do
    @serie = assign(:serie, stub_model(Serie,
      :version => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
