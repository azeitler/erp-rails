class Avo::Resources::InboundWebhook < Avo::BaseResource
  self.authorization_policy = ViewOnlyPolicy
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.title = :label

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::InboundWebhook.statuses

    field :label, as: :text, format_using: -> { record.label }
    field :action_name, as: :text
    field :ip_address, as: :text
    field :user_agent, as: :text
    field :event, as: :text

    field :pipedrive_person, as: :belongs_to, readonly: true, use_resource: Avo::Resources::PipedriveCrmPerson#, hide_on:[:index]
    # field :pipedrive_person, as: :text, readonly: true, hide_on:[:index]
    field :created_at, as: :date_time

    field :body, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: -> { JSON.pretty_generate(JSON.parse(value || "[]")) }

    field :headers, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: -> { JSON.pretty_generate(value.sort.to_h) }

  end

  def filters
    filter Avo::Filters::WebhookControllerFilter
  end

  def actions
    action Avo::Actions::ProcessWebhook
  end
end
