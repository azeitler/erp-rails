# frozen_string_literal: true
class ViewOnlyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def edit?
    false
  end

  def act_on?
    true
  end

  def destroy?
    false
  end

  [:lists, :people, :companies, :activities, :lead, :activity, :statuses, :status, :list, :breakcold_leads, :lemlist_leads].each do |method|
    define_method "attach_#{method}?" do
      false
    end
    define_method "detach_#{method}?" do
      false
    end
    define_method "edit_#{method}?" do
      false
    end
    define_method "create_#{method}?" do
      false
    end
    define_method "destroy_#{method}?" do
      false
    end
  end

end
