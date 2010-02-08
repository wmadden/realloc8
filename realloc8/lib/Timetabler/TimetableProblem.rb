# TimetableProblem.rb
# 
# Implements a subclass of CSProblem used to find timetables.
# 
# William Madden, 29/01/10

require "Timetabler/CSProblem"

module Timetabler

  # 
  # Implements a simple subclass of CSProblem used with timetables.
  # 
  class TimetableProblem < CSProblem
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    def initialize( variables )
      super( variables, constraints )
    end
    
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  private
    
    #------------------------------
    #  constraints
    #------------------------------
    
    def constraints
      [ Kernel.proc do | variables, assignments |
          # Ensure that no two events occupy the same time slot.
          
          # We can achieve this using almost entirely core functions by
          # flattening the assignments and checking for duplicates. This will
          # only occur if two streams have been selected which include at least
          # one of the same time slots.
          flat = []
          assignments.each_value do |value|
            flat.concat( value )
          end
          
          flat.length - flat.uniq.length == 0
        end ]
    end
  
  end # END CLASS
end # END MODULE

