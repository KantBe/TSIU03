7. Challenges
- Low-pass filter.
	Should we just use a rolling average ? Use a more complex filter (FIR ?) ? Should we design the filter ourseves or use recognized filters ?
- VGA output.
	How will we draw the output of the "Visualization block" to the VGA screen ?
- Log scale.
	How to use a log scale in VHDL when numbers are represented using binary digits ?

- Intro design specification
	We are going to create a system on the DE2-115 board to analyse a stereo sound signal. Two bar diagrams indicating the magnitude in dB for each output channel will be display on a VGA screen. We want to put colours on the diagrams according the sound level and increment a game using the keyboard and the variations of the diagrams.
