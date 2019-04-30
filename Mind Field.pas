uses atari, graph, crt, sysutils;    // CRT using 8-bit OS!  
// uses atari, crt, sysutils;
// DOES PASCAL HAVE INCLUDE????


// Pascal Reserved Words
// 	and			array		begin			case			const
// 	div			do			downto		else			end
// 	file		for			function	goto			if
// 	in			label		mod				nil				not
// 	of			or			packed		procedure	program
// 	record	repeat	set				then			to
// 	type		until		var				while			with



    
const
	PRIOR									= $D01B;
  TEMP0									= $C0;
  TEMP1									= $C1;
  TEMP2									= $C2;
  TEMP3									= $C3;
  TEMP4									= $C4;
  TEMP5									= $C5;
  TEMP6									= $C6;
  TEMP7									= $C7;
  TEMP8									= $C8;
  TEMP9									= $C9;
  NDX0									= $CA;
  NDX1									= $CB;
  NDX2									= $CC;
  NDX3									= $CD;
  HOLDX									= $CE;
  HOLDY									= $CF;
    
  M0										= $C0;
  M1										= $C1;
  M2										= $C2;
  M3										= $C3;
  M4										= $C4;
  M5										= $C5;
  M6										= $C6;
  M7										= $C7;
  M8										= $C8;
  M9										= $C9;
  MX    								= $CE;
  MY        						= $CF;

	
	screen_adr 						= 16384;
  PMBANK                = $1000;
  VARBANK               = $1800;
  SPRITENUM	            = PMBANK+$0180;
  SETSP0COLOR           = PMBANK+$0190;
  SETSP1COLOR           = PMBANK+$01A0;
  SETSPWIDTH            = PMBANK+$01B0;
  SPRITENHOZ            = PMBANK+$01C0;
  SPRITENVRT            = PMBANK+$01E0;
  SPHOZNEXT             = PMBANK+$01F0;
  SCREEN_LINE_ADDR_LOW	= PMBANK+$0000;
  SCREEN_LINE_ADDR_HIGH	= PMBANK+$0020;
  CHARSET_ADDRESS       = $A400;



  SPRHZ0		            = PMBANK+$0200;
  SPRHZ1		            = PMBANK+$0210;
  SPRHZ2		            = PMBANK+$0220;
  SPRHZ3		            = PMBANK+$0230;
  SPZONT                = PMBANK+$0240;
  SPZONB                = PMBANK+$0250;

  SPSRC0                = PMBANK+$0260; 
  SPSRC1                = PMBANK+$0278;
  SPSRC2                = PMBANK+$0290;
  SPSRC3                = PMBANK+$02A8;
  SPSRC4                = PMBANK+$02C0;
  SPRITEUSE             = PMBANK+$02D8;

  MIBANK                = PMBANK+$0300;
  PMBNK0	              = PMBANK+$0400;
  PMBNK1	              = PMBANK+$0500;
  PMBNK2	              = PMBANK+$0600;
  PMBNK3	              = PMBANK+$0700;
     
  display_list_title: array [0..29] of byte = (
  $70,$30,$43,
  lo(screen_adr),
  hi(screen_adr),
  $03,$03,$03,$03,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$41,
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
  screen :word = $B000;	
  i : Byte;
  j : Byte;
  k : Byte;
  
	titlephase: Byte = 0;
  score: word = 4250;
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
  
  ClrScr;  
  CursorOff;
  DLISTW := word(@display_list_title);
	sdlstw := word(@display_list_title); 	 
  SAVMSC := word(screen_adr); 
  GotoXY(0, 3);  
  writeln('               Mind Field              ');
  GotoXY(0, 6); 
  writeln('           Atari 8-Bit Version         ');
  writeln(' Programmers:           Peter J. Meyer ');
//writeln('             (Your name could be here) ');
//writeln(' Graphicsming                          ');
//writeln(' Sound                                 ');        
  
	color1:=010;
	color2:=128;
  
  k := 11;
  i := 10;
 dmactl :=62;
 nmien :=64;
 
  repeat     
      if score>hiscore[i] then 
        begin;
          k := i
        end;
      i := i - 1    
  until i = 0;
  if k < 10 then 
    begin;
      i := 10;  
      repeat
        hiscore [i] := hiscore [i-1];
        i := i - 1    
      until i = k;
      hiscore [k] := score
    end;
   GotoXY(12, 9); 
   write('Score:',score);
   GotoXY (8,10);
   write ('Todays High Scores.');
   for i := 1 to 10 do
    begin;
      if k = i then
        begin 
          GotoXY(12,11+i);
          write('*');
        end;
      if i = 10 then
        begin
          GotoXY(13, 11+i);
        end
      else
        begin
          GotoXY(14, 11+i);
        end;
      write (i,' :');
      GotoXY(18, 11+i);      
      write(hiscore[i]);
     end;  
   GotoXY(7, 22);
   write('Press Start to Begin.');
   poke (hposp0,124);
   

   
   
 repeat until keypressed;
 
 
// asm {    
//    ORG 32768
//    ICL "inflate_2017_ver4.asm"
//    ORG 46080
//    INS "roman10.fnt" 
// };
end;

procedure init_game;
begin
	DPOKE(560, word(@display_list_game));
  DPOKE (88,screen_adr);
end;

// CHARSET_ADDRESS rcdata 'Mind Field\MINDFIELD.FNT'

{***************************************************************************************}
{************************************** MAIN *******************************************}
{***************************************************************************************}


begin
		ShowTitleScreen;

asm {
DISPLIST 	          = $0400
SCRTXT              = $0440
;SCREEN              = $8000
       
};


end.

