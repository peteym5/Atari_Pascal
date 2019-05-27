// {$DEFINE Platform_AppliII}
{$define Platform_Atari_Antic} // Either 400/800/XL/XE  or  5200
{$define Platform_Atari_8_bit}     
// {$DEFINE Platform_Commodore16}
// {$DEFINE Platform_Vic20}           
// {$DEFINE Platform_Atari_5200}
// {$DEFINE Platform_Commodore64}
// {$DEFINE Use_Hi_Lo}
program Mind_Field_Cartridge;
{$ifdef Platform_Atari_8_bit}
uses atari, b_system, b_crt, b_pmg, b_set_interupts;    // CRT using 8-bit OS!   blibs libraries independant from OS!
{$endif}
{$ifdef Platform_Atari_5200}
uses atari5200, b_system, b_crt, b_pmg, b_set_interupts;    // CRT using 8-bit OS!   blibs libraries independant from OS!
{$endif}
    

// Todo....
// Speed up Mind Scanning
// Show Mind Count
// Different options for mind detection
// Dodge Dropping Bmmbs.
// Collect Bonus Items on Mind Field
// Avoid Machine Gun Bunkers
// Top of Mind Field Advances to next one.



// Pascal Reserved Words
// 	and	        array		begin		case			const
// 	div	        do			downto		else			end
// 	file        for			function	goto			if
// 	in          label		mod			nil				not
// 	of          or			packed		procedure       program
// 	record      repeat      set			then            to
// 	type        until		var			while			with

const  
  {$ifdef Platform_Atari_Antic}
	{$R 'resources.rc'}	     
  SCREEN_ADDR						= $0800;
  GAME_SCREEN						= SCREEN_ADDR + 40;
  PMBANK                = $1800;
  VARBANK               = $0600;
  LOCALVAR              = VARBANK + $E0;
  CHARSET_GAME          = $A400;
  CHARSET_TITLE         = $A800;
  TITLE_DATA						= $AC00;
  CHARSET_BASE					= $A4;
  {$endif}
  
  {$ifdef Platform_Commodor64}
	SCREEN_ADDR						= $0400; // 1024
	GAME_SCREEN						= SCREEN_ADDR + 40;
  VARBANK               = $1800;
  COLORMAP              = $D800; //  55296-56295
  {$endif}
  
  MIBANK                 = PMBANK+$0300;
  PMBNK0	               = PMBANK+$0400;
  PMBNK1	               = PMBANK+$0500;
  PMBNK2	               = PMBANK+$0600;
  PMBNK3	               = PMBANK+$0700;  

	//{$ifdef Platform_Atari_Antic}
	{$ifdef Platform_Atari_8_bit or $ifdef Platform_Atari_5200}
	display_list_title: array [0..52] of byte = (
  $70,$C0,$44,
  lo(TITLE_DATA),
  hi(TITLE_DATA),
  $04,$04,$04,$04,$04,$04,$84,$00,$44,
  lo(SCREEN_ADDR),
  hi(SCREEN_ADDR),	
	$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$41,
  lo(word(@display_list_title)), 
  hi(word(@display_list_title))
  );
  
  display_list_game: array [0..34] of byte = (
  $70,$70,$44,
  lo(SCREEN_ADDR),
  hi(SCREEN_ADDR),
  $10,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$41,
  lo(word(@display_list_game)), 
  hi(word(@display_list_game))
  );
  
  {$ifdef Use_Hi_lo}
  screen_row_low: array [0..25] of byte = (
	lo(GAME_SCREEN + 000), lo(GAME_SCREEN + 040), lo(GAME_SCREEN + 080), lo(GAME_SCREEN + 120), lo(GAME_SCREEN + 160),
	lo(GAME_SCREEN + 200), lo(GAME_SCREEN + 240), lo(GAME_SCREEN + 280), lo(GAME_SCREEN + 320), lo(GAME_SCREEN + 360),
	lo(GAME_SCREEN + 400), lo(GAME_SCREEN + 440), lo(GAME_SCREEN + 480), lo(GAME_SCREEN + 520), lo(GAME_SCREEN + 560),
	lo(GAME_SCREEN + 600), lo(GAME_SCREEN + 640), lo(GAME_SCREEN + 680), lo(GAME_SCREEN + 720), lo(GAME_SCREEN + 760),
	lo(GAME_SCREEN + 800), lo(GAME_SCREEN + 840), lo(GAME_SCREEN + 880), lo(GAME_SCREEN + 920), lo(GAME_SCREEN + 960),
	lo(GAME_SCREEN + 1000));

  screen_row_high: array [0..25] of byte = (
	hi(GAME_SCREEN + 000), hi(GAME_SCREEN + 040), hi(GAME_SCREEN + 080), hi(GAME_SCREEN + 120), hi(GAME_SCREEN + 160),
	hi(GAME_SCREEN + 200), hi(GAME_SCREEN + 240), hi(GAME_SCREEN + 280), hi(GAME_SCREEN + 320), hi(GAME_SCREEN + 360),
	hi(GAME_SCREEN + 400), hi(GAME_SCREEN + 440), hi(GAME_SCREEN + 480), hi(GAME_SCREEN + 520), hi(GAME_SCREEN + 560),
	hi(GAME_SCREEN + 600), hi(GAME_SCREEN + 640), hi(GAME_SCREEN + 680), hi(GAME_SCREEN + 720), hi(GAME_SCREEN + 760),
	hi(GAME_SCREEN + 800), hi(GAME_SCREEN + 840), hi(GAME_SCREEN + 880), hi(GAME_SCREEN + 920), hi(GAME_SCREEN + 960),
	hi(GAME_SCREEN + 1000));
  {$else}
  screen_rows: array [0..25] of word = (
	GAME_SCREEN + 00,GAME_SCREEN + 40,GAME_SCREEN + 80,GAME_SCREEN + 120,GAME_SCREEN + 160,
	GAME_SCREEN + 200,GAME_SCREEN + 240,GAME_SCREEN + 280,GAME_SCREEN + 320,GAME_SCREEN + 360,
	GAME_SCREEN + 400,GAME_SCREEN + 440,GAME_SCREEN + 480,GAME_SCREEN + 520,GAME_SCREEN + 560,
	GAME_SCREEN + 600,GAME_SCREEN + 640,GAME_SCREEN + 680,GAME_SCREEN + 720,GAME_SCREEN + 760,
	GAME_SCREEN + 800,GAME_SCREEN + 840,GAME_SCREEN + 880,GAME_SCREEN + 920,GAME_SCREEN + 960,
	GAME_SCREEN + 1000);  
  {$endif}


