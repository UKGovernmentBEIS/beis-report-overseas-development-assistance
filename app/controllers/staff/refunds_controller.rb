class Staff::RefundsController < Staff::ActivitiesController
  include Secured

  def new
    @activity = activity
    @refund = Refund.new
    @report = Report.editable_for_activity(@activity)

    @refund.parent_activity = @activity
    @refund.report = @report

    authorize @refund
  end

  def create
    @activity = activity
    authorize @activity

    result = CreateRefund.new(activity: @activity)
      .call(attributes: refund_params)
    @refund = result.object

    if result.success?
      flash[:notice] = t("action.refund.create.success")
      redirect_to organisation_activity_path(@activity.organisation, @activity)
    else
      render :new
    end
  end

  private

  def refund_params
    params.require(:refund).permit(
      :value,
      :financial_quarter,
      :financial_year,
      :comment
    )
  end

  def activity_id
    params[:activity_id]
  end

  def id
    params[:id]
  end

  def activity
    @activity ||= Activity.find(activity_id)
  end
end
