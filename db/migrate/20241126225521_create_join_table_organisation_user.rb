class CreateJoinTableOrganisationUser < ActiveRecord::Migration[6.1]
  def change
    create_join_table :organisations, :users, column_options: {type: :uuid} do |t|
      t.index [:organisation_id, :user_id]
      t.index [:user_id, :organisation_id]
    end

    User.all.each do |user|
      user.organisations << user.organisation
    end
  end
end
