class Hooks::TeamcityController < ApplicationController
  layout "hooks"

  def execute
    response_body = ""
    body_as_string = request.body.read
    hook_event = request.headers['X-Github-Event']
    puts hook_event
    puts '==================  BODY  ======================='
    body = JSON.parse(body_as_string)
    if 'pull_request'.eql? hook_event
      branch = body['pull_request']['head']['ref']
      if ["feature", "hotfix", "bug"].include? branch.split("/").first
        uri = URI.parse("http://teamcity.socialcoder.io:8111/httpAuth/action.html")
        params = {:add2Queue => 'SampleCalculator_Build', :branchName => branch}
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri)
        request.basic_auth 'yoda', 'P@ssw0rd'
        response = Net::HTTP.start(uri.host, uri.port) {|http|
          http.request(request)
        }
        response_body = response.body
      end
    elsif 'commit'.eql? hook_event
      ref = body['ref']
      branch = ref.split("/", 3).last
      if ["feature", "hotfix", "bug"].include? branch.split("/").first
        uri = URI.parse("http://teamcity.socialcoder.io:8111/httpAuth/action.html")
        params = {:add2Queue => 'SampleCalculator_Build', :branchName => branch}
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri)
        request.basic_auth 'yoda', 'P@ssw0rd'
        response = Net::HTTP.start(uri.host, uri.port) {|http|
          http.request(request)
        }
        response_body = response.body
      end
    end
    render json: response_body
  end

end
