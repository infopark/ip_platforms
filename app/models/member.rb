class Member < ActiveRecord::Base

  include BaseRecord
  include GpsLocation

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
  attr_accessible(:version)

  attr_readonly(:username)

  after_save(:create_default_calendar_if_none_exist)
  after_destroy(:destroy_calendars)

  def default_calendar
    calendars.where(:is_default => true).first
  end

  def create_default_calendar
    calendar = Calendar.new(:name => "Your personal calendar")
    calendar.is_default = true
    calendars << calendar
  end

  def create_default_calendar_if_none_exist
    create_default_calendar unless default_calendar
  end

  def destroy_calendars
    calendars.each do |calendar|
      calendar.destroy
    end
  end

  validates_uniqueness_of(:username)
  validates(:username, :presence => true, :length => { :maximum => 50 })
  validates(:fullname, :presence => true, :length => { :maximum => 100 })
  validates(:email, :presence => true, :length => { :maximum => 250 })
  validates(:town, :presence => true, :length => { :maximum => 100 })
  validates(:country, :presence => true, :length => { :maximum => 100 })
  validate(:validate_password_not_blank)

  def to_s
    username || super
  end

  def self.reset_or_create_default_admin!
    admin = Member.find_or_create_by_username('admin')
    admin.password = 'admin'
    admin.admin = true
    admin.fullname = 'Herr Admin'
    admin.email = 'root@localhost'
    admin.town = 'Nürnberg'
    admin.gps = '49.45052N,11.08048E'
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
      self.password_salt = self.password_hash = nil
    else
      salt = [Array.new(6){rand(256).chr}.join].pack('m').chomp
      hash = Digest::SHA256.hexdigest(password + salt)
      self.password_salt, self.password_hash = salt, hash
    end
  end

  def validate_password_not_blank
    if password_hash.blank?
      errors.add(:base, 'password can\'t be blank')
    end
  end

  def change_password!(new_password, new_password_confirmation)
    unless new_password == new_password_confirmation
      raise 'new password confirmation does not match'
    end
    self.password = new_password
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
      new_friend.notifications.create(:content =>
                  "You are now friends with #{self}")
    end
  end

  def self.search(q, state, member, location)
    r = self
    unless q.blank?
      if member && member.admin?
        c = multiword_text_filter_conditions(q, :username, :fullname, :email)
        r = r.where(c)
      else
        if member.nil? || state == 'noFriends' || member.friends.empty?
          r = r.where(['username LIKE ?', "%#{q}%"])
        else
          s = member.friends.map(&:id).join(',')
          r = r.where(["(username LIKE ? OR fullname LIKE ? AND id IN (#{s}))",
              "%#{q}%", "%#{q}%"])
        end
      end
    end
    if member
      case state.to_s
      when 'noFriends'
        unless member.friends.empty?
          r = r.where("id NOT IN (#{member.friends.map(&:id).join(',')})")
        end
      when 'noRCD'
        unless member.friend_requests_sent.empty?
          s = member.friend_requests_sent.map(&:id).join(',')
          r = r.where("id NOT IN (#{s})")
        end
      end
      case location.to_s
      when 'myTown'
        unless member.town.blank?
          r = r.where(:town => member.town)
        end
      when 'myCountry'
        unless member.country.blank?
          r = r.where(:country => member.country)
        end
      when '5', '10', '20', '50', '100', '200', '500', '1000', '2000', '5000'
        if member.has_gps_data?
          r = r.where(["SQRT(POW(ABS(?-lat),2)+POW(ABS(?-lng),2)) < ?",
              member.lat, member.lng, location.to_f/100])
        end
      end
    end
    r.all
  end

end
