module ActivityHelper
  include CodelistHelper

  def step_is_complete_or_next?(activity:, step:)
    steps = Activity::FORM_STEPS

    return false if activity.form_state.nil?
    return true if activity.form_steps_completed?
    return true if activity.fund? && step == :identifier

    presenter_position = steps.index(step.to_sym)
    activity_position = steps.index(activity.form_state.to_sym)

    presenter_position <= activity_position + 1
  end

  def link_to_activity_parent(parent:, user:)
    return if parent.nil?
    return parent.title if parent.fund? && user.partner_organisation?
    link_to parent.title, organisation_activity_path(parent.organisation, parent), {class: "govuk-link govuk-link--no-visited-state"}
  end

  def show_link_to_add_comment?(activity:, report: nil)
    [
      is_commentable_programme?(activity: activity),
      is_commentable_project?(activity: activity, report: report)
    ].any?
  end

  def show_link_to_edit_comment?(comment:)
    [
      is_editable_programme_comment?(comment: comment),
      is_editable_non_programme_comment?(comment: comment)
    ].any?
  end

  def custom_capitalisation(level)
    "#{level[0].upcase}#{level[1..]}"
  end

  def sdg_options
    I18n.t("form.label.activity.sdg_options")
  end

  def policy_markers_iati_codes_to_enum(code)
    Activity::POLICY_MARKER_CODES.key(code.to_i)
  end

  def policy_markers_desertification_iati_codes_to_enum(code)
    Activity::DESERTIFICATION_POLICY_MARKER_CODES.key(code.to_i)
  end

  def first_benefitting_country(benefitting_countries)
    BenefittingCountry.find_by_code(benefitting_countries.first)
  end

  def edit_comment_path_for(commentable, comment)
    case commentable.class.name
    when "Activity"
      edit_activity_comment_path(commentable, comment)
    when "Actual"
      edit_activity_actual_path(commentable.parent_activity, commentable)
    end
  end

  private

  def is_commentable_programme?(activity:)
    activity.programme? && policy(:level_b).create_activity_comment?
  end

  def is_commentable_project?(activity:, report: nil)
    activity.is_project? && policy([:activity, :comment]).create? && report
  end

  def is_editable_programme_comment?(comment:)
    comment.commentable.try(:programme?) && policy(:level_b).update_activity_comment?
  end

  def is_editable_non_programme_comment?(comment:)
    return false if comment.commentable.try(:programme?)

    policy([comment.commentable, comment]).update?
  end
end
