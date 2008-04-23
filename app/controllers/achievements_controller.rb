class AchievementsController < ApplicationController
  before_filter :get_user
  
  def create
    @achievement = @user.achievements.new(params[:achievement])
    if @achievement.save!
      render :update do |page| 
        # page.replace_html "achievement", :partial => "users/display_achievements"
        page['new_achievement'].reset
        page.replace_html "historical-achievements", :partial => "historical_achievements", :collection => @user.achievements.historical
      end 
    end
  end
  
  private

    def get_user
      @user = User.find(params[:user_id])
    end
end
