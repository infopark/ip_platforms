class WsConferencesByCategoryController < AbstractWsController

  def show
    category = Category.find(params[:id])
    if category.conferences.empty?
      render_no_content
    else
      render_ok(category.conferences.map {|c| conference_hash(c, true)})
    end
  end

end
