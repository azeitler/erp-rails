class Avo::Resources::PipedriveCrmPerson < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::Person
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :title

  def fields
    field :id, as: :id, readonly:true, hide_on:[:index], link_to_record: true
    field :title, as: :text, readonly:true
    field :email, as: :text, readonly:true
    field :identifier, as: :text, hide_on:[:index]
    field :custom_fields, as: :key_value, disabled:false
    # field :issues, as: :array


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
