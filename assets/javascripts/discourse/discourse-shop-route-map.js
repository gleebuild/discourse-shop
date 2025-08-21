
export default function () {
  this.route("shop", { path: "/shop" }, function () {
    this.route("product", { path: "/product/:id" });
    this.route("checkout", { path: "/checkout" });
    this.route("complete", { path: "/complete" });
  });

  // Admin plugin page at /admin/plugins/shop
  // (We also have /shop/admin SSR fallback served by Rails for robustness)
  this.route("adminPlugins.shop", { path: "/admin/plugins/shop" });

  // Optional front-facing admin alias (if you want Ember to render something here later)
  this.route("shop-admin", { path: "/shop/admin" });
}