P000:ARRAY[0..13] OF BYTE = (
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00101000,  // $28  40
     %00101000,  // $28  40
     %00101000,  // $28  40
     %00101000   // $28  40
);
P001:ARRAY[0..13] OF BYTE = (
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %01111000,  // $78  120
     %01111000,  // $78  120
     %01111100,  // $7C  124
     %01111110,  // $7E  126
     %00111010,  // $3A  58
     %00111010,  // $3A  58
     %00111000,  // $38  56
     %00101000,  // $28  40
     %00101100,  // $2C  44
     %00100100,  // $24  36
     %00100000   // $20  32
);
P002:ARRAY[0..13] OF BYTE = (
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00001100,  // $0C  12
     %00011110,  // $1E  30
     %00111110,  // $3E  62
     %00111110,  // $3E  62
     %00011110,  // $1E  30
     %00011100,  // $1C  28
     %00011000,  // $18  24
     %00011000,  // $18  24
     %00011000,  // $18  24
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00010100   // $14  20
);
P003:ARRAY[0..13] OF BYTE = (
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %01111100,  // $7C  124
     %11111100,  // $FC  252
     %10111000,  // $B8  184
     %10111000,  // $B8  184
     %00111000,  // $38  56
     %00101000,  // $28  40
     %00101100,  // $2C  44
     %00100100,  // $24  36
     %00100000   // $20  32
);
P004:ARRAY[0..13] OF BYTE = (
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00011000,  // $18  24
     %00111100,  // $3C  60
     %00111110,  // $3E  62
     %00111110,  // $3E  62
     %00111100,  // $3C  60
     %00011100,  // $1C  28
     %00001100,  // $0C  12
     %00001100,  // $0C  12
     %00001100,  // $0C  12
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00010100   // $14  20
);
P005:ARRAY[0..13] OF BYTE = (
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %01111100,  // $7C  124
     %11111100,  // $FC  252
     %10111000,  // $B8  184
     %10111000,  // $B8  184
     %00111000,  // $38  56
     %00101000,  // $28  40
     %01101000,  // $68  104
     %01001000,  // $48  72
     %01001000   // $48  72
);
P006:ARRAY[0..13] OF BYTE = (
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00001100,  // $0C  12
     %00011100,  // $1C  28
     %00011110,  // $1E  30
     %00011101,  // $1D  29
     %00111110,  // $3E  62
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00011000,  // $18  24
     %00100100,  // $24  36
     %00100010,  // $22  34
     %01000001,  // $41  65
     %01000001   // $41  65
);
P007:ARRAY[0..13] OF BYTE = (
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %01111000,  // $78  120
     %01111000,  // $78  120
     %01111100,  // $7C  124
     %01111110,  // $7E  126
     %00111010,  // $3A  58
     %00111010,  // $3A  58
     %00111000,  // $38  56
     %00101000,  // $28  40
     %01101000,  // $68  104
     %01001000,  // $48  72
     %01001000   // $48  72
);
P008:ARRAY[0..13] OF BYTE = (
     %00011100,  // $1C  28
     %00011100,  // $1C  28
     %00011000,  // $18  24
     %00011100,  // $1C  28
     %00111100,  // $3C  60
     %01011100,  // $5C  92
     %00111110,  // $3E  62
     %00011110,  // $1E  30
     %00001100,  // $0C  12
     %00001100,  // $0C  12
     %00010010,  // $12  18
     %00100010,  // $22  34
     %01000001,  // $41  65
     %01000001   // $41  65
);
P009:ARRAY[0..13] OF BYTE = (
     %11000011,  // $C3  195
     %11000011,  // $C3  195
     %01100110,  // $66  102
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00111100,  // $3C  60
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %00111100,  // $3C  60
     %00011000   // $18  24
);
P010:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %11000110,  // $C6  198
     %11000110,  // $C6  198
     %01101100,  // $6C  108
     %00111000,  // $38  56
     %00111000,  // $38  56
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %00111000,  // $38  56
     %00010000   // $10  16
);
P011:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %01100110,  // $66  102
     %01100110,  // $66  102
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00011000,  // $18  24
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00000000   // $00  0
);
P012:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %11000011,  // $C3  195
     %01100110,  // $66  102
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00111100,  // $3C  60
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %01111110,  // $7E  126
     %00011000,  // $18  24
     %00000000,  // $00  0
     %00000000   // $00  0
);
P013:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %11000110,  // $C6  198
     %01101100,  // $6C  108
     %00111000,  // $38  56
     %00010000,  // $10  16
     %00111000,  // $38  56
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %01111100,  // $7C  124
     %00111000,  // $38  56
     %00000000,  // $00  0
     %00000000   // $00  0
);
P014:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %01100110,  // $66  102
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00011000,  // $18  24
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00111100,  // $3C  60
     %00011000,  // $18  24
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000   // $00  0
);
P015:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %01101100,  // $6C  108
     %00111000,  // $38  56
     %00010000,  // $10  16
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00111000,  // $38  56
     %00010000,  // $10  16
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000   // $00  0
);
P016:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00011000,  // $18  24
     %00100100,  // $24  36
     %00100100,  // $24  36
     %00100100,  // $24  36
     %00100100,  // $24  36
     %00011000,  // $18  24
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00000000   // $00  0
);
P017:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00000000,  // $00  0
     %00011000,  // $18  24
     %00100100,  // $24  36
     %01000010,  // $42  66
     %01000010,  // $42  66
     %01000010,  // $42  66
     %01000010,  // $42  66
     %01000010,  // $42  66
     %01000010,  // $42  66
     %00100100,  // $24  36
     %00011000,  // $18  24
     %00000000,  // $00  0
     %00000000   // $00  0
);
P018:ARRAY[0..13] OF BYTE = (
     %00000000,  // $00  0
     %00011000,  // $18  24
     %00100100,  // $24  36
     %01000010,  // $42  66
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %01000010,  // $42  66
     %00100100,  // $24  36
     %00011000,  // $18  24
     %00000000   // $00  0
);
P019:ARRAY[0..13] OF BYTE = (
     %00111100,  // $3C  60
     %01000010,  // $42  66
     %01000010,  // $42  66
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %10000001,  // $81  129
     %01000010,  // $42  66
     %01000010,  // $42  66
     %00111100   // $3C  60
);


	
	spriteframes: array[0..19] of pointer = (@P000, @P001, @P002, @P003, @P004, @P005, @P006,@P007, @P008, @P009,
											 @P010, @P011, @P012, @P013, @P014, @P015, @P016,@P017, @P018, @P019);



  {$ENDIF}

  {$i 'Mind_Field_Interupts.inc'}

