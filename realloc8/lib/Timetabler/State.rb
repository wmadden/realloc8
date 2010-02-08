# State.rb
# 
# Provides the State class.
# 
# William Madden, 29/01/10

module Timetabler

  # 
  # Defines a state in a CSProblem. That is, unassigned variables (and their
  # domains), assignments and the value of the state.
  # 
  class State
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    # 
    # Takes as parameters the variables and assignments of the state, and its
    # parent problem (to test constraint-satisfaction, goals etc.).
    # 
    # Upon construction, the state will estimate its value, automatically assign
    # variables whose domain contains only one value and check its consistency
    # against the problem constraints.
    # 
    def initialize( variables, assignments, problem )
      @variables = {}; @variables.replace( variables )
      @assignments = {}; @assignments.replace( assignments )
      @problem = problem
      
      # Check for single-value variables
      @variables.each_pair do |variable, domain|
        if domain.length == 1
          assign( variable, domain[0] )
        end
      end
    end
    
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
    attr_accessor :variables, :assignments
    
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  successors
    #------------------------------
    
    # 
    # Returns a list of successors to `state'.
    # 
    def successors
      result = []
      
      @variables.each_pair do |variable, domain|
        # Generate successors by assigning to variable
        for value in domain
          # Create the successor state
          successor = State.new( @variables, @assignments, @problem )
          # Assign the variable
          successor.assign( variable, value )
          
          # Test constraints on successor
          next if not successor.constraints_satisfied?
          
          result.push( successor )
        end
      end
      
      result
    end
    
    #------------------------------
    #  assign
    #------------------------------
    
    def assign( variable, value )
      @assignments[ variable ] = value
      @variables.delete( variable )
    end
    
    #------------------------------
    #  constraints_satisfied?
    #------------------------------
    
    # 
    # Returns true if all constraints are satisfied, otherwise false.
    # 
    def constraints_satisfied?
      # Check all unassigned variables have non-empty domains
      @variables.each_value do |domain|
        return false if domain.length == 0
      end
      
      # Test problem constraints
      @problem.constraints_satisfied?( @variables, @assignments )
    end
    
    #------------------------------
    #  value
    #------------------------------
    
    def value
      result = @assignments.length
      
      # Added by Will, redo this later to use real values instead of parsing the
      # string
      return result
      @assignments.each_pair do |variable, value|
        # If it's in the morning, add 1
        morning = true
        for time in value
          # Parse time
          /[a-zA-Z]+\s*([\d]):[\d]+[amp]+ - ([\d]):[\d]+[amp]+/ === time
          start = $1; finish = $2
          
          # If time is in morning
          if start.to_i > 12
            morning = false
            break
          end
        end
        
        if morning
          result += 2
        else
          result -= 2
        end
      end
      
      #puts result
      result
    end
    
  end
  
end
