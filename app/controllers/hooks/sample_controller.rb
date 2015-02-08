class Hooks::SampleController < ApplicationController
  layout "hooks"

  def execute
    puts request.body.read
    render json: "{'name': 'lee faus'}"
  end

end
