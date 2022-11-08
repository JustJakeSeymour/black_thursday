require_relative 'requirements'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    # @sales_analyst = sales_analyst
  end

  def average_items_per_merchant
   (items_count / merchants_count.to_f).round(2)
    # total number of items per merchant
    # divided by total number of merchants
  end

  def items_count
    sales_engine.items.all.count
  end

  def merchants_count
    sales_engine.merchants.all.count
  end

  def average_items_per_merchant_standard_deviation
    sum = 0
    sales_engine.merchants.all.each do |merchant|
      sum += (sales_engine.items.find_all_by_merchant_id(merchant.id).count - average_items_per_merchant)**2
    end
    Math.sqrt(sum / (merchants_count - 1)).round(2)
    # take average_items_per_merchant 
    # find the standard deviation
        # (item_count_ForEachMerchant - average_items_per_merchant) ^ 2
        # add all of these up for every single merchant = sum
            #  sum / (by total number of merchants - 1) = answer
        # sqrt(answer) = sd
    # Float
  end

  def merchants_with_high_item_count
    high_item_count = sales_engine.merchants.all.find_all do |merchant|
      (sales_engine.items.find_all_by_merchant_id(merchant.id).count) > (average_items_per_merchant + average_items_per_merchant_standard_deviation)
    end
    # find_all merchants with more than ONE sd ABOVE the average number of items offered
    # return array of merchants
  end

  def average_item_price_for_merchant(merchant_id)
    item_prices_per_merchant = []
      items_per_merchant = sales_engine.items.find_all_by_merchant_id(merchant_id)
      items_per_merchant.each do |item|
        item_prices_per_merchant << (item.unit_price / 100)
      end
      avg = ((item_prices_per_merchant.sum) / items_per_merchant.count)
      avg = BigDecimal(avg, 4)
      # price of each item for that merchant
      # add it all together
      # divide by number of items for THAT merchant
        # divide ^ by 100 because items are in cents and we want dollars
      #BigDecimal
    end

  def average_average_price_per_merchant
    all_merchant_averages = []
    sales_engine.merchants.all.each do |merchant|
      all_merchant_averages  << average_item_price_for_merchant(merchant.id)
    end
    ((all_merchant_averages.sum) / merchants_count).truncate(2)
    # use average_item_price_for_merchant(merchant_id)
    # add the sum of all averages between ALL of the merchants
    # divided by number of total merchants
    # BigDecimal
  end

  def average_price_for_all_items
    total_price_for_all_items = sales_engine.items.all.sum do |item|
      item.unit_price
    end
    avg_price_of_items = (total_price_for_all_items / items_count).round(2)
  end

  def average_standard_deviation_for_all_items
    sum = 0
    sales_engine.items.all.each do |item|
      sum += (item.unit_price - average_price_for_all_items)**2
    end
    items_standard_deviation = Math.sqrt(sum / (items_count - 1)).round(2)
  end

  def golden_items
    sales_engine.items.all.find_all do |item|
      item.unit_price > (average_price_for_all_items + (average_standard_deviation_for_all_items * 2))
    end
  end
    # find average_item_price_for_all_items
      # all item prices / all items count
    # find all items SD
    # find all items that are TWO sd ABOVE the average_item_price_for_all_items
    # returns an array of item objects
    # it is an Item Class


   # ======================================= #

  def average_invoices_per_merchant
    (invoice_count / merchants_count.to_f).round(2)
  end

  def invoice_count
    sales_engine.invoices.all.count
  end
  
  def average_invoices_per_merchant_standard_deviation
    sum = 0
    sales_engine.merchants.all.each do |merchant|
      sum += (sales_engine.invoices.find_all_by_merchant_id(merchant.id).count - average_invoices_per_merchant)**2
    end
    Math.sqrt(sum / (merchants_count - 1)).round(2)
  end
  
  def top_merchants_by_invoice_count
    high_invoice_count = sales_engine.merchants.all.find_all do |merchant|
      (sales_engine.invoices.find_all_by_merchant_id(merchant.id).count) > (average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2))
    end
  end
  
  def bottom_merchants_by_invoice_count
    low_invoice_count = sales_engine.merchants.all.find_all do |merchant|
      (sales_engine.invoices.find_all_by_merchant_id(merchant.id).count) < (average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2))
    end
  end

  def invoice_count_per_day
    invoices_per_day = {}
    days_of_the_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    days_of_the_week.each do |day|
      day_count = sales_engine.invoices.all.find_all do |invoice|
        invoice.created_at.strftime("%A") == day
      end
      invoices_per_day[day] = day_count.count
    end
    invoices_per_day
  end

  def average_invoices_per_day
    (invoice_count.to_f / invoice_count_per_day.count).truncate(2)
  end

  def average_invoice_standard_deviation
    sum = 0
    invoice_count_per_day.each do |day, count|
      sum += ((count - average_invoices_per_day)**2)
    end
    invoice_standard_deviation = Math.sqrt(sum / (invoice_count_per_day.count - 1)).round(2)
  end

  def top_days_by_invoice_count
    top_days = []
    invoice_count_per_day.each do |day, count|
      top_days << day if count > (average_invoices_per_day + average_invoice_standard_deviation)
    end
    top_days
  end

  def invoice_status(status)
    case status
    when :pending
      return (sales_engine.invoices.find_all_by_status(:pending).count / (invoice_count.to_f) *100).round(2)
    when :shipped 
      return (sales_engine.invoices.find_all_by_status(:shipped).count / (invoice_count.to_f) *100).round(2)
    else 
      return (sales_engine.invoices.find_all_by_status(:returned).count / (invoice_count.to_f) *100).round(2)
    end
  end
  
  # ======================================= #
  
  def invoice_paid_in_full?(invoice_id) 
    # returns true if the Invoice with the corresponding id is paid in full
  end
  
  def invoice_total(invoice_id)
    # returns the total $ amount of the Invoice with the corresponding id
    # Failed charges should never be counted in revenue totals or statistics
    # An invoice is considered paid in full if it has a successful transaction
  end


  # ======================================= #

  def total_revenue_by_date(date)
    # use unit_price listed within invoice_items
  end

  def top_revenue_earners(top_number = 10)
    # optional argument
    # If no number is given for top_revenue_earners, 
    # it takes the top 20 merchants by defaul
  end

  def merchants_ranked_by_revenue
    #not on iteraction pattern but noticed on spec harness
  end

  def merchants_with_pending_invoices
    # pending invoices = if none of the transactions are successful
  end

  def merchants_with_only_one_item_registered_in_month(month)
    # merchants that only sell one item by the month they registered 
    # (merchant.created_at)
  end

  def revenue_by_merchant(merchant_id)
    # formatted in dollars
  end

  def most_sold_item_for_merchant(merchant_id)
    # quantity sold
    # if a tie [item, item, item]
  end

  def best_item_for_merchant(merchant_id)
    # item in terms of revenue generated
  end
end
