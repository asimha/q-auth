class CreateDesignations < ActiveRecord::Migration
  def self.up
    create_table :designations do |t|
      t.string :title, limit: 256
      t.string :responsibilities, limit: 2056
      t.timestamps
    end
  end

  def self.down
    drop_table :designations
  end
end