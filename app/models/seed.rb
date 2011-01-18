require "json"

class Seed

  def self.reset
    Calendar.delete_all
    Category.delete_all
    Conference.delete_all
    Member.delete_all
    Notification.delete_all
    Serie.delete_all
    Member.reset_or_create_default_admin!
  end

  def self.factorydefaults
    reset
    load_json_data
    create_members
    create_categories
    create_series
    create_conferences
  end

  private

  def self.load_json_data
    data = JSON.parse(Rails.root.join('lib', 'factorydefaults.json').read)
    @members, @categories, @series, @conferences = data
  end

  def self.create_members
    @members.each do |hash|
      password = hash.delete("password")
      member = Member.new(hash)
      member.password = password
      member.save!
    end
  end

  def self.create_categories
    @categories.each do |orig_hash|
      hash = orig_hash.dup
      hash.delete("parent")
      hash.delete("subcategories")
      Category.create!(hash)
    end
    @categories.each do |orig_hash|
      hash = orig_hash.dup
      parent_name = hash["parent"]["name"]
      if parent_name
        category = Category.where(:name => hash["name"]).first
        parent = Category.where(:name => parent_name).first
        category.parent = parent
        category.save!
      end
    end
  end

  def self.create_series
    @series.each do |orig_hash|
      hash = orig_hash.dup
      contact_hashes = hash.delete("contacts")
      serie = Serie.new(hash)
      contact_hashes.each do |contact_hash|
        contact = Member.where(:username => contact_hash["username"]).first
        serie.contacts << contact
      end
      serie.save!
    end
  end

  def self.create_conferences
    @conferences.each do |orig_hash|
      hash = orig_hash.dup
      creator_hash = hash.delete("creator")
      series_hash = hash.delete("series")
      category_hashes = hash.delete("categories")
      conference = Conference.new(hash)
      creator = Member.where(:username => creator_hash["username"]).first
      conference.creator = creator
      if series_hash.present?
        serie = Serie.where(:name => series_hash["name"]).first
        conference.serie = serie
      end
      category_hashes.each do |category_hash|
        category = Category.where(:name => category_hash["name"]).first
        conference.categories << category
      end
      conference.save!
    end
  end

end
