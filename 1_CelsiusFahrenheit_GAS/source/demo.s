@;-----------------------------------------------------------------------
@;   Description: a program to check the temperature-scale conversion
@;				functions implemented in "CelsiusFahrenheit.c".
@;	IMPORTANT NOTE: there is a much confident testing set implemented in
@;				"tests/test_CelsiusFahrenheit.c"; the aim of "demo.s" is
@;				to show how would it be a usual main() code invoking the
@;				mentioned functions.
@;-----------------------------------------------------------------------
@;	Author: Santiago Romani (DEIM, URV)
@;	Date:   March/2022 
@;-----------------------------------------------------------------------
@;	Programador/a 1: florian.serb@estudiants.urv.cat
@;	Programador/a 2: alan.rocha@estudiants.urv.cat
@;-----------------------------------------------------------------------*/

.data
		.align 2
	temp1C:	.word 0x0002335C		@; temp1C = 35.21 �C
	temp2F:	.word 0xFFFE8400		@; temp2F = -23.75 �F

.bss
		.align 2
	temp1F:	.space 4				@; expected conversion:  95.379638671875 �F
	temp2C:	.space 4				@; expected conversion: -30.978271484375 �C

.text
		.align 2					
		.arm						
		.global main				
main:								
		push {lr}					
		@; temp1F = Celsius2Fahrenheit(temp1C);
		ldr r1, =temp1C				@; Guardem en r1 la direccio de temp1C		
		ldr r0, [r1]				@; Carreguem a r0 el contingut de la direccio r1		
		bl Celsius2Fahrenheit   	@; Fem una crida a la rutina que modificara r0
		ldr r2, =temp1F        		@; Guardem en r2 la direccio de temp1F 
		str r0, [r2]				@; Carreguem el contingut que tenim a r0 per a modificar Celsius2Fahrenheit
		@; temp2C = Fahrenheit2Celsius(temp2F);
		ldr r1, =temp2F				@; Guardem en r1 la direccio de temp2F
		ldr r0, [r1]				@; Carreguem a r0 el contingut de la direccio r1
		bl Fahrenheit2Celsius   	@; Fem una crida a la rutina que modificara r0
		ldr r2, =temp2C         	@; Guardem en r2 la direccio de temp2C
		str r0, [r2]				@; Carreguem el el contingut que tenim a r0 per a modificar Fahrenheit2Celsius

@; TESTING POINT: check the results
@;	(gdb) p /x temp1F		-> 0x0005F613
@;	(gdb) p /x temp2C		-> 0xFFFE1059
@; BREAKPOINT
		mov r0, #0					@; return(0)
		
		pop {pc}

.end