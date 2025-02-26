class Avo::Resources::ConnectedAccount < Avo::BaseResource
  self.title = :id
  self.includes = []
  self.model_class = ConnectedAccount

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :image_url, as: :external_image
    field :expired?, as: :boolean, hide_on: :forms
  end
end
