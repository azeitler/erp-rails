class Avo::Resources::AccountUser < Avo::BaseResource
  self.title = :id
  self.includes = []

  def fields
    main_panel do
      field :id, as: :id
      field :account, as: :belongs_to
      field :user, as: :belongs_to
      field :roles,
        as: :boolean_group,
        options: {
          admin: "Administrator",
          member: "Member",
        }
      field :admin?, as: :boolean do
        record.roles["admin"] == true
      end

      sidebar do
        field :created_at, as: :date_time
        field :updated_at, as: :date_time
      end
    end
  end
end
