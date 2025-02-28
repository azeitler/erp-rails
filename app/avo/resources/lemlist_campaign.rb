class Avo::Resources::LemlistCampaign < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Lemlist::Campaign
  self.authorization_policy = LemlistCampaignPolicy
  self.title = :title
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :title, as: :text, link_to_record: true
    field :status, as: :badge, options: {
      success: :running,
      warning: :paused,
      danger: [:stopped, :ended],
      neutral: [:archived]
    }
    # field :id, as: :id
    # field :identifier, as: :text
    field :persona, as: :belongs_to, can_create: false
    field 'Leads', as: :text do
      record.leads.count
    end
    field :leads, as: :has_many

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportLemlistCampaigns
  end
end
