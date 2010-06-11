require 'gosu'
require File.expand_path %w(.. lib chingu lib chingu).join('/'), __FILE__
include Gosu
include Chingu

DEBUG = true

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
    Chingu::Particle.destroy_if { |object| object.parent.outside_viewport?(object) || object.color.alpha == 0 }

    #
    # Revert ship to last positions when:
    # - ship is outside the viewport
    # - ship is colliding with at least one object of class Asteroid
    #
    if self.parent.outside_viewport?(self) || self.first_collision(Asteroid)
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

    self.input = {:holding_up=>:accelerate, :holding_down=>:reverse, :holding_left=>:turn_left, :holding_right=>:turn_right}
  end
end

class Level < GameState
  has_trait :viewport

  def setup
    @map = GameObject.create(:image => "Space.png", :factor => $window.factor, :rotation_center => :top_left)

    Player.create(:x=>100, :y=>100)
    10.times do
      Asteroid.create(:x=>rand($window.width), :y=>rand($window.height))
    end

    self.viewport.x_min = 0
    self.viewport.y_min = 0
    self.viewport.x_max = @map.image.width * $window.factor - $window.width
    self.viewport.y_max = @map.image.height * $window.factor - $window.height
  end
end

class Asteroid < GameObject
  has_trait :bounding_circle, :debug => true
  has_trait :collision_detection

  def setup
    @image = Image["Asteroid.png"]
    self.factor = 0.2
  end
end

class Game < Chingu::Window
  def setup
    self.input = {:escape => :exit}
    self.factor=1.3

    switch_game_state(Level.new)
  end
end

Game.new.show

#require 'rubygems'
#require 'gosu'
#require File.join(File.dirname($0), "lib", "chingu", "lib", "chingu")
#include Gosu
#
#require 'constants'
#require 'extensions'
#
#
## require 'behaviors/steering_behaviors'
#
#require File.join(File.dirname($0), "lib", "ruby_steering_behaviors", "lib", "steering_behaviors", "vector2d")
#require File.join(File.dirname($0), "lib", "ruby_steering_behaviors", "lib", "steering_behaviors", "steering_behaviors")
#
#require 'bullet'
#require 'ship'
#require 'enemy'
#require 'player'
#require 'star'
#
#class GameWindow < Chingu::Window
#  def initialize
#    super(SCREEN_WIDTH, SCREEN_HEIGHT)
#    self.caption = "Gosu Tutorial Game"
#    
#    @player = Player.new
#    @player.input = PLAYER_INPUT
#    @player.warp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
#    
#    # @enemy = Ship.new
#    # @enemy.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
#    # 
#    # @enemy.steering = Wander.new
#
#
#    @enemy = Enemy.new
#    @enemy.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
#    @enemy.seek(rand(SCREEN_WIDTH),rand(SCREEN_HEIGHT))
#    
#    # @enemy.steering = Seek.new(rand(SCREEN_WIDTH),rand(SCREEN_HEIGHT))
#    
#    # @enemy2 = Enemy.new 
#    # @enemy2.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
#    
#    # @enemy2.steering = Pursue.new(@player)
#    # 
#    # @enemy3 = Ship.new
#    # @enemy3.warp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
#    # 
#    # @enemy3.steering = Flee.new(0,0)
#    # 
#    # @enemy4 = Ship.new
#    # @enemy4.warp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
#    # 
#    # @enemy4.steering = Evade.new(@player)
#
#    @star_anim = Image::load_tiles(self, "media/Star.png", 25, 25, false)
#    # @stars = Array.new
#    
#    @score = Chingu::Text.new(:text=>"Score: #{@player.score}", :x=>10, :y=>10, :zorder=>ZOrder::UI, :color=>0xffffff00, :factor=>1.5)
#    
#    @last_time = Gosu::milliseconds
#    
#    self.input = {:escape=>:close}
#  end
#
#  def update
#    super
#    if rand(100) < 4 && game_objects_of_class(Star).size < 25
#      Star.new(@star_anim)
#    end
#  end
#
#  def draw
#    super
#    $window.caption = "[particles#: #{game_objects.size} - framerate: #{$window.fps}]"
#    Image["Space.png"].draw(0, 0, ZOrder::Background)
#    @score.text="Score: #{@player.score}"
#  end
#end
#
#GameWindow.new.show
