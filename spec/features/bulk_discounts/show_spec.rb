require 'rails_helper'

RSpec.describe BulkDiscount, type: :feature do
  context 'when merchants visit bulk discount show page' do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'I Care')
      @discount1 = @merchant1.bulk_discounts.create!(percent: 10, threshold: 100)
      @discount2 = @merchant1.bulk_discounts.create!(percent: 20, threshold: 300)
      @discount3 = @merchant1.bulk_discounts.create!(percent: 30, threshold: 400)
    
      visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@discount2.id}"
      save_and_open_page
    end

    it 'display the bulk discounts percentage and threshold information' do
    expect(page).to have_content("Percent discount: 20%")
    expect(page).to have_content("Min purchase quantity required: 300")
    end
  end
end