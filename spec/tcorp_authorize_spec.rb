require 'spec_helper'

auth_attrs = {
	gateway: :sandbox,
	api_login: ENV['AUTHORIZE_SANDBOX_LOGIN'],
	api_key: ENV['AUTHORIZE_SANDBOX_KEY']
}

test_cc_attrs = {
	cc_number: '4242424242424242',
	cc_exp: '0220',
	cc_csv: '123'
}

describe TcorpAuthorize do
	it 'Should have action to key that conerts a supplied action into a proper json key for authorize requests' do
		result = TcorpAuthorize::action_to_key( "createTransactionRequest"  )
		expect(result).to eq "transactionRequest"
	end
	
  it 'has a version number' do
    expect(TcorpAuthorize::VERSION).not_to be nil
  end

	it 'Should have rquest loaded into memory' do
		expect(defined? Rquest).not_to be nil
	end

	it 'Should load TcorpAuthorize into memory' do
		expect(defined? TcorpAuthorize).not_to be nil
	end

	it 'Should load auth variables from env' do
		expect(auth_attrs[:api_login]).not_to be nil
		expect(auth_attrs[:api_key]).not_to be nil
	end

	it 'Should have a client initializer' do
		expect(defined? TcorpAuthorize::Client).not_to be nil
		expect(TcorpAuthorize::Client).to respond_to(:new)
		client = TcorpAuthorize::Client.new( auth_attrs )
		expect(client.class).to be TcorpAuthorize::Client
	end

	# It is up to the caller to check for errors and handle acordingly
	it 'Should handle errors by passing the Authorize error hash to caller' do
		client = TcorpAuthorize::Client.new( auth_attrs )
		req_type = "createTransactionRequest"
		req_attrs = { 
			"transactionType" => "authCaptureTransaction",
			"payment" => { 
				"creditCard": { 
					"cardNumber": test_cc_attrs[:cc_number],
					"expirationDate": test_cc_attrs[:cc_exp],
					"cardCode": test_cc_attrs[:cc_csv]
				}  
			}
		}
		expect(client).to respond_to(:send_request)
		response = client.send_request(req_type, req_attrs)
		expect(response.class).to be Hash
		expect(response["messages"]["resultCode"]).to eq( "Error" )
	end

	it 'Should post an AIM payment successfully' do
		client = TcorpAuthorize::Client.new( auth_attrs )
		req_type = "createTransactionRequest"
		req_attrs = { 
			"transactionType" => "authCaptureTransaction",
			"amount" => "#{rand(100) + 1}",
			"payment" => { 
				"creditCard": { 
					"cardNumber": test_cc_attrs[:cc_number],
					"expirationDate": test_cc_attrs[:cc_exp],
					"cardCode": test_cc_attrs[:cc_csv]
				}  
			},
			"tax" => {
				"amount": "5.00",
				"name": "level2 tax name",
				"description": "level2 tax"  
			},
			"shipping" => { 
				"amount" => "15.00"
			},
			"poNumber" => "456654",
			"customer" => {
				"id" => "1234",
				"email" => "testing@gmail.com"
			},
			"billTo" => {
				"firstName" => "Tbone",
				"lastName" => "Johnson",
				"company" => "Souveniropolis",
				"address" => "14 Main Street",
				"city" => "Pecan Springs",
				"state" => "TX",
				"zip" => "44628",
				"country" => "USA",
				"phoneNumber" => "555-555-5555"
			},
			"shipTo" => {
				"firstName" => "China",
				"lastName" => "Bayles",
				"company" => "Thyme for Tea",
				"address" => "12 Main Street",
				"city" => "Pecan Springs",
				"state" => "TX",
				"zip" => "44628",
				"country" => "USA"
			},
			"customerIP" => "192.168.1.1",
		}
		expect(client).to respond_to(:send_request)
		response = client.send_request(req_type, req_attrs)
		expect(response.class).to be Hash
		expect(response["messages"]["resultCode"]).to eq( "Ok" )
	end
	
	it 'Should post Authorize Card' do
		client = TcorpAuthorize::Client.new( auth_attrs )
		req_type = "createTransactionRequest"
		req_attrs = { 
			"transactionType" => "authOnlyTransaction",
			"amount" => "#{rand(100) + 1}",
			"payment" => { 
				"creditCard": { 
					"cardNumber": test_cc_attrs[:cc_number],
					"expirationDate": test_cc_attrs[:cc_exp],
					"cardCode": test_cc_attrs[:cc_csv]
				}  
			},
		}
		expect(client).to respond_to(:send_request)
		response = client.send_request(req_type, req_attrs)
		expect(response.class).to be Hash
		expect(response["messages"]["resultCode"]).to eq( "Ok" )
	end
	
	it 'Should capture a previously authorized credit card' do
		client = TcorpAuthorize::Client.new( auth_attrs )
		req_type = "createTransactionRequest"
		req_attrs = { 
			"transactionType" => "authCaptureTransaction",
			"amount" => "#{rand(100) + 1}",
			"payment" => { 
				"creditCard": { 
					"cardNumber": test_cc_attrs[:cc_number],
					"expirationDate": test_cc_attrs[:cc_exp],
					"cardCode": test_cc_attrs[:cc_csv]
				}  
			},
		}
		expect(client).to respond_to(:send_request)
		response = client.send_request(req_type, req_attrs)
		expect(response.class).to be Hash
		expect(response["messages"]["resultCode"]).to eq( "Ok" )
	end

	it 'Should post recuring payments' do
		client = TcorpAuthorize::Client.new( auth_attrs )
		req_type = "ARBCreateSubscriptionRequest"
		req_attrs = {
				"name": "Some Subscription",
				"paymentSchedule": {
						"interval": {
								"length": "1",
								"unit": "months"
						},
						"startDate": "2020-08-30",
						"totalOccurrences": "12",
						"trialOccurrences": "1"
				},
				"amount": "#{rand(100) + 1}",
				"trialAmount": "0.00",
				"payment": {
						"creditCard": {
								"cardNumber": "4111111111111111",
								"expirationDate": "2020-12"
						}
				},
				"billTo": {
						"firstName": "Testing",
						"lastName": (0..7).to_a.map{|e| ('A'..'Z').to_a.sample}.join('')
				}
		}
		expect(client).to respond_to(:send_request)
		response = client.send_request(req_type, req_attrs)
		expect(response.class).to be Hash
		expect(response["messages"]["resultCode"]).to eq( "Ok" )
	end
end
