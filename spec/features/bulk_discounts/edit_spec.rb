require 'rails_helper'

RSpec.describe BulkDiscount, type: :feature do
  context 'merchant bulk discount edit page' do
    before(:each) do
    @merchant1 = Merchant.create!(name: 'I Care')
    @discount1 = @merchant1.bulk_discounts.create!(percent: 10, threshold: 100)
    @discount2 = @merchant1.bulk_discounts.create!(percent: 20, threshold: 300)
    @discount3 = @merchant1.bulk_discounts.create!(percent: 30, threshold: 400)
    
    visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@discount2.id}/edit"
  end

  it "edit page has a form prepopulated with current discount attributes" do
    save_and_open_page
      expect(page).to have_field(:percent, with: "20")
      expect(page).to have_field(:threshold, with: "300")
      expect(page).to_not have_field(with: "")
    end

    it 'form updates only the valid discount information provided when submitted and redirects to bulk discount show page' do
      fill_in "percent", with: '25'
      click_on "Submit"
      expect(current_path).to match(merchant_bulk_discount_path(@merchant1, @discount2))
      within("#percent") do
        expect(page).to have_content("Percent discount: 25%")
      end
      within("#threshold") do
        expect(page).to have_content("Min purchase quantity required: 300")
      end
    end

    it 'form updates all valid discount information provided when submitted and redirects to bulk discount show page' do
  
      fill_in :percent, with: '25'
      fill_in :threshold, with: '350'
      click_on "Submit"
      save_and_open_page
      expect(current_path).to match(merchant_bulk_discount_path(@merchant1, @discount2))
      within("#percent") do
        expect(page).to have_content("Percent discount: 25%")
      end
      within("#threshold") do
        expect(page).to have_content("Min purchase quantity required: 350")
      end
    end
  end
end