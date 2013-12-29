class AddImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.string :email_from
      t.string :email_subject
 
      t.timestamps
    end
  end
end
