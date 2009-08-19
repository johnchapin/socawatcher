#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'twitter'
require 'net/https'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

doc = Hpricot(open("https://www.socaspot.org/"))
alertContent = doc.at("//div[@class='alert_content']/span/strong/text()").to_s.strip

httpauth = Twitter::HTTPAuth.new("SOCAWatcher", "")
client = Twitter::Base.new(httpauth)

currentStatus = client.user_timeline[0].text.sub("...","").strip

if (currentStatus != alertContent[0..currentStatus.length])
   client.update(alertContent)
end

