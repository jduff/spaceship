class Bullet < GameObject
  trait :bounding_circle, :debug=>DEBUG
  traits :collision_detection, :velocity, :timer

  def setup
    @image = Image["fire_bullet.png"]
    self.factor = 0.75
    @damage = 10

    @dead = false
  end

  def die
    self.velocity = [0,0]
    @dead = true
    between(0,50) { self.factor += 0.3; self.alpha -= 10; }.then { destroy }
  end

  def dead?
    @dead
  end

  def alive?
    !dead?
  end

  def update
    unless dead?
      self.each_collision(Ship, Asteroid) do |bullet, game_object|
        game_object.damage(@damage)
        self.die
      end
    end
  end
end
