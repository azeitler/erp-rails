class Avo::Resources::LinkedinInvite < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Linkedin::Invite
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :from_persona_id, as: :number
    field :person, as: :text
    field :linkedin_url, as: :text
    field :accepted_at, as: :date_time
    field :status, as: :text
  end
end
