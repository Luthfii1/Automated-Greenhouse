;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
;------------------------
.global main
main:
RCALL SPI_MAX7219_init
RCALL MAX7219_disp_text
RCALL DHT11_sensor

;=================================================================
DHT11_sensor:
;-----------------------------------------------------------------
agn:RCALL delay_20ms      ;wait 2s for DHT11 to get ready   (CHANGE FROM 2S to 20ms)
;-----------------------------------------------------------------
;start_signal
;------------
    SBI   DDRB, 4       ; pin PD7 as o/p
    SBI   PORTB, 4  
    SBI   DDRD, 7       ;pin PD7 as o/p
    CBI   PORTD, 7      ;first, send low pulse
    RCALL delay_20ms    ;for 20ms
    SBI   PORTD, 7      ;then send high pulse
;-----------------------------------------------------------------
;responce signal
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
    LDI   R29, 0x07
    LDI   R30, 0x06
    ;-------------------
    RCALL binary2decimal  ;temp in decimal
    MOV R31, R27   ;(PULUHAN)
    MOV R23, R28   ;(SATUAN)

    ;-------------------
    MOV   R28, R25
    LDI   R29, 0x02
    LDI   R30, 0x01
    ;-------------------
    RCALL binary2decimal  ;humidity in decimal
    ;-------------------
    RCALL check_data      ;check the value of the temperature
    RJMP  agn           ;go back & get another sensor reading
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
.equ  SCK, 5
.equ  MOSI, 3
.equ  SS, 2
;--------------------------------------------------------------
      LDI   R17, (1<<MOSI)|(1<<SCK)|(1<<SS)
      OUT   DDRB, R17       ;set MOSI, SCK, SS as o/p
      ;--------------------------------------------------------
      LDI   R17, (1<<SPE)|(1<<MSTR)|(1<<SPR0)
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
      INC   R27             ;increment counter2 by 1 (R27 = PULUHAN)
      SUBI  R28, 10         ;R28 = R28 - 10  (R28 = SATUAN)
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

;=======================To Check Data==========================
;=============And Compare============to Turn on the servo======
check_data: CPI R31, 2                    ; Check the MSB to two
            BRMI skip_servo_motor         ; Jump when (dozens < 2) and the servo will be turn off
            BREQ  check_second_digit      ; jump to check_second_digit if equal to two
            SBI DDRB, 4                   ; pin PB4 o/p for servo control 
            RCALL turn_on_servo           ; turn on the servo

check_second_digit: CPI R23, 5            ; Check the LSB to five
                    BRMI skip_servo_motor ; Jump when (unit < 5) and the servo will be turn off
                    RCALL turn_on_servo   ; Turn on the servo if equal or higher than 5

;Servo will not turn on
skip_servo_motor: RET

;---------------------------------------------------------------
turn_on_servo:     
    LDI   R25, 1          ;counter for LED control
    LDI   R26, 8          ;counter for # of rotation pos
    LDI   ZL, lo8(rotate_pos)
    LDI   ZH, hi8(rotate_pos)
    RCALL l1
    ;-----------------------------------------------------------
l1: LPM   R24, Z+         ;load rotation pos
    RCALL rotate_servo    ;& rotate servo
    DEC   R26
    BRNE  l1              ;go back & get another rotate pos
    ;-----------------------------------------------------------
    RJMP agn           ;go back & repeat

rotate_pos:
.byte 180, 90, 180, 90
;==============================================================
rotate_servo:
;------------
    LDI   R20, 10         ;count to give enough cycles of PWM
loop2: SBI   PORTB, 4
    RCALL delay_timer1
    CBI   PORTB, 4        ;send msec pulse to rotate servo
    DEC   R20
    BRNE  loop2              ;go back & repeat PWM signal
    ;-----------------------------------------------------------
    CPI   R25, 1
    CPI   R25, 3
    CPI   R25, 5
    CPI   R25, 7
bak:RCALL delay_ms        ;0.5s delay
    INC   R25
    RET                   ;& return to main subroutine
;===============================================================
;delay subroutines
;===============================================================
delay_timer1:             ;delay via Timer0
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCNT0, R21      ;initialize timer0 with count=0
    MOV   R21, R24
    OUT   OCR0A, R21
    LDI   R21, 0b00001100
    OUT   TCCR0B, R21     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
loop3: IN    R21, TIFR0      ;get TIFR0 byte & check
    SBRS  R21, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  loop3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCCR0B, R21     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R21, (1<<OCF0A)
    OUT   TIFR0, R21      ;clear OCF0 flag
    RET
;===============================================================

delay_20mss:               ;delay 20ms
    LDI   R21, 255
loop4: LDI   R22, 210
loop5: LDI   R23, 2
loop6: DEC   R23
    BRNE  loop6
    DEC   R22
    BRNE  loop5
    DEC   R21
    BRNE  loop4
    RET
;===============================================================
delay_ms:                 ;delay 0.5s
    LDI   R21, 255
loop7 :LDI   R22, 255
loop8 :LDI   R23, 41
l9 :DEC   R23
    BRNE  l9
    DEC   R22
    BRNE  loop8
    DEC   R21
    BRNE  loop7
    RET