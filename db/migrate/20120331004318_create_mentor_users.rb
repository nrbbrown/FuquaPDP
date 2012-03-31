class CreateMentorUsers < ActiveRecord::Migration
  def change
    create_table :mentor_users do |t|
      t.integer :mentor_user_id
      t.integer :student_user_id

      t.timestamps
    end
  end
end
