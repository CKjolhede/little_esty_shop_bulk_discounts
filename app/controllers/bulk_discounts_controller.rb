class BulkDiscountsController < ApplicationController
before_action :find_merchant, only: [:index, :new, :create]
before_action :find_discount_and_merchant, only: [:show, :edit, :update, :destroy]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    # @merchant = Merchant.find(params[:merchant_id])
  end

  def show
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount), notice: "Discount Updated Successfully"
    else
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}/edit", notice: "Please re-enter your changes"
    end
  end


  def create
    # find_merchant
    discount = BulkDiscount.create(bulk_discount_params)
    # if discount.save
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts", notice: "New Discount Created"
    # else
    #   redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new", notice: "Invalid input. Use only positive integers"
    # end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.permit(:percent, :threshold, :merchant_id)
  end

  def find_discount_and_merchant
      @bulk_discount = BulkDiscount.find(params[:id])
      @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

end