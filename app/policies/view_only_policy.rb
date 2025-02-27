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

  def destroy?
    false
  end
end
