require 'rubygems'
require 'gosu'
require File.join(File.dirname($0), "lib", "chingu", "lib", "chingu")
include Gosu

require 'constants'
require 'behaviors/vector2d'
require 'extensions'


require 'behaviors/steering_behaviors'

require 'ship'
require 'player'
require 'star'

class GameWindow < Chingu::Window
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = "Gosu Tutorial Game"
    
    @player = Player.new
    @player.input = PLAYER_INPUT
    @player.warp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    
    @enemy = Ship.new
    @enemy.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
    
    @enemy.steering = Seek.new(rand(SCREEN_WIDTH),rand(SCREEN_HEIGHT))
    
    @enemy2 = Ship.new
    @enemy2.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
    
    @enemy2.steering = Pursue.new(@player)

    @star_anim = Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @stars = Array.new
    
    @score = Chingu::Text.new(:text=>"Score: #{@player.score}", :x=>10, :y=>10, :zorder=>ZOrder::UI, :color=>0xffffff00, :factor=>1.5)
    
    @last_time = Gosu::milliseconds
    
    self.input = {:escape=>:close}
  end

  def update
    super
    new_time = Gosu::milliseconds
    @last_time = new_time
    
    # @player.validate_position!
    @player.collect_stars(@stars)
    
    if rand(100) < 4 && @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
  end

  def draw
    super
    Image["Space.png"].draw(0, 0, ZOrder::Background)
    @player.draw
    @score.text="Score: #{@player.score}"
    @enemy.draw
    @stars.each { |star| star.draw }
  end
end

GameWindow.new.show