#include <avr/io.h>

; # - Interrupt Vectors - #

                        ; Jump to the initialization code.

reset:					rjmp init

interrupt_0:			reti

pin_change_0:			reti

timer_capture:          reti

timer_overflow:         rjmp ovf_isr

timer_compare_a:		reti

timer_compare_b:		reti

analog_compare:         reti

watchdog:				reti

voltage_change:         reti

adc_complete:			reti

; # - Initialize the hardware. - #

init:

	cli

	wdr

	in r16, RSTFLR
	andi r16, ~(1 << WDRF)
	out RSTFLR, r16

	ldi r16, (1 << PB2) | (1 << PB1)
	out DDRB, r16
	out PORTB, r16

	; ~ Unlock the CLKPSR register by writing the appropriate unlock signature (0xD8) to the CCP. ~
    ldi r16, 0xD8
    out CCP, r16
    ; ~ Prescale the internal clock to 1x. ~
    ldi r16, (1 << CLKPS0)
    out CLKPSR, r16

	ldi r16, (1 << COM0B0)
	out TCCR0A, r16
    ; ~ Clear counter register on compare match. Configure the timer with a 1/1024 prescaler. Start the timer. ~
    ldi r16, (1 << WGM02) | (1 << WGM01) | (1 << WGM00) | (1 << CS00)
    out TCCR0B, r16

	ldi r16, 100
	out OCR0AL, r16

	ldi r16, 10
	out OCR0BL, r16

    ; ~ Enable the timer compare match interrupt. ~
    ldi r16, (1 << TOIE0)
	out TIMSK0, r16

	sei

	ldi r20, 20

loop:
	rjmp loop

ovf_isr:

;	in r16, PORTB
;	ldi r17, (1 << PB1)
;	eor r16, r17
;	out PORTB, r16

	in r16, TIFR0
	andi r16, (1 << OCF0B)
	tst r16
	breq _ovf_b

	in r16, OCR0AL
	sub r16, r20
	out OCR0AL, r16

	reti

;	in r16, OCR0AH
;	adc r16, r17
;	out OCR0AH, r16

_ovf_b:

	in r16, PORTB
	ldi r17, (1 << PB2)
	eor r16, r17
	out PORTB, r16

	ldi r16, 10
	add r20, r16

	reti
