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
    field :identifier, as: :text, hide_on: [:index]
    field :persona, as: :belongs_to, can_create: false

    field 'View on Lemlist', as: :text, label: 'View', as_html: true do
      "<a href='#{Lemlist.campaign_url(record.identifier, 'leads')}' target='_blank' class='rounded-xl px-4 py-1 bg-gray-700 text-white'>Lemlist ›</a>"
    end

    field 'Leads', as: :text do
      record.leads.count
    end
    field :leads, as: :has_many

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportLemlistCampaigns
    action Avo::Actions::ImportLemlist
  end
end
