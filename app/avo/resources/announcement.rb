class Avo::Resources::Announcement < Avo::BaseResource
  self.title = :title
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], title_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.title,
      }
    }
  }

  def fields
    field :id, as: :id
    field :title, as: :text
    field :description, as: :trix, always_show: true
    field :kind, as: :badge, options: {success: "new", info: "improvement", danger: "fix", warning: "update"}, hide_on: :forms
    field :kind, as: :select, options: Announcement::TYPES.map { |t| [t, t] }.to_h, show_on: :forms
    field :published_at, as: :date_time
  end
end
