class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  # def items_discount(ii_id)
  #   bulk_discounts = BulkDiscount.order(:threshold)
  #   invoice_item = InvoiceItem.find(ii_id)
  #   bulk_discount = nil
  #   bulk_discounts.each do |bd|
  #     if bd.threshold <= invoice_item.quantity
  #       bulk_discount = bd
  #     end
  #   end
  # bulk_discount
  # end

  def items_discount
    bulk_discounts.where("bulk_discounts.threshold <= ?", quantity)
      .select('bulk_discounts.*')
      .order(percent: :desc)
      .first
  end
end
