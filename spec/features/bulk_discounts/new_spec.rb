require 'rails_helper'

RSpec.describe BulkDiscount, type: :feature do
  context "new discount form" do
  end
  before(:each) do
    @merchant1 = Merchant.create!(name: 'I Care')
    @discount1 = @merchant1.bulk_discounts.create!(percent: 10, threshold: 100)
    @discount2 = @merchant1.bulk_discounts.create!(percent: 20, threshold: 300)
    @discount3 = @merchant1.bulk_discounts.create!(percent: 30, threshold: 400)
    
    visit "/merchant/#{@merchant1.id}/bulk_discounts/new"
  end

  it "redirects back to bulk discount index when form completed with valid data" do

    fill_in :percent, with: '40'
    fill_in :threshold, with: '600'
    click_button "Submit"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
    expect(page).to have_content('New Discount Created')
    expect(page).to have_content("40% off if 600 items purchased")
  end

  it "redirects back to new bulk discount form when form completed with invalid data" do
    fill_in :percent, with: ""
    fill_in :threshold, with: ''
    click_button "Submit" #leaving fields blank    
    expect(current_path).to match("merchant/#{@merchant1.id}/bulk_discounts/new")
    expect(page).to have_content("Invalid input. Use only positive integers")
    # fill_in :percent, with: '400'
    # fill_in :threshold, with: '600'
    # click_button "Submit"
    # expect(current_url).to eq("merchant/#{@merchant1.id}/bulk_discounts/new")
    # # expect(page).to have_content('Value must be less than or equal to 100.')
    # fill_in :percent, with: "40"
    # fill_in :threshold, with: "44.4"
    # click_button "Submit"
    # expect(current_path).to match("merchant/#{@merchant1.id}/bulk_discounts/new")
    # expect(page).to have_content("Please enter a valid value.")
  end
end