class StatusesController < ApplicationController
  before_filter :get_user

  def create
    active_statuses = @user.statuses.find_active
    @status = @user.statuses.new(params[:status])
    @status.active = true
    if @status.save!
      active_statuses.each do |status|
        status.active = false
        status.active_until = @status.created_at
        status.save!
      end
      render :update do |page| 
        page.replace_html "status-message", :partial => "users/display_status"
        page.replace_html "side-status-#{@user.id}", @status.description
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
