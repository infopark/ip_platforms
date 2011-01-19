class WsMemberContactsController < AbstractWsController

  def create
    member = find_member
    if params[:positive].nil?
      render_bad_request('must specify "positive"')
    else
      if params[:positive]
        if member.friend_requests_sent.include?(@current_user)
          @current_user.accept_rcd(member.id)
        else
          @current_user.add_rcd(member.id)
        end
      else
        if member.friend_requests_sent.include?(@current_user)
          @current_user.decline_rcd(member.id)
        else
          @current_user.revoke_rcd(member.id)
        end
      end
      render_no_content
    end
  end

  def index
    member = find_member
    contacts = member.friends + member.friend_requests_sent +
        member.friend_requests_received
    if member != @current_user && !@current_user.admin?
      contacts = contacts.select {|m| @current_user.friends.include?(m)}
    end
    if contacts.empty?
      render_no_content
    else
      contacts.map! do |m|
        {
          :username => m.username,
          :details => ws_member_url(m.username),
          :status =>
            if member.friend_requests_sent.include?(m)
              'RCD_sent'
            elsif member.friend_requests_received.include?(m)
              'RCD_received'
            else
              'no_contact'
            end,
        }
      end
      render_ok(contacts)
    end
  end

  private

  def find_member
    Member.find_by_username!(params[:member_id].to_s)
  end

end
