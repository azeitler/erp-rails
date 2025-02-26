# a thing that is deleted by a profile
module ObjectWithIssues
  extend ActiveSupport::Concern

  included do
    serialize :issues, Array
    scope :has_issues, -> { where.not(issues: nil) }
  end

  def has_issues?
    self.issues.any?
  end

  def clear_issues
    self.issues = []
    save
  end

  def add_warning(title,params={})
    return if title.blank?
    params[:type] = :warning
    add_issue(title,params)
  end

  def add_error(title,params={})
    return if title.blank?
    params[:type] = :error
    add_issue(title,params)
  end

  def add_issue(title,params={})
    return if title.blank?
    params[:title] = title
    self.issues << params
  end

end
