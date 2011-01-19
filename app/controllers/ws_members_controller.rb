class WsMembersController < AbstractWsController

  def create
    member = Member.new(params)
    if member.save
      render_member(member)
    else
      render_bad_request(member.errors.full_messages.join(';'))
    end
  end

  def show
    member = Member.find_by_username!(params[:id])
    render_member(member)
  end

  def update
    member = Member.find_by_username!(params[:id])
    if member != @current_user
      render_forbidden('you can only update yourself')
    else
      member.attributes = params
      if member.save
        render_member(member)
      else
        render_bad_request(member.errors.full_messages.join(';'))
      end
    end
  end

  private

  def render_member(member)
    render_ok(member_hash(member))
  end

end
