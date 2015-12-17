#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

SCHEDULER.every '5s', :first_in => 0 do
    begin
        uri = URI.parse('http://zenoss-server.ch:8080/zport/dmd/evconsole_router')
        header = {}
        data = {
            action:'EventsRouter',
            method:'query',
            tid: 1,
            data: [{
                limit:20,
                sort: 'severity',
                params:{
                    eventState:[0],
                    severity:[4,5],
                    prodState:[1000]
                }
            }]
        }

        # Create the HTTP objects
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})

        #authentication
        path = File.join(File.dirname(__FILE__), '../../monitoring.pw')
        password = IO.read(path).delete!("\n")
        request.basic_auth 'screen', password

        request.body = data.to_json
        # Send the request
        response = http.request(request)
        parsed = JSON.parse(response.body)
        events = []
        newids = ""
        new_event = false
        ids = IO.read('ids.txt')
        parsed["result"]["events"].each do |event|
            newids.concat event['id']
            hash = { :summary => event["summary"], :resource => event["device"]["text"], :severity => "severity#{event['severity']}" }
            events.push(hash)
            if !ids.include? event['id']
                new_event = true
            end
        end
        if new_event
            `aplay assets/notification.wav`
        end
        if newids != ids
            IO.write('ids.txt', newids)
            send_event('zenoss', { events: events })
        end
    rescue
        `zenity --error --timeout=5 --title="test" --no-wrap --text="<span font='32'>Zenoss not available!!</span>"`
    end
end
