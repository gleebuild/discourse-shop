
# frozen_string_literal: true
class DiscourseShop::Variant < ActiveRecord::Base
  self.table_name = 'discourse_shop_variants'
  belongs_to :product, class_name: 'DiscourseShop::Product'
  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  after_create  { ::DiscourseShop::Log.log!("[Variant] CREATE id=#{id}") }
  after_update  { ::DiscourseShop::Log.log!("[Variant] UPDATE id=#{id}") }
  after_destroy { ::DiscourseShop::Log.log!("[Variant] DESTROY id=#{id}") }
end
