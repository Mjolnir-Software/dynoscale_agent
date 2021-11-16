require 'uri'
require 'net/http'
require 'net/https'

module DynoscaleAgent
  class ApiWrapper
    def initialize(dyno, url, app_name)
      @dyno     = dyno
      @url      = URI(url)
      @app_name = app_name
    end

    def publish_reports(reports, current_time = Time.now, http = Net::HTTP.new(@url.host, @url.port), &block)
      headers = { "Content-Type": "text/csv",
                  "X_REQUEST_START": "t=#{current_time.to_i}",
                  "X_DYNO": @dyno,
                  "X_APP_NAME": @app_name
                }

      body = reports.reduce(""){|t, r| "#{t}#{r.to_csv}"}

      begin
        response = request(http, headers, body)
      rescue Timeout::Error, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
        # ignore and let the retry mechanism handle it
      end

      success = response&.code == "200" || false
      published_reports = success ? reports : []

      block.call(success, published_reports)
    end

    private

    def request(http, headers, body)
      http.use_ssl = true if @url.scheme == "https"
      request = Net::HTTP::Post.new(@url, headers)

      request.body = body
      http.request(request)
    end
  end
end
