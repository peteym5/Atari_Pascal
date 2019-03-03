uses atari, crt, graph, sysutils;  

// DOES PASCAL HAVE INCLUDE????

{$R ASSETS_CHARSETS.RS}
    
const
  screen_adr = 45056;
  PMBANK              = $1000;
  VARBANK             = $1800;
  SPRITENUM	          = PMBANK+$0180;
  SETSP0COLOR         = PMBANK+$0190;
  SETSP1COLOR         = PMBANK+$01A0;
  SETSPWIDTH          = PMBANK+$01B0;
  SPRITENHOZ          = PMBANK+$01C0;
  SPRITENVRT          = PMBANK+$01E0;
  SPHOZNEXT           = PMBANK+$01F0;
  SCREEN_LINE_ADDR_LOW	= PMBANK+$0000;
  SCREEN_LINE_ADDR_HIGH	= PMBANK+$0020;


  SPRHZ0		          = PMBANK+$0200;
  SPRHZ1		          = PMBANK+$0210;
  SPRHZ2		          = PMBANK+$0220;
  SPRHZ3		          = PMBANK+$0230;
  SPZONT              = PMBANK+$0240;
  SPZONB              = PMBANK+$0250;

  SPSRC0              = PMBANK+$0260; 
  SPSRC1              = PMBANK+$0278;
  SPSRC2              = PMBANK+$0290;
  SPSRC3              = PMBANK+$02A8;
  SPSRC4              = PMBANK+$02C0;
  SPRITEUSE           = PMBANK+$02D8;

  MIBANK              = PMBANK+$0300;
  PMBNK0	            = PMBANK+$0400;
  PMBNK1	            = PMBANK+$0500;
  PMBNK2	            = PMBANK+$0600;
  PMBNK3	            = PMBANK+$0700;
     
  display_list_title: array [0..29] of byte = (
  $70,$50,$43,
  lo(screen_adr),
  hi(screen_adr),
  $03,$03,$03,$03,$03,$10,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$41,
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



   
begin


asm {
DISPLIST 	          = $0400
SCRTXT              = $0440
;SCREEN              = $8000
       
};

  InitGraph(0);
  chbase1 :=180;
  topMem := chbase1 * 256;
asm {
    lda #0
    sta 82
    sta 710
    lda #12
    sta 709
    lda chbase1
    sta 756
    LDA #0
    STA NMIEN
    STA DMACTL
    STA PRIOR

    LDX #>RamSizeCode+1
    LDY #$00
    STY NDX0
    STY NDX2
    LDA #$38
    STA NDX1
    LDA #$A8
    STA NDX3
    
MLR_CRLOOP
    LDA (NDX2),Y
    STA (NDX0),Y
    INY
    BNE MLR_CRLOOP
    INC NDX1
    INC NDX3
    DEX
    BNE MLR_CRLOOP

		LDA #<SCREEN
		STA M0	
		LDA #>SCREEN
		STA M1	
		LDY #$00
MAKE_SCREEN_ADDR_LOOP
		lda M0
		sta SCREEN_LINE_ADDR_LOW,Y
		clc			
		adc #40
		sta M0			
		lda M1			
		sta SCREEN_LINE_ADDR_HIGH,Y
		bcc NOSHA		
		inc M1			
NOSHA		
    iny			
		cpy #$18		
		bcc MAKE_SCREEN_ADDR_LOOP
        

    LDA #<TITLE00DLI
    STA VDSLST + 0
    LDA #>TITLE00DLI
    STA VDSLST + 1
    LDA #<VBI_TITLE
    STA VVBLKI + 0 
    LDA #>VBI_TITLE
    STA VVBLKI + 1 
    LDA #0
    STA M0
    STA VBIDONE
    LDA #$01
    STA $09
HOLDINGCONSOLKEY1
    LDA #08
    STA CONSOL
    LDA CONSOL
    CMP #7
    BNE HOLDINGCONSOLKEY1 
;    JSR :RMT_SILENCE
    LDA #08
    STA CONSOL
    STA $99
    JSR Clear_Sprite_Memory
    JSR Clear_Screen
  
  
};
  
  ClrScr;  
  CursorOff;
  dpoke(560, word(@display_list_title));
  //dpoke(88, word(@screen));
  DPOKE (88,screen_adr);
  GotoXY(0, 3);  
  writeln('               Mind Field              ');
  GotoXY(0, 5); 
  writeln('           Atari 8-Bit Version         ');
  writeln(' Programmers:           Peter J. Meyer ');
  writeln('             (Your name could be here) ');
  writeln(' Graphicsming                          ');
  writeln('                                       ');
  writeln(' Sound                                 ');
  writeln('                                       ');        
  
  
  k := 11;
  i := 10;
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
   GotoXY(12, 7); 
   write('Score:',score);
   GotoXY (8,9);
   write ('Todays High Scores.');
   for i := 1 to 10 do
    begin;
      if k = i then
        begin 
          GotoXY(12,9+i);
          write('*');
        end;
      if i = 10 then
        begin
          GotoXY(13, 9+i);
        end
      else
        begin
          GotoXY(14, 9+i);
        end;
      write (i,' :');
      GotoXY(18, 9+i);      
      write(hiscore[i]);
     end;  
   GotoXY(7, 21);
   write('Press Start to Begin.');
   poke (hposp0,124);
 repeat until keypressed;
 
 
// asm {    
//    ORG 32768
//    ICL "inflate_2017_ver4.asm"
//    ORG 46080
//    INS "roman10.fnt" 
// };

end.

procedure init_game;
  dpoke(560, word(@game_list_title));
  DPOKE (88,screen_adr);
end;

