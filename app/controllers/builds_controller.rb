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
        repo_name = body['repository']['full_name']
        pull_request_id = body['number']
        repository = Repository.where(repo_id: repo_id).first
        sha = body['pull_request']['head']['sha']
        time = Time.now
        build = repository.builds.create!(:time_start => time, :state => "requested")
        client = Octokit::Client.new(:access_token => GitHub['server']['user_token'], :api_endpoint => "#{GitHub['server']['url']}/api/v3")
        assignee = body['pull_request']['assignee']

        if assignee.nil?
          client.create_status(repo_id, sha,
              'failure', {:context => "Process Checker",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "This PR needs to be assigned before it is merged!"}
          )
        else
          client.create_status(repo_id, sha,
              'success', {:context => "Process Checker",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "This PR has been properly assigned."}
          )
        end

        # Start SquirrelCI demo
        client.create_status(repo_id, sha,
            'pending', {:context => "SquirrelCI Build",
            :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
            :description => "Evaluation in progress..."}
        )
        #commits = client.pull_request_commits(repo_name, pull_request_id.to_i)
        comments = client.issue_comments(repo_name, pull_request_id.to_i)
        #puts "COMMENTS :: #{comments.inspect}"
        puts "COMMENTS :: #{comments.size}"
        # puts "COMMIT COUNT ==> #{body['pull_request']['commits'].to_i}"
        if (body['pull_request']['commits'].to_i == 3) && (comments.size == 1)
          sleep(5.seconds)
          build.update_attributes(:elapsed_time => time + 5.minutes, :state => "completed", :status => 'success')
          client.create_status(repo_id, sha,
              'success', {:context => "SquirrelCI Build",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "Great coding! Keep up the good work."})
          sleep(5.seconds)
          client_vader = Octokit::Client.new :login => 'darthvader', :password => 'P@ssw0rd', :api_endpoint => "#{GitHub['server']['url']}/api/v3"
          user = client_vader.user
          user.login
          client_vader.add_comment(repo_name, pull_request_id.to_i, "build is **passing** let's :shipit: to QA. \n\n @republic/developers anyone have an issue with merging this?", options = {})
          user.logout
        elsif (body['pull_request']['commits'].to_i == 2) && (comments.size == 1)
          commits = client.pull_request_commits(repo_name, pull_request_id.to_i)
          client_obiwan = Octokit::Client.new :login => 'obiwan', :password => 'P@ssw0rd', :api_endpoint => "#{GitHub['server']['url']}/api/v3"
          user = client_obiwan.user
          user.login
          client_obiwan.create_pull_request_comment(repo_name, pull_request_id.to_i, "I think we need some **documentation** here :frowning:", commits[0]['sha'], "src/main/java/com/github/Calculator.java", 5, options = {})
          user.logout
          build.update_attributes(:elapsed_time => time + 3.minutes, :state => "completed", :status => 'failure')
          client.create_status(repo_id, sha,
              'failure', {:context => "SquirrelCI Build",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "Build failed! Do you need some help?"})
        elsif (body['pull_request']['commits'].to_i == 1) && (comments.size == 0 || comments.size == 1)
          if comments.size == 0
            sleep(5.seconds)
            client_yoda = Octokit::Client.new :login => 'yoda', :password => 'P@ssw0rd', :api_endpoint => "#{GitHub['server']['url']}/api/v3"
            user = client_yoda.user
            user.login
            client_yoda.add_comment(repo_name, pull_request_id.to_i, ":-1: test first you should, young padawan!", options = {})
            user.logout
          end
          build.update_attributes(:elapsed_time => time + 3.minutes, :state => "completed", :status => 'failure')
          client.create_status(repo_id, sha,
              'failure', {:context => "SquirrelCI Build",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "Build failed! Do you need some help?"})
        else
          client.create_status(repo_id, sha,
              'success', {:context => "SquirrelCI Build",
              :target_url => "http://192.168.115.1:3000/builds/#{build._id}",
              :description => "Great coding! Keep up the good work."})
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
