class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.text :email

      t.timestamps null: false
    end
  end
end
