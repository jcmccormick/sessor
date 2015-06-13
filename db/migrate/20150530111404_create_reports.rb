class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.text :submission
      t.text :response
      t.boolean :active
      t.string :location
      t.text :participants


      t.timestamps null: false
    end
  end
end
