class ProductsController < ApplicationController
  def index
    @products = Product.newest
    @categories = Category.newest
  end

  def show
    @product = Product.find_by(id: params[:id])
    @ratings = Rating.where(product_id: params[:id]).newest
    @pagy, @ratings = pagy @ratings if @ratings.present?
    return if @product.present?

    flash[:danger] = t "static_pages.product_not_found"
    redirect_to root_path
  end

  def result
    @name = params[:name]
    @pagy, @products = pagy Product.by_name params[:name]
  end

  def filter
   if params[:filter] == t("static_pages.newest")
    @pagy, @products = pagy Product.newest
   elsif params[:filter] == t("static_pages.price_increase")
    @pagy, @products = pagy Product.order_by_price(:asc)
   else
    @pagy, @products = pagy Product.order_by_price(:desc)
   end
  end
end
