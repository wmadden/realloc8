# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  layout 'layout'
  
  cattr_accessor :timetable_hash, :subject_titles_hash
  
  def self.timetable_hash
    @@mighty_subjects_hash ||= mighty_subjects_hash
    @@timetable_hash  ||= @@mighty_subjects_hash.first
    return @@timetable_hash
  end
  
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
    
    problem = Timetabler::TimetableProblem.new( variables )
    problem.solve! # I love this line
  end
  
end
