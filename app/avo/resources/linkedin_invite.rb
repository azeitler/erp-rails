class Avo::Resources::LinkedinInvite < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Linkedin::Invite
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :person

  def fields
    # field :id, as: :id
    field :person, as: :text, link_to_record: true
    field :linkedin_url, as: :text
    field :status, as: :badge, options: { success: ["accepted"], warning: ["sent"] }
    field :from_persona, as: :belongs_to, resource: Avo::Resources::Persona, link_to_resource: true
    field :created_at, as: :date_time
    field :accepted_at, as: :date_time

    panel 'Import' do
      field "Properties", as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate((record.properties || {}).sort.to_h)
      end
    end
  end
end
