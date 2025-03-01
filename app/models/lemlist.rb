module Lemlist
  def self.table_name_prefix
    "lemlist_"
  end

  TEAM_ID = "tea_hSBr4gYQ9J7ALq2P3"

  def self.campaign_url(campaign_id, slug = "leads")
    "https://app.lemlist.com/teams/#{TEAM_ID}/campaigns-next/#{campaign_id}/#{slug}"
  end
end
