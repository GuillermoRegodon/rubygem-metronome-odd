require './lib/metronome-odd.rb'
require 'test/unit'

class TestNAME < Test::Unit::TestCase

  def test_practice
    t = Bar.new(100, 6, 8)
    p = Practice.new
    (1..5).each {p.push(t)}
    p.play
  end

end