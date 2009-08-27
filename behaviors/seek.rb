class Seek < Base
  def initialize(x, y)
    super
    @target_pos = Vector2d.new(x,y)

  end
  
  def calculate(time, object)
    object_pos = Vector2d.new(object.x, object.y)
    desired_velocity = ((@target_pos - object_pos).normalize * @max_speed)
    
    current_velocity = Vector2d.new(object.vel_x, object.vel_y)
    
    apply(time,object,desired_velocity-current_velocity)
    
  end
end