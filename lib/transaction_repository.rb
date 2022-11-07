require_relative '../requirements'

class TransactionRepository

  def initialize(transactions, engine)
    @transactions = create_records(transactions)
    @engine = engine
  end

  def all
    @transactions
  end

  def a_valid_id?(id)
    @transactions.any? do |transaction| transaction.id == id
    end
  end 

  def find_by_id(id)
    nil if !a_valid_id?(id)
    
    @transactions.find do |transaction|
      transaction.id == id
    end
  end
  
  def find_all_by_invoice_id(id)
    # nil if !a_valid_id?(id)
    
    @transactions.find_all do |transaction|
      transaction.invoice_id == id
    end
  end

  def find_all_by_credit_card_number(cc)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == cc
    end
  end

  def find_all_by_result(result)
    result.to_sym
    @transactions.find_all do |transaction|
      transaction.result == result
    end
  end

  def create(attributes)
    new_id = @transactions.last.id + 1
    @transactions << Transaction.new({ :id => new_id, 
                                      :invoice_id => attributes[:invoice_id], 
                                      :credit_card_number => attributes[:credit_card_number],
                                      :credit_card_expiration_date => attributes[:credit_card_expiration_date],
                                      :result => attributes[:result],
                                      :created_at => Time.now,
                                      :updated_at => Time.now}, self)
  end

  def update(id, attributes)
    @transactions.each do |transaction|
      transaction.update(attributes) if transaction.id == id
    end
  end

  def delete(id)
    @transactions.delete(find_by_id(id))
  end

  def create_records(filepath)
    contents = CSV.open filepath, headers: true, header_converters: :symbol, quote_char: '"'
    make_object(contents)
  end
  
  def make_object(contents)
    contents.map do |row|
      transaction = {
              :id => row[:id].to_i, 
              :invoice_id => row[:invoice_id].to_i,
              :credit_card_number => row[:credit_card_number],
              :credit_card_expiration_date => row[:credit_card_expiration_date],
              :result => row[:result].to_sym,
              :created_at => Time.parse(row[:created_at]),
              :updated_at => Time.parse(row[:updated_at]),
            }
      Transaction.new(transaction, self)
    end
  end
  
  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end

