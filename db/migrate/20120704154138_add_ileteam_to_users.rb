class AddIleteamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ileteam, :integer  ,:default => 1

  end
end
