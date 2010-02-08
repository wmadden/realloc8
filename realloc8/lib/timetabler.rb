#!/usr/bin/env ruby

require "Timetabler/TimetableProblem"

include Timetabler

# 
# Search for a valid timetable given subject times.
# Subjects must be an hash in the form:
#   
#   {
#     subject_name => {
#       event_name => [
#         streams
#       ]
#     }
#   }
# 
# E.g.,
# 
#   {
#     "Computer Design" => {
#       "Lecture" => [
#         # Stream 1
#         [ [:Monday, 9], [:Wednesday, 9], [:Friday, 9] ],
#         # Stream 2
#         [ [:Monday, 11], [:Wednesday, 11], [:Friday, 11] ],
#         # Stream 2
#         [ [:Monday, 13], [:Wednesday, 13], [:Friday, 13] ]
#       ]
#     }
#   }
#  
#  Upon success, the function will return a timetable as a hash, in the form
#  
#    {
#      [ subject_name, event_name ] => stream
#    }
#   
def search( subjects )
  
  # Initialize a timetable problem and attempt to solve it.
  variables = Hash.new { |hash, key| hash[key] = [] }
  
  subjects.each_pair do | subject, events |
    events.each_pair do | event, streams |
    #  for stream in streams
    #    for time in stream
    #      variables[ time ] = [subject, event]
    #    end
    #  end
      
      variables[ [subject, event] ] = streams.values
    end
  end
  
  problem = TimetableProblem.new( variables )
  problem.solve! # I love this line
end

# Load subject data
f = File.open( "subjects" )
lines = f.readlines

subjects = Hash.new { |hash, key| hash[key] = Hash.new() }

for line in lines do
  re = /\s*([\d]+)\s*([A-Z])(\d+)\/(\d+)\s+([a-zA-Z]+\s+\d+:[\dapm]+ - [\d]+:[\dapm]+)/
  if re === line
    subject = $1
    event = $2
    event_number = $3
    stream = $4
    time = $5
    #puts "subject = '#{subject}', event = '#{event}', stream = '#{stream}', time = '#{time}'"
    subjects[ subject ][ event ] ||= {}
    subjects[ subject ][ event ][ stream ] ||= []
    subjects[ subject ][ event ][ stream ] << time
  end
end

# Test
timetable = search(subjects)

if timetable.nil?
  puts "No solution."
else
  # Pretty print timetable
  ordered_hash = {}
  puts " Result ="
  puts timetable.inspect
  timetable.each_pair do | event, stream |
    ordered_hash[ event[0] ] ||= {}
    ordered_hash[ event[0] ][ event[1] ] = stream
  end
  timetable = ordered_hash
  timetable.each_pair do | subject, events |
    puts "\n#{subject}"
    events.each_pair do | event, stream |
      puts "  #{event}"
      for time in stream do
        puts "    #{time}"
      end
    end
  end
end

