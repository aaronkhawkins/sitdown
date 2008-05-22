class AchievementsController < ApplicationController
  before_filter :get_user
  
  def create
    @achievement = current_user.achievements.new(params[:achievement])
    if @achievement.save!
      render :update do |page| 
        page["side-achievement-#{current_user.id}"].replace_html :partial => "users/side_achievements", :locals => { :user => current_user }
        page.insert_html :top, "day-#{@achievement.day.to_i}", :partial => "users/day_achievement", :locals => { :ach => @achievement }
        page['new_achievement'].reset
        #page << "eventSource.clear()"
        #page << "Timeline.loadXML(\"#{url_for(@user)}.xml\", function(xml, url) { eventSource.loadXML(xml, url); });"
      end 
    end
  end
  
  private

    def get_user
      @user = User.find(params[:user_id])
    end
end
