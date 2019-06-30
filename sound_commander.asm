SOUND_VAR_BANK               = $0650;
	
SND_LENGTH_LO =       	 SOUND_VAR_BANK + $000;
SND_LENGTH_HI =       	 SOUND_VAR_BANK + $001;
SND_CHANNEL_IN_USE =  	 SOUND_VAR_BANK + $008;
NX_SND_CHNL =          	 SOUND_VAR_BANK + $009;
MUSIC_SUBSTAIN =       	 SOUND_VAR_BANK + $00B; //;SOUND_COMMANDER_VARIABLE_AREA + $0010
MUSIC_VOL =            	 SOUND_VAR_BANK + $00D;
MUSIC_MIN =            	 SOUND_VAR_BANK + $00F;


SND_ADDR_LO =     		 SOUND_VAR_BANK + $0010;
SND_ADDR_HI =     		 SOUND_VAR_BANK + $0011;
SND_DELAY_TIME =  		 SOUND_VAR_BANK + $0018;
SND_DELAY_RATE =  		 SOUND_VAR_BANK + $0019;

MUSIC_DIST_START =  	 SOUND_VAR_BANK + $0020;
MUSIC_SUBSTAIN_SET =	 SOUND_VAR_BANK + $0021;
MUSIC_REPEAT_SET =  	 SOUND_VAR_BANK + $0022; 
MUSIC_REPEAT_DELAY =	 SOUND_VAR_BANK + $0023;

STEMP0 =                 SOUND_VAR_BANK + $0028;
STEMP1 =                 SOUND_VAR_BANK + $0029;
STEMP2 =                 SOUND_VAR_BANK + $002A;
STEMP3 =                 SOUND_VAR_BANK + $002B; 

NDX0 =					 $EA;
NDX1 =					 $EB;
NDX2 =					 $EC;
NDX3 =					 $ED;

PLAY_SOUNDS
    LDX MUSIC_REPEAT_DELAY
    BEQ NO_RESTART_MUSIC
    DEX
    STX MUSIC_REPEAT_DELAY     
    BNE NO_RESTART_MUSIC
    LDX MUSIC_REPEAT_SET 
    LDA #1
    JSR START_SOUND     
NO_RESTART_MUSIC    
    LDX #$06
    LDA #$00
    STA NDX0
PLAY_SOUND_LOOP
    LDA SND_CHANNEL_IN_USE,X
    BEQ DEC_CHANNEL_INDEX
    BPL NO_MUSIC_DECAY    
    LDA SND_DELAY_TIME,X
    LSR @
    BCC NO_MUSIC_DECAY
    LDA MUSIC_VOL
    CMP MUSIC_MIN
    BEQ NO_MUSIC_DECAY
    LDA MUSIC_SUBSTAIN
    BEQ ALLOW_DECAY
    DEC MUSIC_SUBSTAIN
    BNE NO_MUSIC_DECAY
ALLOW_DECAY    
    DEC MUSIC_VOL
    LDA MUSIC_VOL
    STA AUDC1,X
NO_MUSIC_DECAY    
    ;LDA SND_DELAY_TIME,X
    DEC SND_DELAY_TIME,X
    BNE DEC_CHANNEL_INDEX
    LDA SND_CHANNEL_IN_USE,X
    BPL NO_MUSIC_NOTE
    JSR GET_NEXT_MUSIC_NOTE
    JMP DEC_SOUND_LENGTH 
NO_MUSIC_NOTE            
    LDA SND_DELAY_RATE,X
    STA SND_DELAY_TIME,X
GET_SOUND_PART_ADDRESS       
    LDY SND_ADDR_LO,X
    LDA SND_ADDR_HI,X
    STA NDX1     
    LDA (NDX0),Y
    STA AUDC1,X
    INY    
    BNE NO_SND_INC_ADDR_HI1
    INC SND_ADDR_HI,X
    INC NDX1
NO_SND_INC_ADDR_HI1   
    LDA (NDX0),Y
    STA AUDF1,X 
    INY 
    BNE NO_SND_INC_ADDR_HI2
    INC SND_ADDR_HI,X    
NO_SND_INC_ADDR_HI2   
    TYA
    STA SND_ADDR_LO,X
DEC_SOUND_LENGTH
    DEC SND_LENGTH_LO,X
    BNE DEC_CHANNEL_INDEX
    LDA SND_CHANNEL_IN_USE,X
    BMI MUSIC_REPEAT_CHECK
NO_MUSIC_REPEAT_CHECK    
    LDA #0
    STA SND_CHANNEL_IN_USE,X
    STA AUDC1,X              
DEC_CHANNEL_INDEX
    DEX
    DEX
    BPL PLAY_SOUND_LOOP    
END_SOUND_VBI    
	RTS

MUSIC_REPEAT_CHECK
    LDA MUSIC_REPEAT_SET
    BEQ NO_MUSIC_REPEAT_CHECK
    LDA #6
    STA MUSIC_REPEAT_DELAY 
	JMP DEC_CHANNEL_INDEX



