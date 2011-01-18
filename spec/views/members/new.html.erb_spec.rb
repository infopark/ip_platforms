require 'spec_helper'

describe "members/new.html.erb" do
  before(:each) do
    assign(:member, stub_model(Member,
      :version => 1,
      :username => "MyString",
      :password_hash => "MyString",
      :password_salt => "MyString",
      :fullname => "MyString",
      :email => "MyString",
      :town => "MyString",
      :country => "MyString",
      :gps => "MyString",
      :admin => false
    ).as_new_record)
  end

  it "renders new member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => members_path, :method => "post" do
      assert_select "input#member_version", :name => "member[version]"
      assert_select "input#member_username", :name => "member[username]"
      assert_select "input#member_password_hash", :name => "member[password_hash]"
      assert_select "input#member_password_salt", :name => "member[password_salt]"
      assert_select "input#member_fullname", :name => "member[fullname]"
      assert_select "input#member_email", :name => "member[email]"
      assert_select "input#member_town", :name => "member[town]"
      assert_select "input#member_country", :name => "member[country]"
      assert_select "input#member_gps", :name => "member[gps]"
      assert_select "input#member_admin", :name => "member[admin]"
    end
  end
end