var
    RT_CHECK								: byte absolute $14;
    PRIOR								    : byte absolute $D01B;
    TMP0								    : byte absolute $E0;
    TMP1								    : byte absolute $E1;
    TMP2								    : byte absolute $E2;
    TMP3								    : byte absolute $E3;
    TMP4								    : byte absolute $E4;
    TMP5								    : byte absolute $E5;
    TMP6								    : byte absolute $E6;
    TMP7								    : byte absolute $E7;
    TMP8								    : byte absolute $E8;
    TMP9								    : byte absolute $E9;
    NDX0								    : byte absolute $EA;
    NDX1								    : byte absolute $EB;
    NDX2								    : byte absolute $EC;
    NDX3								    : byte absolute $ED;
    HOLDX								    : byte absolute $EE;
    HOLDY								    : byte absolute $EF;
    
    

  a :       Byte absolute VARBANK + $000;
  b :       Byte absolute VARBANK + $002;  
  c :       Word absolute VARBANK + $004;
  d :       Word absolute VARBANK + $006;  
  e :       Byte absolute VARBANK + $008;
  f :       Byte absolute VARBANK + $00A;  
  g :       Byte absolute VARBANK + $00C;
  h :       Byte absolute VARBANK + $00E;  
  i :       Byte absolute VARBANK + $010;
  j :       Byte absolute VARBANK + $012;
  k :       Byte absolute VARBANK + $014;
  l :       Byte absolute VARBANK + $016;
  m :       Byte absolute VARBANK + $018;
  n :       Byte absolute VARBANK + $01A;
  o :       Byte absolute VARBANK + $01C;
  p :       Byte absolute VARBANK + $01E;

  
    character_px :              byte absolute VARBANK + $020;
    character_py :              byte absolute VARBANK + $021;
    character_status :          byte absolute VARBANK + $022;
    prior_py :                  byte absolute VARBANK + $024;
    stick_read:                 byte absolute VARBANK + $026; 
    prior_rt_clock:             byte absolute VARBANK + $028;
    menu_selection:             byte absolute VARBANK + $02A;
    find_option:                byte absolute VARBANK + $02C;
    bombs_on_option:            byte absolute VARBANK + $02E;
    walls_on_option:            byte absolute VARBANK + $030;
    shooters_option:            byte absolute VARBANK + $032;
    mind_color:                 byte absolute VARBANK + $034;
    show_countdown:             byte absolute VARBANK + $036;
    minds_found:                byte absolute VARBANK + $038;
    minds_under:                byte absolute VARBANK + $03A;
    titlephase:                 byte absolute VARBANK + $03C;
    score:                      word absolute VARBANK + $03E;
    lives :                     byte absolute VARBANK + $040;
    topMem :                    word absolute VARBANK + $042;
    chbase1 :                   byte absolute VARBANK + $044;
    row_addr :                  word absolute VARBANK + $046; 

    hiscore  : array [0..10] of word absolute VARBANK + $100; //  can we initialize it as blank?    = (0,7500,5500,3500,2500,0500,00,00,00,00,0);


