# Changelog

## Unreleased

[Full changelog][unreleased]

- Fix IATI XML export countries where there is only one benefitting country

## Release 169 - 2025-02-10

[Full changelog][169]

- Migrate to Rails 7.1 defaults
- Update IATI XML export benefitting countries into single region

## Release 168 - 2025-02-10

[Full changelog][168]

- Upgrade to Rails 7.1 with 7.0 defaults

## Release 167 - 2025-02-06

[Full changelog][167]

- Fix Level B activities export organisation name

## Release 166 - 2025-02-05

[Full changelog][166]

- Anonymise users background job
- Devise two-factor-auth 4.x -> 5.x cleanup
- Export Level B activities fixes (part one)

## Release 165 – 2025-02-03

[Full changelog][165]

- Upgrade Devise two factor gem from 4.x to 5.x

## Release 164 – 2025-01-30

[Full changelog][164]

- Fix: duplicate countries allowed on import
- Export level B activities per fund (controlled by Rollout)

## Release 163 – 2025-01-23

[Full changelog][163]

- Add functionality to anonymise a user

## Release 162 – 2025-01-20

[Full changelog][162]

- Fixed: users list view shows correct organisation after admin user has
  switched organisation

## Release 161 - 2025-01-14

[Full changelog][161]

- Split out deactivate/reactivate functionality into separate pages with confirmatory text
- Upgrade the remaining 11 config options to Rails 7.0 defaults

## Release 160 - 2025-01-08

[Full changelog][160]

- Admin interface to enable additional organisations

## Release 159 - 2024-12-19

[Full changelog][159]

- Upgrade to Rails 7.0.8.7

## Release 158 - 2024-12-18

[Full changelog][158]

- Theme colour has changed from blue to a black
- The date and time a user is deactivated is now stored

## Release 157 - 2024-12-16

[Full changelog][157]

- Dropdown switcher component for users with multiple organisations

## Release 156 - 2024-12-12

[Full changelog][156]

- Fixed: the welcome email is now sent to new users correctly
- Some instances of 'BEIS' have been replaced with 'DSIT'

## Release 155 - 2024-12-10

[Full changelog][155]

- Migration (and logic) to allow users to belong to multiple organisations
- Data migration to fix forecasts with incorrect providing organisation name

## Release 154 - 2024-12-05

[Full changelog][154]

- Remove Spring from development
- Switch to the Zeitwerk autoloader
- Use Rails 6.1 default configuration

## Release 153 - 2024-12-02

[Full changelog][153]

- Update Node to 22.11.0

## Release 152 - 2024-11-27

[Full changelog][152]

- Update Redis and Sidekiq

## Release 151 - 2024-11-26

[Full changelog][151]

- Update Ruby to 3.3.6

## Release 150 - 2024-11-25

[Full changelog][150]

- Separate out users into tabbed view of active and inactive

## Release 149 - 2024-11-21

[Full changelog][149]

- Rails version updated to 6.1.7.10

## Release 148 - 2024-09-30

[Full changelog][148]

- Adjust data migration to update 100 PO Org IDs

## Release 147 - 2024-09-23

[Full changelog][147]

- Add Rails script to update 100 PO IDs
- Remove Docker cache
- Update 'docker-compose' command to 'docker compose'

## Release 146 - 2024-07-24

[Full changelog][146]

- Bump Ruby version from 3.0.6 to 3.1.2
- Update details in IATI xml yaml to reflect switch from BEIS to DSIT

## Release 145 - 2024-01-25

[Full changelog][145]

- Configure rack-attack to prevent brute force login attacks
- Update README and documentation

## Release 144 - 2024-01-24

[Full changelog][144]

- Change the transparency identifier and names for the DSIT organisations (DSIT and DSIT Finance)
- Add a rake task to change the transparency identifier for activities that will continue under DSIT, and the providing org reference for their actual spend and forecasts
- model a simple imported row so that users can see which row in the csv import
  were skipped
- the Activity actual, refund and comment upload success view now shows the
  imported actuals, refunds, activity comments and skipped rows
- Use an activity's `transparency_identifier` as `iati-identifier` in XML exports, and the `previous_identifier`, if it exists, as `other-identifier`

## Release 143 - 2024-01-23

[Full changelog][143]

- support both the new and the old actual importer, allowing switching between
  them with a feature flag
- Exclude health check requests from host authorisation
- Remove the feature flag for ODA bulk upload
- Allow service owner to be identified by both IDs during the transition between BEIS and DSIT

## Release 142 - 2024-01-16

[Full changelog][142]

- Display the budgets headings as "Activity budgets" for level C and D activities on the Financials tab
- model a financial value from a csv file
- add a new Activity tag, Strategic Allocation Pot (SAP), code 8
- model a single row of csv data that contains actual, refund and activity
  comments
- the new actual, refund and activity importer no longer accepts negative actual
  values
- Provide a CSV download of all activities that are likely to continue under DSIT and will need the new DSIT transparency identifier
- add a service that can import a single row of csv that contains either a
  Actual, Refund or Activity Comment
- when importing an Activity, Refund or Activity comment, the result can now be
  a row that was skipped
- add a service that can import a single row of csv that contains either a
  Actual, Refund or Activity Comment
- update Import Row Error to expose csv row number as expected by the user
- add a service that can import a file of multiple rows of csv that contain either an Actual,
  Refund, or Activity Comment

## Release 141 - 2023-12-04

[Full changelog][141]

- The IATI activity scope is calculated based on the benefitting countries and
  included in the IATI XML download as applicable
- The error summary is now shown correctly when adding new matched effort in the
  application
- The filenames for ISPF report CSVs now include the ODA type

## Release 140 - 2023-11-28

[Full changelog][140]

- Remove the `oda_eligibility` criterion from `reportable` scope, and apply it on a report by report basis, so we don't exclude ISPF non-ODA activities from ISPF non-ODA reports
- Update how Node and Yarn are installed inside the application container
- Allow ISPF reports to be created as ODA or non-ODA
- Ensure that non-ISPF reports do not get a value set for `is_oda` (for historical reasons, the app relies on non-ISPF reports and activities not having an `is_oda` value set)
- Validate that the value of `is_oda` is set for ISPF reports
- Reorder the fields on the new report form per design
- Show if a report for ISPF is ODA or non-ODA on the report show view
- Show if a report for ISPF is ODA or non-ODA on the report edit form
- Upload templates for ISPF reports use the ODA type of the report
- The report export now includes a column for Total Actuals, the sum on the
  Actuals net values for all financial quarters in the report
- Fix originating report finder in ActivityDefaults to take into account the ODA type of the activity
- Update documentation to reflect various new processes on the new DSIT AWS infrastructure
- The report export now includes a column for the Original Commitment value of
  the activity, if one is available
- The report export now includes a column for the Published to IATI value, which
  will either be yes or no

## Release 139 - 2023-11-14

[Full changelog][139]

- Remove ispf_fund_in_stealth_mode that hides ISPF funds from users
- Add `is_oda` attribute to reports and populate it to `false` for all existing ISPF reports
- Amend report validation to permit two editable reports per fund and organisation, as long as they have different ODA types
- Amend the check for a pre-existing later report to take ODA type into account
- Error message shown when attempting to create a report while an unapproved one for the same fund, org, and ODA type exists includes the ODA type where relevant
- Show ODA/non-ODA alongside the fund short name on the reports table for ISPF
- Fix the logic that generates actuals and variance rows for reports, to avoid inserting a spurious column for reports that have forecasts but no actuals
- Show environment banner and email prefix on the `dev` domain

## Release 138 - 2023-10-27

[Full changelog][138]

- Support s3 access via ECS credentials, with the bucket name set as an environment variable

## Release 137 - 2023-08-02

[Full changelog][137]

- Add script to upload multiple budgets while bypassing report validation

## Release 136 - 2023-06-15

[Full changelog][136]

- Add script to change incorrect partner organisation identifiers on 2 activities

## Release 135 - 2023-06-14

[Full changelog][135]

- Add script to change incorrect receiving organisations for 9 actuals that had been incorrectly set on upload

## Release 134 - 2023-03-31

[Full changelog][134]

- Exclude planned activities from annual fund impact metrics CSV
- Allow partner organisation users to list the implementing organisations
- Add guidance about finding implementing organisation names on the report activities tab
- Show a validation error when a Budget is edited with a comment but without changing the value
- Fix bug where current value was incorrect when editing a Budget with an invalid value
- Use locales for the programme status of the activities in the annual fund impact metrics CSV

