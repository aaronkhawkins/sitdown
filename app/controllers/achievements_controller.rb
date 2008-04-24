class AchievementsController < ApplicationController
  before_filter :get_user
  
  def create
    @achievement = @user.achievements.new(params[:achievement])
    if @achievement.save!
      render :update do |page| 
        page['new_achievement'].reset
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
