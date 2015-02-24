GitHub = YAML.load_file("#{Rails.root.to_s}/config/github.yml")

puts GitHub.inspect
