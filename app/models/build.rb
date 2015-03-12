class Build
  include Mongoid::Document
  belongs_to :repository

  field :time_start,         type: Time, default: ""
  field :elapsed_time,       type: Time, default: ""
  field :state,              type: String, default: "requested"
  field :status,             type: String, default: "" #requested, queued, completed

  scope :recent, ->{order_by(:time_start => :desc).limit(5)}
end