procedure ShowTitleScreen;
begin
	
  // InitGraph(0);
  // chbase1 :=180;
  topMem := chbase1 * 256;
  titlephase := 0;
  score := 4250;
asm {
;	  ICL "Atari 8-bit Equates.asm"
		
    lda #0
    sta 82
    sta 710
    lda #12
    sta 709
    ; lda chbase1
    ; sta 756
    LDA #0
    STA NMIEN
    STA DMACTL
    STA PRIOR
    STA HITCLR

;    LDX #>RamSizeCode+1
    LDY #$00
    STY NDX0
    STY NDX2
    LDA #$38
    STA NDX1
    LDA #$A8
    STA NDX3
    };		
  dmactl :=0;		 
  nmien :=0;
  CRT_INIT (SCREEN_ADDR,40,25);
  SetIntVec(iDLI, @title00dli);
  //SetIntVec(iVBL, @TitleVBI);
  SetVBLI(@TitleVBI);
  CRT_CLEAR;  
  DLISTW := word(@display_list_title); 	 
  SDLSTW := word(@display_list_title); 
  SAVMSC := word(SCREEN_ADDR); 
  SETCHARSET(HI(CHARSET_GAME));
  CHBAS := HI(CHARSET_GAME);
  CRT_GotoXY(0, 0); 
  CRT_WRITE('           ATARI 8-BIT VERSION          '~);
  CRT_WRITE(' PROGRAMMING             PETER J. MEYER '~);
  CRT_WRITE('              (YOUR NAME COULD BE HERE) '~);
  CRT_WRITE(' GRAPHICS                               '~);
  CRT_WRITE(' SOUND AND MUSIC                        '~);        
 TMP5:=0; 
  gprior := 1;
  prior := 1;
  k := 6;
  i := 5;
		 
	color0:=$D8;	
	color1:=$06;
	color2:=$aa;
	color3:=54;
	color4:=34;

  PMG_Init(hi(PMBANK), 48  OR PMG_sdmctl_DMA_both OR PMG_sdmctl_oneline OR PMG_sdmctl_screen_normal);
 nmien :=192;
	
  repeat     
      if score>hiscore[i] then 
        begin;
          k := i
        end;
      i := i - 1    
  until i = 0;
  if k < 5 then 
    begin;
      i := 5;  
      repeat
        hiscore [i] := hiscore [i-1];
        i := i - 1    
      until i = k;
      hiscore [k] := score
    end;
   CRT_GotoXY(7, 15);
   CRT_WRITE('PRESS START TO BEGIN.'~);
   poke (hposp0,124);      
   
 repeat 
     
		  
		    // if CRT_OptionPressed then 
        // else CRT_Write(' OPTION '~);

        // if CRT_SelectPressed then CRT_Write(' SELECT '~*)
        // else CRT_Write(' SELECT '~);

        if CRT_StartPressed then TMP5:=255;

        // if CRT_HelpPressed then CRT_Write(' HELP '~*)
        // else CRT_Write(' HELP '~);
 until tmp5=255;
