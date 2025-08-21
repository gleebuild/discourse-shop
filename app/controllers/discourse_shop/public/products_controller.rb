
# frozen_string_literal: true
class DiscourseShop::Public::ProductsController < DiscourseShop::Public::BaseController
  def index
    DiscourseShop::Log.log!("[shop] list products; ua=#{request.user_agent}")
    products = DiscourseShop::Product.published.order(created_at: :desc).limit(200)
    render_json_dump(products: ActiveModel::ArraySerializer.new(products, each_serializer: DiscourseShop::ProductSerializer))
  end
  def show
    product = DiscourseShop::Product.find(params[:id])
    DiscourseShop::Log.log!("[shop] show product ##{product.id}")
    raise Discourse::InvalidAccess.new unless product.active? || current_user&.admin?
    render_json_dump(product: DiscourseShop::ProductSerializer.new(product))
  end
end
