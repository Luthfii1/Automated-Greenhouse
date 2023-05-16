;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;=================CHANGE================
;#include "avr/interrupt.h"
;=================END CHANGE================
;------------------------
.global main
;=================CHANGE================
;.org 0x0000
;  rjmp main
.org 0x0004
;  jmp interupsi
;.org 0x1000
;=================END CHANGE================

main:
;=================CHANGE================
;sbi DDRD, 6 ; Set PORTD4 as input with pull-up enabled (interrupt pin)
;sbi PORTD, 6
;ldi R16, (1 << ISC11); Configure ISC11 to trigger on falling edge
;sts EICRA, R16
;ldi R16, (1 << INT1) ; Enable INT1
;STS EIMSK, R16
;SEI; Enable global interrupts
;=================END CHANGE================

RCALL SPI_MAX7219_init
RCALL MAX7219_disp_text
agn: 
RCALL DHT11_sensor
RCALL check 
RJMP agn

;=================================================================
DHT11_sensor: 
;-----------------------------------------------------------------
RCALL delay_2s      ;wait 2s for DHT11 to get ready
;-----------------------------------------------------------------
;start_signal
;------------
    SBI   DDRD, 7       ;pin PD7 as o/p
    CBI   PORTD, 7      ;first, send low pulse
    RCALL delay_20ms    ;for 20ms
    SBI   PORTD, 7      ;then send high pulse
;-----------------------------------------------------------------
;response signal
;---------------
    CBI   DDRD, 7       ;pin PD7 as i/p
w1: SBIC  PIND, 7
    RJMP  w1            ;wait for DHT11 low pulse
w2: SBIS  PIND, 7
    RJMP  w2            ;wait for DHT11 high pulse
w3: SBIC  PIND, 7
    RJMP  w3            ;wait for DHT11 low pulse
;-----------------------------------------------------------------
    RCALL DHT11_reading ;read humidity (1st byte of 40-bit data)
    MOV   R25, R24
    RCALL DHT11_reading
    RCALL DHT11_reading ;read temp (3rd byte of 40-bit data)
;-----------------------------------------------------------------
;convert temp & humidity bytes to decimal & display on MAX7219
;-------------------------------------------------------------
    MOV   R28, R24
    MOV   R31, R24
    RCALL check 
    LDI   R29, 0x07
    LDI   R30, 0x06
    ;-------------------
    RCALL binary2decimal  ;temp in decimal
    ;-------------------
    MOV   R28, R25
    LDI   R29, 0x02
    LDI   R30, 0x01
    ;-------------------
    RCALL binary2decimal  ;humidity in decimal
    ;-------------------
    ;COMPARE THE OUTPUT 
    ;-------------------
    check:
    CPI   R31, 30
    BRLO  skip_servo
    CBI   PORTD, 5
    RCALL servo_motor

    skip_servo:  
    CBI   PORTD, 4
    CPI   R31, 20
    BRGE  skip_led
    SBI   PORTD, 5
    RET

    skip_led:
    CBI   PORTD, 5
    RET          ;go back & get another sensor reading

;=================================================================
DHT11_reading:
    LDI   R16, 8        ;set counter for receiving 8 bits
    CLR   R24           ;clear data register
    ;-------------------------------------------------------
w4: SBIS  PIND, 7
    RJMP  w4            ;detect data bit (high pulse)
    RCALL delay_timer0  ;wait 50us & then check bit value
    ;-------------------------------------------------------
    SBIS  PIND, 7       ;if received bit=1, skip next inst
    RJMP  skp           ;else, received bit=0, jump to skp
    SEC                 ;set carry flag (C=1)
    ROL   R24           ;shift in 1 into LSB data register
    RJMP  w5            ;jump & wait for low pulse
skp:LSL   R24           ;shift in 0 into LSB data register
    ;-------------------------------------------------------
w5: SBIC  PIND, 7
    RJMP  w5            ;wait for DHT11 low pulse
    ;-------------------------------------------------------
    DEC   R16           ;decrement counter
    BRNE  w4            ;go back & detect next bit
    RET                 ;return to calling subroutine
