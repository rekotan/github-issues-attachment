class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :user_id
      t.string :repository
      t.integer :issue_id

      t.timestamps
    end
  end
end
