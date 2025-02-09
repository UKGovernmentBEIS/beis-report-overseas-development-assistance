class ReportPolicy < ApplicationPolicy
  attr_reader :user, :record

  def index?
    true
  end

  def show?
    return true if beis_user?
    return true if record.organisation == user.organisation
    false
  end

  def create?
    beis_user?
  end

  def edit?
    update?
  end

  def update?
    beis_user?
  end

  def destroy?
    false
  end

  def change_state?
    case record.state
    when "active"
      partner_organisation_user? && record.organisation == user.organisation
    when "submitted"
      beis_user?
    when "in_review"
      beis_user?
    when "awaiting_changes"
      partner_organisation_user? && record.organisation == user.organisation
    when "qa_completed"
      beis_user?
    when "approved"
      false
    end
  end

  def upload?
    record.editable? && record.organisation == user.organisation
  end

  def upload_history?
    return true if beis_user? && record.editable?
    false
  end

  def download?
    show?
  end

  def activate?
    false
  end

  def submit?
    change_state? if record.editable?
  end

  def review?
    change_state? if record.state == "submitted"
  end

  def request_changes?
    change_state? if %w[in_review qa_completed].include?(record.state)
  end

  def mark_qa_completed?
    change_state? if record.state == "in_review"
  end

  def approve?
    change_state? if record.state == "qa_completed"
  end

  class Scope < Scope
    def resolve
      if user.organisation.service_owner?
        scope.all
      else
        scope.where(organisation: user.organisation)
      end
    end
  end
end
