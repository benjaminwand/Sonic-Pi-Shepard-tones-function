define :shepard do |pitch, time = 1, attack = 0.5, volume = 1, synth = :sine, center = 78|
  use_synth synth
  counter = 1
  9.times do                                  # 9 octaves
    if pitch.class == Symbol
      ton = (note_info pitch, octave: counter).midi_note    # make number
    else                                      # assuming an int or float
      ton = pitch % 12 + 12 * (counter + 1)   # midi number of tones
    end
    equal_amp = 30.0 / ton * volume           # all at same-ish volume
    middle =  (ton - center)/10.7             # centers around zero [-5 .. 5]
    gauss = equal_amp * 2**-( middle**2/10)   # bell curve * equalized volume
    play ton, amp: gauss, attack: attack, sustain: time, release: attack
    counter = inc (counter)
  end
  sleep time
end

# example 1: single call with alternative synth and center
shepard :g, 2, 0.9, 0.8, :blade, 100

sleep 0.5

# example 2: single call with alternative same synth and different center
shepard :g, 2, 0.9, 0.8, :blade, 60

sleep 0.5

# example 3: scale call
2.times do
  for each_tone in [:c, :cs, :d, :ds, :e, :f, :fs, :g, :gs, :a, :as, :b]
    shepard each_tone, 0.5
  end
end

sleep 0.5

# example 4: call with numbers that move on a sinus curve
x = (10..200).to_a
x = x.collect{|x| Math.cos(0.1*x)}
for each_tone in x
  shepard each_tone, 0.05, 0.1
end
