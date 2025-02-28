class Avo::Resources::BreakcoldLeadActivity < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::LeadActivity
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :title

  def fields
    # field :id, as: :id
    field :title, as: :text
    field :lead, as: :belongs_to, resource: Avo::Resources::BreakcoldLead, link_to_resource: true
  end
end
