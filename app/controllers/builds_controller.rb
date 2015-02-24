class BuildsController < ApplicationController

  respond_to :json

  def create
    body_as_string = request.body.read
    hook_event = request.headers['X-Github-Event']
    puts hook_event
    puts '==================  BODY  ======================='
    body = JSON.parse(body_as_string)
    if 'pull_request'.eql? hook_event
      branch = body['pull_request']['head']['ref']
      if ["feature", "hotfix", "bug"].include? branch.split("/").first
        repo_id = body['repository']['id']
        repository = Repository.where(repo_id: repo_id).first
        build = repository.builds.create!(:time_start => Time.now, :elapsed_time => 5.minutes.from_now, :status => 'success')
        sha = body['pull_request']['head']['sha']
        client = Octokit::Client.new(:access_token => GitHub['server']['user_token'], :api_endpoint => "#{GitHub['server']['url']}/api/v3")
        client.create_status(repo_id, sha,
            'pending', {:context => "SquirrelCI Build",
            :target_url => "http://#{request.remote_ip}:3000/builds/#{build._id}",
            :description => "Checking our nuts!"}
        )
        assignee = body['pull_request']['assignee']
        if assignee.nil?
          client.create_status(repo_id, sha,
              'failure', {:context => "Process Checker",
              :target_url => "http://#{request.remote_ip}:3000/builds/#{build._id}",
              :description => "This PR needs to be assigned before it is merged!"}
          )
        end
        sleep(15.seconds)
        client.create_status(repo_id, sha,
            'success', {:context => "SquirrelCI Build",
            :target_url => "http://#{request.remote_ip}:3000/builds/#{build._id}",
            :description => "Great coding! Keep up the good work."}
        )
        #puts body.inspect
      end
    end
    response_body = response.body
    render json: body
  end

end
