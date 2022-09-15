class Admin::BaseController < ApplicationController
  layout "layouts/application_admin"

  before_action :authenticate_user!

  private
  def logged_in_admin
    return if admin_logged_in?

    flash[:danger] = t("carts.show.please_login_admin")
    redirect_to root_path
  end
end
