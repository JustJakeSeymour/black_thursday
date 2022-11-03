class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at
              
  def initialize
    @id = info[:id]
    @invoice_id = info[:invoice_id]
    @credit_card_number = info[:credit_card_number]
    @credit_card_expiration_date = info[:credit_card_expiration_date]
    @result = info[:result]
    @created_at = info[:created_at]
    @updated_at = info[:updated_at]
  end
end