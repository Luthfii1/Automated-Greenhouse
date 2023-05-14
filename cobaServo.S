;------------------------
; Assembly Code
;------------------------
#define __SFR_OFFSET 0x00
#include "avr/io.h"
.global main
;---------------------------------------------------------------

;===============================================================
main:
    LDI   R24, 27              ;inititation of value (constant)
    CPI   R24, 20              ; check the value 
    BREQ  skip_servo_motor     ;jump to skip_servo_motor if  equal 
    SBI   DDRB, 4              ;pin PB4 o/p for servo control
    SBI   DDRB, 0              ;PB0 o/p, red LED: pos 0 deg
    SBI   DDRB, 1              ;PB1 o/p, green LED: pos 90 deg
    SBI   DDRB, 2              ;PB2 o/p, blue LED: pos 180 deg

;---------------------------------------------------------------
again:     
    LDI   R25, 1          ;counter for LED control
    LDI   R26, 8          ;counter for  of rotation pos
    LDI   ZL, lo8(rotate_pos)
    LDI   ZH, hi8(rotate_pos)
;-----------------------------------------------------------
l1: LPM   R24, Z+         ;load rotation pos
    RCALL rotate_servo    ;& rotate servo
    DEC   R26
    BRNE  l1              ;go back & get another rotate pos
    ;-----------------------------------------------------------
    RJMP  again           ;go back & repeat

rotate_pos:
.byte 90,110,180,110,90,70
;==============================================================
rotate_servo:
;------------
    LDI   R20, 10         ;count to give enough cycles of PWM
l2: SBI   PORTB, 4
    RCALL delay_timer0
    CBI   PORTB, 4        ;send msec pulse to rotate servo
    DEC   R20
    BRNE  l2              ;go back & repeat PWM signal
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
delay_timer0:             ;delay via Timer0
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCNT0, R21      ;initialize timer0 with count=0
    MOV   R21, R24
    OUT   OCR0A, R21
    LDI   R21, 0b00001100
    OUT   TCCR0B, R21     ;timer0: CTC mode, prescaler 256
    ;-----------------------------------------------------------
l3: IN    R21, TIFR0      ;get TIFR0 byte & check
    SBRS  R21, OCF0A      ;if OCF0=1, skip next instruction
    RJMP  l3              ;else, loop back & check OCF0 flag
    ;-----------------------------------------------------------
    CLR   R21
    OUT   TCCR0B, R21     ;stop timer0
    ;-----------------------------------------------------------
    LDI   R21, (1<<OCF0A)
    OUT   TIFR0, R21      ;clear OCF0 flag
    RET
;===============================================================
delay_20ms:               ;delay 20ms
    LDI   R21, 255
l4: LDI   R22, 210
l5: LDI   R23, 2
l6: DEC   R23
    BRNE  l6
    DEC   R22
    BRNE  l5
    DEC   R21
    BRNE  l4
    RET
;===============================================================
delay_ms:                 ;delay 0.5s
    LDI   R21, 255
l7 :LDI   R22, 255
l8 :LDI   R23, 41
l9 :DEC   R23
    BRNE  l9
    DEC   R22
    BRNE  l8
    DEC   R21
    BRNE  l7
    RET

skip_servo_motor:
  RET