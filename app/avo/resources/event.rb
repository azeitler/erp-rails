class Avo::Resources::Event < Avo::BaseResource
  self.model_class = ::Event
  self.authorization_policy = ViewOnlyPolicy

  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.title = :id

  def fields
    # field :id, as: :id
    field :event_type, as: :text, link_to_record: true
    field :event_label, as: :text, format_using: ->  do
      begin
        record.becomes(record.event_type.constantize).event_label
      rescue StandardError
        record.event_type
      end
    end
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