START_SOUND
    STA STEMP0
    LDA NX_SND_CHNL
    ASL @    
    TAY
    LDA STEMP0
    STA SND_DELAY_RATE,Y
    LDA START_SOUND_ADDR_LO,X
    STA SND_ADDR_LO,Y 
    LDA START_SOUND_ADDR_HI,X
    STA SND_ADDR_HI,Y         
    LDA START_SOUND_LENGTH_LO,X
    BEQ PLAY_SOUND_ERROR  
    STA SND_LENGTH_LO,Y 
    LDA START_SOUND_LENGTH_HI,X
    STA SND_LENGTH_HI,Y
    BPL NO_SET_SOUND_MUSIC
    AND #$0F
    STA SND_LENGTH_HI,Y
    LDA #$00
    STA MUSIC_VOL
    STA MUSIC_MIN
    LDA #$81
    DTA $2C
NO_SET_SOUND_MUSIC    
    LDA #$01
    STA SND_CHANNEL_IN_USE,Y
    AND #$01 
    STA SND_DELAY_TIME,Y
    LDA NX_SND_CHNL
    CLC
    ADC #1
    CMP #4
    BCC NO_SND_CHNL_RESET
    LDA #0
    STA AUDCTL
NO_SND_CHNL_RESET    
    STA NX_SND_CHNL
PLAY_SOUND_ERROR
    RTS
    
GET_NEXT_MUSIC_NOTE
    LDA #0
    STA AUDC1,X
    LDY SND_ADDR_LO,X
    LDA SND_ADDR_HI,X
    STA NDX1
    LDA (NDX0),Y ;DISTORTION + VOLUME
    STA MUSIC_VOL
    AND #$F0
    STA MUSIC_MIN    
    INY
    BNE NO_MUSIC_INC_ADDR_HI1
    INC SND_ADDR_HI,X
    INC NDX1
NO_MUSIC_INC_ADDR_HI1
    LDA (NDX0),Y
    AND #$C0    
    BEQ SET_EIGTH_NOTE
    CMP #$40
    BEQ SET_QUARTER_NOTE
    CMP #$80
    BEQ SET_HALF_NOTE
    CMP #$C0
    BEQ SET_WHOLE_NOTE
SET_EIGTH_NOTE    
    LDA #$04         
    DTA $2C
SET_QUARTER_NOTE
    LDA #$08
    DTA $2C
SET_HALF_NOTE
    LDA #$10
    DTA $2C
SET_WHOLE_NOTE
    LDA #$20        
    STA SND_DELAY_TIME,X               
    LDA (NDX0),Y
    AND #$3F
    STA STEMP1
    INY 
    BNE NO_MUSIC_INC_ADDR_HI2
    INC SND_ADDR_HI,X
    INC NDX1
NO_MUSIC_INC_ADDR_HI2  
    TYA 
    STA SND_ADDR_LO,X
CHECK_MUSIC_BASS1
    LDY STEMP1
    LDA MUSIC_MIN
    CMP #$C0
    BNE CHECK_MUSIC_BASS2
    LDA MUSIC_NOTE_BASS1_TABLE,Y
    STA AUDF1,X  
    LDA MUSIC_VOL
    STA AUDC1,X  
    RTS
CHECK_MUSIC_BASS2
    CMP #$E0
    BNE DO_MUSIC_MAIN    
    LDA MUSIC_VOL
    AND #$0F
    ORA #$C0
    STA AUDC1,X
    STA MUSIC_VOL
    AND #$F0
    STA MUSIC_MIN
    LDA MUSIC_NOTE_BASS2_TABLE,Y
    STA AUDF1,X
    RTS
DO_MUSIC_MAIN        
    LDA MUSIC_NOTE_MAIN_TABLE,Y
    STA AUDF1,X
    LDA MUSIC_VOL
    STA AUDC1,X 
    RTS    
    
    
STOP_SOUND
    TYA
    ASL @
    TAY
    LDA #0
    STA SND_CHANNEL_IN_USE,Y
    STA SND_LENGTH_LO,Y
    STA SND_LENGTH_HI,Y
    STA AUDC1,Y
    STA AUDF1,Y    
    RTS

SILENCE
    LDA #0
    STA AUDCTL
    STA SKCTL
    STA COLBAK
    LDY #7
NEXT_SILENCE    
    STA SND_LENGTH_LO,Y
    STA SND_LENGTH_HI,Y
    STA SND_CHANNEL_IN_USE,Y
    STA SND_ADDR_LO,Y
    STA SND_ADDR_HI,Y
    STA SND_DELAY_TIME,Y 
    STA AUDC1,Y
    STA AUDF1,Y
    DEY
    BPL NEXT_SILENCE
    LDA #3
    STA SKCTL
    RTS     

MUSIC_NOTE_MAIN_TABLE  ;Pure Tone  from RMT 
;      C  C#   D   D#  E   F   F#  G  G#  A    A#  B
	dta $F3,$E6,$D9,$CC,$C1,$B5,$AD,$A2,$99,$90,$88,$80 ;O1  00
  dta $79,$72,$6C,$66,$60,$5B,$55,$51,$4C,$48,$44,$40 ;O2  12
  dta $3C,$39,$35,$32,$2F,$2D,$2A,$28,$25,$23,$21,$1F ;O3  24
  dta $1D,$1C,$1A,$18,$17,$16,$14,$13,$12,$11,$10,$0F ;O4  36
	dta $0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03 ;O5  48
  dta $02,$01,$00,$00                                 ;O6  60
