class WsConferenceAttendeesController < AbstractWsController

  def create
    conference = find_conference
    if params[:username] == @current_user.username
      conference.participants << @current_user
      render_no_content
    else
      render_forbidden('you can only attend yourself')
    end
  end

  def delete
    conference = find_conference
    if params[:username] == @current_user.username
      conference.participants.delete(@current_user)
      render_no_content
    else
      render_forbidden('you can only revoke yourself')
    end
  end

  def index
    participants = find_conference.participants
    if participants.empty?
      render_no_content
    else
      render_ok(members.map {|member| member_hash(member, true)})
    end
  end

  private

  def find_conference
    Conference.find(params[:conference_id])
  end

end
