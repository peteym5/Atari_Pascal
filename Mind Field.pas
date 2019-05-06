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
     
	screen_adr 						= 16384;
  PMBANK                = $1000;
  VARBANK               = $1800;
	CHARSET_ADDRESS       = $A400;
	CHARSET_BASE					= $A4;

  display_list_title: array [0..50] of byte = (
  $70,$70,$44,
  lo(screen_adr),
  hi(screen_adr),
  $04,$04,$04,$04,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$00,$04,$41,
  lo(word(@display_list_title)), 
  hi(word(@display_list_title))
  );
  
  display_list_game: array [0..34] of byte = (
  $70,$50,$43,
  lo(screen_adr),
  hi(screen_adr),
  $03,$03,$10,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$41,
  lo(word(@display_list_game)), 
  hi(word(@display_list_game))
  );
  
var
  PRIOR								    : byte absolute $D01B;
  TMP0								    : byte absolute $C0;
  TMP1								    : byte absolute $C1;
  TMP2								    : byte absolute $C2;
  TMP3								    : byte absolute $C3;
  TMP4								    : byte absolute $C4;
  TMP5								    : byte absolute $C5;
  TMP6								    : byte absolute $C6;
  TMP7								    : byte absolute $C7;
  TMP8								    : byte absolute $C8;
  TMP9								    : byte absolute $C9;
  NDX0								    : byte absolute $CA;
  NDX1								    : byte absolute $CB;
  NDX2								    : byte absolute $CC;
  NDX3								    : byte absolute $CD;
  HOLDX								    : byte absolute $CE;
  HOLDY								    : byte absolute $CF;
    
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

  screen :word = $B000;	
  i : Byte;
  j : Byte;
  k : Byte;
  
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
			 
  CRT_INIT (screen_adr,40,23);
  CRT_CLEAR;  
  DLISTW := word(@display_list_title); 	 
  SDLSTW := word(@display_list_title); 
  SAVMSC := word(screen_adr); 
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
 

	colpf0:=142;	
	colpf1:=010;
	colpf2:=186;
	colpf3:=54;
	colbk:=34;
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
   
 repeat 
     
		  
		 
		    // if CRT_OptionPressed then 
        // else CRT_Write(' OPTION '~);

        // if CRT_SelectPressed then CRT_Write(' SELECT '~*)
        // else CRT_Write(' SELECT '~);

        if CRT_StartPressed then TMP5:=255;

        // if CRT_HelpPressed then CRT_Write(' HELP '~*)
        // else CRT_Write(' HELP '~);
 until tmp5=255;
 
 //  repeat
 //  until CRT_StartPressed = false;
 
 
asm {
Title_VBI
      
//    ORG 32768
//    ICL "inflate_2017_ver4.asm"
//    ORG 46080
//    INS "roman10.fnt" 
};
end;


procedure Initialize_Level;
begin
end;

procedure Display_Information_Line;
begin
  CRT_GotoXY(0, 0);
  CRT_WRITE('SCORE:'~);
  CRT_GotoXY(8, 0);
  CRT_WRITE (score);
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
        lives := 0;
        CRT_INIT (screen_adr,40,23);
        CRT_CLEAR;  
        DLISTW := word(@display_list_game); 	 
        SDLSTW := word(@display_list_game); 
        SAVMSC := word(screen_adr); 
        SETCHARSET(HI(CHARSET_ADDRESS));
        CHBAS := HI(CHARSET_ADDRESS);
        
        repeat until CRT_KeyPressed;
	
asm {
DISPLIST 	          = $0400
SCRTXT              = $0440
;SCREEN              = $8000
       
};

    until false;
end.
 
 
