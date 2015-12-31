class CreateFormJob < ActiveRecord::Migration
  def change
    create_table :form_jobs do |t|
      t.string     :name
      t.string     :email
      t.string     :country
      t.text       :periods
      t.attachment :letter
      t.attachment :resume

      t.timestamps null: false
    end
  end
end
