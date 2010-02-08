class TimetableController < ApplicationController
 
  def index

    subjects_hash = {}
    
    if params[:login]
      list = authenticate_unimelb_by_pin(params[:login],params[:pin]).scan /name=([\d]*)-\d-semester\s*\n\s*value=(.*?)>/
      list = list.select {|x| ['1','Y'].include? x.last }
      list.each do |x|
        subjects_hash[x.first] = ApplicationController.timetable_hash[x.first]
      end
    else
      for key in [:subject1,:subject2,:subject3,:subject4]
        subjects_hash[params[key]] = ApplicationController.timetable_hash[params[key]] if ApplicationController.timetable_hash[params[key]]
      end
    end

    
    debugger
    
    @timetable = search(subjects_hash) || {}
    
    return unless @timetable
    
    @timetable =  @timetable.invert
    
    new_hash = {}
    
    for key in @timetable.keys
      for sub_key in key
        new_hash[sub_key] = @timetable[key]
      end
    end


    @timetable = {}

    debugger

    for key in new_hash.keys
      
      day,time =  key.scan(/^(.*?) (.*?) -/)[0]
      
      @timetable[day] ||= {}
      @timetable[day][time] = new_hash[key]
      
    end
    
    debugger
    
    @times_list  = ["9:00am","10:00am","11:00am","12:00pm","1:15am","2:15pm","3:15pm","4:15pm","5:15pm","6:15pm"]
    @days = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
  end

end
