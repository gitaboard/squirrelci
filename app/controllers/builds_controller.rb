class BuildsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  respond_to :json, :html

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
        sha = body['pull_request']['head']['sha']
        time = Time.now
        build = repository.builds.create!(:time_start => time, :state => "requested")
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
        puts "COMMIT COUNT ==> #{body['pull_request']['commits'].to_i}"
        if body['pull_request']['commits'].to_i.even?
          puts "FOUND EVEN"
          build.update_attributes(:elapsed_time => time + 5.minutes, :state => "completed", :status => 'success')
          client.create_status(repo_id, sha,
              'success', {:context => "SquirrelCI Build",
              :target_url => "http://#{request.remote_ip}:3000/builds/#{build._id}",
              :description => "Great coding! Keep up the good work."})
        else
          puts "FOUND ODD"
          build.update_attributes(:elapsed_time => time + 3.minutes, :state => "completed", :status => 'failure')
          client.create_status(repo_id, sha,
              'failure', {:context => "SquirrelCI Build",
              :target_url => "http://#{request.remote_ip}:3000/builds/#{build._id}",
              :description => "Build failed! Do you need some help?"})
        end
        #puts body.inspect
      end
    end
    response_body = response.body
    render json: body
  end

  def index
    @current_builds = Build.recent
    @old_builds = Build.where(state: 'completed').limit(10)
    respond_with(@current_builds, @old_builds)
  end

end
