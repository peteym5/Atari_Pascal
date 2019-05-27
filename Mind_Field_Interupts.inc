procedure TitleVBI;assembler;interrupt;
	asm {
		lda #<title00dli
		sta vdslst+0
		lda #>title00dli
		sta vdslst+1
		lda #$22
		sta colbak
		lda #$36
		sta colpf3				
		inc rtclok+2
		jmp XITVBV
	};	
end;
 
procedure GameVBI;interrupt;  //  assembler;
	begin
	asm {
		lda #<title00dli
		sta vdslst+0
		lda #>title00dli
		sta vdslst+1
		lda #$22
		sta colbak
		lda mind_color
		sta colpf3		
inc_rt_clock
		inc rtclok+2
		bne no_inc_other_clock
		inc rtclok+1
		bne no_inc_other_clock
		inc rtclok
no_inc_other_clock	
    };  
//
// Can we do some no ASM within the VBI?
//     

    asm {		
		jmp XITVBV
	};	
end;

procedure PauseVBI;assembler;interrupt;
  asm {};
end;

procedure title00dli;assembler;interrupt;
	asm {
	pha	
	lda #$D8
	sta wsync
	sta colpf0
	lda #$06
	sta colpf1
	lda #$AA
	sta colpf2
	lda #>CHARSET_TITLE
	sta chbase
	lda #<title01dli
	sta vdslst+0
	lda #>title01dli
	sta vdslst+1
	pla
	rti};
end;

procedure title01dli;assembler;interrupt;
	asm {
	pha	
	lda #142
	sta wsync
	sta colpf0
	lda #216
	sta colpf1
	lda #56
	sta colpf2
	lda #>CHARSET_GAME
 	sta chbase
	lda #<title00dli
	sta vdslst+0
	lda #>title00dli
	sta vdslst+1
	pla
	rti};

end;

procedure title02dli;assembler;interrupt;
	asm {phr
	plr};

end;

procedure title03dli;assembler;interrupt;
	asm {phr
	plr};
end;


procedure game00dli;assembler;interrupt;
	asm {phr
	plr};

end;

procedure game01dli;assembler;interrupt;
	asm {phr
	plr};
end;

procedure game02dli;assembler;interrupt;
	asm {phr
	plr};
end;

procedure game03dli;assembler;interrupt;
	asm {phr
	plr};
end;
