class AddSectionNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :section_number, :integer  ,:default => 1

  end
end
