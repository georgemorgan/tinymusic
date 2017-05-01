all:
	avr-gcc -nostdlib -mmcu=attiny10 main.S -o main.elf
	avr-objcopy -O ihex main.elf main.hex
write: all
	avrdude -pt10 -c usbtiny -U flash:w:main.hex
dump:
	avr-objdump -D main.elf
clean:
	rm -rf *.elf *.hex
