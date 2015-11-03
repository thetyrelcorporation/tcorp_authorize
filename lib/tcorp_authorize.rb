require "tcorp_authorize/version"

module TcorpAuthorize

	class Client
		def initialize( auth_attrs )
			@gateway = auth_attrs[:gateway]
			@api_login = auth_attrs[:api_login]
			@api_key = auth_attrs[:api_key]
		end

		def send_request( action, params )
			rquest = Rquest.new({
				verb: :post,
				uri: uri,
				payload: payload_for(action, params),
				form_type: :json 
			})
			# rquest.send.to_json
			response = TcorpAuthorize::strip_byte_order_mark(rquest.send )
			JSON::parse( response )
		end

		private

		def uri
			@gateway == :sandbox ? "https://apitest.authorize.net/xml/v1/request.api" : "https://api.authorize.net/xml/v1/request.api"
		end

		def payload_for( action, params )
				{
					action => {
						"merchantAuthentication" => {
							"name" => @api_login,
							"transactionKey" => @api_key
						},
						TcorpAuthorize::action_to_key(action) => params
					}
				}
		end

	end

	class << self
		def action_to_key( action )
			{
				"createTransactionRequest" => "transactionRequest",
				"ARBCreateSubscriptionRequest" => "subscription"
			}[action]
		end

		def strip_byte_order_mark(string)
			string.sub("\xEF\xBB\xBF".force_encoding('ASCII-8BIT'), "")
		end
	end
	
end
