# CSProblem.rb
# 
# Provides the CSProblem class.
# 
# William Madden, 29/01/10

require "Timetabler/State"

module Timetabler

  # 
  # Defines a constraint-satisfaction problem and implements a recursive
  # backtracking search function to solve it.
  # 
  # Adapted from the algorithm in "Artificial Intelligence, A Modern
  # Approach" (Russel, Norvig).
  # 
  # This implementation is modeled on a recursive depth-first search. Openings
  # have been left for heuristics to be added, which should speed up the search.
  # Worst case scenario (no solution) will still require searching all available
  # combinations.
  # 
  class CSProblem
    
    #---------------------------------------------------------------------------
    #  
    #  Constructor
    #  
    #---------------------------------------------------------------------------
    
    # 
    # Takes as parameters a hash of variable identifiers to arrays of values
    # they may take and an array of constraints that must be satisfied, as
    # Procs.
    # 
    def initialize( variables, constraints, assignments = nil, fringe = nil )
      @variables = variables || @variables || {}
      @constraints = constraints || @constraints || []
      @assignments = assignments || @assignments || {}
      
      @fringe = fringe || @fringe || []
    end
    
    
    #---------------------------------------------------------------------------
    #  
    #  Properties
    #  
    #---------------------------------------------------------------------------
    
  public
    
    attr_reader :assignments
    
    
    #---------------------------------------------------------------------------
    #  
    #  Methods
    #  
    #---------------------------------------------------------------------------
    
  public
    
    #------------------------------
    #  solve!
    #------------------------------
    
    # 
    # Wrapper for search implementations.
    # 
    def solve!
      #rec_backtracking_search
      iterative_search( @variables, @assignments )
    end
    
    #------------------------------
    #  constraints_satisfied?
    #------------------------------
    
    # 
    # Returns true if all constraints are satisfied, otherwise false.
    # 
    def constraints_satisfied?( variables, assignments )
      result = true
      
      for constraint in @constraints
        result = result && constraint.call( variables, assignments )
      end
      
      result
    end
    
  private
    
    #------------------------------
    #  iterative_search
    #------------------------------
    
    def iterative_search( variables, assignments )
      
      fringe = [ State.new(variables, assignments, self) ]
      
      while not fringe.empty?
        state = fringe.pop
        
        # Success, return immediately
        return state.assignments if goal_state?( state )
        
        # Add successors to fringe
        successors = state.successors
        fringe.concat( successors )
        
        # Order fringe
        fringe.sort! { |a, b| a.value <=> b.value }
      end
      
      # Failure, return nil
      nil
    end
    
    #------------------------------
    #  rec_backtracking_search
    #------------------------------
    
    # 
    # Searches for a solution.
    # 
    def rec_backtracking_search
      
      return @assignments if assignment_complete?( @assignments, @variables )
      
      variable = select_unassigned_variable( @variables, @assignments )
      values = order_domain_values( variable )
      
      for value in values do
        assign( variable, value )
        
        if not constraints_satisfied?( @variables, @assignments, @constraints )
          unassign( variable )
          next
        end
        
        result = rec_backtracking_search
        
        return result unless result.nil? # Success, return immediately
        
        unassign( variable )
      end
      
      # Failure, return nil
      nil
    end
    
    #------------------------------
    #  select_unassigned_variable
    #------------------------------
    
    # 
    # Chooses a variable to assign next.
    # 
    def select_unassigned_variable( variables, assignments )
      # TODO: heuristic
      
      # Choose first unassigned var
      for variable in variables.keys
        break unless assignments.has_key?( variable )
        variable = nil
      end
      
      variable
    end
    
    #------------------------------
    #  order_domain_values
    #------------------------------
    
    # 
    # Orders the domain values of a variable such that the most valuable is
    # first and the least valuable last.
    # 
    def order_domain_values( variable )
      # TODO: heuristic
      @variables[ variable ]
    end
    
    #------------------------------
    #  assignment_complete?
    #------------------------------
    
    # 
    # Returns true if all variables have been assigned values, otherwise false.
    # 
    def assignment_complete?( assignments, variables )
      assignments.length == @variables.length
    end
    
    #------------------------------
    #  goal_state?
    #------------------------------
    
    # 
    # Returns true if the given state is a goal state (i.e. complete timetable).
    # 
    def goal_state?( state )
      assignment_complete?( state.assignments, state.variables )
    end
    
    #------------------------------
    #  assign
    #------------------------------
    
    # 
    # Assigns value to variable.
    # 
    def assign( variable, value )
      @assignments[ variable ] = value
    end
    
    #------------------------------
    #  unassign
    #------------------------------
    
    # 
    # Unassigns variable.
    # 
    def unassign( variable )
      @assignments.delete( variable )
    end
    
    #------------------------------
    #  value_state
    #------------------------------
    
    # 
    # Returns the numerical value of a state.
    # 
    def value_state( state )
      assignments = state[2]
      value = assignments.length
    end
    
  end # END CLASS
end # END MODULE