;=================================================================
;delay subroutines
;=================================================================
delay_20ms:             ;delay 20ms
    LDI   R21, 255
l3: LDI   R22, 210
l4: LDI   R23, 2
l5: DEC   R23
    BRNE  l5
    DEC   R22
    BRNE  l4
    DEC   R21
    BRNE  l3
    RET
;-----------------------------------------------------------------
delay_2s:               ;delay 2s
    LDI   R21, 255
l6: LDI   R22, 255
l7: LDI   R23, 164
l8: DEC   R23
    BRNE  l8
    DEC   R22
    BRNE  l7
    DEC   R21
    BRNE  l6
    RET
;===============================================================
delay_timer0:             ;50 usec delay via Timer 0
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCNT0, R20      ;initialize timer0 with count=0
    LDI   R20, 100
    OUT   OCR0A, R20      ;OCR0 = 100
    LDI   R20, 0b00001010
    OUT   TCCR0B, R20     ;timer0: CTC mode, prescaler 64
    ;---------------------------------------------------------
l2: IN    R20, TIFR0      ;get TIFR0 byte & check
    SBRS  R20, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l2              ;else, loop back & check OCF0 flag
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCCR0B, R20     ;stop timer0
    ;---------------------------------------------------------
    LDI   R20, (1<<OCF0A)
    OUT   TIFR0, R20      ;clear OCF0 flag
    RET
;===============================================================
;MAX7219 subroutines
;===============================================================
SPI_MAX7219_init:
;----------------
SBI   DDRD, 4       ;pin PD4 as o/p buzzer 
SBI   DDRD, 5       ;pin PD5 as o/p LED
.equ  SCK, 5
.equ  MOSI, 3
.equ  SS, 2
;--------------------------------------------------------------
      LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
      OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
      ;--------------------------------------------------------
      
      LDI   R17, (1<<SPIE)|(1<<SPE)|(1<<MSTR)|(1<<SPR0)
      OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
      ;--------------------------------------------------------
      LDI   R17, 0x0A       ;set segment intensity (0 to 15)
      LDI   R18, 8          ;intensity level = 8
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x09       ;set decoding mode command
      LDI   R18, 0b01100011 ;decoding byte
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x0B       ;set scan limit command
      LDI   R18, 0x07       ;8 digits connected to MAX7219
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x0C       ;set turn ON/OFF command
      LDI   R18, 0x01       ;turn ON MAX7219
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      RET
;==============================================================
MAX7219_disp_text:
;-----------------
      LDI   R17, 0x08       ;select digit 7
      LDI   R18, 0x0F       ;data = t
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x05       ;select digit 4
      LDI   R18, 0x4E       ;data = C
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x04       ;select digit 3
      LDI   R18, 0x00       ;data = space
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      LDI   R17, 0x03       ;select digit 2
      LDI   R18, 0x17       ;data = h
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      RET
;==============================================================
send_bytes:
      CBI   PORTB, SS       ;enable slave device MAX7219
      OUT   SPDR, R17       ;transmit command
      ;--------------------------------------------------------
ll2:  IN    R19, SPSR
      SBRS  R19, SPIF       ;wait for byte transmission
      RJMP  ll2             ;to complete
      ;--------------------------------------------------------
      OUT   SPDR, R18       ;transmit data
      ;--------------------------------------------------------
ll3:  IN    R19, SPSR
      SBRS  R19, SPIF       ;wait for byte transmission
      RJMP  ll3             ;to complete
      ;--------------------------------------------------------
      SBI   PORTB, SS       ;disable slave device MAX7219
      RET
;==============================================================
binary2decimal:
;--------------
      CLR   R26             ;set counter1, initial value 0
      CLR   R27             ;set counter2, initial value 0
      ;--------------------------------------------------------