;      C  C#   D   D#  E   F   F#  G  G#  A    A#  B
MUSIC_NOTE_BASS1_TABLE
	dta $BF,$B6,$AA,$A1,$98,$8F,$89,$80,$F2,$E6,$DA,$CE ;O1  00
	dta $BF,$B6,$AA,$A1,$98,$8F,$89,$80,$7A,$71,$6B,$65 ;O2  12
	dta $5F,$5C,$56,$50,$4D,$47,$44,$3E,$3C,$38,$35,$32 ;O3  24
	dta $2F,$2D,$2A,$28,$25,$23,$21,$1F,$1D,$1C,$1A,$18 ;O4  36
	dta $17,$16,$14,$13,$12,$11,$10,$0F,$0E,$0D,$0C,$0B ;O5  48
	dta $0A,$09,$08,$07                                 ;O6  60
;      C  C#   D   D#  E   F   F#  G  G#  A    A#  B  
MUSIC_NOTE_BASS2_TABLE
	dta $FF,$F1,$E4,$D8,$CA,$C0,$B5,$AB,$A2,$99,$8E,$87 ;O1  00
	dta $7F,$79,$73,$70,$66,$61,$5A,$55,$52,$4B,$48,$43 ;O2  12
	dta $3F,$3C,$39,$37,$33,$30,$2D,$2A,$28,$25,$24,$21 ;O3  24
	dta $1F,$1E,$1C,$1B,$19,$17,$16,$15,$13,$12,$11,$10 ;O4  36
	dta $0F,$0E,$0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04 ;O5  48
	dta $03,$02,$01,$00                                 ;O6  60


;3 byte music format.
;0 Adjusted Distort
;1 Note + Substain
;2 Instrument + Note

BIT_MUSIC_LOOP
  dta $40
BIT_SOUND_IS_MUSIC
  dta $80

EXPLOSION_SOUND_DATA  
  DTA $8F,248,$8F,240,$8E,232,$8E,224,$0D,216,$8D,208,$8C,200,$6C,192
  DTA $8B,252,$6B,244,$0A,236,$8A,228,$89,220,$89,212,$88,204,$88,196
  DTA $07,248,$87,240,$86,232,$66,224,$85,216,$85,208,$84,200,$84,192
  DTA $83,252,$83,244,$83,236,$82,228,$82,220,$62,212,$01,204,$81,196
EXPLOSION_SOUND_SIZE = (*- EXPLOSION_SOUND_DATA) / 2

BELL_01_SOUND_DATA                                                           ; 14
  DTA $CF,236,$AE,120,$CD,236,$AC,112
  DTA $CB,137,$AA,120,$C8,242,$A6,112
  DTA $C4,136,$A3,120,$C2,251,$A1,112
BELL_01_SOUND_SIZE = (*- BELL_01_SOUND_DATA)/2

BELL_02_SOUND_DATA    
  DTA $AF,064,$AE,064,$AD,065,$AC,064                                       ; 12
  DTA $AB,064,$AA,063,$A8,064,$A6,064
  DTA $A4,065,$A3,064,$A2,064,$A1,063
BELL_02_SOUND_SIZE = (*- BELL_02_SOUND_DATA) / 2  

GET_ITEM_SOUND_DATA 
  DTA $AF,128,$AF,128,$AE,128,$AE,128                                       ; 12
  DTA $CD,206,$CC,206,$CB,206,$CA,206
  DTA $6F,048,$AF,048,$AE,048,$AE,048                                       ; 12
  DTA $CD,080,$CC,080,$CB,080,$CA,080  
GET_ITEM_SOUND_SIZE = (*- GET_ITEM_SOUND_DATA) / 2



START_SOUND_ADDR_LO                                                                                                                                                                                                                                                                       
	DTA <EXPLOSION_SOUND_DATA
	DTA <BELL_01_SOUND_DATA
	DTA <BELL_02_SOUND_DATA
	DTA <GET_ITEM_SOUND_DATA   

START_SOUND_ADDR_HI                                                                                
	DTA >EXPLOSION_SOUND_DATA
	DTA >BELL_01_SOUND_DATA
	DTA >BELL_02_SOUND_DATA
	DTA >GET_ITEM_SOUND_DATA
	   
START_SOUND_LENGTH_LO                                                                                                                                                                                                                                                                         
    DTA	<EXPLOSION_SOUND_SIZE
	DTA <BELL_01_SOUND_SIZE	
    DTA <BELL_02_SOUND_SIZE
    DTA <GET_ITEM_SOUND_SIZE
	    
START_SOUND_LENGTH_HI                                                                                                                                                                                                                                                                     
    DTA	>EXPLOSION_SOUND_SIZE
	DTA >BELL_01_SOUND_SIZE	
    DTA >BELL_02_SOUND_SIZE
    DTA >GET_ITEM_SOUND_SIZE