// 		  vdslst:= title00dli;
     nmien :=064;
		 repeat
     until CRT_StartPressed = false;
 
 
asm {
//    ORG 32768
//    ICL "inflate_2017_ver4.asm"
//    ORG 46080
//    INS "roman10.fnt" 
};

end;


procedure	Show_High_Scores;
   begin 	
	 CRT_GotoXY(10, 06); 
   CRT_WRITE('SCORE : '~);
   CRT_GOTOXY(18, 06);
   CRT_WRITE (score);
   CRT_GotoXY (8,07);
   CRT_WRITE ('TODAYS HIGH SCORES.'~);
   for i := 1 to 5 do
    begin;
      if k = i then
        begin 
          CRT_GOTOXY(12,08+i);
          CRT_WRITE('*'~);
        end;
      CRT_GOTOXY(14, 08+i);  
      CRT_WRITE (i);
      CRT_WRITE (' :'~);
      CRT_GotoXY(18, 08+i);      
      CRT_WRITE(hiscore[i]);
     end;  
	end;

procedure	Show_Options_Screen;
	begin
	end;

procedure	Show_Story_Screen;
	begin
	end;


procedure Initialize_Level;
	begin
	mind_color:=70;
	for i := 0 to 255 do
	
	begin
asm {
	LDA RANDOM
	CLC
	ADC #<game_screen
	STA NDX0
	LDA RANDOM
	AND #3
	ADC #>game_screen
	STA NDX1
	LDA RANDOM
	AND #3
	ORA #68
	LDY #0
	STA (NDX0),Y
};
	end;


	for i := 0 to 063 do
	begin
asm {
			LDA RANDOM
			CLC
			ADC #<game_screen
			STA NDX0
			LDA RANDOM
			AND #3
			ADC #>game_screen
			STA NDX1
			LDA #193
			LDY #0
			STA (NDX0),Y
};
	end;	
	begin
				character_px :=124;
				character_py :=208;
				character_status :=0;
                a := (character_px - 48) DIV 4;
				b := (character_py - 24) DIV 8;
				for j := b - 2 to b + 3 do
					for i := a - 2 to a + 3 do
						begin
								c := game_screen + i + 40 * j;
								e := peek(c);
								if e=193 then poke (c,0);
						end;
					
						
				
	end;
	end;
	


procedure Display_Information_Line;
begin
  CRT_GotoXY(0, 0);
  CRT_WRITE('SCORE:'~);
  CRT_GotoXY(6, 0);
  CRT_WRITE (score);

  CRT_GotoXY(14, 0);
  CRT_WRITE('LIVES:'~);
  CRT_GotoXY(20, 0);
  CRT_WRITE (lives);

end;
// CHARSET_ADDRESS rcdata 'Mind Field\MINDFIELD.FNT'

{***************************************************************************************}
{************************************** MAIN *******************************************}
{***************************************************************************************}


