class Attachment < ActiveRecord::Base
  attr_accessible :issue_id, :repository, :user_id
  attr_accessible :file
  before_create :generate_access_token
  has_attached_file :file, Proc.new {
    if Rails.env.production?
      {
        :storage => :s3,
        :s3_credentials => Rails.root.join("config", "s3.yml"),
        :path => ':attachment/:id/:access_token/:style.:extension',
        :bucket => ENV['S3_BUCKET'],
        :styles => {:medium => "300x300>", :thumb => "100x100>"}
      }
    else
      {
        :url => '/system/attachments/:id/:access_token/:style.:extension',
        :path => ':rails_root/public:url',
        :styles => {:medium => "300x300>", :thumb => "100x100>"}
      }
    end
  }.call

  private
  # simple random salt
  def random_salt(len = 20)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    salt = ""
    1.upto(len) { |i| salt << chars[rand(chars.size-1)] }
    return salt
  end

  # SHA1 from random salt and time
  def generate_access_token
    self.access_token = Digest::SHA1.hexdigest("#{random_salt}#{Time.now.to_i}")
  end

  # interpolate in paperclip
  Paperclip.interpolates :access_token  do |attachment, style|
    attachment.instance.access_token
  end
end
