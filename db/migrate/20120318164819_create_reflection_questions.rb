class CreateReflectionQuestions < ActiveRecord::Migration
  def change
    create_table :reflection_questions do |t|
      t.string :qno
      t.text :question

      t.timestamps
    end
  end
end