begin

    repeat
		ShowTitleScreen;
        
// Game Initialization here
        score := 0;
        lives := 5;
        CRT_INIT (SCREEN_ADDR,40,26);
        CRT_CLEAR;  
        Display_Information_Line;
        DLISTW := word(@display_list_game); 	 
        SDLSTW := word(@display_list_game); 
        SAVMSC := word(SCREEN_ADDR); 
        SETCHARSET(HI(CHARSET_GAME));
        CHBAS := HI(CHARSET_GAME);
        Initialize_Level;
        color0:=142;	
        color1:=212;        
        color3:=150;
        color4:=34;
        colpm0:=202;
        colpm1:=250;
        colpm2:=136;
        colpm3:=36;				
        sizep0:= PMG_SIZE_NORMAL;
        sizep1:= PMG_SIZE_NORMAL;
        sizep2:= PMG_SIZE_NORMAL;
        sizep3:= PMG_SIZE_NORMAL;
        PMG_Init(hi(PMBANK), 48  OR PMG_sdmctl_DMA_both OR PMG_sdmctl_oneline OR PMG_sdmctl_screen_normal);
        SetVBLI(@GameVBI);
        NMIEN := 192;

		show_countdown:= 180;
		mind_color:=$3F;	
		
		f :=0; 				
//	for i := 0 to 255 do
//	begin
//		poke (game_screen + i,i);
//	end;	
		prior_rt_clock := RT_CHECK;
        repeat 				
        if prior_rt_clock <> RT_CHECK then begin				              
				prior_rt_clock := RT_CHECK;
				fillbyte(pointer(PMBNK0+prior_py),14,0);										
				move(spriteframes[f],pointer(PMBNK0+character_py),14);
				hposp0:=character_px;
				prior_py := character_py;									
        		if show_countdown >0 then
        			show_countdown := show_countdown - 1			  					
        		else if mind_color > $32 then begin; 
					mind_color := mind_color - 1;			  						
					if mind_color = $32 then mind_color := $22					  					
        	  	end;												
        	    if (mind_color = $22) and (show_countdown = 0) then											                                                                                                                                                                                     					
                        begin			  				                                            
						a := (character_px - 47) DIV 4;
						b := (character_py - 24) DIV 8;
                        //   a := 9;
						if (minds_found > 0) then begin;
                              for j := b - 2 to b + 3 do
                                    if (j >=0) and (j < 25) then begin                                            
                                    row_addr :=   screen_rows [j] + a;
                                    for c := row_addr  - 2 to row_addr  + 3 do
                                  	   begin
											e := peek(c);
											if e = 65 then poke (c,193);                                                          												
                                  	    end;
                                      end;           					            										
                                end;
								if character_status = 0 then begin 
									stick_read := (porta and 15);				
						          	  g := (RT_CHECK and 4); 
									//		asm {
									//		lda RT_CHECK
									//		AND #4
									//		STA G
								    //};		

									f:=0;  
						          	if (stick_read and 1=0) then begin
						          		character_py := character_py - 1;
						          		f:=1+G;
						          	end;
						          	if (stick_read and 2=0) then begin
						          		character_py := character_py + 1;
						          		f:=3+G;
									end;
						          	if (stick_read and 4=0) then begin
										character_px := character_px - 1;
										f:=2+G;
						          	end;
						          	if (stick_read and 8=0) then begin
						          		character_px := character_px + 1;
						          		f:=4+G;
						          	end;															            						            			
									a := (character_px - 47) DIV 4;
									b := (character_py - 24) DIV 8;
									colpm0:=202;
									g:=0;                                    
  									for j := b - 2 to b + 3 do begin 
										if (j >=0) and (j < 25) then begin                                            
                                            row_addr :=   screen_rows [j] + a;
                                            h :=0;
                                            for c := row_addr  - 2 to row_addr  + 3 do begin
												e := peek(c);
												if e=193 then begin 
                                                    poke (c,65);
                                                    minds_found :=+1;
                                                    if ((g = 1) or (g = 2)) and ((h = 2) or  (h = 3))  then begin
                                                        colpm0:=15;                    
														end;                                                                                                                                                                                                                                                                                      												
												end;
                                        		h := h + 1;
											end;                                            	  					            										
										end;
										g := g + 1;
									end;			
								end;					
								if (character_status > 0) and (character_status < 16) then begin 
								    character_status := character_status + 1;								
								end;
							end;
						end;					          
				until CRT_KeyPressed;
	
    until false;
end.

