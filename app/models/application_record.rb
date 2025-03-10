class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include ActionView::RecordIdentifier

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  # Orders results by column and direction
  def self.sort_by_params(column, direction)
    sortable_column = column.presence_in(sortable_columns) || "created_at"
    order(sortable_column => direction)
  end

  # Returns an array of sortable columns on the model
  # Used with the Sortable controller concern
  #
  # Override this method to add/remove sortable columns
  def self.sortable_columns
    @sortable_columns ||= columns.map(&:name)
  end

  def name
    return send(:name) if self.methods.include?('name')
    return read_attribute(:name) if has_attribute?(:name)
    return send(:title) if self.methods.include?('title')
    return read_attribute(:title) if has_attribute?(:title)
    'Name not provided'
  end

  def title
    name
  end

  def full_title
    title
  end

  protected
  def event_store
    Rails.configuration.event_store
  end
end
