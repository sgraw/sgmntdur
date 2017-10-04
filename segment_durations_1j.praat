####
# This script expects the following tiers with exactly these names
# "CD/VOT	words	sounds	transcription	label pr_typ comments"
# The comments tier should always be at the last position or absent.
# In case 'comments' does not exist the script will create one.
# 
# You will find the results file in the path of the script
## (c) Copyleft 2017 Sven Grawunder. MPI EVA Leipzig. 

#### change log ########
# 2017-09-27 15:00 >>>> 1c
# - added condition brackets in vowel labels
#	- delete brackets , make not in comment column
#	- added comment column 
# - added /j/ to the non-stops list line 79
#### 2017-09-28 9:30 >>> 1d
# - added the possibility of "cv" inside stop phase
# - added "cvst" as starting point in time of cv (cv2) 
#### 2017-09-29 16:30 >>> 1e
# - corrected bug in brackets condition
# - added POA column (place of articulation) 
# - added voice column (voiced voiceless) 
# - added affric column (affricate /plain)
# - added pharyngealized column 
# - added glott column (ejective/ non eject) 
# - added palatalized column
# - added labialized column
# - added /ʁ/ and /ʔ/ to the non-stops list
# - added long sound file load option
# - added cv2st undefined condition
# - added pfst undefined condition
# - added modst undefined condition
# - script cosmetics
#### 2017-09-29 20:30 >>> 1f
# - added /ɨ/, /aʔ/ and /h/ to the non-stops list
#### 2017-10-01 19:30 >>> 1g
# - added substituion of white space and not white space for labels in sound tier and CD/VOT tier
# - added substituion of white space and not white space for labels in CD/VOT tier
#### 2017-10-02 0:30 >>> 1h
# - changed poa$="dentalv" to poa$="dental"
#### 2017-10-02 9:08 >>>> 1i
# - added  tɬ and qχ to affricates.
#### 2017-10-02 9:08 >>>> 1j
# - added ɬ to voiceless
# - added ʡ , aˤ , š, ž, ħ to non-stops list
# - added n:, ~e,~u, a' to non-stops list
# - added substitution of brackets in sound labels
# - added substitution of tabs and line breaks in word and transl tier labels
# - added cyrillic vowel letters and "1" to non-stops list
# - added geminate column

### TO DO list
# - built in acoustic voicing analysis
# - built in auditory/visual voicing analysis

form start
	comment Where is the folder with the textgrids?
	sentence file_path /Volumes/KOALA/Documents/Dagestan_Stops/test_textgrids/
	comment What is the name of the results file?
	word outputf dagstop_seg_vot.txt
	comment Load same named sound files from same directory as long sounds?
	boolean load 0	 
endform


deleteFile: "'outputf$'"
clearinfo
writeFileLine: "'outputf$'", "index", tab$,"filename", tab$, "word", tab$, "translation", tab$, "context", tab$, "repetition", tab$, "position", tab$, "stop", tab$,"poa", tab$, "voice", tab$, "geminate", 
...tab$, "affric", tab$, "glott", tab$,  "pharlzd" , tab$, "labialzd", tab$, "palatlzd" , tab$, "folVowel", tab$, "prevVowel", tab$, "totdur", tab$, "folVowDur", tab$, "prevVowDur", tab$, "fric", tab$, "postfric", tab$, "closdur",
...tab$, "tstart", tab$, "tend", tab$, "reltime", tab$, "pfst", tab$, "cvst", tab$, "modst", tab$, "comment"

fileList=Create Strings as file list: "fileList", "'file_path$'*.TextGrid"

index=0
nrst=Get number of strings

