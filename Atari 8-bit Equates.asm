;Atari Hardware Registers
;File version 1.03
;2005-01-02 17:47:15
;Register names based on PDF specifications
;---------------------------------------
;HARDWARE
;CPU vectors
NMIV	= $FFFA 	;NMI vector
RESETV	= $FFFC 	;RESET vector
IRQV	= $FFFE 	;IRQ vector

;GTIA Write
GTIA	= $D000
HPOSP0	= $D000
HPOSP1	= $D001
HPOSP2	= $D002
HPOSP3	= $D003
HPOSM0	= $D004
HPOSM1	= $D005
HPOSM2	= $D006
HPOSM3	= $D007
SIZEP0	= $D008
SIZEP1	= $D009
SIZEP2	= $D00A
SIZEP3	= $D00B
SIZEM	= $D00C
GRAFP0	= $D00D
GRAFP1	= $D00E
GRAFP2	= $D00F
GRAFP3	= $D010
GRAFM	= $D011
COLPM0	= $D012
COLPM1	= $D013
COLPM2	= $D014
COLPM3	= $D015
COLPF0	= $D016
COLPF1	= $D017
COLPF2	= $D018
COLPF3	= $D019
COLBAK	= $D01A
COLBK	= $D01A 	;alias of COLBAK
PRIOR	= $D01B
VDELAY	= $D01C
GRACTL	= $D01D
HITCLR	= $D01E
CONSOL	= $D01F

;GTIA Read
M0PF	= $D000
M1PF	= $D001
M2PF	= $D002
M3PF	= $D003
P0PF	= $D004
P1PF	= $D005
P2PF	= $D006
P3PF	= $D007
M0PL	= $D008
M1PL	= $D009
M2PL	= $D00A
M3PL	= $D00B
P0PL	= $D00C
P1PL	= $D00D
P2PL	= $D00E
P3PL	= $D00F
TRIG0	= $D010
TRIG1	= $D011
TRIG2	= $D012
TRIG3	= $D013
PAL	= $D014

;Pokey Write
POKEY	= $D200
AUDF1	= $D200
AUDF2	= $D202
AUDF3	= $D204
AUDF4	= $D206
AUDC1	= $D201
AUDC2	= $D203
AUDC3	= $D205
AUDC4	= $D207
AUDCTL	= $D208
STIMER	= $D209
SKRES	= $D20A
POTGO	= $D20B
SEROUT	= $D20D
IRQEN	= $D20E
SKCTL	= $D20F

;Pokey Read
POT0	= $D200
POT1	= $D201
POT2	= $D202
POT3	= $D203
POT4	= $D204
POT5	= $D205
POT6	= $D206
POT7	= $D207
ALLPOT	= $D208
POTST	= $D208
KBCODE	= $D209
RANDOM	= $D20A
SERIN	= $D20D
IRQST	= $D20E
SKSTAT	= $D20F

;PIA
PIA	= $D300
PORTA	= $D300
PORTB	= $D301
PACTL	= $D302
PBCTL	= $D303
;ANTIC
ANTIC	= $D400
DMACTL	= $D400
CHACTL	= $D401
DLISTL	= $D402
DLISTH	= $D403
HSCROL	= $D404
VSCROL	= $D405
PMBASE	= $D407
CHBASE	= $D409
WSYNC	= $D40A
VCOUNT	= $D40B
PENH	= $D40C
PENV	= $D40D
NMIEN	= $D40E
NMIRES	= $D40F
NMIST	= $D40F

;ANTIC dlisplay list commands
DL_E1	= $00
DL_E2	= $10
DL_E3	= $20
DL_E4	= $30
DL_E5	= $40
DL_E6	= $50
DL_E7	= $60
DL_E8	= $70
DL_JUMP	= $01 	;jump to adress and create one empty line
DL_LOOP	= $41 	;jump to adress and wait for vsync
DL_ADRES	= $40 	;load memory counter
DL_DLI	= $80 	;dli interrupt
DL_HS	= $10 	;horizontal scroll
DL_VS	= $20 	;vertical scroll
;BASIC GR-codes:
DL_GR0	= $02 	;text hi-res mode 40 bytes/line
DL_GR1	= $06 	;4 color text mode 20 bytes/line, 1 line V
DL_GR2	= $07 	;4 color text mode 20 bytes/line, 2 line V
DL_GR3	= $08 	;4 color graphics mode 10 bytes/line, 8 line V
DL_GR4	= $09 	;1 color graphics mode 10 bytes/line, 4 line V
DL_GR5	= $0A 	;4 color graphics mode, 20 bytes/line, 4 line V
DL_GR6	= $0B 	;1 color graphics mode, 20 bytes/line, 2 line V
DL_GR7	= $0D 	;4 color graphics mode, 40 bytes/line, 2 line V
DL_GR8	= $0F 	;graphics hi-res mode 40 bytes/line
DL_GR12	= $04 	;text - 4+1 color, 1 line V
DL_GR15	= $0E 	;4 color graphics mode, 40 bytes/line, 1 line V
;modes not supported by BASIC
DL_A3	= $03 	;hi-res text mode 8x10 pixel char, 40 bytes/line
DL_A5	= $05 	;text - 4+1 color, 2 line V
DL_AC	= $0C 	;1 color graphics mode, 20 bytes/line, 1 line V
;------------------------------------------
;OS Vectors
VDSLST = $0200 ;512,513
VPRCED = $0202 ;514,515
VINTER = $0204 ;516,517
VBREAK = $0206 ;518,519
VKEYBD = $0208 ;520,521
VSERIN = $020A ;522,523
VSEROR = $020C ;524,525
VSEROC = $020E ;526,527
VTIMR1 = $0210 ;528,529
VTIMR2 = $0212 ;530,531
VTIMR3 = $0214 ;532,533
VIMIRQ = $0216 ;534,535
CDTMV1 = $0218 
CDTMV2 = $021A
CDTMV3 = $021C 
CDTMV4 = $022E
CDTMV5 = $0220
VVBLKI = $0222 ;546,547
VVBLKD = $0224 ;548,549
CDTMA1 = $0226
CDTMA2 = $0228
SDMCTL = $022F ;559
SDLSTL = $0230 ;560,561
;OS CALLS
SETVBV	= $E45C
SYSVBV	= $E45F
XITVBV	= $E462
;------------------------------------------
;USEFUL
;bit mask
OR0	= 1
OR1	= 2
OR2	= 4
OR3	= 8
OR4	= 16
OR5	= 32
OR6	= 64
OR7	= 128
AND0	= $FE
AND1	= $FD
AND2	= $FB
AND3	= $F7
AND4	= $EF
AND5	= $DF
AND6	= $BF
AND7	= $7F
;-----------------------------------------------
;hw bits
SKSTAT_KEYPRESS	= OR2 	;key pressed
SKSTAT_SHIFT	= OR3 	;shift key pressed
SKSTAT_SR_BUSY	= OR1 	;serial input register busy
SKSTAT_FERR	= OR7 	;framing error
SKSTAT_KB_OVR	= OR6 	;keyboard overrun
SKSTAT_SR_OVR	= OR5 	;serial overrun
SKSTAT_IN_PAD	= OR4 	;serial input pin

