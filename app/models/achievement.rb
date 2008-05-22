class Achievement < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :description
  
  def self.historical(limit=0)
    results = find(:all, :order => 'created_at DESC')
    if limit == 0
      return results
    else
      range = [limit-1, results.size].min
      find(:all, :order => 'created_at DESC')[0..range]
    end
  end
  
  def day
    created_at.midnight
  end
end
