beginPause: "Script spectral analyses - fricatives and stops"
comment: "Leave empty to select with the browser your path"
sentence: "parent_directory", ""
comment: "What is the name of your results file?"
  	sentence: "results", "spectralResults"
  	comment: "Tier number"
  		positive: "tier", "1"
	comment: "Parameters"
		optionMenu: "Filter", 1
			option: "yes"
			option: "no"
		real: "Min frequency (Hz)", "500"
		positive: "Max frequency (Hz)", "12000"
	comment: "Peak frequency range"
		positive: "Min frequency peak (Hz)", "750"
		positive: "Max frequency peak (Hz)", "8000"
clicked = endPause: "OK", 1

clearinfo

if parent_directory$ = ""
	parent_directory$ = chooseDirectory$("Select your directory of sound files and TextGrids")
endif

createDirectory: "spectra"

Create Strings as file list: "list", "'parent_directory$'\*.wav"
nbFiles = Get number of strings

appendFileLine: "'results$'.xls", "fileName", tab$, "phoneme", tab$, "start", tab$, "startAfter", tab$, "midBefore", tab$, 
... "midAfter", tab$, "endBefore", tab$, "end", tab$, "duration", tab$, "durationMS", tab$, "cogStart", tab$, "sdevStart", tab$, 
... "skewStart", tab$, "kurtStart", tab$, "levelMStartPa", tab$, "levelMStartdB", tab$, "levelHStartPa", tab$, "levelHStartdB", tab$, "levelDStartdB", tab$,
... "peakAmpdBStart", tab$, "peakFreqHzStart", tab$, "ampLStart", tab$, "ampMStart", tab$, "dynamicAmpStart", tab$, "tiltBurst", tab$, "cogMid", tab$, 
... "sdevMid", tab$, "skewMid", tab$, "kurtMid", tab$, "levelMMidPa", tab$, "levelMMiddB", tab$, "levelHMidPa", tab$, 
... "levelHMiddB", tab$, "levelDMiddB", tab$, "peakAmpdBMid", tab$, "peakFreqHzMid", tab$, "ampLMid", tab$, "ampMMid", tab$, "dynamicAmpMid", tab$,
... "cogEnd", tab$, "sdevEnd", tab$, "skewEnd", tab$, "kurtEnd", tab$, "levelMEndPa", tab$, "levelMEnddB", tab$, 
... "levelHEndPa", tab$, "levelHEnddB", tab$, "levelDEnddB", tab$, "peakAmpdBEnd", tab$, "peakFreqHzEnd", tab$, "ampLEnd", tab$, 
... "ampMEnd", tab$, "dynamicAmpEnd", tab$,
... "cogWhole", tab$, "sdevWhole", tab$, "skewWhole", tab$, "kurtWhole", tab$, "levelMWholePa", tab$, "levelMWholedB", tab$, 
... "levelHWholePa", tab$, "levelHWholedB", tab$, "levelDWholedB", tab$, "peakAmpdBWhole", tab$, "peakFreqHzWhole", tab$, "ampLWhole", tab$, 
... "ampMWhole", tab$, "dynamicAmpWhole"

