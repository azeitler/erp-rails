class Avo::Resources::InboundWebhook < Avo::BaseResource
  self.authorization_policy = ViewOnlyPolicy
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::InboundWebhook.statuses

    field :body, as: :code, theme: 'dracula', language: 'json', format_using: -> { JSON.pretty_generate(JSON.parse(value || "[]")) }

    field :controller_name, as: :text
    field :action_name, as: :text
    field :ip_address, as: :text
    field :user_agent, as: :text

    field :headers, as: :code, theme: 'dracula', language: 'json', format_using: -> { JSON.pretty_generate(value) }

    field :created_at, as: :date
  end

  def filters
    filter Avo::Filters::WebhookControllerFilter
  end

  def actions
    action Avo::Actions::ProcessWebhook
  end
end
