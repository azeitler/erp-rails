module InboundWebhooks
  class ApplicationController < ActionController::API
    private

    # Returns the payload for the webhook as a String
    #
    # Some services use multipart/form-data to encapsulate their JSON payload
    # For multipart/form-data we will let Rails parse and then dump the params as JSON
    def payload
      @payload ||= request.form_data? ? request.request_parameters.to_json : request.raw_post
    end

    def filtered_headers
      # Retrieve and normalize headers
      headers_to_store = {}
      request.headers.each do |key, value|
        if key.start_with?('HTTP_')
          normalized_key = key.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')
          headers_to_store[normalized_key] = value
        end
      end

      # Mask sensitive headers
      headers_to_store['Authorization'] = headers_to_store['Authorization']&.gsub(/.(?=.{4})/, '*')
      headers_to_store
    end
  end
end
