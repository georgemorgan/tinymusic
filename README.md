tinymusic
===

This project is just a fun attempt at using the Timer/Counter0 in an ATTiny10 chip to create a basic audio synthesizer.

Currently, a PWM signal is produced on PB2 and modulated to create a RMS sin wave. By changing OCR0A during each overflow interrupt, the pitch of the sound generated can be changed by incrementing the value of OCR0A.
