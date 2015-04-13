# usage:
# ruby pub.rb channel username

require 'rubygems'
require 'redis'
require 'json'
require 'byebug'
require 'awesome_print'

@redis = Redis.new(host: 'redis')

def set_devices
  # "B016005991000520" => value
  commands = []
  device = {}
  device_id = "B016005991000520"
  device.update(device_id => { device_name: "HYBRID",
                                components: [
                                  {
                                    component_id: "2",
                                    component_type: "SeatLight#{rand(1..5)}",
                                    data_descriptors: [
                                      {
                                        data_descriptor_id: "4201",
                                        name: "Reading Light",
                                        comments: nil,
                                        data: "#{rand(0..1)}",
                                        date: nil
                                      },
                                      {
                                        data_descriptor_id: "4202",
                                        name: "Call Light",
                                        comments: nil,
                                        data: "#{rand(0..1)}",
                                        date: nil
                                      }
                                    ],
                                    configuration_descriptors: [
                                      {
                                        configuration_descriptor_id: "3177",
                                        name: "Reading Light",
                                        comments: nil
                                      },
                                      {
                                        configuration_descriptor_id: "3178",
                                        name: "Call Light",
                                        comments: nil
                                      }
                                    ]
                                  },
                                  {
                                    component_id: "3",
                                    component_type: "Motor",
                                    data_descriptors: [
                                      {
                                        data_descriptor_id: "5587",
                                        name: "Fault Status",
                                        comments: "0 = Cleared, 1 = Active",
                                        data: "#{rand(0..1)}",
                                        date: nil
                                      }
                                    ],
                                    configuration_descriptors: [ ]
                                  }
                                ]
                              })

  # Redis.new.publish channel/key, value
  # Publish Device Message (contains all Component Messages)
  messages = {}
  messages[device_id] = device[device_id].to_json

  device[device_id][:components].each do |component|
    # Remove configuration descriptors
    component = component.reject{|k,v| k == :configuration_descriptors}
    # Publish Component Message (subset of Device Message)
    messages["#{device_id}.c#{component[:component_id]}"] = component.to_json
  end

  @redis.pipelined do
    messages.each do |key, value|
      @redis.publish key, value
      puts "Sent Message: #{key} | #{value}"
    end
  end
end

loop do
  set_devices
  sleep 2
end
