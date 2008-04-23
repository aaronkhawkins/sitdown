class Achievement < ActiveRecord::Base
  belongs_to :user
  
  def self.historical()
    find(:all, :order => 'created_at DESC')
  end
end
