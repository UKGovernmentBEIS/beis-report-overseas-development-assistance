administrator = User.find_or_initialize_by(
  name: "Administrator",
  email: "roda@dxw.com"
)
partner_org_user = User.find_or_initialize_by(
  name: "Partner Org User",
  email: "roda+dp@dxw.com"
)
ukri_user = User.find_or_initialize_by(
  name: "UKRI",
  email: "roda+ukri@dxw.com"
)

beis = Organisation.service_owner
other_organisation = Organisation.find_by(role: :partner_organisation)
ukri_organisation = Organisation.find_by_name("UK Research and Innovation")

[
  {user: administrator, organisation: beis},
  {user: partner_org_user, organisation: other_organisation},
  {user: ukri_user, organisation: ukri_organisation}
].each do |hash|
  hash[:user].update(password: "LlEeTtMmEeIiNn!1", otp_required_for_login: false, organisation: hash[:organisation], organisations: [hash[:organisation]])
  hash[:user].save!
end
