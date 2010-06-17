class Asteroid < GameObject
  trait :bounding_circle, :debug => DEBUG
  traits :collision_detection, :timer

  def setup
    @image = Image["Asteroid.png"]
    self.factor = 0.2
    @life = 100
  end

  def damage(amount)
    @life -= amount

    self.die if @life <= 0
  end

  def die
    between(0,50) { self.factor += 0.1; self.alpha -= 10; }.then { destroy }
  end
end
