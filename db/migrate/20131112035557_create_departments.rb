class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name, limit: 256
      t.string :description, limit: 2056
      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end