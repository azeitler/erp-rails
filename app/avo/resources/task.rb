class Avo::Resources::Task < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.authorization_policy = ViewOnlyPolicy

  def fields
    field :id, as: :id
    field :job_class, as: :text
    field :status, as: :number
    field :result, as: :textarea
    field :log, as: :text
  end
end
