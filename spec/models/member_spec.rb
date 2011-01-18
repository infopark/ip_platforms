require 'spec_helper'

describe Member do

  before do
    @m = Member.create!(:username => 'test')
  end

  it 'should initially have no password set' do
    @m.should_not be_password_set
    @m.password_hash.should be_nil
    @m.password_salt.should be_nil
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

  it 'should NOT set empty password and raise' do
    lambda do
      @m.password = ''
    end.should raise_error(StandardError, 'new password cannot be blank')
  end

  it 'should NOT set NIL password and raise' do
    lambda do
      @m.password = nil
    end.should raise_error(StandardError, 'new password cannot be blank')
  end

  describe 'with password set' do
    before do
      @m.change_password!('testpw', 'testpw')
    end

    it 'should be password_set' do
      @m.should be_password_set
    end

    it 'should clear password' do
      @m.check_password('testpw').should be_true
      @m.clear_password!
      @m.password_hash.should be_nil
      @m.password_salt.should be_nil
      @m.check_password('testpw').should be_false
    end
  end

end

describe 'given some members' do
  before do
    @m1 = Member.new(:username => 'user1')
    @m1.password = 'pw1'
    @m1.save!
    @m2 = Member.new(:username => 'user2')
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
