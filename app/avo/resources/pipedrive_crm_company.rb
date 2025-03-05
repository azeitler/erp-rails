class Avo::Resources::PipedriveCrmCompany < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::Company
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :issues, as: :textarea
    field :title, as: :text
    field :customer_number, as: :text

    panel 'Import' do
      field "Properties", as: :code, theme: 'dracula', language: 'json', hide_on:[:new,:edit], format_using: ->  do
        JSON.pretty_generate(record.properties.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ParseAndSave
  end
end
