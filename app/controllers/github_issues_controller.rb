class GithubIssuesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @attachment_id = params[:attachment_id]
    at = Attachment.find(@attachment_id)
    @issue = GithubIssue.new
    @issue.repo = ENV['TARGET_REPO']
    @issue.body = "![image](#{at.file.url})"
  end

  def create
    @attachment_id = params[:attachment_id]
    at = Attachment.find(@attachment_id)
    @issue = GithubIssue.new(params[:github_issue])
    client = Octokit::Client.new(:login => current_user.login, :oauth_token => current_user.access_token)
    begin
      issue = client.create_issue(@issue.repo, @issue.title, @issue.body)
      at.update_column(:issue_id, issue.id)
      redirect_to attachments_path, :notice => 'Github Issue successfully created'
    rescue => e
      Rails.logger.error e.inspect
      redirect_to attachments_path, :alert => 'Failed to create Github Issue'
    end
  end

end
