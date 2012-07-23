class AddAccessTokenToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :access_token, :string
  end
end
