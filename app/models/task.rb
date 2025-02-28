# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  job_class  :string
#  log        :string           default([]), is an Array
#  result     :text
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Task < ApplicationRecord
end
