class WsSearchController < AbstractWsController

  def show
    conferences = Conference.extended_search(params[:id], @current_user)
    if conferences.empty?
      render_no_content
    else
      render_ok(conferences.map {|c| conference_hash(c, true)})
    end
  end

end
