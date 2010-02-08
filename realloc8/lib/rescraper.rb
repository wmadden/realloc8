#!/usr/bin/ruby


require 'rubygems'
require 'mechanize'
#require 'codes'

#def get_subjects(query)
#  agent = WWW::Mechanize.new
#  page = agent.get "https://sis.unimelb.edu.au/cgi-bin/subjects.pl"
#  search_form = page.forms.last

#  search_form.field_with(:name => "scodes").value = query
#  search_results = agent.submit(search_form)
#  return search_results.body
#end

def authenticate_unimelb_by_pin(login,pin)
  agent = WWW::Mechanize.new
  page = agent.get "https://sis.unimelb.edu.au/cgi-bin/subject-change.pl"
  search_form = page.forms.last

  search_form.field_with(:name => "id_number").value = login
  search_form.field_with(:name => "pin_number").value = pin
  search_results = agent.submit(search_form)
  return search_results.body
end


#((@subject_codes.length / 100)+1).times do |x|
#  y = x * 100
#  puts y
#  File.open("damnyou_#{x}.html","w") do |f|
#    f.write get_subjects( @subject_codes[y..(y+100)].join("\n"))
#  end
#end


def mighty_subjects_hash
  crazy_regex = /<td><\/td><td>(\d\d\d\d\d\d)<\/td><td>([A-Z]*)(\d\d)\/(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><td>(.*?)<\/td><\/tr>/
  subject_name_regex = /Subject: ([\d]*) (.*?)<\/b><\/p>/

  subjects = Hash.new # { |hash, key| hash[key] = Hash.new() }
  subject_titles = {}

  for file in Dir["lib/scraped_info/*"]
    data = IO.read(file)
       
    subject_titles_scan = data.scan(subject_name_regex)
    
    for item in subject_titles_scan
      subject_titles[item.first] = item.last
    end

    data = data.scan(crazy_regex)
    
    for entry in data
      subject = entry[0]
      event = entry[1]
      event_number = entry[2]
      stream = entry[3]
      time = "#{entry[4]} #{entry[5]}"
      #puts "subject = '#{subject}', event = '#{event}', stream = '#{stream}', time = '#{time}'"
      subjects[ subject ] ||= {}
      subjects[ subject ][ event ] ||= {}
      subjects[ subject ][ event ][ stream ] ||= []
      subjects[ subject ][ event ][ stream ] << time
    end
  end
  
  return subjects , subject_titles
  
end



