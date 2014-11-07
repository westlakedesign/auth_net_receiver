module AuthNetReceiver::SampleData

  TRANS_AMOUNT = "9.99"
  TRANS_ID = "12345"
  SUBSCRIPTION_ID = "67890"

  def valid_hash_for_transaction
    return Digest::MD5.hexdigest(AuthNetReceiver.config.hash_value + AuthNetReceiver.config.gateway_login + TRANS_ID + TRANS_AMOUNT).upcase
  end

  def valid_hash_for_subscription 
    return Digest::MD5.hexdigest(AuthNetReceiver.config.hash_value + TRANS_ID + TRANS_AMOUNT).upcase
  end

  def authentic_transaction
    authentic_transaction = base_transaction.clone()
    authentic_transaction['x_trans_id'] = TRANS_ID
    authentic_transaction['x_MD5_Hash'] = valid_hash_for_transaction
    return authentic_transaction
  end

  def forged_transaction
    forged_transaction = base_transaction.clone()
    forged_transaction['x_trans_id'] = TRANS_ID
    forged_transaction['x_MD5_Hash'] = 'fail!'
    return forged_transaction
  end

  def authentic_subscription
    authentic_subscription = base_transaction.clone()
    authentic_subscription['x_trans_id'] = TRANS_ID
    authentic_subscription['x_subscription_id'] = SUBSCRIPTION_ID
    authentic_subscription['x_MD5_Hash'] = valid_hash_for_subscription
    return authentic_subscription
  end

  def base_transaction
    return {
      "x_response_code"         => "1",
      "x_response_reason_code"  => "1",
      "x_response_reason_text"  => "This transaction has been approved.",
      "x_avs_code"              => "P",
      "x_auth_code"             => "xxxx",
      "x_trans_id"              => "",
      "x_method"                => "CC",
      "x_card_type"             => "MasterCard",
      "x_account_number"        => "XXXX1234",
      "x_first_name"            => "",
      "x_last_name"             => "",
      "x_company"               => "",
      "x_address"               => "",
      "x_city"                  => "",
      "x_state"                 => "",
      "x_zip"                   => "",
      "x_country"               => "",
      "x_phone"                 => "",
      "x_fax"                   => "",
      "x_email"                 => "",
      "x_invoice_num"           => "1-234567890",
      "x_description"           => "This is a transaction",
      "x_type"                  => "prior_auth_capture",
      "x_cust_id"               => "",
      "x_ship_to_first_name"    => "",
      "x_ship_to_last_name"     => "",
      "x_ship_to_company"       => "",
      "x_ship_to_address"       => "",
      "x_ship_to_city"          => "",
      "x_ship_to_state"         => "",
      "x_ship_to_zip"           => "",
      "x_ship_to_country"       => "",
      "x_amount"                => TRANS_AMOUNT,
      "x_tax"                   => "0.00",
      "x_duty"                  => "0.00",
      "x_freight"               => "0.00",
      "x_tax_exempt"            => "FALSE",
      "x_po_num"                => "",
      "x_MD5_Hash"              => "",
      "x_cvv2_resp_code"        => "",
      "x_cavv_response"         => "",
      "x_test_request"          => "false"
    }
  end

end

