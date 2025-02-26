class Avo::Resources::InboundWebhook < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::InboundWebhook.statuses

    field :body, as: :code, theme: 'dracula', language: 'json' do |model, resource, view|
      JSON.pretty_generate(model.body)
    end

    field :controller_name, as: :text
    field :action_name, as: :text
    field :ip_address, as: :text
    field :user_agent, as: :text

    field :headers, as: :code, theme: 'dracula', language: 'json' do |model, resource, view|
      JSON.pretty_generate(model.headers)
    end
  end
end
