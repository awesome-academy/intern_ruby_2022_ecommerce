class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i(edit update)

  def index
    @orders = Order.this_month.without_deleted.oldest
    @pagy, @orders2 = pagy(Order.this_month.oldest,
                           items: Settings.order.item)
    @search = Order.ransack(params[:q])
    @orders3 = @search.result
  end

  def search
    index
    render :index
  end

  def edit
    @order_details = @order.order_details
  end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path
    else
      flash[:danger] = t "flashes.update_failed"
      render :edit
    end
  end

  private
  def find_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "flashes.alert_not_found"
    redirect_to admin_orders_path
  end

  def order_params
    params.require(:order).permit(:user_id, :amount, :status)
  end
end
