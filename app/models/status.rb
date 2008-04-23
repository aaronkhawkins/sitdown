class Status < ActiveRecord::Base
  belongs_to :user
  
  def self.find_active(options = {})
    with_scope :find => options do
      find_all_by_active(true, :order => 'created_at DESC')      
    end 
  end

  def self.find_inactive(options = {})
    with_scope :find => options do
      find_all_by_active(false, :order => 'created_at DESC')      
    end 
  end

end
