import parselmouth
import sys

if len(sys.argv) < 3:
    print("usage: pmpitch.py input_file output_text")
    exit()

sound = parselmouth.Sound(sys.argv[1])

pitch = sound.to_pitch()
pitch_listing = pitch.selected_array["frequency"]

with open(sys.argv[2], "w") as file:
    for f0 in pitch_listing:
        file.write("%s\n" % f0)