## Release 133 - 2023-03-30

[Full changelog][133]

- Add budget revisions:
  - Only budget value can be edited
  - Add a budget revisions page
  - Add comments when editing budgets to be shown alongside the revisions
  - Improve design/content for the budgets area
  - Show "original" and "revised" budgets on the XML exports
- Feature flag ISPF ODA bulk upload
- Allow users to enter commas in Original Commitment Figure values
- Prevent users from editing fund activities via the bulk upload
- Use correct column name in bulk upload results when trying to update an activity that cannot be found
- Fix accessibility issue of overflowing contents on the reports table and users table when zoomed in
- Ensure non-BEIS users cannot download activities as XML
- Use a safer method to display accessible links that can contain user input
- Add inclusion validation for Activity attributes
- Add "Previously reported under Newton Fund" ISPF tag
- Rename Commitment date in Activity "Financials" tab
- Change the colour of success messages to black
- Allow BEIS users to delete untitled activities and signpost PO users on the process
- Add more information to the form guidance on the original commitment figure step
- Set app's local time zone to "London"
- Fix bug where users could not sign out if JavaScript was disabled
- Allow users to upload a single actual/refund without deleting the (invalid) default values in other rows of the template. Rows with (invalid) default values will be ignored in this case. Any other invalid values will still throw an error
- Ensure BEIS users can't download individual fund and programme activities as XML

## Release 132 - 2023-03-16

[Full changelog][132]

- Update Commitment-importing script to infer `transaction_date` value from Activity values
- Collect original commitment figure in new activity form and bulk activity upload, only editable by BEIS users
- Remove mobile number reset field from new user form
- Fix an accessibility issue on the Organisations page
- Set `publish_to_iati` to `false` for non-ODA activities
- Add `govuk-link` class to links where missing
- Update ISPF themes
- Update ISPF non-ODA countries
- Only provide an IATI export link if there are publishable activities
- Always show "Untitled activity" in breadcrumbs when an activity is untitled
- Ensure upload forms are constrained to a 2 thirds layout for accessibility
- Signpost how to add a comment after a failed actual/refund upload containing a comment
- Add "Back to report" links at all stages of the actuals and forecasts upload journeys

## Release 131 - 2023-03-07

[Full changelog][131]

- Remove heading for unpopulated organisation column in organisation reports table for BEIS users
- Prevent child ODA activities being created on non-ODA parents and vice-versa via the bulk upload
- Prefix imported non-ODA programmes "NODA-"
- Prevent editing ODA type via the UI
- Fix the display of successfully uploaded forecasts for the cases when:
  - the original forecast is deleted
  - the imported values were already in the report
- Omit legacy fields for ISPF activities on the "details" page
- Remove legacy fields from ISPF reports
- Only generate IATI identifiers for ODA activities
- Remove reference to truncating data published to Statistics in International Development for non-ODA activities
- Hide IATI identifier and "Include in IATI XML export?" fields on activity details tab for non-ODA activities
- Remove ODA fields from the non-ODA CSV upload template
- Move the comments column to the end of all the CSV templates
- Make error messages clearer when importing actuals and refunds
- Fix login issues after running the training database sync script by clearing remember tokens during password reset step and clearing sessions as an additional step
- ODA only attributes are blank on non-ODA activities
- Add a feature flag to enable/disable the linked activities feature
- Hardcode budget IATI status as "Indicative" (previously "Committed")
- Fix error when submitting an invalid "purpose" step
- Refactor Commitments:
  - Add `transaction_date` field to be used in place of Financial Year and Quarter

## Release 130 - 2023-02-13

[Full changelog][130]

- Update Ruby to 3.0.5

## Release 129 - 2023-02-07

[Full changelog][129]

- Upload the report CSV to S3 when the report is approved
- For approved reports, provide download of stored report CSV file instead of generating it from live data
- Fix/improve various commenting edge cases:
  - Show useful error when trying to remove the body from an existing comment
  - Show the RODA identifier when adding/editing a comment on an activity without a title
  - Include breadcrumbs when the form is re-rendered after failing to create/update a comment
- Report approved emails sent to BEIS users include a reminder that the report is going to be uploaded
- Send a notification email to the report approver if the report upload fails
- The latest generated spending breakdown CSVs can be downloaded from the Exports page
- Spending breakdown email notification has a link to the Exports page instead of a direct download link
- Spending breakdown exports use a private S3 bucket
- Default to 0, rather than `nil` in the rare case where a report has no actual value for an activity
- Add QA completed report step in between review and approval
- Optimise codelist-related logic with the aim of fixing IATI export timeout issues and providing speed gains more generally
- Add Sidekiq web UI route

## Release 128 - 2023-01-24

[Full changelog][128]

- Allow ISPF non-ODA partner countries on ODA activities
- Change "Vietnam" to "Viet Nam" in ISPF ODA partner countries
- Prefix the RODA identifiers of all non-ODA activities with "NODA-"

## Release 127 - 2023-01-17

[Full changelog][127]

- Add page titles for home and activities pages (useful for Google Analytics reporting and accessibility); make page titles and headings consistent on activity form pages
- Update level C/D IATI exports to provide a quarterly summary of all transactions combined (actuals, adjustments and refunds), not just actuals
- Update tags question wording to make more sense for multiple choice

## Release 126 - 2023-01-11

[Full changelog][126]

- Show an error message if trying to upload a level D ISPF activity without an implementing organisation
- Remove legacy report CSV generator
- Switch to using JSbundling and CSSbundling instead of now-deprecated Webpacker for our assets
- Fix exclusion from IATI of redacted programmes - an earlier change allowed programmes to be flagged for exclusion, but missed some code required for actually excluding them
- Update programme-level IATI exports to provide a quarterly summary of all transactions combined (actuals, adjustments and refunds), not just actuals

## Release 125 - 2022-12-20

[Full changelog][125]

- Add report CSV download for ISPF activities
- Show ODA / Non-ODA on level C and D activities' details pages
- Fix call to action link text for Benefitting countries to correctly change from Add to Edit when applicable
- Reject ODA uploads via non-ODA form
- Tags for ISPF activities can be added via bulk uploads
- Add tags to spending breakdown and quarterly report CSV exports

## Release 124 - 2022-12-13

[Full changelog][124]

- Filter non-ODA activities from IATI exports
- Enable activity linking for ISPF activities
- ISPF activities can have multiple ISPF themes
- ISPF activities can be tagged via the UI - tags can only be chosen from a BEIS-defined codelist
- Allow users to designate an ISPF activity as having no ISPF partner countries

## Release 123 - 2022-12-01

[Full changelog][123]

- Add ISPF ODA and non-ODA activity bulk uploads - templates will only be visible when the ISPF feature flag is disabled

## Release 122 - 2022-11-09

[Full changelog][122]

- Update seeds and create data migration for adding ISPF fund entity to the service
- Add ISPF Level B UI user journeys for adding activities
- Add ISPF Level C/D UI user journeys for adding activities
- Inherit `is_oda` from the parent activity - Level C/D ISPF activities will therefore be ODA or non-ODA based on the (grand)parent Level B activity
- Do not allow removing the implementing organisation from a level C or D ISPF activity if it is the only one
- Require ISPF third-party projects (level D) to have at least one implementing organisation set through the new activity journey
- Hide ISPF-facing functionality in the service and exports when the feature flag is enabled
- Allow programmes to be redacted from IATI
- Set default values for currency and transaction type on Actual Transactions, output in IATI XML
- Remove reference to "ODA activities" in activity status descriptions

## Release 121 - 2022-10-31

[Full changelog][121]

- Configure Rollout and Rollout UI gems to allow BEIS users to manage feature flags
- Allow comments on Level B activities from BEIS users
- Add comments column to Level B activities bulk upload template
- Add Level B activity comments to budget exports
- Strip leading/trailing whitespace and line breaks from comments in reports and exports

## Release 120 - 2022-10-18

[Full changelog][120]

- Improve error message when trying to create child activities on incomplete parent activities

## Release 119 - 2022-10-12

[Full changelog][119]

- Rename `master` branch to `main`

## Release 118 - 2022-10-11

[Full changelog][118]

