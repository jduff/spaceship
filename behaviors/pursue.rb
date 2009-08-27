class Pursue < Base
  def initialize(target)
    super
    @target = target
  end
  
  def calculate(time, object)  
    target_pos = Vector2d.new(@target.x, @target.y)
  
    to_evader = target_pos - Vector2d.new(object.x, object.y)
  
    object_heading = object.angle.angle_to_vect
    evader_heading = @target.angle.angle_to_vect
  
    relative_heading = object_heading.dot(evader_heading)
    if to_evader.dot(object_heading) > 0 && relative_heading < -0.95
      @predicted_pursuit = nil
      @look_ahead_time = nil
      @seek = Seek.new(target_pos.x, target_pos.y)
    else
      target_vel = Vector2d.new(@target.vel_x, @target.vel_y)

      @look_ahead_time = to_evader.length / (@max_speed + target_vel.length)
      @predicted_pursuit = target_pos + target_vel * @look_ahead_time
      @seek = Seek.new(@predicted_pursuit.x, @predicted_pursuit.y)
    end
  
    @seek.calculate(time, object)
  end

end