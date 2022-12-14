class Admin::UsersController < Admin::BaseController
  before_action :find_user, only: %i(show)

  load_and_authorize_resource

  def index
    @pagy, @users = pagy(User.newest, items: Settings.user.item)
    @best = User.best_user(Order.most_order).first
  end

  def show
    @pagy, @orders = pagy(@user.orders.oldest,
                          items: Settings.user.item)
    @pagy, @ratings = pagy(@user.ratings.all, items: Settings.user.item)
  end

  private
  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "flashes.alert_not_found"
    redirect_to admin_users_path
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :address)
  end
end
