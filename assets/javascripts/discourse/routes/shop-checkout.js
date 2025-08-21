
import DiscourseRoute from "discourse/routes/discourse";
import { ajax } from "discourse/lib/ajax";
export default class ShopCheckoutRoute extends DiscourseRoute {
  queryParams = { product_id: { refreshModel: true }, variant_id: { refreshModel: true }, qty: { refreshModel: true } };
  model(params) { return ajax(`/shop-api/public/products/${params.product_id}.json`).then((res) => ({ product: res.product, params })); }
}
