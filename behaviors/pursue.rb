class Pursue < Seek
  def initialize(target)
    super(0,0)
    @target_vehicle = target
  end
  
  def calculate(time, object)  
    target_pos = Vector2d.new(@target_vehicle.x, @target_vehicle.y)
  
    to_evader = target_pos - Vector2d.new(object.x, object.y)
  
    object_heading = object.angle.angle_to_vect
    evader_heading = @target_vehicle.angle.angle_to_vect
  
    relative_heading = object_heading.dot(evader_heading)
    if to_evader.dot(object_heading) > 0 && relative_heading < -0.95
      @target = target_pos
    else
      target_vel = Vector2d.new(@target_vehicle.vel_x, @target_vehicle.vel_y)

      look_ahead_time = to_evader.length / (@max_speed + target_vel.length)
      @target = target_pos + target_vel * look_ahead_time
    end
    
    super
  end

end