#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'digest/md5'
require 'twitter'

require 'net/https'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

FILENAME = File.expand_path("~/.socawatcher_last")

doc = Hpricot(open("https://www.socaspot.org/"))

alertContent = doc.at("//div[@class='alert_content']/div/span/strong/text()")

oldMD5 = nil
if (File.exists?(FILENAME))
	oldFile = File.open(FILENAME,"r")
	oldMD5 = oldFile.gets
#	print "Old MD5 = " + oldMD5
	oldFile.close
end

newMD5 = Digest::MD5.hexdigest(alertContent.to_s) + "\n"

print "New MD5 = " + newMD5

if (oldMD5 != newMD5)
#	print "New alert Content = " + alertContent.to_s + "\n"
	newFile = File.new(FILENAME,File::CREAT|File::TRUNC|File::RDWR, 0644)
	newFile.puts(newMD5)
	newFile.close

	httpauth = Twitter::HTTPAuth.new('SOCAWatcher', '')
	base = Twitter::Base.new(httpauth)
	base.update("www.socaspot.org - " + alertContent.to_s)
end
