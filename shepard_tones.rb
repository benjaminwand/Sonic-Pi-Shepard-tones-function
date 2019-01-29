define :shepard do |pitch, time = 1, attack = 0.5, volume = 1, synth = :sine, center = 78|
  use_synth synth
  (1..9).each do |octave|                       # 9 octaves
    if pitch.class == Symbol
      tones = (note_info pitch, octave: octave).midi_note    # make number
    else                                        # assuming an int or float
      tones = pitch % 12 + 12 * (octave + 1)    # midi number of tones
    end
    equal_amp = 30.0 / tones ** 1.5 * volume    # all at same-ish volume
    middle =  (tones - center)/10.7             # centers bell curve, 78 -> [-5 .. 5]
    gauss = equal_amp * 2**-( middle**2/10)     # bell curve * equalized volume
    play tones, amp: gauss, attack: attack, sustain: time, release: attack
  end
  sleep time
end

# example 1: single call with alternative synth and center
shepard :g, 2, 0.9, 0.8, :blade, 86

sleep 0.5

# example 2: single call with alternative same synth and different center
shepard :g, 2, 0.9, 0.8, :blade, 50

sleep 0.5

# example 3: scale call
2.times do
  for each_tone in [:c, :cs, :d, :ds, :e, :f, :fs, :g, :gs, :a, :as, :b]
    shepard each_tone, 0.5
  end
end

sleep 1

# example 4: call with numbers that move on a sine wave
x = (-200..0).map {|x| Math.sin(0.1*x)}
for each_tone in x
  shepard each_tone, 0.05, 0.1, 1, :sine, 86
end

# example 5: rising tones and falling center
y = Range.new(0,36).step(0.1)
z = Range.new(50,86).step(0.1).to_a.reverse
for (each_y, each_z) in y.zip(z)
  shepard each_y, 0.1, 0.1, 1, :sine, each_z
end
