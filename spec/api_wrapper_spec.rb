require 'dynoscale_ruby/api_wrapper'
require 'dynoscale_ruby/measurement'
require 'dynoscale_ruby/report'

RSpec.describe DynoscaleRuby::ApiWrapper do

  context "#publish_reports" do
    let(:wrapper) { DynoscaleRuby::ApiWrapper.new("dyno.1", "https://www.example.com", "Test App") }
    let(:report) { DynoscaleRuby::Report.new(1636595665) }
    let(:reports) { [report] }
    context "when request is successful" do
      let(:http) do
        request = double("request", code: 200, body: '{ "config": { "publish_frequency": 30 } }')
        double("Net::HTTP", request: request, "use_ssl=": true)
      end
      it "should yield with published reports and success request state" do
  	expect { |b| wrapper.publish_reports(reports, Time.now, http,&b) }.to yield_with_args(true, reports, { "publish_frequency" => 30 })
      end
    end

    context "when request fails" do
      let(:http) do
        request = double("request", code: error_code, body: '{ "config": { "publish_frequency": 30 } }')
        double("Net::HTTP", request: request, "use_ssl=": true)
      end
      context "due to a timeout" do
        let(:error_code) { 504 }
        it "should yield with empty published reports and failed request state" do
          expect { |b| wrapper.publish_reports(reports, Time.now, http, &b) }.to yield_with_args(false, [], { "publish_frequency" => 30 })
        end
      end
      context "due to a connection reset" do
        let(:error_code) { 503 }
        it "should yield with empty published reports and failed request state" do
          expect { |b| wrapper.publish_reports(reports, Time.now, http, &b) }.to yield_with_args(false, [], { "publish_frequency" => 30 })
        end
      end
      context "due to a bad request" do
        let(:error_code) { 400 }
        it "should yield with empty published reports and failed request state" do
          expect { |b| wrapper.publish_reports(reports, Time.now, http, &b) }.to yield_with_args(false, [], { "publish_frequency" => 30 })
        end
      end
    end
  end
end
