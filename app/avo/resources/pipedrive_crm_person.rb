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
    field :id, as: :id, readonly:true, hide_on:[:index]
    field :title, as: :text, readonly:true, link_to_record: true
    field :email, as: :text, readonly:true
    field :emails, as: :tags, readonly:true
    field :labels, as: :tags, readonly:true
    # field :label_ids, as: :tags, readonly:true
    field :label_names, as: :tags, readonly:true
    field :identifier, as: :text, hide_on:[:index]
    field :custom_field_values, as: :key_value, disabled:false
    field :updated_at, as: :date_time, readonly:true
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
