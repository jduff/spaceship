class Ship < GameObject
  has_traits :velocity, :collision_detection
  has_trait :bounding_circle, :debug => DEBUG

  def setup
    @image = Image["Starfighter.bmp"]
    @fireball_animation = Chingu::Animation.new(:file => media_path("fireball.png"), :size => [32,32])

    self.factor = 0.75
  end

  def accelerate
    @motion = :accelerate
    @velocity_x += Gosu::offset_x(angle, 0.2)
    @velocity_y += Gosu::offset_y(angle, 0.2)
  end

  def reverse
    @motion = :reverse
    @velocity_x -= Gosu::offset_x(angle, 0.1)
    @velocity_y -= Gosu::offset_y(angle, 0.1)
  end

  def turn_left
    self.angle -= 3.0
  end

  def turn_right
    self.angle += 3.0
  end

  def fire
    direction = [Gosu::offset_x(angle, 5), Gosu::offset_y(angle, 5)]
    d2 = [Gosu::offset_x(angle, self.image.width/2), Gosu::offset_y(angle, self.image.height/2)]
    Bullet.create(:x => self.x+d2[0], :y => self.y+d2[1], :velocity => direction)
  end

  def update
    if @motion == :accelerate
      scale = -0.05
    elsif @motion == :reverse
      scale = -0.25
    else
      scale = -0.15
    end
    @motion = nil
    Chingu::Particle.create( :x => @x-Gosu::offset_x(angle,30),
                          :y => @y-Gosu::offset_y(angle,30),
                          :animation => @fireball_animation,
                          :scale_rate => scale,
                          :fade_rate => -20,
                          :rotation_rate => +1,
                          :mode => :default
                        )
    Chingu::Particle.destroy_if { |object| object.color.alpha == 0 }

    #
    # Revert ship to last positions when:
    # - ship is outside the viewport
    # - ship is colliding with at least one object of class Asteroid
    #
    if self.parent.viewport.outside_game_area?(self) || self.first_collision(Asteroid)
      @x, @y = @last_x, @last_y
      # bounce back a bit when you hit something
      @velocity_x, @velocity_y = -@velocity_x, -@velocity_y
    else
      # degrade the velocity over time
      @velocity_x *= 0.95
      @velocity_y *= 0.95
    end

    @last_x, @last_y = @x, @y
  end
end

class Player < Ship
  def setup
    super

    self.input = { :holding_up    => :accelerate,
                   :holding_down  => :reverse,
                   :holding_left  => :turn_left,
                   :holding_right => :turn_right,
                   :space         => :fire}
    update
  end
end
