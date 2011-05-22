class Feed < ActiveRecord::Base
  paginates_per 5
  
  belongs_to :feed_url
  validates_uniqueness_of :title, :scope => [:link]
  validates_presence_of :feed_url_id
  validates_numericality_of :feed_url_id
end
