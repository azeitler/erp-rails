class Avo::Resources::PipedriveCrmField < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::Field
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    # field :id, as: :id
    field :title, as: :id
    field :active_flag, as: :boolean
    field :edit_flag, as: :boolean
    # field :last_updated_by_user_id, as: :text
    field :description, as: :text, as_description: true, hide_on: [:index], as_html: true, format_using: ->  do
      "<code><small class='font-bold'>#{value}</small></code> – #{record.field_target.capitalize}"
    end
    field :field_target, as: :badge, sortable: true, options: { success: ["organization"], warning: ["deal"], danger: ["product"] }
    field :field_type, as: :text, as_html: true, sortable: true, format_using: ->  do
      "<code><small class='font-bold'>#{value}</small></code>"
    end
    field :field_name, as: :text, as_html: true, sortable: true, format_using: ->  do
      "<code><small>#{value}</small></code>"
    end
    field :field_level, as: :text, as_html: true, sortable: true, format_using: -> do
      record.system_level? ?
        "<code class='bg-red-500 text-white text-xs font-semibold mr-2 px-2 py-1 rounded'>#{record.field_level.capitalize}</code>" :
        "<code class='bg-gray-500 text-white text-xs font-semibold mr-2 px-2 py-1 rounded'>#{record.field_level.capitalize}</code>"
    end
    field :field_options, as: :text, hide_on:[:index]
    field :user, as: :belongs_to

    field :properties, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end

    field :values, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end
  end

  def filters
    filter Avo::Filters::PipedriveFieldLevelFilter
    filter Avo::Filters::PipedriveFieldTypeFilter
    filter Avo::Filters::PipedriveFieldTargetFilter
  end

  def actions
    action Avo::Actions::ImportPipedriveFields
  end
end
