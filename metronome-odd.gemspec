# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "metronome-odd"
  spec.version       = '1.0'
  spec.authors       = ["Guillermo Regodón"]
  spec.email         = ["guillermoregodon@gmail.com"]
  spec.summary       = %q{Programmable metronome}
  spec.description   = %q{Metronome that can be programmed to change de tempo or the time signature.}
  spec.homepage      = "https://github.com/GuillermoRegodon/rubygem-metronome-odd"
  spec.license       = "MIT"

  spec.files         = ['lib/metronome-odd.rb',
                        'lib/metronome-odd/parse_line.rb',
                        'lib/metronome-odd/save.rb',
                        'lib/metronome-odd/keypress.rb',
                        'lib/metronome-odd/interruptible_sleep.rb',
                        'data/metronome-odd/beat_upbeat.aiff',
                        'data/metronome-odd/beat_downbeat.aiff']
  spec.executables   = ['metronome-odd']
  spec.test_files    = ['tests/test_metronome-odd.rb']
  spec.require_paths = ["lib", "data"]
end