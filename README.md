# rubygem-metronome-odd
A rubygem to program a metronome that allows for standard and non-standar odd time signature, in any combination.

It includes an executable, metronome-odd, to practice and save practice sessions.

The prompt input is intended to be improved. I have used Terminal system call "afplay", therefore I may suppose that in wont work in Windows o Linux (yet)

I have developed too helper libraries, Save and Parse_Line, adapted from another rubygem to be published. I have also used some content from:

*InterruptibleSleep by @ileitch: https://gist.github.com/ileitch/1459987

*KeyPress by @acook: https://gist.github.com/acook/4190379

Examples of usage, after typing metronome-odd, in the >>> prompt type

add:4x4

loop

to play repeatedly a 4x4 time signature, until 'ctrl'+c in presses

reset

add:1.0,1.0,1.0,0.5

loop

to play a 7/8 time signature repeatedly

type example in the >>> prompt for further examples
