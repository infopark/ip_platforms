class HomeController < ApplicationController

  def index
    @conferences_current = Conference.where("startdate <= ?", Date.today).
                                      where("enddate >= ?", Date.today)
    @conferences_next_day = Conference.where(:startdate => Date.today + 1.day)
    @conferences_next_week = Conference.where(:startdate => Date.today + 1.week)
    @conferences_next_10 = Conference.where("startdate >= ?", Date.today).
                                            order('startdate ASC').limit(10)
    @categories_first = Category.limit(15)
  end

end
