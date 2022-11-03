require 'csv'
require './lib/sales_engine'
require './lib/merchant'
require './lib/merchant_repository'
require './lib/item_repository'
require './lib/item'
require './lib/sales_analyst'

RSpec.describe SalesEngine do
  let!(:sales_engine) {SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv"})}
  it 'exists' do
    expect(sales_engine).to be_a(SalesEngine)
  end

  it 'has common roots to their repositories' do
    expect(sales_engine.items).to be_a(ItemRepository)
    expect(sales_engine.merchants).to be_a(MerchantRepository)
  end

   it 'creates a SalesAnalyst' do
    sales_analyst = sales_engine.analyst
    expect(sales_analyst).to be_a(SalesAnalyst)
  end
end