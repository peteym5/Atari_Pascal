// {$DEFINE Platform_AppliII}
{$define Platform_Atari_Antic} // Either 400/800/XL/XE  or  5200
{$define Platform_Atari_8_bit}     
// {$DEFINE Platform_Commodore16}
// {$DEFINE Platform_Vic20}           
// {$DEFINE Platform_Atari_5200}
// {$DEFINE Platform_Commodore64}

program Mind_Field_Cartridge;
{$ifdef Platform_Atari_8_bit}
uses atari, b_system, b_crt, b_pmg, b_set_interupts;    // CRT using 8-bit OS!   blibs libraries independant from OS!
{$endif}
{$ifdef Platform_Atari_5200}
uses atari5200, b_system, b_crt, b_pmg, b_set_interupts;    // CRT using 8-bit OS!   blibs libraries independant from OS!
{$endif}
    


// Pascal Reserved Words
// 	and			array		begin			case			const
// 	div			do			downto		else			end
// 	file		for			function	goto			if
// 	in			label		mod				nil				not
// 	of			or			packed		procedure	program
// 	record	repeat	set				then			to
// 	type		until		var				while			with

const
	

  
  {$ifdef Platform_Atari_Antic}
	{$R 'resources.rc'}	     
	SCREEN_ADDR						= $0800;
	GAME_SCREEN						= SCREEN_ADDR + 40;
  PMBANK                = $1800;
  VARBANK               = $0600;
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
    
	a : Byte;
  b : Byte;  
	c : Word;
  d : Word;  
	e : Byte;
  f : Byte;  
	g : Byte;
  h : Byte;  
	i : Byte;
  j : Byte;
  k : Byte;
  l : Byte;
  
  character_px :byte;
  character_py :byte;
  prior_py :byte;
  stick_read: byte; 
  prior_rt_clock: byte;
  
  menu_selection: byte;
  find_option: byte;
  bombs_on_option: byte;
  walls_on_option: byte;
  shooters_option: byte;
  mind_color: byte;
	show_countdown: byte;
	minds_found: byte;
	minds_under: byte;
	titlephase: Byte = 0;
  score: word = 4250;
  lives : Byte;
  hiscore  : array [0..10] of word = (0,7500,5500,3500,2500,0500,00,00,00,00,0);
  topMem : word;
  chbase1 : byte;

procedure ShowTitleScreen;
begin
	
  // InitGraph(0);
  // chbase1 :=180;
  topMem := chbase1 * 256;
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
				SetVBLI(@GameVBI);
        PMG_Init(hi(PMBANK), 48  OR PMG_sdmctl_DMA_both OR PMG_sdmctl_oneline OR PMG_sdmctl_screen_normal);
        NMIEN := 192;

        show_countdown:=180;
				mind_color:=$3F;	

				f :=0; 				
//	for i := 0 to 255 do
//	begin
//		poke (game_screen + i,i);
//	end;	
				prior_rt_clock := RT_CHECK;
        repeat 				
						if (minds_found > 0) and (show_countdown = 0) then
							begin
										minds_found :=0;
										a := (character_px - 48) DIV 4;
										b := (character_py - 24) DIV 8;
										for j := b - 2 to b + 3 do
											for i := a - 2 to a + 3 do
												begin
														c := game_screen + i + 40 * j;
														e := peek(c);
														if e=65 then poke (c,193);												
												end;			            					            										
							end;							
						if prior_rt_clock <> RT_CHECK then begin
				        minds_found :=0;
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
										        stick_read := (porta and 15);
														asm {
															lda RT_CHECK
															AND #4
															STA G
								            };		
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
			            			end;															            						            			
												a := (character_px - 48) DIV 4;
												b := (character_py - 24) DIV 8;
												for j := b - 2 to b + 3 do
													for i := a - 2 to a + 3 do
														begin
																c := game_screen + i + 40 * j;
																e := peek(c);
																if e=193 then
																	begin
																 	if (j=b) or (i=a) or (i=a+1) then	minds_under :=1;															 	
																	 	poke (c,65);
																	 	minds_found:=minds_found+1;
																 end;
														end;			            					            			
								end;					          
				until CRT_KeyPressed;
	
    until false;
end.

