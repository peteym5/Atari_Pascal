unit b_set_interupts;
(*
* @type: unit
* @author: bocianu <bocianu@gmail.com>
* @name: System Tools
* @version: 0.5.2
* @description:
* Set of useful constants, registers and methods to simplify common
* system related tasks in Atari 8-bit programming.
*
* This library is a part of 'blibs' - set of custom Mad-Pascal libraries.
*
* <https://gitlab.com/bocianu/blibs>
*)
interface
uses atari;
procedure SetVBLI(vblptr: pointer); assembler;
(*
* @description:
* Enable and set custom handler for Vertical Blank Interrupt.
*
* @param: vblptr - pointer to interrupt handler routine
*)
procedure SetVBLD; assembler;
(*
* @description:
* Disables custom routine of Vertical Blank Interrupt.
*)
procedure SetDLI(dliptr: pointer); assembler;
(*
* @description:
* Enable and set custom handler for Display List Interrupt.
*
* @param: dliptr - pointer to interrupt handler routine
*)
var __nmien:byte;

const
	PORTB_SELFTEST_OFF = %10000000; // portb bit value to turn Self-Test off
	PORTB_BASIC_OFF = %00000010;	// portb bit value to turn Basic off
	PORTB_SYSTEM_ON = %00000001;	// portb bit value to turn System on

implementation


procedure SetVBLI(vblptr: pointer); assembler;
asm
{
	mwa vblptr vvblki
};
end;


procedure SetVBLD(vblptr: pointer); assembler;
asm
{
		mwa vblptr vvblkd
};
end;


procedure SetDLI(dliptr: pointer); assembler;
asm
{
		mwa dliptr vdslst
};
end;

end.