for i to nrst
	select fileList
	str$=Get string: i
	tg=Read from file: "'file_path$''str$'"
	nrt=Get number of tiers
	ltn$=Get tier name: nrt
	if ltn$!="comments"
		Insert interval tier: nrt+1, "comments"
	endif
	str$=str$-".TextGrid"
	if load==1
		Open long sound file: "'file_path$''str$'.wav"
	endif
	for ii to nrt
		select tg
		tn$=Get tier name: ii
		if tn$=="CD/VOT"
			cdtier=ii
		elsif tn$=="words"
			wordtier=ii
		elsif tn$=="sounds"
			soundtier=ii
		elsif tn$=="transcription"
			ipatier=ii
		elsif tn$=="labels"
			transtier=ii
		elsif tn$=="pr_typ"
			conttier=ii
		elsif tn$=="comments"
			commtier=ii
		endif
	endfor
	
	nri=Get number of intervals: soundtier
	for iii to nri
		select tg
		li$=Get label of interval: soundtier, iii
		li$=replace_regex$(li$,"\s|\t|\n|\r","",0)
		li$=replace$(li$,")","",0)
		li$=replace$(li$,"(","",0)
		if (li$!="a" and li$!="i" and li$!="ai" and li$!="o" and li$!="u" and li$!="x" and li$!="i" and li$!="e" and li$!="ẽ" and li$!="r" and li$!="ɨ" and li$!="ʃ" and li$!="š" and li$!="z" and li$!="ž"
			...and li$!="а" and li$!="е" and li$!="о" and li$!="у" and li$!="и" and li$!="1" and li$!="aˤ" and li$!="ũ" and li$!="a'" 
			...and li$!="n" and li$!="n:" and li$!="m" and li$!="h" and li$!="ħ" and li$!="l" and li$!="s" and li$!="χ" and li$!="w" and li$!="j" and li$!="ʁ" and li$!="ʔ" and li$!="aʔ" and li$!="ʡ" and li$!="")
			index+=1
			st=Get start point: soundtier, iii
			et=Get end point: soundtier, iii
			totdur=et-st
			pli$=Get label of interval: soundtier, iii-1
			pli$=replace_regex$(pli$,"\s|\t|\n","",0)
			wi=Get interval at time: ipatier, st
			word$=Get label of interval: ipatier, wi
			word$=replace_regex$(word$,"\t|\n|\r","",0)
			ti=Get interval at time: transtier, st
			transl$=Get label of interval: transtier, ti
			transl$=replace_regex$(transl$,"\t|\n|\r","",0)
			conti=Get interval at time: conttier, st
			cont$=Get label of interval: conttier, conti
			comm$=""
			if startsWith(cont$, "i")==1
				contxt$="iso"
				rep$=right$(cont$, 1)
			else
				contxt$="carrier"
				rep$="--undefined--"
			endif
			fvdur=0
			pvdur=0
			
			fli$=Get label of interval: soundtier, iii+1
			fli$=replace_regex$(fli$,"\s|\t|\n|\r","",0)
			flist=Get start point: soundtier, iii+1
			fliet=Get end point: soundtier, iii+1
			fvdur=fliet-flist
			
			if pli$==""
				posit$="initial"
				pvdur=undefined
				plist=undefined
				pliet=undefined
			elsif fli$==""
				posit$="final"
				fvdur=undefined
				flist=undefined
				fliet=undefined
				plist=Get start point: soundtier, iii-1
				pliet=Get end point: soundtier, iii-1
				pvdur=pliet-plist
			else
				posit$="medial"
				plist=Get start point: soundtier, iii-1
				pliet=Get end point: soundtier, iii-1
				pvdur=pliet-plist
				
				
			endif
				
			f=0
			pf=0
			cd=0
			cv1=0
			cv2=0
			m1=0
			m2=0
			pfst=0
			cv2st=0
			modst=0
			#stop
			stop_part=Extract part: st, et, "yes"
			nri_st=Get number of intervals: cdtier
			for iv to nri_st
				stli$=Get label of interval: cdtier, iv
				stli$=replace_regex$(stli$,"\s|\t|\n|\r","",0)
				stlist=Get start point: cdtier, iv
				stliet=Get end point: cdtier, iv
				dur=stliet-stlist
				if stli$=="cd"
					cd=dur
				elif stli$=="pf"
					pf=dur
					pfst=stlist
				elif stli$=="f"
					f=dur
					reltime=stlist
				elif stli$=="cv"
					cv2=dur
					cv2st=stlist
				endif
			endfor
			Remove
			
			#following vowel
			if posit$!="final"
				select tg
				fvow_part=Extract part: flist, fliet, "yes"
				nri_fv=Get number of intervals: cdtier
				for v to nri_fv
					fvli$=Get label of interval: cdtier, v
					fvlist=Get start point: cdtier, v
					fvliet=Get end point: cdtier, v
					dur=fvliet-fvlist
					if fvli$=="m"
						m2dur=dur
						modst=fvlist
					elif fvli$=="cv"
						cv2=dur
						cv2st=fvlist
					endif
				endfor
				Remove
			endif
			#preceding vowel
			if posit$!="initial"
				select tg
				pvow_part=Extract part: plist, pliet, "yes"
				nri_pv=Get number of intervals: cdtier
				for v to nri_pv
					pvli$=Get label of interval: cdtier, v
					pvlist=Get start point: cdtier, v
					pvliet=Get end point: cdtier, v
					dur=pvliet-pvlist
					if pvli$=="m"
						m1dur=dur
					elif pvli$=="cv"
						cv1=dur
					endif
				endfor
				Remove
			endif
			
			if cv2st==0
				cv2st=undefined
			endif
			if pfst==0
				pfst=undefined
			endif
				
			if pfst==0
				pfst=undefined
			endif	
			
			# brackets
			if (index(fli$,")") > 0 or index(pli$,")") > 0)
				comm$=comm$+"check right border"
			elsif (index(fli$,"(") > 0 or index(pli$,"(") > 0)
				comm$=comm$+"check left border"
			endif
			
			# glottalic vs pulmonic
			if (index(li$,"'") > 0 or index(li$,"’") > 0)
				glott$="glottalic"
			else
				glott$="pulmonic"
			endif
			
			# labialized
			if index(li$,"ʷ") > 0
				lablzd$="labialized"
			else
				lablzd$="non-lablzd"
			endif
			
			#pharyngealized
			if index(li$,"ˤ") > 0
				pharlzd$="pharyngealized"
			else
				pharlzd$="non-pharnglzd"
			endif

			#palatalized
			if index(li$,"ʲ") > 0
				palatlzd$="palatalized"
			else
				palatlzd$="non-palatlzd"
			endif
			
			# POA
			if (index(li$,"g") > 0 or index(li$,"k")> 0)
				poa$="velar"
			elsif (index(li$,"q") > 0 or index(li$,"ɢ")> 0)
				poa$="uvular"
			elsif (index(li$,"b") > 0 or index(li$,"p")> 0)
				poa$="bilabial"
			elsif (index(li$,"d") > 0 or index(li$,"t")> 0)
				poa$="dental"
			endif
			
			# affricate
			if index_regex(li$,"c|ts|tʃ|dǯ|dʒ|dz|tɬ|qχ") > 0
				affric$="affricate"
			else
				affric$="plain"
			endif
			
			# voice
			if index_regex(li$,"c|t|ʃ|x|k|q|p|χ|s|ɬ") > 0
				voiced$="voiceless"
			else
				voiced$="voiced"
			endif
			# geminate
			if index_regex(li$,":|ː") > 0
				gemin$="geminate"
			else
				gemin$="singleton"
			endif
			
			
			appendFileLine: outputf$, index, tab$, str$, tab$, word$, tab$, transl$, tab$, contxt$, tab$, rep$, tab$, posit$, tab$, li$, tab$, poa$, tab$, voiced$, tab$, gemin$, 
			...tab$, affric$, tab$, glott$, tab$, pharlzd$, tab$, lablzd$, tab$, palatlzd$, tab$, fli$, tab$, pli$, tab$, totdur, tab$, fvdur, tab$, pvdur, tab$, f, tab$, pf, tab$, cd,
			...tab$, st, tab$, et, tab$, reltime, tab$, pfst, tab$, cv2st, tab$, modst, tab$, comm$
			
		endif
	endfor
	printline 'str$'...done.
endfor

