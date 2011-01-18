class Member < ActiveRecord::Base

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

  def self.reset_or_create_default_admin!
    admin = Member.find_or_create_by_username('admin')
    admin.password = 'admin'
    admin.admin = true
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
