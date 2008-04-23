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
        page.replace_html "status", :partial => "users/display_status" 
      end 
      
      # redirect_to :controller => "users", :action => "show", :id => @user
    end
  end

private

  def get_user
    @user = User.find(params[:user_id])
  end

end
