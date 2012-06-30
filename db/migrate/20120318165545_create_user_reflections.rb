class CreateUserReflections < ActiveRecord::Migration
  def change
    create_table :user_reflections do |t|
      t.integer :user_id
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
