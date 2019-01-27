define :shepard do |pitch, time = 1, attack = 0.5, volume = 1, synth = :sine, center = 78|
  use_synth synth
  counter = 1
  9.times do                                    # 9 octaves
    if pitch.class == Symbol
      tones = (note_info pitch, octave: counter).midi_note    # make number
    else                                        # assuming an int or float
      tones = pitch % 12 + 12 * (counter + 1)   # midi number of tones
    end
    equal_amp = 30.0 / tones ** 1.5 * volume    # all at same-ish volume
    middle =  (tones - center)/10.7             # centers around zero [-5 .. 5]
    gauss = equal_amp * 2**-( middle**2/10)     # bell curve * equalized volume
    play tones, amp: gauss, attack: attack, sustain: time, release: attack
    counter = inc (counter)
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

# example 4: call with numbers that move on a sinus curve
x = (-200..0).to_a.collect{|x| Math.sin(0.1*x)}
for each_tone in x
  shepard each_tone, 0.05, 0.1, 1, :sine, 86
end

# example 5: rising tones and falling center
y = (0..360).to_a.collect{|y| 0.1*y}
z = (500..860).to_a.reverse.collect{|z| 0.1*z}
i = 0
for each_tone in y
  shepard each_tone, 0.1, 0.1, 1, :sine, z[i]
  i = inc (i)
end
