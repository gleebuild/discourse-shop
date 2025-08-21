
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import DiscourseURL from "discourse/lib/url";
export default class ShopCheckoutController extends Controller {
  @action
  async submitCheckout(e) {
    e.preventDefault();
    const form = e.target;
    const data = new FormData(form);
    const payProvider = data.get("payment_provider");
    try {
      const qty = Number(this.model?.params?.qty || 1);
      const orderRes = await ajax("/shop-api/public/checkout", {
        type: "POST",
        data: {
          product_id: this.model?.params?.product_id,
          variant_id: this.model?.params?.variant_id,
          quantity: qty,
          coupon_code: data.get("coupon_code"),
          shipping: {
            name: data.get("name"),
            phone: data.get("phone"),
            country: data.get("country"),
            province: data.get("province"),
            city: data.get("city"),
            address: data.get("address"),
            postal_code: data.get("postal_code"),
          },
          payment_provider: payProvider
        }
      });
      const orderId = orderRes.order.id;
      const payRes = await ajax("/shop-api/public/pay", {
        type: "POST",
        data: { order_id: orderId, payment_provider: payProvider }
      });
      if (payRes.payment?.url) {
        DiscourseURL.redirectTo(payRes.payment.url);
      } else {
        DiscourseURL.redirectTo(`/shop/complete?order_id=${orderId}`);
      }
    } catch (err) {
      popupAjaxError(err);
    }
  }
}
