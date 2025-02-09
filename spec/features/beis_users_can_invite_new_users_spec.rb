RSpec.feature "BEIS users can invite new users to the service" do
  let(:user) { create(:administrator) }

  before do
    authenticate!(user: user)
  end
  after { logout }

  context "when the user belongs to BEIS" do
    let(:user) { create(:beis_user) }

    scenario "a new user can be created" do
      organisation = create(:partner_organisation)
      second_organisation = create(:partner_organisation)
      additional_organisation = create(:partner_organisation)
      new_user_name = "Foo Bar"
      new_user_email = "email@example.com"

      perform_enqueued_jobs do
        create_user(organisation, additional_organisation, new_user_name, new_user_email)
      end

      expect(page).to have_content(organisation.name)
      expect(page).not_to have_content(second_organisation.name)
      expect(page).to have_content(additional_organisation.name)

      new_user = User.where(email: new_user_email).first
      reset_password_link_regex = %r{http://test.local/users/password/edit\?reset_password_token=.*}
      expect(new_user).to have_received_email.with_personalisations(
        link: match(reset_password_link_regex),
        name: new_user_name,
        service_url: "test.local"
      )
    end

    context "when the name and email are not provided" do
      it "shows the user validation errors instead" do
        visit new_user_path

        expect(page).to have_content("Create user")
        fill_in "user[name]", with: "" # deliberately omit a value
        fill_in "user[email]", with: "" # deliberately omit a value

        click_button "Submit"

        expect(page).to have_content("Enter a full name")
        expect(page).to have_content("Enter an email address")
      end
    end
  end

  context "when the user does not belong to BEIS" do
    let(:user) { create(:partner_organisation_user) }

    it "does not show them the manage user button" do
      visit organisation_path(user.organisation)
      expect(page).not_to have_content("Users")
    end
  end

  def create_user(organisation, additional_organisation, new_user_name, new_user_email)
    # Navigate from the landing page
    visit organisation_path(organisation)
    click_on("Users")

    # Navigate to the users page
    expect(page).to have_content("Users")

    # Create a new user
    click_on("Add user")

    # We expect to see BEIS on this page in the dropdown
    within(".user-organisations") do
      beis_identifier = Organisation.service_owner.id
      expect(page).to have_css("select option[value='#{beis_identifier}']")
    end

    # We expect to see the additional organisation too
    within(".additional-organisations") do
      expect(page).to have_css("input[value='#{additional_organisation.id}']")
    end

    # Fill out the form
    expect(page).not_to have_content("Reset the user's mobile number?")
    expect(page).to have_content("Create user")
    fill_in "user[name]", with: new_user_name
    fill_in "user[email]", with: new_user_email
    select organisation.name
    check additional_organisation.name

    # Submit the form
    click_button "Submit"
  end
end
