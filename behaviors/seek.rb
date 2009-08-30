class Seek < Base
  def initialize(*args)
    super
    @target = args.length==1 ? Vector2d(args.first) : Vector2d.new(*args)
  end
  
  def calculate(time, object)
    object_pos = Vector2d(object)
    desired_velocity = ((@target - object_pos).normalize * @max_speed)
    
    current_velocity = Vector2d.new(object.vel_x, object.vel_y)
    
    apply(time,object,desired_velocity-current_velocity)
  end
end