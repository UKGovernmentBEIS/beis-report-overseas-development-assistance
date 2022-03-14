RSpec.feature "Home page" do
  scenario "visit the home page" do
    visit root_path
    expect(page).to have_content("Report your Official Development Assistance")
  end

  context "when signed in as a BEIS user" do
    let(:user) { create(:beis_user) }
    before { authenticate!(user: user) }

    scenario "they are redirected to their organisation show page" do
      visit root_path
      expect(page.current_path).to eq home_path
    end
  end

  context "when signed in as a delivery partner user" do
    let(:user) { create(:delivery_partner_user) }
    before { authenticate!(user: user) }

    scenario "they are redirected to their organisation show page" do
      visit root_path
      expect(page.current_path).to eq home_path
    end
  end

  context "when signed in as a user who is not active" do
    let(:user) { create(:delivery_partner_user, active: false) }
    before { authenticate!(user: user) }

    scenario "they are shown the start page" do
      visit root_path
      expect(page).to have_button("Sign in")
    end
  end
end