- Refactor the importers (including associated uploads controllers and views) to use a unified approach for all entities being imported
- Ensure `Forecast.set_value` always returns a forecast or nil; this will ensure that uploaded forecasts are correctly displayed back to the user on the success page
- Add Level B budget bulk upload functionality - form with errors/confirmation view; link in top nav
- Include refunds and adjustments in the calculation of an activity's total spend (previously only actuals were included)
- Point the "Back to home" link on the Level B activities bulk upload to the home page instead of the organisations page
- Comments in report CSVs are delimited by a pipe, instead of a newline, to enable BEIS users' QA workflow
- Fix the command invoking the password reset script when updating training environment with the latest data from production
- Prevent inactive organisations being added to activities as implementing organisations
- Remove the "staff" namespace

## Release 117 - 2022-09-23

[Full changelog][117]

- Add ability for BEIS users to create and update Level B activities in bulk by uploading a CSV
- Make partner organisation identifier optional for Level B activities (both via the individual new activity form and bulk upload)

## Release 116 - 2022-09-21

[Full changelog][116]

- Replace "View details" link in the Partner Organisation table for BEIS users with a link on Organisation name instead
- Replace "Delivery partner" with "Partner organisation" and "DP" with "PO" in user-facing text, including CSV column headers
- Replace references to `delivery_partner` with `partner_organisation` (or `partner_organisation_user` depending on context)
  across the code, including a database migration to rename `delivery_partner_identifier` to `partner_organisation_identifier`
- Replace references to `country_delivery_partners` with `country_partner_organisations`, including database migration
- Replace code references to `uk_dp_named_contact` with `uk_po_named_contact`, including database migration
- Remove "PO Definition" from "Aims/Objectives" CSV headers

## Release 115 - 2022-09-01

[Full changelog][115]

- Display total of refunds in the report summary
- Fix the misspelling of "FSTC" in a codelist and in the service using the codelist
- Add parent programme ID and title, and parent project ID and title where applicable, to activity rows in report CSVs
- Make the message shown when there are no approved reports more accurate
- Ensure CSV export of report has consistent columns if there are no forecasts

## Release 114 - 2022-08-24

[Full changelog][114]

- Temporary allow activities to be added with the earliest actual start date of mid 2005 for historical data migration
- Fix issue where welcome emails wouldn't be sent on production
- Send welcome email subject from the application instead of trying to pesonalise the templated subject

## Release 113 - 2022-08-22

[Full changelog][113]

- Display a banner on non-production environments to make it clearer to users which site they're using
- Show the environment name (e.g. "training") in the subject of emails sent by the application

## Release 112 - 2022-07-01

[Full changelog][112]

- Blank Implementing Organisations fields leave the current Implementing Organisations list unchanged

## Release 111 - 2022-06-22

[Full changelog][111]

- Fix handling of implementing organisations when updating activities through CSV upload

## Release 110 - 2022-06-21

[Full changelog][110]

- Do not parse arbitary text in oda_eligibilities or programme_status as being 0.

## Release 109 - 2022-05-18

[Full changelog][109]

- Generates public (rather than pre-signed) URL for download link to fetch reports from S3 bucket

## Release 108 - 2022-04-11

[Full changelog][108]

- Fix spending breakdown report by running asynchronously and emailing a download link
  to the requester.
- Fix missing Q4 21/22 option in external income by including "previous" year as well as
  the next ten.

## Release 107 - 2022-04-06

[Full changelog][107]

- Remove 33 ineligible countries from RODA configuration

## Release 106 - 2022-04-06

[Full changelog][106]

- Data migration to remove 33 ineligible countries from 57 activities

## Release 105 - 2022-03-31

[Full changelog][105]

- Validate XML against IATI schema on export
- Fix some accessibility issues with tables and tab lists
- Declare `remember_user_token` on cookies statement
- Fix declared duration of default session from 24 hours to the actual value of 12 hours
- Organisations are sorted by active status on the organisations page (applies to all types of organisation: delivery partner, matched effort providers, external income providers, and implementing organisations)
- Reduce "Password Reset" link validity period to 24 hours
- Acknowledge the hotfix release at c041ad3e8b2ca727ca7d12dd07327c3cabdfa044 for a critical Puma fix

## Release 104 - 2022-03-29

[Full changelog][104]

- Fix attempt to use an unloaded gem that was causing the report's comments tab to raise server error

## Release 103 - 2022-03-29

[Full changelog][103]

- Add bulk uploading to Refunds via the Actual importer
- Rename `activity.comments` association to better reflect its purpose of collecting all comments on an
  activity and on its child transactions (which can be actuals, refunds, and adjustments)
- Remove Auth0 user identifier from user management
- Add sector and sector category codes to radio button text when adding a new activity
- Fix an error where a new refund creation would silently fail when the value was non-numeric
- Users can add and edit comments on actuals through the form

## Release 102 - 2022-03-23

[Full changelog][102]

- Fix bug where Remember me was not working for users logging in with MFA

## Release 101 - 2022-03-22

[Full changelog][101]

- Add 'Other ODA' fund
- Change the HTML title tag of the Users page to be Users, not Home
- Prevent server errors when a mobile number is invalid
- Fix bug where comments on actuals were not being included in activity comments

## Release 100 - 2022-03-17

[Full changelog][100]

- Log in with local Devise. This replaces Auth0. Uses BEIS password policy linked with GOV.UK guidelines and dxw policy
- Self-service reset user password through Devise via "Forgot your password?" link
- User invitations via Users / Create User
- Remember my login for 30 days
- User deactivation via Devise
- Two-factor authentication via SMS/OTP and a phased login including mobile number provision/confirmation
- OTP resend for delivery failures
- Relax user model validation to permit capitalisation changes and whitespace removal from email addresses
- Use Devise case-insensitive method when retrieving users for authentication
- Add functionality to search for activities by IATI identifier

## Release 99 - 2022-03-08

[Full changelog][99]

- Allow Actuals to have a comment and display on Actual and Comment report tabs
- Add comments to Activities and Actuals via bulk CSV upload

## Release 98 - 2022-02-24

[Full changelog][98]

- No longer hide all the organisations when creating a user if one wasn't picked to start with
- Correctly highlight the absence of an organisation when creating a user if one wasn't picked to start with
- Make activities and forecasts CSV upload buttons consistent with actuals

## Release 97 - 2022-02-15

[Full changelog][97]

- Upgrade framework dependencies (gems)
- Expand the list of channel of delivery codes from 8 to 32 to allow greater precision describing implementing organisations

## Release 96 - 2022-02-02

[Full changelog][96]

- Ensure that activities validate the presence of `planned_start_date` (or `actual_start_date`) and `planned_end_date` (or `actual_end_date`)
- Add data migrations for fixing inconsistencies with implementing organisations: add the implementing role to organisations that are missing it; normalise organisation names to uppercase; remove excess spaces from organisation names

## Release 95 - 2022-01-31

[Full changelog][95]

- Moved deactivated users to the bottom of the users list
- Remove control characters from input before validation

## Release 94 - 2022-01-11

[Full changelog][94]

- Remove some historic actuals, backfilled with duplicates

## Release 93 - 2021-12-9

[Full changelog][93]

- BEIS users can add and edit implementing organisations

## Release 92 - 2021-12-07

[Full changelog][92]

- Refactor setting of implementing organisations to use unique organisations
  through new join table

## Release 91 - 2021-12-07

[Full changelog][91]

- Health check endpoint includes basic sidekiq stats
- Show users a warning about appending data when uploading actuals data
- Update Readme - Add process to get terraform AWS credentials
- New reports have a stricter validation to financial period
- Documentation about logging
- Fix setup script
- Use postgres version 13 in backing-services-docker-compose.yml

## Release 90 - 2021-11-23

[Full changelog][90]

- Uploaded actual history must be in past financial quarters
- Activity summary view uses BEIS approved attribute names
- Channel of delivery code 90000, 'Other' added to the accepted codes list
- Fix deployment notification

## Release 89 - 2021-11-22

[Full changelog][89]

- Actual spend values can no longer be negative, use Adjustments or Refunds to
  document funding flowing back
- BEIS users can upload 'actual history' - historic actual spend, this is a
  short term feature to facilitate migration to the application
- Update terrafom to version 1.0.11
- Update postgres to version 13

## Release 88 - 2021-11-17

[Full changelog][88]

- Set implementing organisation on new programmes (Level B activities)
- Add support runbook for adding a channel of delivery code to accepted list

## Release 87 - 2021-11-11

[Full changelog][87]

- Add Ghost Inspector tests to the GitHub action deploy workflow
- Report csv export is includes all actual spend
- Report csv export variance is calculate from net actual spend
- Report csv performance improvements
- Legacy version of report csv download is available whilst the new version is
  validated by BEIS

## Release 86 - 2021-11-09

