require 'rubygems'
require 'gosu'
require File.join(File.dirname($0), "lib", "chingu", "chingu")
include Gosu

require 'constants'
require 'extensions'
require 'keyboard_manager'

require 'behaviors/vector2d'
require 'behaviors/steering_behaviors'

require 'ship'
require 'player'
require 'star'

class GameWindow < Chingu::Window
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = "Gosu Tutorial Game"
    
    @player = Player.new(self)
    # @player.input = PLAYER_INPUT
    @player.warp(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    
    @enemy = Ship.new(self)
    @enemy.warp(rand(SCREEN_WIDTH), rand(SCREEN_HEIGHT))
    
    @enemy.pursue(@player)

    @star_anim = Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @stars = Array.new
    
    @score = Chingu::Text.new(:text=>"Score: #{@player.score}", :x=>10, :y=>10, :zorder=>ZOrder::UI, :color=>0xffffff00, :factor=>1.5)
    @keyboard = KeyboardManager.new(@player, self)
    
    @last_time = Gosu::milliseconds
    
    self.input = {:escape=>:close}
  end

  def update
    super
    new_time = Gosu::milliseconds
    @enemy.update(new_time-@last_time).validate_position!
    @last_time = new_time
    
    # Check keyboard
    @keyboard.execute
    
    @player.update.validate_position!
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