l70:  CPI   R28, 100        ;compare R28 with 100
Ret:  BRMI  l80             ;jump when R28 < 100
      INC   R26             ;increment counter1 by 1
      SUBI  R28, 100        ;R28 = R28 - 100
      RJMP  l70
      ;--------------------------------------------------------
l80:  CPI   R28, 10         ;compare R28 with 10
      BRMI  dsp             ;jump when R28 < 10
      INC   R27             ;increment counter2 by 1
      SUBI  R28, 10         ;R28 = R28 - 10
      RJMP  l80
      ;--------------------------------------------------------  
dsp:  MOV   R18, R27
      MOV   R17, R29        ;select digit
      RCALL send_bytes      ;send command & data to MAX7219
      ;--------------------------------------------------------
      MOV   R18, R28
      MOV   R17, R30        ;select digit
      RCALL send_bytes      ;send command & data to MAX7219    
      ;--------------------------------------------------------
      RET

servo_motor:
  CPI   R31, 40
  BRLO  skip_buzzer
  SBI   PORTD, 4    ;output buzzer

skip_buzzer:
  LDI   R17, 0
  OUT   SPCR, R17       ;enable SPI as master, fsck=fosc/16
  SBI   DDRB, 4         ;pin PB4 o/p for servo control

;---------------------------------------------------------------
again_servo:     
    LDI   R26, 8          ;counter for # of rotation pos
    LDI   ZL, lo8(rotate_pos)
    LDI   ZH, hi8(rotate_pos)
    ;-----------------------------------------------------------
ls1: LPM   R24, Z+         ;load rotation pos
    RCALL rotate_servo    ;& rotate servo
    DEC   R26
    BRNE  ls1              ;go back & get another rotate pos
    ;-----------------------------------------------------------
    RJMP SPI_MAX7219_init           ;go back & repeat
;---------------------------------------------------------------
rotate_pos:
.byte 40,70,90,110,180,110,90,70
;===============================================================
rotate_servo:
;------------
    LDI   R20, 10         ;count to give enough cycles of PWM
    SBI DDRB, 1
ls2: SBI   PORTB, 4
    RCALL delay_timer0_servo
    CBI   PORTB, 4        ;send msec pulse to rotate servo
    RCALL delay_20ms_servo      ;wait 20ms before re-sending pulse
    DEC   R20
    BRNE  ls2              ;go back & repeat PWM signal
    ;-----------------------------------------------------------
bak:RCALL delay_ms        ;0.5s delay
    RET                   ;& return to main subroutine
;-------------------
;===============================================================
;delay subroutines
;===============================================================
delay_timer0_servo:             ;delay via Timer0
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCNT0, R21      ;initialize timer0 with count=0
    MOV   R21, R24
    OUT   OCR0A, R21
    LDI   R21, 0b00001100
    OUT   TCCR0B, R21     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
ls3: IN    R21, TIFR0      ;get TIFR0 byte & check
    SBRS  R21, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  ls3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCCR0B, R21     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R21, (1<<OCF0A)
    OUT   TIFR0, R21      ;clear OCF0 flag
    RET
;===============================================================
delay_20ms_servo:               ;delay 20ms
    LDI   R21, 255
ls4: LDI   R22, 210
ls5: LDI   R23, 2
ls6: DEC   R23
    BRNE  ls6
    DEC   R22
    BRNE  ls5
    DEC   R21
    BRNE  ls4
    RET
;===============================================================
delay_ms:                 ;delay 0.5s
    LDI   R21, 255
ls7 :LDI   R22, 255
ls8 :LDI   R23, 41
ls9 :DEC   R23
    BRNE  ls9
    DEC   R22
    BRNE  ls8
    DEC   R21
    BRNE  ls7
    RET

;=================CHANGE================
;interupsi: ; ini adalah subrutin yang dilakukan untuk mengaktifkan interrupt
;  SBI PORTD, 4;Turn on buzzer
;  sbi EIFR, INTF1 ;Clear INT1 Flag
;  reti ;Return dari interrupt
;=================END CHANGE================