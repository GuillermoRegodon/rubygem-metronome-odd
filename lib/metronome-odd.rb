require 'metronome-odd/interruptible_sleep'
require 'metronome-odd/parse_line.rb'
require 'metronome-odd/save.rb'
require 'metronome-odd/keypress.rb'


module Metronome
  class Sound
    def initialize(sound_file)
      @sound_file = sound_file
      self
    end

    def is_sound_file?
      @sound_file.extension == "aiff"
    end

    def play
      spawn("afplay #{@sound_file}")
    end

    def set_sound(sound_file)
      @sound_file = sound_file
    end

    private
    def extension
      @sound_file.split('.').last
    end
  end

  class Silence
    include Stop
    include InterruptibleSleep
    attr_accessor :duration

    def initialize(duration)
      @duration = duration
      self
    end

    def wait
      Signal.trap('SIGINT') do print "\b\bstopped"
        @@stop = true
      end
      interruptible_sleep @duration
    end

    def play
      self.wait
    end

    def print_sign
    end
  end

  class Beat
    attr_accessor :silence
    def initialize(tempo, sound_file)
      @sound = Sound.new(sound_file)
      @silence = Silence.new(60.0/tempo)
      self
    end

    def play
      @sound.play
      @silence.wait
    end
  end

  class Bar
    attr_writer :upbeat_sound_file
    attr_writer :downbeat_sound_file
    attr_reader :n
    attr_reader :d
    attr_accessor :tempo
    attr_accessor :beat_array

    def initialize(tempo, n, d)
      data_dir = Gem.datadir("metronome-odd")
      data_dir = data_dir ? data_dir : ""
      @upbeat_sound_file = data_dir + "/beat_upbeat.aiff"
      @downbeat_sound_file = data_dir + "/beat_downbeat.aiff"

      @beat_array = Array.new
      @beat_array.push(Beat.new(tempo*d/4.0, @upbeat_sound_file))

      @n = n
      @d = d

      @tempo = tempo

      (2..n).each do 
        @beat_array.push(Beat.new(tempo*d/4.0, @downbeat_sound_file))
      end
      self
    end

    def play
      @beat_array.each {|b| b.play}
    end

    def print_sign
      print "|#{@n}x#{@d}|"
    end

    def set_tempo(tempo)
      old_tempo = Float(@tempo)

      @beat_array.each do |beat|
        beat.silence.duration *= old_tempo/tempo
      end

      @tempo = tempo
    end

  end

  class OddBar < Bar
    attr_accessor :tempo
    attr_accessor :beat_array

    def initialize(tempo, in_beat)
      data_dir = Gem.datadir("metronome-odd")
      data_dir = data_dir ? data_dir : ""
      @upbeat_sound_file = data_dir + "/beat_upbeat.aiff"
      @downbeat_sound_file = data_dir + "/beat_downbeat.aiff"

      @beat_array = Array.new
      @in_beat = in_beat
      @tempo = tempo

      upbeat_b = true
      time = 1
      prev_beat = 1
      in_beat.each do |t|
        if upbeat_b
          beat = Beat.new(tempo/t, @upbeat_sound_file)
          upbeat_b = false
        else
          beat = Beat.new(tempo/t, @downbeat_sound_file)
        end
        @beat_array.push(beat)
      end

    end

    def print_sign
      # In order to print an odd bar, firstly we find the beat sound times
      #   in in_sum, starting from 1.
      # Then we add the silences in the beats in in_clone
      # Finally we print the bar, with numbers in the beats and
      #   semicolons in the silences that occur in a beat
      # width may be used to change size
      width = 8
      max_beat = @in_beat.sum
      in_sum = [1.0]
      acum = 1.0
      @in_beat.each do |e| acum=acum+e;in_sum.push(acum) end
      in_clone = in_sum.clone
      (1...max_beat.floor).each do |d|
        if not(in_clone.include?(d))
          in_clone.push(Float(d))
        end
      end
      in_clone = in_clone.sort

      print "|"
      in_clone[0...-1].each_with_index do |d, i|
        if in_sum.include?(d)
          if d == Integer(d)
            print(':')
          end
          print(d.floor)
        else
          print(':')
        end
        if d<in_clone.last
          t = Integer((in_clone[i+1]-in_clone[i])*width-1)
          t.times do print " " end 
        end
      end
      print "|"
    end
  end

  class Practice < Array
    include Stop
    @next_bar_hash = nil
    @prev_bar = nil

    def initialize
      @next_bar_hash = Hash.new(nil)
    end

    def sound(type)
      @@stop = false
      bar_counter = 0 # 0 accounts for the intial silence

      self.each do |b| 
        unless b.class == Silence
          print "\n#{bar_counter}:\t"
          b.print_sign
          if @next_bar_hash[b]
            print " -> "
            @next_bar_hash[b].print_sign
            print "\t"
          else
            case type
            when :play
              print " - last bar! "
            when :loop
              print " - repeat! "
            end
          end
        end
        b.play
        bar_counter += 1
        if @@stop then break end
      end
      puts
    end

    def play
      sound(:play)
    end

    def loop_stop?
      sound(:loop)
      @@stop
    end

    def force_tempo(tempo)
      self.each do |bar|
        unless bar.class == Silence
          bar.set_tempo(tempo)
        end
      end
    end

    def push(b)
      super(b)
      if @prev_bar
        @next_bar_hash[@prev_bar] = b
      end
      @prev_bar = b
    end

    def print_practice
      bar_counter = 0 # 0 accounts for the intial silence
      self.each do |b| 
        unless b.class == Silence
          print "\n#{bar_counter}:\t"
          b.print_sign
        end
        bar_counter += 1
      end
      puts
    end
  end
end
