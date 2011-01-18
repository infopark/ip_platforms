class Member < ActiveRecord::Base

  include BaseRecord
  include GpsLocation

  acts_as_mappable

  set_locking_column(:version)

  has_and_belongs_to_many(:friend_requests_received, :class_name => 'Member',
      :join_table => 'friend_requests',
      :foreign_key => :requestee_id,
      :association_foreign_key => :member_id)
  has_and_belongs_to_many(:friend_requests_sent, :class_name => 'Member',
      :join_table => 'friend_requests',
      :foreign_key => :member_id,
      :association_foreign_key => :requestee_id)
  has_and_belongs_to_many(:friends, :class_name => 'Member',
      :join_table => 'friends',
      :foreign_key => :friend_id)
  has_and_belongs_to_many(:participations, :class_name => 'Conference')
  has_and_belongs_to_many(:series)
  has_many(:calendars)
  has_many(:conferences, :foreign_key => :creator_id)
  has_many(:notifications, :order => 'created_at DESC')

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

  def to_s
    username || super
  end

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

  def defriend(friend_id)
    transaction do
      friend = Member.find(friend_id)
      friend.friends.delete(self)
      self.friends.delete(friend)
      self.notifications.create(:content => "You defriended #{friend}")
    end
  end

  def add_rcd(requestee_id)
    requestee = Member.find(requestee_id)
    raise 'You cannot be friend with yourself' if requestee == self
    requestee.friend_requests_received << self
    self.notifications.create(:content =>
                            "You want to be friends with #{requestee}")
  end

  def revoke_rcd(requestee_id)
    requestee = Member.find(requestee_id)
    requestee.friend_requests_received.delete(self)
    self.notifications.create(:content =>
                    "You revoked your friend request for #{requestee}")
  end

  def decline_rcd(requester_id)
    requester = Member.find(requester_id)
    friend_requests_received.delete(requester)
    self.notifications.create(:content =>
                "You declined a friendship request from #{requester}")
  end

  def accept_rcd(requester_id)
    transaction do
      new_friend = Member.find(requester_id)
      self.friend_requests_received.delete(new_friend)
      new_friend.friends << self
      self.friends << new_friend
      self.notifications.create(:content =>
                  "You accepted a friendship request from #{new_friend}")
    end
  end

  def search_members(q, state, location)
    r = Member
    unless q.blank?
      if state == 'noFriends' || friends.empty?
        r = r.where(['username LIKE ?', "%#{q}%"])
      else
        s = friends.map(&:id).join(',')
        r = r.where(["(username LIKE ? OR fullname LIKE ? AND id IN (#{s}))",
            "%#{q}%", "%#{q}%"])
      end
    end
    case state
    when 'noFriends'
      unless friends.empty?
        r = r.where("id NOT IN (#{friends.map(&:id).join(',')})")
      end
    when 'noRCD'
      unless friend_requests_sent.empty?
        r = r.where("id NOT IN (#{friend_requests_sent.map(&:id).join(',')})")
      end
    end
    case location
    when 'myTown'
      unless town.blank?
        r = r.where(:town => town)
      end
    when 'myCountry'
      unless country.blank?
        r = r.where(:country => country)
      end
    when '5', '10', '20', '50', '100', '200', '500', '1000', '2000', '5000'
      unless has_gps_data?
        r = r.where(["SQRT(POW(ABS(?-lat),2)+POW(ABS(?-lng),2)) < ?",
            lat, lng, location.to_f/100])
      end
    end
    r.all
  end

end