[Full changelog][86]

- fix: free standing technical cooperation in report export is rendered correctly
- Fix Readme typos and dead links
- Remove unwanted packages from Brewfile (redis and Firefox)
- Move terraform readme into '/doc' directory

## Release 85 - 2021-11-09

[Full changelog][85]

- Fix "Total forecasted" (in Activity financial summary) to exclude periods
  already reported
- Fix spending breakdown report

## Release 84 - 2021-11-02

[Full changelog][84]

- Record redactions from IATI in the activity's change history
- Track changes to budgets

## Release 83 - 2021-10-21

[Full changelog][83]

- Budgets can be added in the past, back to 2010
- List organisations sorted alphabetically on the Organisations and Reports pages

## Release 82 - 2021-10-19

[Full changelog][82]

- BEIS users create reports manually
- Create historical events when creating a refund
- Ensure all types of comments are displayed against reports and activities

## Release 81 - 2021-10-14

[Full changelog][81]

- Record changes to refunds and show them in the activity's Change history
- Show the commitment value on an activity's finance tab
- Include any commitment in an activity's IATI XML

## Release 80 - 2021-10-12

[Full changelog][80]

- Remove the unused Skylight gem
- Include activities 'change state' in the report csv
- Use a single comment model for all comments
- Track the creation of adjustments in an activity's Change history

## Release 79 - 2021-10-06

[Full changelog][79]

- Consolidate links to commnents on the report, variance tab

## Release 78 - 2021-10-05

[Full changelog][78]

- Create additional (non-variance) comments for an Activity
- Show fuller detail on comments in "Activity | Comments" tab
- Show all comments for a report in "Report | Comments" tab
- Adjustments to actual spend are included in the variance calculation

## Release 77 - 2021-10-01

[Full changelog][77]

- Fix up activities (with legacy intended beneficiaries) where backfilling was
  too enthusiastic

## Release 76 - 2021-09-30

[Full changelog][76]

- Include refunds in the report CSV exports
- BEIS users can export spending breakdown for all organisations
- BEIS users can export spending breakdown for any organisation
- Delviery partner users can export spending breakdown for their own
  organisation
- Remove the old Report > Spending Breakdown download
- Improve the Report CSV download experience, includes moving the link that
  triggers the download
- Fix up activities' benefitting countries where backfilled overenthusiastically
- No longer show 'requires additional benefitting countries' in activity details

## Release 75 - 2021-09-28

[Full changelog][75]

- Remove the all reports download
- Fix the GCRF strategic area code for Coherence and Impact

## Release 74 - 2021-09-21

[Full changelog][74]

- BEIS users have a link to delivery partners reports on the homepage
- Show the activity summary on all activity tabs
- Delivery Partner can post an adjustment to an historic financial period
- Users can export budget data

## Release 73 - 2021-09-16

[Full changelog][73]

- Added a new accepted channel of delivery code, "22000" ("Donor country-based NGO")
- Force word wrapping in table cells showing invalid upload values
- Allow a BEIS user to export external income for all delivery partner organisations
- Countries and regions are derived from BEIS benefitting countries code lists

## Release 72 - 2021-09-02

[Full changelog][72]

- BEIS users can export the external income per organisation per fund

## Release 71 - 2021-08-31

[Full changelog][71]

- Do not list inactive reports on the delivery partners' home page
- Show guidance on the home page when a delivery partner has no active reports

## Release 70 - 2021-08-26

[Full changelog][70]

- The Activities upload template no longer includes the "BEIS ID" column
- Replace the use of "historic" with "approved" in the context of reports
- List the current reports on the delivery partners' homepage

## Release 69 - 2021-08-24

[Full changelog][69]

- Show an error message if the search query is empty
- Show delivery partner users more information about the current reports
- Ensure all other views have a sensible breadcrumb

## Release 68 - 2021-08-19

[Full changelog][68]

- Allow a refund to be posted against an active report
- Activity breadcrumb trail for BEIS users includes the delivery partner organisation
- Truncate breadcrumbs that are over a certain length
- Fix `aria-controls` element in the tree view
- Show grouped refunds from a report on the report actuals page

## Release 67 - 2021-08-12

[Full changelog][67]

- Remove legacy geography steps
- Backfill benefitting_countries where possible
- Add horizontal margin inside table wrappers

## Release 66 - 2021-08-10

[Full changelog][66]

- Make sure users are active even after login
- Add breadcrumb trail for activities
- Adjust XML exports to use new benefitting countries field
- No longer collect geography, recipient country, recipient region, and intended beneficiaries (deprecated by collecting benefitting countries)

## Release 65 - 2021-08-03

[Full changelog][65]

- Move IATI XML exports to the exports section
- Collect all benefitting countries in one step
- Benefitting countries can be imported via CSV upload
- Tidy up Report Variance tab to only show activities that have a variance

## Release 64 - 2021-07-27

[Full changelog][64]

- Show the financial quarter of the actuals spend on the Report view
- Content and layout improvements to the actual spend tab on Report
- Content and layout improvements to the actual spend upload page
- Rework the way reports are shown to Delivery Partners and Service Owners
- Fix: 'spending breakdown' download is no longer empty
- Allow budgets to be deleted

## Release 63 - 2021-07-22

[Full changelog][63]

- New activities know which was their 'originating' report, and reports can list
  'new' activities originating from their financial period
- Newly updated activities are shown in a report.
- Newly added activities are shown in a report.
- Exports page layout is more accessible
- New activities know which was their 'originating' report, and reports can list
  'new' activities originating from their financial period
- BEIS users navigate activities by delivery partners
- Improvements to navigation and to url scheme for activities
- Add new programme (level B) activities buttons are now on the delivery partner
  activities pages
- Track changes to 'Actual' financials in activity's 'Change history'
- Create and populate an activity's RODA identifier automatically

## Release 62 - 2021-07-13

[Full changelog][62]

- Fix: guard against orphan HistoricalEvents
- Delete related HistoricalEvents when their associated activity is deleted
- Ignore internal "changes" to Activity made by form "wizard"

## Release 61 - 2021-07-08

[Full changelog][61]

- Optimise `projects_and_third_party_projects_for_report` scope
- Group Activity's Change history by "reference" and show newest first

## Release 60 - 2021-07-06

[Full changelog][60]

- Show actuals grouped by activity against a specific report
- Show uploaded transactions after an upload
- Record edits to Activities made in bulk via CSV imports, using the new Historical Event entity
- Associate Report with HistoricalEvent when editing Activity via Wizard
- BEIS users have a home page that lets them view activities by delivery partner
  organisation
- Make sure a Budget has a Budget Type
- Delivery partner users have a home page that lets them view and search their
  own activities
- Associate Report with HistoricalEvent when uploading a bulk CSV
- Add a report summary tab
- List an Activity's historical events in a new "Change history" tab

## Release 59 - 2021-06-29

[Full changelog][59]

- Add a Forecasts tab to the Report view, listing forecasts grouped by activity. Move 'Upload forecast' to this tab.
- Add a list of uploaded forecasts (grouped by activity) to the upload success page
- Fix: include BEIS in the organisation filter on the activities page
- Change GCRF Strategic Area codes to Alphanumeric
- Record edits to Activities made via Wizard form, using new HistoricalEvent entity

## Release 58 - 2021-06-22

[Full changelog][58]

- Reduce the maximum length of a fund's RODA identifier to 5 characters
- Bugfix: existing policy marker values are correctly shown when editing an activity
- Invalid policy marker values are highlighted when importing an activity from a CSV
- Policy marker add/edit links go directly to the relevant form section
- Change applicable Budget Types

## Release 57 - 2021-06-18

[Full changelog][57]

- Reports have an Activities tab
- Incoming and outgoing transfers can store the historic BEIS identifier (tracker row ID)
- Hide non-DP orgs on the Activities dropdown

## Release 56 - 2021-06-15

[Full changelog][56]

- Infer the value of `channel_of_delivery_code` from `collaboration_type`

## Release 55 - 2021-06-10

[Full changelog][55]

- Users can no longer update the delivery partner identifier
- Rename `Transfer` to `OutgoingTransfer`
- Infer the collaboration type when aid type is B02 or B03
- Show the user the activities that they've just uploaded
- Allow Incoming Transfers to be recorded against an activity

## Release 54 - 2021-06-03

[Full changelog][54]

- Allow users to add, edit and delete external income on activities
- Only show activities with relevant statuses in the actuals upload template
- Approved reports are displayed in historical order
- Update the logic to auto populate the FSTC applies field

