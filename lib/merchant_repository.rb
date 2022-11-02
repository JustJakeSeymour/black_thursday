class MerchantRepository

  def initialize(merchants)
    @merchants = merchants
  end
  
  def all
    @merchants
  end

  def find_by_id(id)
    if !a_valid_id?(id)
      return nil
    else
      @merchants.find do |merchant|
        merchant.id == id
      end
    end
  end

  def a_valid_id?(id)
    @merchants.any? do |merchant| merchant.id == id
    end 
  end
  
  def find_by_name(name)
    @merchants.find{|merchant| merchant.name.downcase == name.downcase}
  end

  def find_all_by_name(string)
    @merchants.find_all do |merchant|
      merchant.name.downcase.include?(string.downcase)
    end
  end

  def create(attribute)
    new_id = @merchants.last.id + 1
    @merchants << Merchant.new({:id => new_id, :name => attribute})
  end

  def update(id, name)
    @merchants.each do |merchant|
      if merchant.id == id
        merchant_new_name = merchant.name.replace(name)
        return merchant_new_name
      end
    end
  end

  def delete(id)
    @merchants.delete(find_by_id(id))
  end
end