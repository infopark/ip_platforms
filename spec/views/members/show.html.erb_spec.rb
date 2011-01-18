require 'spec_helper'

describe "members/show.html.erb" do
  before(:each) do
    @member = assign(:member, stub_model(Member,
      :version => 1,
      :username => "Username",
      :password_hash => "Password Hash",
      :password_salt => "Password Salt",
      :fullname => "Fullname",
      :email => "Email",
      :town => "Town",
      :country => "Country",
      :gps => "Gps",
      :admin => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Username/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password Hash/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password Salt/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Fullname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Town/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gps/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
