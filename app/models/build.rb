class Build
  include Mongoid::Document

  field :time_start,         type: Time, default: ""
  field :elapsed_time,       type: Time, default: ""
  field :status,             type: String, default: ""

end
