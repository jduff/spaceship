class Flee < Base
  def initialize(*args)
    super
    @target = args.length==1 ? Vector2d(args.first) : Vector2d.new(*args)
  end
  
  def calculate(time, object)
    object_pos = Vector2d(object)
    diff = (object_pos - @target).normalize
    diff = Vector2d.new(1,1) if diff.zero?
    desired_velocity = (diff * @max_speed)
    
    current_velocity = Vector2d.new(object.vel_x, object.vel_y)
    
    apply(time,object,desired_velocity-current_velocity)
  end

end