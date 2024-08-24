#######################################################################
#  ArticulationGenerate
#######################################################################
#  This script divides a file into individual segments (articulations)
#  that have been marked in some specified tier.  Each vowel is saved 
#  as an individual Praat sound file with the name of the original file
#  plus the interval label.
#
#  Input:   Sound files with associated TextGrids
#  Output:  Individual sound files named according to the original file and
#           the interval label.
#  Process: The script asks for a directory in which to look for files, a tier
#           by which to segment, and an input sound file type.  It then looks
#           for soundfiles of the specified type with associated TextGrids in
#           the specified folder.  For each soundfile, it locates marked
#           intervals in the specifed tier one-by-one.  Each labeled interval 
#           is saved as a new .wav file and a new text grid (with the segmented tier removed).
#######################################################################

form - ArticulationGenerate
   comment Specify which tier in the TextGrid contains the articulation boundaries:
        integer tier_number 1
   comment Specify which tier in the TextGrid contains the phoneme boundaries:
        integer other_tier_number 2
   comment Sound file extension
        word file_type .wav
   comment Prefix (None if blank)
   		word namebase
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 
out_dir$ = chooseDirectory$ ("Choose the directory of segmented files and textgrids")
out_dir$ = "'out_dir$'" + "\"

clear info
Create Strings as file list... list 'directory$'*'file_type$'
number_of_files = Get number of strings

# Starting from here, add everything that should be repeated for each sound file
for j from 1 to number_of_files
        select Strings list
        filename$ = Get string... 'j'
        Read from file... 'directory$''filename$'
        soundname$ = selected$ ("Sound")
        
        gridfile$ = "'directory$''soundname$'.TextGrid"
        if fileReadable (gridfile$)
                Read from file... 'gridfile$'
                select TextGrid 'soundname$'
                number_of_intervals = Get number of intervals... 'tier_number'
                
                # iterate through intervals
                for k from 1 to number_of_intervals
	   		 		select TextGrid 'soundname$'
	    			seg_label$ = Get label of interval... 'tier_number' 'k'
			    	if seg_label$ <> ""
			            seg_start = Get starting point... 'tier_number' 'k'
			            seg_end = Get end point... 'tier_number' 'k'
			            start = seg_start
			            end = seg_end
			            select Sound 'soundname$'
			            Extract part: start, end, "rectangular", 1, "no"
						if namebase$ <> ""
			            	writename$ = "'namebase$'_'seg_label$'"
						else
			            	writename$ = "'seg_label$'"
						endif
						# Although you should use ASCII when making textgrids, this bit removes some instacrashes
						writename$ = replace$ (writename$, " ", "_", 0)
						writename$ = replace$ (writename$, "/", "_", 0)
						out_filename$ = "'out_dir$''writename$'"
						# initialize anti-collision counter.
			        aff = 1
						name$ = "'out_filename$'_'aff'"

						#writeInfo: name$
			        while fileReadable ("'name$'.wav")
							aff = aff + 1
							name$ = "'out_filename$'_'aff'"
			        endwhile
			            Write to WAV file... 'name$'.wav
			            select TextGrid 'soundname$'
			            Extract part... 'start' 'end' no
                                    Extract one tier... 'other_tier_number'
			            #Rename... 'out_filename$'
			            Write to text file... 'name$'.TextGrid
				    endif
                endfor
                select all
                minus Strings list
                Remove
        endif
endfor
select all
Remove
print Articulation generation complete.