;Atari OS Routines
;File version 1.01
;2005-03-13 10:35:00
;-----------------------------
RAMLO	= $04
IRQENS	= $10
RTCLOK1	= $14
TIMER	= $14
RTCLOK2	= $13
RTCLOK3	= $12
RAMTOP	= $6A
ATRACT	= $4D
KEYDEF	= $79
;----------------------------
WARMST	= $08
DOSVEC	= $0A
DOSINI	= $0C
COLDST	= $0244
PUPBT1	= $033D
PUPBT2	= $033E
PUPBT3	= $033F
ZIOCB	= $20
RUNAD	= $02E0
INITAD	= $02E2
KBCODES	= $02FC
HATABS	= $031A
;bloki IOCB
IOCB	= $0340
ICHID	= $0340
ICDNO	= $0341
ICCOM	= $0342
ICSTA	= $0343
ICBAL	= $0344
ICBAH	= $0345
ICPTL	= $0346
ICPTH	= $0347
ICBLL	= $0348
ICBLH	= $0349
ICAX1	= $034A
ICAX2	= $034B
ICAX3	= $034C
ICAX4	= $034D
ICAX5	= $034E
ICAX6	= $034F
CIO_OPEN	= 3
CIO_GETTEXT	= 5
CIO_GETDATA	= 7
CIO_PUTTEXT	= 9
CIO_PUTDATA	= 11
CIO_CLOSE	= 12
CIO_GETSTATUS	= 13
CIO_READ	= 4
CIO_WRITE	= 8
CIO_DIR	= 6
;------------------------------
;Procedury, tablice OS
PUTLINE	= $C642
DSKINT	= $E453
CIOMAIN	= $E456
CIOVXLE = $E4DF
CIOV800 = $E4C4
CIOVANY	= $E456
CIOV    = CIOVXLE  

SIOINT	= $E459
SIOV	= $E459
SELFTST	= $E471
COLDV	= $E477
COLD	= $E477
NEWDEV	= $EEBC
;Graphic Direct Calls
FILFLG = $02B7
DRAWXLE = $F9C2


KEY_A  = 63
KEY_S  = 62
KEY_G  = 61
KEY_Cap  = 60
KEY_D  = 58
KEY_H  = 57
KEY_F  = 56
KEY_Great = 55
KEY_Less = 54
KEY_8  = 53
KEY_BSp  = 52
KEY_7  = 51
KEY_0  = 50
KEY_9  = 48
KEY_Q  = 47
KEY_W  = 46
KEY_T  = 45
KEY_Tab  = 44
KEY_Y  = 43
KEY_E  = 42
KEY_R  = 40
KEY_Inv  = 39
KEY_Slash = 38
KEY_M  = 37
KEY_N  = 35
KEY_Dot  = 34
KEY_Spa  = 33
KEY_Comma = 32
KEY_1  = 31
KEY_2  = 30
KEY_5  = 29
KEY_Esc  = 28
KEY_6  = 27
KEY_3  = 26
KEY_4  = 24
KEY_Z  = 23
KEY_X  = 22
KEY_B  = 21
KEY_F4  = 20
KEY_F3  = 19
KEY_C  = 18
KEY_Hlp  = 17
KEY_V  = 16
KEY_Equal = 15
KEY_Minus = 14
KEY_I  = 13
KEY_Ret  = 12
KEY_U  = 11
KEY_P  = 10
KEY_O  = 8
KEY_Aster = 7
KEY_plus = 6
KEY_K  = 5
KEY_F2  = 4
KEY_F1  = 3
KEY_Semi = 2
KEY_J  = 1
KEY_L  = 0
