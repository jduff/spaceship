class Player < Ship
  attr_reader :score

  def initialize(window)
    super(window)
    @score = 0
  end
  
  def turn_left
    new_angle = (@heading.angle-94)
    @heading.x = Float(Math::cos(new_angle.to_rads))
    @heading.y = Float(Math::sin(new_angle.to_rads))
  end
  
  def turn_right
    new_angle = (@heading.angle-86)
    @heading.x = Float(Math::cos(new_angle.to_rads))
    @heading.y = Float(Math::sin(new_angle.to_rads))
  end
  
  def accelerate
    @vel.x += Gosu::offset_x(@heading.angle, 0.5)
    @vel.y += Gosu::offset_y(@heading.angle, 0.5)
  end
  
  def reverse
    @vel.x -= Gosu::offset_x(@heading.angle, 0.5)
    @vel.y -= Gosu::offset_y(@heading.angle, 0.5)
  end
  
  def update
    @pos.x += @vel.x
    @pos.y += @vel.y
    
    @vel.x *=0.95
    @vel.y *=0.95
    
    return self
  end
  
  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@pos.x, @pos.y, star.x, star.y) < 35 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end