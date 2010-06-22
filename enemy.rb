# require 'behaviors/base'
# require 'behaviors/seek'
# require 'behaviors/pursue'
# require 'behaviors/flee'
# require 'behaviors/evade'
# require 'behaviors/wander'

class Enemy < Ship
  attr_accessor :target

  def setup
    super

    self.input = { :holding_w    => :accelerate,
                   :holding_s  => :reverse,
                   :holding_a  => :turn_left,
                   :holding_d => :turn_right,
                   :x         => :fire}
    update
  end


  def update
    execute_behaviour if target
    super
  end

  def execute_behaviour
    seek
  end


  def seek
    # angle between enemy and target
    angle_to_target = Gosu::angle(x, y, target.x, target.y)

    # shortest angle to face target (pos for clockwise, neg for counter-clockwise)
    angle_diff = angle_diff(angle, angle_to_target)

    # turn right if pos; left otherwise
    self.angle += angle_diff > 0 ? [3.0, angle_diff].min : [-3.0, angle_diff].max unless angle_diff == 0

    dist = Gosu::distance(x, y, target.x, target.y)

    accelerate if dist > 1

    # slow down if getting close
    @velocity_x *= [[dist/50, 1].min, 0.6].max
    @velocity_y *= [[dist/50, 1].min, 0.6].max
  end
end
