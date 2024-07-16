@;----------------------------------------------------------------
@;  CelsiusFahrenheit.s: rutines de conversi� de temperatura en 
@;						 format Q12 (Coma Fixa 1:19:12). 
@;----------------------------------------------------------------
@;	santiago.romani@urv.cat
@;	pere.millan@urv.cat
@;	(Mar� 2021, Mar� 2022)
@;----------------------------------------------------------------
@;	Programador/a 1: florian.serb@estudiants.urv.cat
@;	Programador/a 2: alan.rocha@estudiants.urv.cat
@;----------------------------------------------------------------*/

.include "include/Q12.i"

.text
		.align 2
		.arm

@; Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
@;						temperatura equivalent en graus Fahrenheit, utilitzant
@;						valors codificats en Coma Fixa 1:19:12.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input * 9/5) + 32.0;
	.global Celsius2Fahrenheit	@; Declarem la funcio "Celsius2Fahrenheit" 
	@; .global per a que sigui visible per a tots els fitxers
Celsius2Fahrenheit:				@; Inicialitzem la funcio "Celsius2Fahrenheit"
	push {r1-r3, lr}
		@; prod64 = r0 * Q12(9/5)
		mov r1, #0x1C00 		@; guardem el valor del 9/5 en Q12 = 0x1CCD
		add r1, #0x00CD 		@; Aquest valor el separem en dos perque el tamany del operador te un tamany de 8 bits
		smull r2, r3, r0, r1 	@; Multipliquem amb signe i guardem el resultat en els registres r2 i r3
		@;s = signe
		@; r2 (part baixa), r3 (part alta)
		mov r2, r2, lsr #12		@; Mou el registre a la dreta part baixa
		orr r2, r3, lsl #20		@; Passem els bits de menys pes de r3 cap a r2
		mov r3, r3, lsr #12		@; Mou el r3 cap a la dreta part alta
		add r2, #0x20000		@; Al registre r2 li sumem 32bits
		mov r0, r2				@; El resultat de r2, el movem a r0
	pop {r1-r3, pc}				@; Recuperem els valor dels registres i actualitzem el pc pero tornar al main

@; Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
@;						temperatura equivalent en graus Celsius, utilitzant
@;						valors codificats en Coma Fixa 1:19:12.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input - 32.0) * 5/9;
	.global Fahrenheit2Celsius		
Fahrenheit2Celsius:					@;Inicialitzem la funcio "Celsius2Fahrenheit"
	push {r1-r3, lr}				@; Salvem les dades dels registres
		sub r0, #0x20000			@; Li restem 32bits al r0
		ldr r1, =0x8E4				@; Igualem a r1 el valor hexadecimal "0x8E4" 
		smull r2, r3, r0, r1  		@; Multipliquem amb signe i guardem el resultat en els registres r2 i r3
		@;s = signe
		@; r2 (part baixa), r3 (part alta)
		mov r2, r2, lsr #12 		@; Mou a la dreta el registre part baixa
		orr r2, r3, lsl #20 		@; Passem els bits de menys pes de r3 a r2
		mov r3, r3, asr #12 		@; Mogem a la dreta el registre part alta
		mov r0, r2					@; El resultat de r2, el passem a r0	
	pop {r1-r3, pc}					@; Recuperem els valors del registres i actualitzem el pc pero tornar al main.	