## Release 53 - 2021-06-01

[Full changelog][53]

- add spacing between view and edit links on Organisation index page
- export complete transaction history per delivery partner for BEIS users
- Change the email address given in email notifications

## Release 52 - 2021-05-27

[Full changelog][52]

- Sort the users list by name within each organisation
- Only show Channel of delivery code for projects and third-party projects
- Send approved report email notifications to BEIS users
- Add "sdgs_apply" to CSV export
- Allow organisations of type "External Income Provider" to be created
- Move Aid type question before Collaboration type question
- Report title no longer includes the description
- A report description is no longer required
- Reports show a more detailed summary, including deadline, organisation and
  description (if one is supplied)

## Release 51 - 2021-05-25

[Full changelog][51]

- Allow organisations of type "Matched Effort Provider" to be created
- Stop forecast totals double-counting multiple versions of the same forecast
- Update the request an account link
- Allow DP users to create transfers and associate them with the current report
- Add some useful stats to our healthcheck endpoint
- Prevent uploading transactions if the report is not editable
- Prevent uploading activities, transactions and planned disbursements if the report is not editable
- Sum programme and child activity forecasts by financial quarter in IATI XML
- Remove unused 'role' from User model
- Open external links in the footer in new tabs
- Use consistent naming for China (People's Republic of) when selecting and showing recipient country and intended beneficiaries
- Allow matched effort funding transactions to be created

## Release 50 - 2021-05-18

[Full changelog][50]

- Replace the broken sector code hint link with an easier to maintain BEIS Zendesk link
- Include 'source fund' and 'delivery partner short name' in CSV export
- Prevent report mailer from sending emails to inactive users
- Merge Academies Collective Fund and Resilient Futures GCRF strategic areas into one
- Show organisation short name on organisations index page
- Total budget should only total budgets from a specific activity

## Release 49 - 2021-05-11

[Full changelog][49]

- Add BEIS contact info to the IATI XML
- Validate that activities have the correct organisation
- Deleting a forecast doesn't delete data from approved reports
- Handle the case of forecasts for past financial quarters during bulk importing
- Fix a typo in the email notification sent to BEIS when a DP submits a report
- Infer the value of `sdgs_apply` when importing new or existing activities from CSV

## Release 48 - 2021-04-27

[Full changelog][48]

- Implementing organisations are shown in the report csv file
- Remove Reporting Organisation from activities
- Add new category to GCRF strategic area options
- Fix bug that prevented historical reports from being accessed
- Sum programme and child activity transactions by financial quarter in IATI XML

## Release 47 - 2021-04-23

[Full changelog][47]

- Link to the Service performance Zendesk article in the footer
- Add functionality to search for activities by identifiers and title
- Record providing organisation for budgets
- Migrate to Webpacker for compiling JavaScript
- Show activities in an collapsable and expandable tree view table

## Release 46 - 2021-04-20

[Full changelog][46]

- Bump Ruby and Rails versions
- Update Rails configuration files with v6.1 settings
- Add tests to guard against missing Activity field translations
- Provide a breakdown of spend, refund and net values as a report CSV download
- Only include transferred and direct budget in budget calculations
- Show an activity's total forecasted spend to date against an activity

## Release 45 - 2021-04-15

[Full changelog][45]

- Allow forecasts to have negative values
- Add links to Guidance for all Activity fields that have guidance
- Create a [pattern library](doc/patterns.md) for developers

## Release 44 - 2021-04-13

[Full changelog][44]

- Change policy markers to radio buttons
- The activity upload UI looks similar to the actuals and forecasts upload UI
- Hide "Add child" buttons when users cannot create a child
- Activity importer checks permissions to create or update an activity

## Release 43 - 2021-04-01

[Full changelog][43]

- Data dictionary link opens in a new window/tab by default
- Add supporting hint text about the soft limits to title and description
- Change channel of delivery code to radio buttons
- Collect transferred and external budget types
- Show the type of budget in the application
- Remove limit on the number of intended beneficiaries
- Introduce `create_child?` check in ActivityPolicy

## Release 42 - 2021-03-30

[Full changelog][42]

- Add headings for the next 20 financial quarters to the forecast CSV upload template
- Only set provided variables when updating via the CSV upload
- Refactor handling of implementing organisations
- Set all activity policy marker fields to `not_assessed` by default
- Add total spend and total budget to the activity financials page

## Release 41 - 2021-03-26

[Full changelog][41]

- Bump Mimemagic version to 0.3.8
- GCRF Strategic area is collected at level C and D

## Release 40 - 2021-03-25

[Full changelog][40]

- Users can report the strategic area under which the GCRF allocation was made
- Bring back script for importing forecast data into an in-review/approved report
- Make receiving organisation optional

## Release 39 - 2021-03-23

[Full changelog][39]

- Display the RODA Identifier anywhere we have an activity table with an "Identifier" column
- Budgets do not collect IATI fields or currency as they are set by default
- Budgets tables do not show IATI fields and only show the financial year
- Budgets funding type must be the same as the parent activity

## Release 38 - 2021-03-18

[Full changelog][38]

- Skip rows where the value is 0 when importing transactions
- Update sector code list
- Show sector code and name in the application
- BEIS users can no longer create funds
- Send emails when the status of reports has changed
- BEIS users can no longer edit a programme's extending organisation
- Allow importing into existing activities without repeating the Channel of delivery code in the uploaded spreadsheet
- Add the GOV.UK Cookie banner and settings

## Release 37 - 2021-03-15

[Full changelog][37]

- Include 12 previous quarters of actual spend in the report CSV
- Include 20 following quarters of forecast spend in the report CSV

## Release 36 - 2021-03-08

[Full changelog][36]

- Fix inconsistencies with activity tab display and their ARIA hints
- Edit BEIS organisation reference (short name) via forms
- Users can create transfers
- Delivery partners can add level D activities, automatically parented to an existing level C
- Downloaded files have more descriptive filenames, using financial quarter, source fund, and organisation short name

## Release 35 - 2021-03-02

[Full changelog][35]

- Remove Data Migrate gem and run data migrations manually
- Activities can recursively total the transactions for all of their children
- Add an attribute to `Organisation` to record the short name, `beis_organisation_reference`,
  and populate it via a data migration
- Delivery partners can add level C activities, automatically parented to an existing level B

## Release 34 - 2021-02-24

[Full changelog][34]

- Clicking a link when signed-out should take you to the right place
- Accept financial quarters instead of dates when inputting transactions
- Redirect old domains to canonical one
- Overhaul the interface for uploading financial data (actuals and forecasts)

## Release 33 - 2021-02-18

[Full changelog][33]

- BEIS users can download a CSV report for all DPs
- Transaction description is populated from the financial quarter and year and from the activity's title
- The default type for a transaction is Disbursement, set during creation and import
- The providing organisation for a transaction is set from the activity
- Show a list of programmes grouped by fund on the organisation pages
- Publish terms of service on RODA
- Add RODA ID column to the activity import template
- Only tell robots to index the production site

## Release 32 - 2021-02-16

[Full changelog][32]

- Serve CSV downloads encoded in UTF-8, prefixed with a byte order mark
- Show textarea content with wrapper HTML on the Activity details page
- BEIS users can create a programme-level activity associated with a source fund

## Release 31 - 2021-02-08

[Full changelog][31]

- Relegate "Download report as CSV" link to tertiary status
- Add a `funding_type` column to a budget
- Work out a Budget's period based on the financial year
- Users can see Current activities and Historic activities in different tabs
- Reorder reports in a more intuitive manner
- Group activities by hierarchy on the view of a single report page
- Add links to the guidance across the site
- Users can report Channel of delivery code through the activity form

## Release 30 - 2021-01-25

[Full changelog][30]

- On the user administration page, BEIS now appears as a separate organisation to avoid users being assigned to this org by accident
- Users can upload activities in bulk from a CSV
- Make sure only completed parent activities are shown when prompting for a parent activity
- Expose forecast bulk upload to end users
- Load codelists into memory in production

## Release 29 - 2021-01-18

[Full changelog][29]

- Allow users to delete their transactions
- Fix display of previous actuals in the report CSV

## Release 28 - 2021-01-13

[Full changelog][28]

- SDGs on activity details page now shows `Not applicable` when the user selects this option on the form
- Refactor away `funding organisation` field
- Forecasted spend form always includes the current financial year
- Remove `Complete` label from child activities view
- Refactor helper to standardise the way we load BEIS codes
- Activity importer ignores incomplete activities when finding a parent
- IATI status is calculated on the fly from the programme status
- Do not allow a user's email address to be changed after creation
- Infer the value of FSTC applies from aid type, where possible
- Require UK Delivery partner named contact for all projects and third-party projects
- Fix a brittle spec
- Fix users can change the extending organisation on a level B (programme) activity

## Release 27 - 2021-01-05

[Full changelog][27]

- Transaction importer sets Description automatically from report and project attributes
- Transaction importer doesn't process Disbursement channel
- Show error messages when the user tries to enter invalid values for a forecasted spend. Covers financial quarter being in the past and forecast value an invalid number
- Transaction importer expects dates in `dd/mm/yyyy` format
- Activity CSV export includes previous quarter's actuals where available

## Release 26 - 2020-12-21

[Full changelog][26]

- Fix bug on option `stopped` for `programme_status`
- Validation prevents to add a `planned_end_date` that is earlier than `planned_start_date`
- Hint text for `fstc` modified
- Move CI tests to Github Actions
- Activity importer sets BEIS as the funding and accountable organisation
- Activity importer infers `status` from `programme_status`
- Activity importer sets `form_state` to "complete" to ensure correct behaviour
- Organisation name must be unique
- Show error message when the user tries to enter an invalid date on the `dates` step. Covers `planned_start_date`, `planned_end_date`, `actual_start_date`, `actual_end_date`
- Catch encoding errors when uploading Transactions with invalid characters

## Release 25 - 2020-12-14

[Full changelog][25]

- Lock bundler version for Docker to 2.1.4
- Column order of CSV report file matches data migration template
- Add missing columns to the CSV report file
- Add a transaction form has been simplified
- CSV template uses `activity.title` for activity name
- Updated version of sector codelist added to RODA
- Activity importer handles missing implementing organisations

## Release 24 - 2020-12-09

[Full changelog][24]

- Show only the financial quarter and value for forecasts on the activity page
- Use the latest versions of forecasts from the report history to calculate variance
- Add a new activity status: "Paused"
- Update importer date format to be MM/DD/YYYY
- Separate intended beneficiaries with a pipe
- Add a field to record the UK delivery partner named contact for project-level activities
- Validate country codes against all valid-country codes in the importer
- Importer can import policy markers
- Allow importer to import the ODA Eligibility Lead
- Users can add `country_delivery_partners` for Newton funded activities
- Users can add `gcrf_challenge_area` for GCRF-funded activities
- Add fund pillar question to the Activity form
- Allow Channel of delivery code to be imported from CSV and reported in the CSV
- Allow importer to import the implementing organisation name, reference and sector
- Add "BEIS ID" (beis_id) to the importer
- Add "UK DP Named Contact (NF)" (uk_dp_named_contact) to the importer
- Add "NF Partner Country DP" (country_delivery_partners) to the importer
- Add link to the support site in the footer
- Change programme status field to an enum
- Simplify actuals/transactions display on an activity's financials page

## Release 23 - 2020-11-25

[Full changelog][23]

- Fix parent level strings
- Add a field to report whether the activity has any relation to the Covid-19 pandemic.
- Include the Covid-19 field in the CSV report.
- Append the text "COVID-19" to the activity description in the IATI XML export, where applicable.
- Collect Sustainable Development Goals (SDGs) for activities
- Policy markers added to the CSV report file
- Activity Objectives added to the activity form, IATI XML and CSV report
- Add missing regions back on RODA and open scope of country list for `intended_beneficiaries`
- `Intended_beneficiaries` is now optional in all cases
- Store the BEIS ID and export it to the report CSV file
- Add field to record the ODA eligibility lead
- Add missing fields to the activity importer
- Allow forecasts to be edited, preserving their history

## Release 22 - 2020-11-17

[Full changelog][22]

- Fix allow application to create new users in Auth0
- Activity capital-spend is always exported as 0 to the IATI xml
- Fix allow application to create new users in Auth0
- Filter out unused aid types.
- Replace the hints in the aid type form with shorter, more accessible copy if available.
- Option `No - was never eligible` added to ODA eligibility form step
- Two original planned disbursements for the same activity, financial quarter
  and year cannot be created.
- Add a field to report Free Standing Technical Cooperation
- Policy markers added to activity form, including BEIS custom answer `not assessed`
- Add a class to import Activities from a CSV

## Release 21 - 2020-11-03

[Full changelog][21]

- Collect financial quarter and year for planned disbursements (forecasts)
  instead of start and end dates (the values of which are calculated).
- No longer collect start and end dates for planned disbursements (forecasts)
  through the application interface.
- Planned disbursements are always original when created
- Planned disbursement currency is always GBP
- Planned disbursement providing organisation is always BEIS
- Planned disbursement receiving organisations is no longer collect, but is
  retained for existing records
- Planned disbursements do not include receiving organisation in the IATI xml
  export
- Answers for GDI form step have been modified
- Use scripts to rule them all for development tasks

## Release 20 - 2020-10-06

[Full changelog][20]

- Fix bug that prevented delivery partners from submitting a report.

## Release 19 - 2020-10-02

[Full changelog][19]

- The user type is tracked in Google Analytics
- `providing_organisation_reference` is set when the user uploads transactions
- Separate the list of intended beneficiaries in the report CSV with semicolons
- Users can now edit fields on invalid completed activities

## Release 18 - 2020-09-25

[Full changelog][18]

- Add and amend Activity data fields in the Report CSV export
- Accept strictly numeric values in the `Value` column for bulk transaction
  import
- Do not automatically strip letters from numeric value fields; instead reject
  the values as invalid and show an error to the user
- the sign out navigation link is not active on the users page
- BEIS users can download IATI XML for programmes (level B)

## Release 17 - 2020-09-18

[Full changelog][17]

- New reports are created when the prior is approved
- `Total applications` and `Total awards` form step added to create activity journey
- Report deadline value is shown on the edit form
- Change on hierarchy terminology to display activity levels A, B, C and D along with old terminology in the UI across the service
- Update on the definitions for each level of activity
- Updated transaction policy
- Only show the edit transaction link when the transaction can be edited
- Only show the add transaction button when the activity can be edited
- Updated planned disbursement policy
- Only show the edit planned disbursement link then it the planned disbursement
  can be edited
- Only show the add planned disbursement button when the activity can be edited
- BEIS users can add transactions regardless of report state
- BEIS users can add planned disbursements regardless of report state
- Update the activity financials view to show all financials on all levels
  except Funds (Level A)
- Delivery partners can create & update comments associated to an activity & a report
  The comments are exported to the report CSV
- For delivery partners, Budgets relate to the report that creates them
- Ingest can handle the new budget/report relationship
- Update the budget policy
- Report variance is shown in a tab
- Show budgets added in a report on the reports view
- `Collaboration type` form field added to create activity journey and activity XML
- Upload transaction data in bulk as CSV
- Display the parent activity's RODA identifier when adding RODA IDs
- Missing `West Bank and Gaza Strip` country included in `recipient_country` list
- Report state content updated

## Release 16 - 2020-09-09

[Full changelog][16]

- Reports no longer have to be unique
- Reports cannot be unique for the Level A activity
- Add empty states for report tables
- Show Level A (Fund), organisation and financial quarter on the report edit
  page
- Handle attempts to activate invalid reports
- `Recipient_region` codelist modified
- `Intended beneficiaries` form field added, including validations, and country to region mapping
- `ODA eligibility` form step added to create activity journey
- Update any ingested Level B activities that do not have the BEIS organisation as their
  associated organisation. All Level B activities should belong to BEIS.
- `GDI` form step added to create activity journey
- Show Aid Type and Sector codes in Report CSV export for activities
- Update activity policy to account for the report state

## Release 15 - 2020-09-03

[Full changelog][15]

- Reports can be submitted
- Submitted reports are shown to users
- Reports can be activated explicitly
- Inactive reports are shown in their own table on the reports page
- Reports are no longer activated when the deadline is set
- Calculate the variance between an Activity's transactions total for a date range, and
  that same Activity's planned disbursements total for a date range. Output this value
  to the Report CSV as "Variance"
- Find the next four financial quarters after this report's financial quarter. Find the
  forecasted totals (planned disbursement totals) for those four future quarters and output
  them to the report CSV
- Submitted reports can be moved into the review state
- Reports in review can be moved into the awaiting changes state
- Transactions & Planned Disbursements cannot be edited if they are associated with an approved Report
- BEIS users can move a Report into the approved state
- `Call open date` and `Call close date` added to the create activity form, for levels C and D.
  This field is mandatory for new activities, but optional for activities marked as `ingested: true`
- `Create activity` buttons that were not changed on previous PR, are changed to
  `Add activity` now.
- RODA Identifiers can be added to activities on creation and when updating
- Reports in 'awaiting changes' can be submitted.
- Forecasted and actual spend and variance is shown on the report show page
- Ingest RS GCRF data from IATI
- Ingest BA GCRF data from IATI
- Ingest RAEng GCRF data from IATI
- Transparency Identifiers are set based on RODA Identifiers
- Delivery Partner Identifiers can be edited

## Release 14 - 2020-08-21

[Full changelog][14]

- Associate Transactions to Submissions
- Export Activity data in the Submission CSV
- rename Submission to Report
- reports can be managed in the reports section of the application
- remove submission from the organisation page
- Add `transactions_total` to Activity and add it to the Submission CSV per Activity
- Migrate AMS GCRF activities from Level C to Level B and update identifiers
- Ingest creates new activities at a level below its parent
- Reports store the relevant financial quarter
- Associate Planned Disbursements to Reports
- Update extending organisation question content
- `programme status` field added to activity form in exchange for old IATI status.
  Mapping `programme_status` to `IATI_status` included. Schema migration to replace
  `form_state` at `status` step for `programme_status` step
- `programme status` form step is not shown for level A activities
- Scope the total transaction value for an Activity to a Report and that Report's date
  range, and call the result `actual_total_for_report_financial_quarter`. Add this
  value to the Report CSV.
- Calculate the total of all Planned Disbursements in a Report's date range as
  `forecasted_total_for_report_financial_quarter` and output the value to the Report CSV
- Ingest RAEng Newton fund data from IATI

## Release 13 - 2020-08-05

[Full changelog][13]

- Allow budgets to have a negative value (but not zero)
- Customise error messages according to the content review
- Add a very basic Submission show page and CSV skeleton
- Migrate AMS GCRF activities from Level C to Level D

## Release 12 - 2020-07-28

[Full changelog][12]

- Activity identifiers are unique among siblings
- add accessibility statement
- Move budgets to the top of the programme activity financials tab
- Activity XML includes only recipient-country OR recipient-region, not both
- Activity creation journey changed to ask for a level and parent
- Add an activities page and navigation
- Remove Back links, except on the Activity form
- Refactor the activity update action
- Replace generic Rails error pages with styled pages (404, 500 and 422)
- Activities can be filtered to an organisation
- Selecting an activity level now includes more explanation of the hierarchy
- Activities show their child activities in a tab
- Activities link to their parent activity in the details tab
- Add Submission model, tests and fixtures. Seed database with a Submission per
  Organisation/Fund pair. Show a basic Submission table on the user's home page.
- Fund, programme, project and third-party project activities are no longer
  shown on the home page
- Submission descriptions can be edited. A deadline attribute has also been added
  to the Submission model; setting a deadline moves the Submission into the "active"
  state
- Migrate UKSA GCRF activities from Level C to Level D
- Add new `transparency_identifier` field which will be the identifier used in the
  IATI XML. This field is non-editable.

## Release 11 - 2020-07-08

[Full changelog][11]

- Ingest RS Newton fund data from IATI
- Allow BEIS users to redact activities from the IATI XML file, and to
  easily see on the Organisation show page which Activities are redacted
- Activity show content is show in tabs for financials and details
- Refactor how we can ask activities for their parents
- Ingest BA Newton fund data from IATI

## Release 10 - 2020-06-30

[Full changelog][10]

- Users can see codes when selecting aid type
- Content changes to activity status field
- Content changes to activity title field
- Content changes to activity purpose field
- Remove 3 unwanted activities from production
- Content changes to fields for transaction value and activity identifier
- Increase the width of the application layout

## Release 9 - 2020-06-18

[Full changelog][9]

- Transactions can have a negative value (but not zero)
- Amend Activity date validations - either `planned_start_date` _OR_ `actual_start_date`
  must be present, in line with the IATI `activity-date` XML standard
- Amend ingest service to successfully ingest Activities without an `activity-date` type
  2 (`actual_start_date`)
- Ingest AMS Newton fund data from IATI
- Flag incomplete activities in the activity table views
- XML download does not contain any incomplete activities
- XML download contains a `narrative` element for region & country containing the region or country name
- Ingest AMS GCRF data from IATI
- When a programme has an extending organisation set, the same organisation is set as the implementing organisation
- Use the `lograge` gem to reduce logging in production

## Release 8 - 2020-06-04

[Full changelog][8]

- The IATI identifier on an activity, transaction, planned disbursement,
  organisation and implementing organisation is stripped of leading and
  trailing whitespace
- Header navigation follows GOVUK frontend pattern
- Infer a transaction's and planned disbursement's `receiving-org type` from its
  parent activity's `implementing organisation`, if the `receiving-org type` on the
  element is missing
- Ingest tool fails loudly if any activity fails to be created
- Ingest UKSA data from IATI

## Release 7 - 2020-06-01

[Full changelog][7]

- Ingest tool no longer creates programmes but is instructed to look for existing records
- If an activity has a recipient_country set, the recipient_region is inferred from the recipient_country
- Planned disbursements are exported in the IATI XML
- The new planned disbursement form pre-fills the providing organisation details
- Add cookie policy
- Planned disbursement dates are validated within boundaries
- Ingest tool creates or updates existing projects if they match on the IATI identifier
- Ingest tool will try to set more meaningful identifiers for projects
- The providing organisation is pre-filled in for new transactions
- No longer lint the automatic schema changes made by the data_migrate gem
- Switched to the latest form builder gem version from our fork
- Planned disbursement create and update actions are recorded
- User role hint text is shown
- Transaction dates are validated to be no more than 10 years ago and 25 years
  in the future

## Release 6 - 2020-05-19

[Full changelog][6]

- Transaction and budget values are validated down to 0.01
- Add Skylight application performance monitoring
- Script to ingest legacy IATI data
- No longer show the geography response on the activity summary and when changing country or region the flow includes the geography question
- Add concept of `ingested` to budgets, and skip validation on ingested budgets. This is in preparation for ingesting legacy data from IATI.
- Sector questions asks for a category and uses radio buttons
- Add concept of `ingested` to transactions
- Transaction disbursement channel is no longer mandatory
- IATI ingest tool now saves the original XML for each activity to enable future tasks to copy across additional fields
- User can add, view and edit planned disbursements to projects and third-party projects
- BEIS users can download all of an Organisation's project (or third-party project) activities as XML from the organisation show page

## Release 5 - 2020-05-07

[Full changelog][5]

- User actions are tracked on Activities, Budgets, Transactions and Users.
- Activities that have an identifier already can use it as the iati-identifier
  in the xml output
- User actions are tracked on Organisations.
- Individual Activity update steps are tracked on create & update
- Content added to start page
- Links that open in a new window now have a message informing the user of this.
- BEIS users only see an organisation's activities on that organisation's show page (bug)
- XML file for projects now shows the identifiers for the parent activities.
- Fix descriptive labels on action links
- Remove `reference` from Transactions
- Add level D activities (third-party projects)
- Store Budget status and type as numbers, not words
- Delivery partner users can view budgets on Level B activities (but not edit or create them)
- Show a funds programmes in a table

## Release 4 - 2020-04-09

[Full changelog][4]

- When creating an activity the Finance step has been defaulted to `Standard grant` and omitted from the user journey
- When creating an activity, the `Tied status` step has been removed from the user journey and it has now a default value of `Untied`, code "5"
- Progressively enhance the country select element into a combo box when
  Javascript is available
- Add privacy policy to site
- Empty optional dates for `actual start date` and `actual end date` are not included on the activity XML
- Reporting org in the IATI XML is always BEIS for funds, programmes and projects created by governmental organisations, and the activity's organisation if it is a non-governmental organisation

## Release 3 - 2020-04-02

[Full changelog][3]

- Activities are ordered by `created_at` date, oldest first
- Transactions are ordered by `date`, newest first
- Budgets are ordered by `period_start_date`, newest first
- Remove transaction description from the transaction display table, to improve the activity page UI
- Organisation and User management links are in the site header navigation
- Organisations are managed from the /organisation page
- Organisation show page re-organised to show more information including funds,
  programmes and projects for the relevant users
- Make it clearer that Programme should have an extending organisation in order
  for delivery partners to report on the programme
- fix cookie error by switching session storage to Redis
- Activity aid type is now selected by radio button, not a dropdown select box
- Iterate the form content for the sector field by renaming it to "focus area"
- Enable host whitelisting (Rails 6 feature) to mitigate poisoned host header attacks
- Anonymize user's IP addresses before logging them outside the application, by removing the last octet of the address. Also use Rollbar's built-in IP address anonymizer.
- BEIS users can view Transactions & Budgets on a project, but not create or edit them
- Country list for recipient countries when creating an activity has been reduced to only those ODA uses as recipients.
- Add feedback form link to phase banner

## Release 2 - 2020-03-12

[Full changelog][2]

- Activity status is now shown as radio buttons with hints
- Activity XML includes 'iati-identifier' which is includes the reporting organisation
- Activity XML includes 'iati-identifier' with an identifier that consists of all present levels of hierarchy: fund and/or programme
- BEIS users (administrators) can mark other users as active or inactive
- Budget start and end dates are validated according to IATI standard
- BEIS users can view projects (read-only) and download them as XML via a button
- Codelist dropdowns do not contain values which have been marked as "status: withdrawn" by IATI
- Redis version increased from 3.x to 4.x now that GPaaS supports it
- Users can report either recipient_country or recipient_region data which is
  include in the xml

## Release 1 - 2020-03-04

[Full changelog][1]

- Add Google Tag Manager in place of templated Google Analytics code
- Ensure missing I18n strings cause tests to fail
- Users can be created/updated both locally and in Auth0
- Users can be associated with multiple organisations
- Allow roles to be assigned to users
- Users are welcomed and able to create their new password to access the service
- Service name updated from "Overseas" to "Official"
- Users can create and view Funds; users can create and view Activities
- Users can download an XML representation of an Activity
- Split activity form into multiple steps
- Create Transactions associated with a Fund
- Remove the distinction between Fund and Activity from the user
- Users can edit an organisation
- Users can edit the basic fund record
- Users can edit a transaction
- Users can edit an activity record
- Transactions record the provider and receiver organisations
- All forms now use `govuk_design_system_formbuilder` instead of `simple_form`
- Activity multi-step form now has validations
- Users can view an XML representation of Transactions and Funds
- Force SSL in production environments
- A users role can be viewed, set and changed
- Restrict delivery partners so they can only view and edit their own organisation
- Fund managers can manage users, organisations, funds, fund activites and fund transactions
- Transaction and Activity dates are restricted to 10 years in the past or 25 years in the future at most
- Provide a way to flag an organisation as BEIS
- User email addresses must be valid emails
- Users are only associated with one organisation
- Users land on their organisation#show page when they log in, instead of a "dashboard"
- Fund manager can add a programme level activity to a fund level activity
- Fund manager can view a fund level activity's programme activities
- Fund managers can create Budgets
- Fund and Programme activities store funding organisation details
- Fund and Programme activities store accountable organisation details
- Fund activities store extending organisation details
- Sign in button works when JS is disabled
- Fund managers can set and change the extending organisation
- Date inputs in forms for creating activity, transaction and a budget have a hint text
- Transaction provider and receiver IATI references are exposed in the XML if present
- Users can report project level activities
- Users can add budgets to project level activities
- Users can view Budgets in the Activity XML
- Consolidate all user roles into 'administrator', removing 'fund_manager' and 'delivery_partner'. All users can temporarily do anything
- Users who belong to delivery partners see a list of programmes on their organisation page
- Users are authorised based on the organisations they belong to
- Users can add budgets to activities at all levels
- Users can edit a budget
- Users can add currency information to budgets and see the currency in the budget XML
- Users can report an activities implementing organisation
- Users can edit a reported implementing organisation
- Users can view implementing organisations in the Activity XML
- Planned start and end dates are mandatory
- Actual start and end dates must not be in the future

[unreleased]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-169...HEAD
[169]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-168...release-169
[168]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-167...release-168
[167]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-166...release-167
[166]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-165...release-166
[165]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-164...release-165
[164]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-163...release-164
[163]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-162...release-163
[162]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-161...release-162
[161]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-160...release-161
[160]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-159...release-160
[159]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-158...release-159
[158]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-157...release-158
[157]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-156...release-157
[156]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-155...release-156
[155]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-154...release-155
[154]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-153...release-154
[153]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-152...release-153
[152]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-151...release-152
[151]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-150...release-151
[150]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-149...release-150
[149]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-148...release-149
[148]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-147...release-148
[147]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-146...release-147
[146]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-145...release-146
[145]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-144...release-145
[144]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-143...release-144
[143]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-142...release-143
[142]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-141...release-142
[141]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-140...release-141
[140]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-139...release-140
[139]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-138...release-139
[138]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-137...release-138
[137]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-136...release-137
[136]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-135...release-136
[135]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-134...release-135
[134]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-133...release-134
[133]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-132...release-133
[132]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-131...release-132
[131]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-130...release-131
[130]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-129...release-130
[129]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-128...release-129
[128]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-127...release-128
[127]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-126...release-127
[126]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-125...release-126
[125]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-124...release-125
[124]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-123...release-124
[123]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-122...release-123
[122]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-121...release-122
[121]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-120...release-121
[120]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-119...release-120
[119]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-118...release-119
[118]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-117...release-118
[117]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-116...release-117
[116]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-115...release-116
[115]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-114...release-115
[114]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-113...release-114
[113]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-112...release-113
[112]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-111...release-112
[111]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-110...release-111
[110]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-109...release-110
[109]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-108...release-109
[108]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-107...release-108
[107]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-106...release-107
[106]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-105...release-106
[105]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-104...release-105
[104]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-103...release-104
[103]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-102...release-103
[102]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-101...release-102
[101]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-100...release-101
[100]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-99...release-100
[99]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-98...release-99
[98]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-97...release-98
[97]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-96...release-97
[96]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-95...release-96
[95]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-94...release-95
[94]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-93...release-94
[93]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-92...release-93
[92]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-91...release-92
[91]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-90...release-91
[90]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-89...release-90
[89]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-88...release-89
[88]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-87...release-88
[87]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-86...release-87
[86]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-85...release-86
[85]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-84...release-85
[84]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-83...release-84
[83]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-82...release-83
[82]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-81...release-82
[81]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-80...release-81
[80]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-79...release-80
[79]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-78...release-79
[78]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-77...release-78
[77]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-76...release-77
[76]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-75...release-76
[75]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-74...release-75
[74]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-73...release-74
[73]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-72...release-73
[72]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-71...release-72
[71]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-70...release-71
[70]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-69...release-70
[69]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-68...release-69
[68]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-67...release-68
[67]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-66...release-67
[66]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-65...release-66
[65]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-64...release-65
[64]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-63...release-64
[63]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-62...release-63
[62]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-61...release-62
[61]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-60...release-61
[60]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-59...release-60
[59]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-58...release-59
[58]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-57...release-58
[57]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-56...release-57
[56]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-55...release-56
[55]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-54...release-55
[54]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-53...release-54
[53]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-52...release-53
[52]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-51...release-52
[51]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-50...release-51
[50]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-49...release-50
[49]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-48...release-49
[48]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-47...release-48
[47]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-46...release-47
[46]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-45...release-46
[45]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-44...release-45
[44]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-43...release-44
[43]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-42...release-43
[42]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-41...release-42
[41]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-40...release-41
[40]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-39...release-40
[39]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-38...release-39
[38]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-37...release-38
[37]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-36...release-37
[36]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-35...release-36
[35]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-34...release-35
[34]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-33...release-34
[33]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-32...release-33
[32]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-31...release-32
[31]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-30...release-31
[30]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-29...release-30
[29]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-28...release-29
[28]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-27...release-28
[27]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-26...release-27
[26]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-25...release-26
[25]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-24...release-25
[24]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-23...release-24
[23]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-22...release-23
[22]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-21...release-22
[21]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-20...release-21
[20]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-19...release-20
[19]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-18...release-19
[18]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-17...release-18
[17]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-16...release-17
[16]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-15...release-16
[15]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-14...release-15
[14]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-13...release-14
[13]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-12...release-13
[12]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-11...release-12
[11]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-10...release-11
[10]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-9...release-10
[9]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-8...release-9
[8]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-7...release-8
[7]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-6...release-7
[6]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-5...release-6
[5]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-4...release-5
[4]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-3...release-4
[3]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-2...release-3
[2]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/release-1...release-2
[1]: https://github.com/UKGovernmentBEIS/beis-report-official-development-assistance/compare/3199f25...release-1
