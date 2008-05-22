class StatusesController < ApplicationController
  before_filter :get_user

  def create
    active_statuses = current_user.statuses.find_active
    @status = current_user.statuses.new(params[:status])
    @status.active = true
    if @status.save!
      active_statuses.each do |status|
        status.active = false
        status.active_until = @status.created_at
        status.save!
      end
      render :update do |page| 
        page.replace_html "status-message", :partial => "users/display_status"
        page.replace_html "side-status-#{current_user.id}", @status.description
        page.replace_html "updated-ago-#{current_user.id}", :partial => "users/status_updated_ago", :locals => { :status => @status }
        page['new_status'].reset
        page << "eventSource.clear()"
        page << "Timeline.loadXML(\"#{url_for(@user)}.xml\", function(xml, url) { eventSource.loadXML(xml, url); });"
      end 
    end
  end

private

  def get_user
    @user = User.find(params[:user_id])
  end

end
