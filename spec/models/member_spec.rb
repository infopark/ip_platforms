require 'spec_helper'

describe Member do

  before do
    @m = Member.new(:username => 'test',
        :fullname => 'full',
        :email => 'email@example.org',
        :town => 'Berlin',
        :country => 'Germany')
    @m.password = 'tttt'
    @m.save!
  end

  it 'should set password' do
    @m.check_password('testpw').should be_false
    @m.password = 'testpw'
    @m.password_hash.should_not be_nil
    @m.password_salt.should_not be_nil
    @m.check_password('testpw').should be_true
  end

  it 'should change password if it is confirmed' do
    @m.check_password('testpw').should be_false
    @m.change_password!('testpw', 'testpw')
    @m.reload.check_password('testpw').should be_true
  end

  it 'should NOT change password and raise if it is not confirmed' do
    lambda do
      @m.change_password!('testpw', nil)
    end.should raise_error(StandardError,
        'new password confirmation does not match')
    @m.reload.check_password('testpw').should be_false
  end

  it 'should NOT set empty password' do
    @m.password = ''
    @m.should_not be_valid
  end

  it 'should NOT set NIL password' do
    @m.password = nil
    @m.should_not be_valid
  end

end

describe 'given some members' do
  before do
    @m1 = Member.new(:username => 'user1',
        :fullname => 'full',
        :email => 'email@example.org',
        :town => 'Berlin',
        :country => 'Germany')
    @m1.password = 'pw1'
    @m1.save!
    @m2 = Member.new(:username => 'user2',
        :fullname => 'full',
        :email => 'email@example.org',
        :town => 'Berlin',
        :country => 'Germany')
    @m2.password = 'pw2'
    @m2.save!
  end

  it 'should authenticate with correct password' do
    Member.authenticate('user1', 'pw1').should == @m1
    Member.authenticate('user2', 'pw2').should == @m2
  end

  it 'should NOT authenticate with wrong password' do
    Member.authenticate('user1', 'pw2').should be_nil
    Member.authenticate('user2', 'pw1').should be_nil
  end

  it 'should NOT authenticate without password' do
    Member.authenticate('user1', nil).should be_nil
    Member.authenticate('user2', nil).should be_nil
  end

end
