class Member < ActiveRecord::Base

  include BaseRecord
  include GpsLocation

  acts_as_mappable

  set_locking_column(:version)

  has_and_belongs_to_many(:friend_requests, :class_name => 'Member',
      :join_table => 'friend_requests', :foreign_key => :requestee_id)
  has_and_belongs_to_many(:friends, :class_name => 'Member',
      :join_table => 'friends', :foreign_key => :friend_id)
  has_and_belongs_to_many(:participations, :class_name => 'Conference')
  has_and_belongs_to_many(:series)
  has_many(:calendars)
  has_many(:conferences, :foreign_key => :creator_id)
  has_many(:notifications)

  attr_accessible(:username)
  attr_accessible(:fullname)
  attr_accessible(:email)
  attr_accessible(:town)
  attr_accessible(:country)

  attr_readonly(:username)

  validates(:username, :presence => true, :length => { :maximum => 50 })
  validates(:fullname, :length => { :maximum => 100 })
  validates(:email, :length => { :maximum => 250 })
  validates(:town, :length => { :maximum => 100 })
  validates(:country, :length => { :maximum => 100 })

  def self.reset_or_create_default_admin!
    admin = Member.find_or_create_by_username('admin')
    admin.password = 'admin'
    admin.admin = true
    admin.fullname = 'Herr Admin'
    admin.email = 'root@localhost'
    admin.town = 'Berlin'
    admin.country = 'Germany'
    admin.save!
  end

  def self.authenticate(username, password)
    member = find_by_username(username)
    (member && member.check_password(password)) ? member : nil
  end

  def check_password(password)
    return false if password.blank? || password_hash.blank?
    password_hash == Digest::SHA256.hexdigest("#{password}#{password_salt}")
  end

  def password_set?
    !password_hash.blank?
  end

  def password=(password)
    if password.blank?
      raise 'new password cannot be blank'
    end
    salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
    hash = Digest::SHA256.hexdigest(password + salt)
    self.password_salt, self.password_hash = salt, hash
  end

  def change_password!(new_password, new_password_confirmation)
    unless new_password == new_password_confirmation
      raise 'new password confirmation does not match'
    end
    self.password = new_password
    save!
  end

  def clear_password!
    self.password_salt, self.password_hash = nil, nil
    save!
  end

end
