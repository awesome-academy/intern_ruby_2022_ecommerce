class Admin::XlsxController < Admin::BaseController
  skip_authorization_check

  def index
    @orders = Order.this_month.group(:user_id).count
    @order_details = OrderDetail.this_month.group(:product_id).count
    month = Date::MONTHNAMES[Date.current.last_month.month.to_i]
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers["Content-Disposition"] =
          "attachment; filename=#{month}_summary.xlsx"
      end
    end
  end
end
