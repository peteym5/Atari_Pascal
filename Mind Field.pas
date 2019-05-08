program Mind_Field_Cartridge;
uses atari, b_system, b_crt;    // CRT using 8-bit OS!   blibs libraries independant from OS!
    
// uses atari, crt, sysutils;


// Pascal Reserved Words
// 	and			array		begin			case			const
// 	div			do			downto		else			end
// 	file		for			function	goto			if
// 	in			label		mod				nil				not
// 	of			or			packed		procedure	program
// 	record	repeat	set				then			to
// 	type		until		var				while			with

const
  {$R 'resources.rc'}
	     
	SCREEN_ADDR						= 4096;
	GAME_SCREEN						= SCREEN_ADDR + 40;
  PMBANK                = $1000;
  VARBANK               = $1800;
	CHARSET_ADDRESS       = $A400;
	CHARSET_BASE					= $A4;

  
	
	display_list_title: array [0..50] of byte = (
  $70,$F0,$44,
  lo(SCREEN_ADDR),
  hi(SCREEN_ADDR),
  $04,$04,$04,$04,$84,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$41,
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
  

  {$i 'Mind_Field_Interupts.inc'}

var
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
    
  SPRITENUM	              : byte absolute PMBANK+$0180;
  SETSP0COLOR             : byte absolute PMBANK+$0190;
  SETSP1COLOR             : byte absolute PMBANK+$01A0;
  SETSPWIDTH              : byte absolute PMBANK+$01B0;
  SPRITENHOZ              : byte absolute PMBANK+$01C0;
  SPRITENVRT              : byte absolute PMBANK+$01E0;
  SPHOZNEXT               : byte absolute PMBANK+$01F0;
  SCREEN_LINE_ADDR_LOW  	: byte absolute PMBANK+$0000;
  SCREEN_LINE_ADDR_HIGH 	: byte absolute PMBANK+$0020;
  
  SPRHZ0		              : byte absolute PMBANK+$0200;
  SPRHZ1		              : byte absolute PMBANK+$0210;
  SPRHZ2		              : byte absolute PMBANK+$0220;
  SPRHZ3		              : byte absolute PMBANK+$0230;
  SPZONT                  : byte absolute PMBANK+$0240;
  SPZONB                  : byte absolute PMBANK+$0250;

  SPSRC0                  : byte absolute PMBANK+$0260; 
  SPSRC1                  : byte absolute PMBANK+$0278;
  SPSRC2                  : byte absolute PMBANK+$0290;
  SPSRC3                  : byte absolute PMBANK+$02A8;
  SPSRC4                  : byte absolute PMBANK+$02C0;
  SPRITEUSE               : byte absolute PMBANK+$02D8;

  MIBANK                  : byte absolute PMBANK+$0300;
  PMBNK0	                : byte absolute PMBANK+$0400;
  PMBNK1	                : byte absolute PMBANK+$0500;
  PMBNK2	                : byte absolute PMBANK+$0600;
  PMBNK3	                : byte absolute PMBANK+$0700;
	
	a : Byte;
  b : Byte;  
	c : Byte;
  d : Byte;  
	e : Byte;
  f : Byte;  
	g : Byte;
  h : Byte;  
	i : Byte;
  j : Byte;
  k : Byte;
  l : Byte;
  
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
			 
  CRT_INIT (SCREEN_ADDR,40,25);
  CRT_CLEAR;  
  DLISTW := word(@display_list_title); 	 
  SDLSTW := word(@display_list_title); 
  SAVMSC := word(SCREEN_ADDR); 
  SETCHARSET(HI(CHARSET_ADDRESS));
  CHBAS := HI(CHARSET_ADDRESS);
  CRT_GotoXY(0, 0);  
 
  CRT_WRITE('               MIND FIELD              '~*);
  CRT_GotoXY(0, 6); 
  CRT_WRITE('           ATARI 8-BIT VERSION          '~);
  CRT_WRITE(' PROGRAMMING             PETER J. MEYER '~);
  CRT_WRITE('              (YOUR NAME COULD BE HERE) '~);
  CRT_WRITE(' GRAPHICS                               '~);
  CRT_WRITE(' SOUND AND MUSIC                        '~);        
 TMP5:=0; 
  
  k := 6;
  i := 5;
 dmactl :=62;
 nmien :=64;
 

	color0:=142;	
	color1:=010;
	color2:=186;
	color3:=54;
	color4:=34;
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
   CRT_GotoXY(10, 13); 
   CRT_WRITE('SCORE : '~);
   CRT_GOTOXY(18, 13);
   CRT_WRITE (score);
   CRT_GotoXY (8,15);
   CRT_WRITE ('TODAYS HIGH SCORES.'~);
   for i := 1 to 5 do
    begin;
      if k = i then
        begin 
          CRT_GOTOXY(12,16+i);
          CRT_WRITE('*'~);
        end;
      CRT_GOTOXY(14, 16+i);  
      CRT_WRITE (i);
      CRT_WRITE (' :'~);
      CRT_GotoXY(18, 16+i);      
      CRT_WRITE(hiscore[i]);
     end;  
   CRT_GotoXY(7, 23);
   CRT_WRITE('PRESS START TO BEGIN.'~);
   poke (hposp0,124);      
			SetIntVec(iDLI, @title00dli); 
 			nmien :=192;
   
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


procedure Initialize_Level;
	begin
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
        SETCHARSET(HI(CHARSET_ADDRESS));
        CHBAS := HI(CHARSET_ADDRESS);
        Initialize_Level;
				color0:=142;	
				color1:=212;
				color2:=070;
				color3:=150;
				color4:=34;

//	for i := 0 to 255 do
//	begin
//		poke (game_screen + i,i);
//	end;	
		
		     
        
        repeat until CRT_KeyPressed;
	
    until false;
end.

