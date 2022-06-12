require 'rails_helper'

RSpec.describe BulkDiscount, type: :feature do
  context "merchant bulk discounts page" do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'I Care')
      @discount1 = @merchant1.bulk_discounts.create!(percent: 10, threshold: 100)
      @discount2 = @merchant1.bulk_discounts.create!(percent: 20, threshold: 300)
      @discount3 = @merchant1.bulk_discounts.create!(percent: 30, threshold: 400)
    
      visit "/merchant/#{@merchant1.id}/bulk_discounts"
    end

    it "lists all discounts for the merchant" do

        expect(page).to have_link('10% off if 100 items purchased')
        expect(page).to have_link('20% off if 300 items purchased')
        expect(page).to have_link('30% off if 400 items purchased')

        click_on "10% off if 100 items purchased"
        expect(current_path).to match("/merchant/#{@merchant1.id}.bulk_discounts/#{@discount1.id}")
    end

    it 'has a link to page with form to create new discount' do
      within("#new_discount") do
        expect(page).to have_link("New Bulk Discount")
        click_on "New Bulk Discount"
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
      end
    end
  
    it "has a delete button next to each bulk discount which deletes the discount and return to the bulk discount index page" do
      expect(page).to have_content("20% off if 300 items purchased")
      within("#discounts-#{@discount1.id}") do 
        expect(page).to have_content("10% off if 100 items purchased")
        expect(page).to have_button("Delete")
        click_button
      end
        expect(current_path).to match("/merchant/#{@merchant1.id}/bulk_discounts")
        expect(page).to_not have_content("10% off if 100 items purchased")
      expect(page).to have_content("20% off if 300 items purchased")
    end 
  end
end