class AbstractWsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  private

  def before_filter_set_current_user
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = Member.authenticate(username, password)
    end
  end

  rescue_from StandardError, :with => :rescue_from_standard_error

  def rescue_from_standard_error(exception)
    case exception
    when ActiveRecord::RecordNotFound,
        ActionController::UnknownController,
        ActionController::UnknownAction,
        ActionController::RoutingError
      render_not_found(exception.message)
    when ActionController::MethodNotAllowed
      render_forbidden(exception.message)
    when ActiveRecord::StaleObjectError
      render_stale_object(exception.message)
    else
      render_server_error(exception.message)
    end
  end

  def render_error(status, message)
    render(:json => {:error => message}, :status => status)
  end

  def render_server_error(message='server error')
    render_error(500, message)
  end

  def render_stale_object(message='conflict')
    render_error(:conflict, message)
  end

  def render_not_found(message='not found')
    render_error(:not_found, message)
  end

  def render_forbidden(message='forbidden')
    render_error(:forbidden, message)
  end

  def render_ok(json)
    render(:json => json, :status => :ok)
  end

  def render_bad_request(message='bad request')
    render_error(:bad_request, message)
  end

  def render_no_content
    head(:no_content)
  end

  def conference_hash(conference, only_ref=false)
    if only_ref
      {
        :name => conference.name,
        :details => ws_conference_url(conference),
      }
    else
      hash = {
        :version => conference.version.to_s,
        :id => conference.id,
        :name => conference.name,
        :startdate => conference.startdate.strftime('%Y-%m-%d'),
        :enddate => conference.enddate.strftime('%Y-%m-%d'),
        :description => conference.description,
        :location => conference.location,
        :gps => conference.gps,
        :venue => conference.venue,
        :accomodation => conference.accomodation,
        :howtofind => conference.howtofind,
      }
      if conference.creator
        hash[:creator] = member_hash(conference.creator, true)
      end
      if conference.serie
        hash[:series] = serie_hash(conference.serie, true)
      end
      unless conference.categories.empty?
        hash[:categories] = conference.categories.map do |category|
          category_hash(category, true)
        end
      end
      hash
    end
  end

  def category_hash(category, only_ref=false)
    if only_ref
      {
        :name => category.name,
        :details => ws_category_url(category),
      }
    else
      hash = {
        :version => category.version.to_s,
        :id => category.id,
        :name => category.name,
      }
      if category.parent
        hash[:parent] = category_hash(category.parent, true)
      end
      unless category.children.empty?
        hash[:subcategories] = category.children.map do |c|
          category_hash(c, true)
        end
      end
      hash
    end
  end

  def serie_hash(serie, only_ref=false)
    if only_ref
      {
        :name => serie.name,
        :details => ws_serie_url(serie),
      }
    else
      hash = {
        :version => serie.version.to_s,
        :id => serie.id,
        :name => serie.name,
      }
      unless serie.contacts.empty?
        hash[:contacts] = serie.contacts.map do |member|
          member_hash(member, true)
        end
      end
      hash
    end
  end

  def member_hash(member, only_ref=false)
    if only_ref
      {
        :username => member.username,
        :details => ws_member_url(member.username),
      }
    else
      hash = {
        :version => member.version.to_s,
        :id => member.id,
        :username => member.username,
        :town => member.town,
        :country => member.country,
      }
      if @current_user.friends.include?(member)
        hash.merge!({
          :fullname => member.fullname,
          :email => member.email,
          :gps => member.gps,
          :status => 'in_contact',
        })
      else
        hash[:status] =
          if @current_user.friend_requests_sent.include?(member)
            'RCD_sent'
          elsif @current_user.friend_requests_received.include?(member)
            'RCD_received'
          else
            'no_contact'
          end
      end
    end
    hash
  end

end
