class UsersController < ApplicationController
  def index
  end
  def callback
    if params[:error]
      redirect_to root_path, :alert => params[:error]
    else
      access_token = request.env['omniauth.auth']['credentials']['token']
      login = JSON.parse(open("https://api.github.com/user?access_token=#{access_token}").read)['login']
      user = User.find_or_create_by_access_token_and_login(:access_token => access_token,
                                                           :login => login)
      session[:user_id] = user.id
      session[:access_token] = user.access_token
      if ENV['CHECK_REPO']
        client = Octokit::Client.new(:login => user.login, :oauth_token => user.access_token)
        begin
          client.repo(ENV['CHECK_REPO'])
          redirect_to attachments_path, :notice => "Successfully logged in"
        rescue
          session[:user_id] = nil
          session[:access_token] = nil
          redirect_to root_path, :alert => "Private usage only, sorry"
        end
      else
        redirect_to attachments_path, :notice => "Successfully logged in"
      end
    end
  end
  def failure
    redirect_to root_path, :alert => params[:message]
  end
  def logout
    session[:user_id] = nil
    session[:access_token] = nil
    redirect_to root_path, :notice => "Successfully logged out"
  end
end
