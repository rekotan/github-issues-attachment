class AttachmentsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @attachments = Attachment.all
  end
  def new
    @attachment = Attachment.new
  end
  def create
    @attachment = Attachment.new(params[:attachment])
    @attachment.user_id = current_user.id
    if @attachment.save
      redirect_to attachments_path, :notice => 'Uploaded successfully'
    else
      redirect_to attachments_path, :alert => 'Failed to uploaded'
    end
  end
end
