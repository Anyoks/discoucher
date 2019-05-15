class Mpesa

  require 'net/http'
  require 'net/https'
  require 'uri'
  

  TIMESTAMP = '20180814085620'#Time.now.strftime '%Y%m%d%H%M%S'
  SHORTCODE = '174379'
  PASSKEY = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919'
  PHONENUMBER = '254711430817'
  CONSUMER_KEY = 'AoX12SIQkaAARWcG85UxvWItMlDbwXk0'
  CONSUMER_SECRET = 'j9kiZOmTuhwpV5v6'
  PASSWORD = "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTgwODE0MDg1NjIw"

  LIVE_CONSUMER_KEY = 'ehw3jJApujSrP2z9ftq8PnJ0pRdUCZ0K' #used for production
  LIVE_CONSUMER_SECRET = 'IuUb50aCHIs0GkFL' #used for production
  LIVE_PASSWORD = "ODg1NTgyNGQxNGMxNDYxNWVmZDk2MWRhMjIwYmM5ZDI3NjhkZjMxYmI5YmUwODQzMjRlY2EzMzc1NmQ1ZWY5MTg2NDgwZDIwMTgwODE0MDg1NjIw"
  LIVE_PASSWORD2 = "NTM5MzA0NGQxNGMxNDYxNWVmZDk2MWRhMjIwYmM5ZDI3NjhkZjMxYmI5YmUwODQzMjRlY2EzMzc1NmQ1ZWY5MTg2NDgwZDIwMTgwODE0MDg1NjIw"
  LIVE_TIMESTAMP = '20180814085620'
  LIVE_TILL_NUMBER = '885582'
  LIVE_SHORTCODE = '539304'
  LIVE_PASSKEY = '4d14c14615efd961da220bc9d2768df31bb9be084324eca33756d5ef9186480d'
  # The password for encrypting the request. This is generated by base64 encoding BusinessShortcode,
  #  Passkey and Timestamp.
  #  
  def initialize(phone_number, amount, description )
    @phone_number = phone_number
    @amount       = amount
    @description  = description
  end

  def phone_number
    @phone_number
  end

  def amount
    @amount
  end

  def description
    @description 
  end

  def phone_number=(newPhone_number)
    @phone_number = newPhone_number
  end

  def amount=(newAmount)
    @amount = newAmount
  end

  def description=(newDesc)
    @description = newDesc
  end
  
  def self.get_token
    uri2 = URI('https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials')
     response = ""
     # token = ''
     

    Net::HTTP.start(uri2.host, uri2.port,
      :use_ssl => uri2.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri2.request_uri
      request.basic_auth "#{CONSUMER_KEY}", "#{CONSUMER_SECRET}"

      response = http.request request # Net::HTTPResponse object

      # puts response
      puts response.body#.class #[:access_token]  



      # t = response.body.split
      # token = t[2]
      # puts "this is it #{token}"
      # return response
       # = response.body
      # token = response.body[:access_token]  
    end

     # token = response[:access_token]   
     
     # puts t
     s = response.body
     parsed_json = JSON.parse(s)
     token = parsed_json["access_token"]
     puts "This is the access_token === #{token}"
     return token
    
  end

  def self.get_live_token
    uri2 = URI('https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials')
     response = ""
     # token = ''
     

    Net::HTTP.start(uri2.host, uri2.port,
      :use_ssl => uri2.scheme == 'https',
      :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

      request = Net::HTTP::Get.new uri2.request_uri
      request.basic_auth "#{LIVE_CONSUMER_KEY}", "#{LIVE_CONSUMER_SECRET}"

      response = http.request request # Net::HTTPResponse object

      # puts response
      puts response.body#.class #[:access_token]  
    end

     # token = response[:access_token]   
     
     # puts t
     s = response.body
     parsed_json = JSON.parse(s)
     token = parsed_json["access_token"]
     puts "This is the access_token === #{token}"
     return token
    
  end

  def request_mpesa_api
    phone_number = self.phone_number
    amount       = self.amount
    description  =  self.description

    token  = Mpesa.get_token
    uri = URI('https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest')
    encode_ready_string = SHORTCODE + PASSKEY + TIMESTAMP
    password =  Base64.encode64(encode_ready_string)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # puts "********* #{token} ***********"

    request = Net::HTTP::Post.new(uri)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["authorization"] = "Bearer #{token}" #'Bearer <KtZ9TVCVQRFwgyc243nbqk00rrFg>'
    request.body = "{\"BusinessShortCode\": \"#{SHORTCODE}\",
      \"Password\": \"#{PASSWORD}\",
      \"Timestamp\": \"#{TIMESTAMP}\",
      \"TransactionType\": \"CustomerBuyGoodsOnline\",
      \"Amount\": \"#{amount}\",
      \"PartyA\": \"#{phone_number}\",
      \"PartyB\": \"#{SHORTCODE}\",
      \"PhoneNumber\": \"#{phone_number}\",
      \"CallBackURL\": \"http://159.89.103.53/api/v1/pay/from_mpesa\",
      \"AccountReference\": \"kk\",
      \"TransactionDesc\": \"oo\"}"

    
      response = http.request(request)
      # puts request.body
      return response    
  end

  def request_live_mpesa_api
    phone_number = self.phone_number
    amount       = self.amount
    description  =  self.description

    token  = Mpesa.get_live_token
    uri = URI('https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest')
    encode_ready_string = LIVE_SHORTCODE + LIVE_PASSKEY + TIMESTAMP
    password =  Base64.encode64(encode_ready_string)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # puts "********* #{token} ***********"

    request = Net::HTTP::Post.new(uri)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["authorization"] = "Bearer #{token}" #'Bearer <KtZ9TVCVQRFwgyc243nbqk00rrFg>'
    request.body = "{\"BusinessShortCode\": \"#{LIVE_SHORTCODE}\",
      \"Password\": \"#{LIVE_PASSWORD2}\",
      \"Timestamp\": \"#{TIMESTAMP}\",
      \"TransactionType\": \"CustomerBuyGoodsOnline\",
      \"Amount\": \"#{amount}\",
      \"PartyA\": \"#{phone_number}\",
      \"PartyB\": \"#{LIVE_TILL_NUMBER}\",
      \"PhoneNumber\": \"#{phone_number}\",
      \"CallBackURL\": \"https://api.discoucher.com/api/v1/pay/from_mpesa\",
      \"AccountReference\": \"Discoucher\",
      \"TransactionDesc\": \"ipay\"}"

      puts request.body
      response = http.request(request)
      
      return response    
  end
end