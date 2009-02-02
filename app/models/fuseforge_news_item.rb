class FuseforgeNewsItem
  def self.recent
    (NewsItem.recent + ProjectNewsItem.recent_excluding_private).sort { |a,b| b.created_at <=> a.created_at }
  end
end