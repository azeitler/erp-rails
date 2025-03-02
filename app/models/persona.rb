# == Schema Information
#
# Table name: personas
#
#  id         :bigint           not null, primary key
#  alias      :string
#  email      :string
#  linkedin   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Persona < ApplicationRecord
end