for i from 1 to nbFiles
select Strings list
	fileName$ = Get string: i
	Read from file: "'parent_directory$'/'fileName$'"
	soundID$ = selected$("Sound")
	Read from file: "'parent_directory$'/'soundID$'.TextGrid"
	nbInterval = Get number of intervals: tier
	for j to nbInterval
		selectObject: "TextGrid 'soundID$'"
		label$ = Get label of interval: tier, j
		if label$ <> ""
			start = Get starting point: tier, j
			startAfter = start + 0.0256
			end = Get end point: tier, j
			endBefore = end - 0.0256
			duration = end - start
			durationMS = duration * 1000
			mid = start + (duration/2)
			midBefore = mid - 0.0128
			midAfter = mid + 0.0128
			burstBefore = mid - 0.0128
			burstAfter = mid + 0.0128
			wholeBefore = start + (duration * 0.1)
			wholeAfter = end - (duration * 0.1)

			cogStart = undefined
			cogMid = undefined
			cogEnd = undefined
			cogWhole = undefined
			sdevStart = undefined
			sdevMid = undefined
			sdevEnd = undefined
			sdevWhole = undefined
			skewStart = undefined
			skewMid = undefined
			skewEnd = undefined
			skewWhole = undefined
			kurtStart = undefined
			kurtMid = undefined
			kurtEnd = undefined
			kurtWhole = undefined
			levelMStartPa = undefined
			levelHStartPa = undefined
			levelMStartdB = undefined
			levelHStartdB = undefined
			levelMMidPa = undefined
			levelHMidPa = undefined
			levelMMiddB = undefined
			levelHMiddB = undefined
			levelMEndPa = undefined
			levelHEndPa = undefined
			levelMEnddB = undefined
			levelHEnddB = undefined
			levelMWholePa = undefined
			levelHWholePa = undefined
			levelMWholedB = undefined
			levelHWholedB = undefined
			peakAmpdBStart = undefined
			peakFreqHzStart = undefined
			ampLStart = undefined
			ampMStart = undefined
			dynamicAmpStart = undefined
			peakAmpdBMid = undefined
			peakFreqHzMid = undefined
			ampLMid = undefined
			ampMMid = undefined
			dynamicAmpMid = undefined
			peakAmpdBEnd = undefined
			peakFreqHzEnd = undefined
			ampLEnd = undefined
			ampMEnd = undefined
			dynamicAmpEnd = undefined
			peakAmpdBWhole = undefined
			peakFreqHzWhole = undefined
			ampLWhole = undefined
			ampMWhole = undefined
			dynamicAmpWhole = undefined
			levelDStartdB = undefined
			levelDMiddB = undefined
			levelDEnddB = undefined
			levelDWholedB = undefined
			tiltBurst = undefined
			
			if label$ = "s"
				# Start
				selectObject: "Sound 'soundID$'"
				Extract part: start, startAfter, "Kaiser1", 1, "no"
				if filter = 1
					resampleFrequency = max_frequency * 2
					Resample: resampleFrequency, 50
					Filter (pass Hann band): min_frequency, max_frequency, 100
				endif
				To Spectrum: "yes"
				Cepstral smoothing: 1000
				cogStart = Get centre of gravity: 2
				sdevStart = Get standard deviation: 2
				skewStart = Get skewness: 2
				kurtStart = Get kurtosis: 2
				levelMStartPa = Get band energy: 3000, 7000
				levelMStartPaLevel = levelMStartPa/0.0256
				levelMStartdB = 10*log10((levelMStartPaLevel/0.00002)^2)
				levelHStartPa = Get band energy: 7000, 11025
				levelHStartPaLevel = levelHStartPa/0.0256
				levelHStartdB = 10*log10((levelHStartPaLevel/0.00002)^2)
				levelDStartdB = levelMStartdB - levelHStartdB

				Write to binary file: parent_directory$ + "/spectra" + "/" + "'soundID$'_'j'_'label$'_start" + ".Spectrum"

				To Ltas (1-to-1)
				peakAmpdBStart = Get maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				peakFreqHzStart = Get frequency of maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				ampLStart = Get minimum: 550, 3000, "Parabolic"
				ampMStart = Get mean: 3000, 7000, "dB"
				dynamicAmpStart = ampMStart - ampLStart

				# Mid
				selectObject: "Sound 'soundID$'"
				Extract part: midBefore, midAfter, "Kaiser1", 1, "no"
				if filter = 1
					resampleFrequency = max_frequency * 2
					Resample: resampleFrequency, 50
					Filter (pass Hann band): min_frequency, max_frequency, 100
				endif
				To Spectrum: "yes"
				Cepstral smoothing: 1000
				cogMid = Get centre of gravity: 2
				sdevMid = Get standard deviation: 2
				skewMid = Get skewness: 2
				kurtMid = Get kurtosis: 2
				levelMMidPa = Get band energy: 3000, 7000
				levelMMidPaLevel = levelMMidPa/0.0256
				levelMMiddB = 10*log10((levelMMidPaLevel/0.00002)^2)
				levelHMidPa = Get band energy: 7000, 11025
				levelHMidPaLevel = levelHMidPa/0.0256
				levelHMiddB = 10*log10((levelHMidPaLevel/0.00002)^2)
				levelDMiddB = levelMMiddB - levelHMiddB

				Write to binary file: parent_directory$ + "/spectra" + "/" + "'soundID$'_'j'_'label$'_mid" + ".Spectrum"

				To Ltas (1-to-1)
				peakAmpdBMid = Get maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				peakFreqHzMid = Get frequency of maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				ampLMid = Get minimum: 550, 3000, "Parabolic"
				ampMMid = Get mean: 3000, 7000, "dB"
				dynamicAmpMid = ampMMid - ampLMid


				# End
				selectObject: "Sound 'soundID$'"
				Extract part: endBefore, end, "Kaiser1", 1, "no"
				if filter = 1
					resampleFrequency = max_frequency * 2
					Resample: resampleFrequency, 50
					Filter (pass Hann band): min_frequency, max_frequency, 100
				endif
				To Spectrum: "yes"
				Cepstral smoothing: 1000
				cogEnd = Get centre of gravity: 2
				sdevEnd = Get standard deviation: 2
				skewEnd = Get skewness: 2
				kurtEnd = Get kurtosis: 2
				levelMEndPa = Get band energy: 3000, 7000
				levelMEndPaLevel = levelMEndPa/0.0256
				levelMEnddB = 10*log10((levelMEndPaLevel/0.00002)^2)
				levelHEndPa = Get band energy: 7000, 11025
				levelHEndPaLevel = levelHEndPa/0.0256
				levelHEnddB = 10*log10((levelHEndPaLevel/0.00002)^2)
				levelDEnddB = levelMEnddB - levelHEnddB

				Write to binary file: parent_directory$ + "/spectra" + "/" + "'soundID$'_'j'_'label$'_end" + ".Spectrum"

				To Ltas (1-to-1)
				peakAmpdBEnd = Get maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				peakFreqHzEnd = Get frequency of maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				ampLEnd = Get minimum: 550, 3000, "Parabolic"
				ampMEnd = Get mean: 3000, 7000, "dB"
				dynamicAmpEnd = ampMEnd - ampLEnd


				# Whole
				selectObject: "Sound 'soundID$'"
				Extract part: wholeBefore, wholeAfter, "Kaiser1", 1, "no"
				if filter = 1
					resampleFrequency = max_frequency * 2
					Resample: resampleFrequency, 50
					Filter (pass Hann band): min_frequency, max_frequency, 100
				endif
				To Spectrum: "yes"
				Cepstral smoothing: 1000
				cogWhole = Get centre of gravity: 2
				sdevWhole = Get standard deviation: 2
				skewWhole = Get skewness: 2
				kurtWhole = Get kurtosis: 2
				levelMWholePa = Get band energy: 3000, 7000
				levelMWholePaLevel = levelMWholePa/0.0256
				levelMWholedB = 10*log10((levelMWholePaLevel/0.00002)^2)
				levelHWholePa = Get band energy: 7000, 11025
				levelHWholePaLevel = levelHWholePa/0.0256
				levelHWholedB = 10*log10((levelHWholePaLevel/0.00002)^2)
				levelDWholedB = levelMWholedB - levelHWholedB

				Write to binary file: parent_directory$ + "/spectra" + "/" + "'soundID$'_'j'_'label$'_whole" + ".Spectrum"

				To Ltas (1-to-1)
				peakAmpdBWhole = Get maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				peakFreqHzWhole = Get frequency of maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				ampLWhole = Get minimum: 550, 3000, "Parabolic"
				ampMWhole = Get mean: 3000, 7000, "dB"
				dynamicAmpWhole = ampMWhole - ampLWhole
			
			elsif label$ = "B"
				# Burst
				selectObject: "Sound 'soundID$'"
				Extract part: burstBefore, burstAfter, "Kaiser1", 1, "no"
				if filter = 1
					resampleFrequency = max_frequency * 2
					Resample: resampleFrequency, 50
					Filter (pass Hann band): min_frequency, max_frequency, 100
				endif
				To Spectrum: "yes"
				Cepstral smoothing: 1000
				cogStart = Get centre of gravity: 2
				sdevStart = Get standard deviation: 2
				skewStart = Get skewness: 2
				kurtStart = Get kurtosis: 2
				levelMStartPa = Get band energy: 3000, 7000
				levelMStartPaLevel = levelMStartPa/0.0256
				levelMStartdB = 10*log10((levelMStartPaLevel/0.00002)^2)
				levelHStartPa = Get band energy: 7000, 11025
				levelHStartPaLevel = levelHStartPa/0.0256
				levelHStartdB = 10*log10((levelHStartPaLevel/0.00002)^2)
				levelDStartdB = levelMStartdB - levelHStartdB
				# for Ahi-A23
				tiltBurst = Get band energy difference: 1250, 3000, 3000, 8000
				Write to binary file: parent_directory$ + "/spectra" + "/" + "'soundID$'_'j'_'label$'_Burst" + ".Spectrum"

				To Ltas (1-to-1)
				peakAmpdBStart = Get maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				peakFreqHzStart = Get frequency of maximum: min_frequency_peak, max_frequency_peak, "Parabolic"
				ampLStart = Get minimum: 550, 3000, "Parabolic"
				ampMStart = Get mean: 3000, 7000, "dB"
				dynamicAmpStart = ampMStart - ampLStart

			endif
			appendFileLine: "'results$'.xls", fileName$, tab$, label$, tab$, start, tab$, startAfter, tab$, midBefore, tab$, 
		... midAfter, tab$, endBefore, tab$, end, tab$, duration, tab$, durationMS, tab$, cogStart, tab$, sdevStart, tab$, 
		... skewStart, tab$, kurtStart, tab$, levelMStartPa, tab$, levelMStartdB, tab$, levelHStartPa, tab$, levelHStartdB, tab$, levelDStartdB, tab$,
		... peakAmpdBStart, tab$, peakFreqHzStart, tab$, ampLStart, tab$, ampMStart, tab$, dynamicAmpStart, tab$, 
		...	tiltBurst, tab$, cogMid, tab$, 
		... sdevMid, tab$, skewMid, tab$, kurtMid, tab$, levelMMidPa, tab$, levelMMiddB, tab$, levelHMidPa, tab$, 
		... levelHMiddB, tab$, levelDMiddB, tab$, peakAmpdBMid, tab$, peakFreqHzMid, tab$, ampLMid, tab$, ampMMid, tab$, dynamicAmpMid, tab$,
		... cogEnd, tab$, sdevEnd, tab$, skewEnd, tab$, kurtEnd, tab$, levelMEndPa, tab$, levelMEnddB, tab$, 
		... levelHEndPa, tab$, levelHEnddB, tab$, levelDEnddB, tab$, peakAmpdBEnd, tab$, peakFreqHzEnd, tab$, ampLEnd, tab$, 
		... ampMEnd, tab$, dynamicAmpEnd, tab$,
		... cogWhole, tab$, sdevWhole, tab$, skewWhole, tab$, kurtWhole, tab$, levelMWholePa, tab$, levelMWholedB, tab$, 
		... levelHWholePa, tab$, levelHWholedB, tab$, levelDWholedB, tab$, peakAmpdBWhole, tab$, peakFreqHzWhole, tab$, ampLWhole, tab$, 
		... ampMWhole, tab$, dynamicAmpWhole
		endif
	endfor
select all
minus Strings list
Remove
endfor
echo finished :)
