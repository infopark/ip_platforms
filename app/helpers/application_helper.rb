module ApplicationHelper

  def page_title
    "Infopark CaP | #{@controller.controller_name.humanize}"
  end

end
