procedure TitleVBI;assembler;interrupt;
	asm {};	
end;
 
procedure GameVBI;assembler;interrupt;
  asm {};
end;

procedure PauseVBI;assembler;interrupt;
  asm {};
end;

procedure title00dli;assembler;interrupt;
	asm {
	pha	
	lda #$00
	sta wsync
	sta colbak
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
	lda #$22
	sta wsync
	sta colbak
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
