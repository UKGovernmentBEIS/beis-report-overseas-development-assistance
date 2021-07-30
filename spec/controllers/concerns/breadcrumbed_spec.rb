require "rails_helper"

class StubController < Staff::BaseController
  include Breadcrumbed

  def show
    activity = Activity.find(params[:id])
    prepare_default_activity_trail(activity)
  end
end

RSpec.describe StubController, type: :controller do
  before do
    allow(subject).to receive(:historic_organisation_activities_path).and_return("historic_index_path")
    allow(subject).to receive(:organisation_activities_path).and_return("current_index_path")
    allow(subject).to receive(:organisation_activity_financials_path).and_return("activity_path")
  end

  context "for a historic project activity" do
    let(:activity) { build(:project_activity, programme_status: "completed") }

    it "adds the historic index path to the breadcrumb stack" do
      expect(subject).to receive(:add_breadcrumb).with("Historic activities", "historic_index_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.parent.title, "activity_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.title, "activity_path")

      subject.prepare_default_activity_trail(activity)
    end
  end

  context "for a current project activity" do
    let(:activity) { build(:project_activity) }

    it "adds the current index path to the breadcrumb stack" do
      expect(subject).to receive(:add_breadcrumb).with("Current activities", "current_index_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.parent.title, "activity_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.title, "activity_path")

      subject.prepare_default_activity_trail(activity)
    end
  end

  context "for a third-party project" do
    let(:activity) { build(:third_party_project_activity) }

    it "adds the parent project and programme activities to the breadcrumb stack" do
      expect(subject).to receive(:add_breadcrumb).with("Current activities", "current_index_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.parent.parent.title, "activity_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.parent.title, "activity_path")
      expect(subject).to receive(:add_breadcrumb).with(activity.title, "activity_path")

      subject.prepare_default_activity_trail(activity)
    end
  end
end
