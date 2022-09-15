class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @pagy, @products = pagy(@q.result)
    @name = params[:q]
  end

  def show
    @product = Product.find_by(id: params[:id])
    @ratings = Rating.where(product_id: params[:id]).newest
    @pagy, @ratings = pagy @ratings if @ratings.present?
    return if @product.present?

    flash[:danger] = t "static_pages.product_not_found"
    redirect_to root_path
  end
end
