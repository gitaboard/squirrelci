class Repository
  include Mongoid::Document
  has_many :builds
  
  field :repo_id,            type: String, default: ""
  field :full_name,          type: String, default: ""
  field :owner,              type: String, default: ""

end
