require 'open-uri'
instance_type(open('http://169.254.169.254/latest/meta-data/instance-type').gets)