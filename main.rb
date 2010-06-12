require 'gosu'
require File.expand_path %w(.. lib chingu lib chingu).join('/'), __FILE__
include Gosu
include Chingu

DEBUG = true # Shows bounding circle etc

%w(asteroid bullet ship).each {|file| require File.expand_path file, File.dirname(__FILE__) }

class Level < GameState
  has_trait :viewport

  def setup
    @map = GameObject.create(:image => "Space.png", :factor => $window.factor, :rotation_center => :top_left)

    @player = Player.create(:x=>100, :y=>100)
    60.times do
      Asteroid.create(:x=>rand(1500), :y=>rand(1500))
    end

    self.viewport.game_area = [0, 0, 1000, 1000]
  end

  def update
    super
    self.viewport.center_around(@player)

    game_objects.destroy_if { |game_object| self.viewport.outside_game_area?(game_object) }

    $window.caption = "Move with arrows! Space to Shoot!- viewport x/y: #{self.viewport.x.to_i}/#{self.viewport.y.to_i} - FPS: #{$window.fps} - Game Objects #{game_objects.size}"
  end
end

class Game < Chingu::Window
  def setup
    self.input = {:escape => :exit}
    switch_game_state(Level.new)
  end
end

Game.new.show
