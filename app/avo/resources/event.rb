class Avo::Resources::Event < Avo::BaseResource
  self.model_class = ::Event
  self.authorization_policy = ViewOnlyPolicy

  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.title = :event_type

  def fields
    # field :id, as: :id
    field :event_type, as: :text, link_to_record: true, hide_on: [:index]
    field :event_label, as: :text, link_to_record: true, format_using: ->  do
      begin
        record.event_type.constantize.new(event_id:record.event_id,data:record.data).event_label
      rescue StandardError => e
        Rails.logger.error "Error: #{record.event_type} (Fallback) -> #{e}"
        "#{record.event_type} (Fallback) #{e}"
      end
    end
    field :event_id, as: :text
    # field :data, as: :code
    # field :metadata, as: :code
    field :created_at, as: :date_time
    field :data, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end
    field :metadata, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end
  end
end
