class Hooks::SampleController < ApplicationController
  layout "hooks"

  def execute
    body_as_string = request.body.read
    hook_event = request.headers['X-Github-Event']
    puts hook_event
    puts '==================  BODY  ======================='
    body = JSON.parse(body_as_string)
    puts body.inspect
    render json: body
  end

end
