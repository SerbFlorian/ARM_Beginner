@;----------------------------------------------------
@;	Programador/a 1: florian.serb@estudiants.urv.cat |
@;	Programador/a 2: alan.rocha@estudiants.urv.cat   |
@;----------------------------------------------------

.include "includes/Q12.i"

.text
	.align 2
	.arm
	
@;SUMA	
@; r0 -> num1 						
@; r1 -> num2			
@; r2 -> unsigned char *overflow	@; r2 -> &overflow
									@; r3 -> ov
@; Output -> sortida per r0 de num1 + num2, es modifica el valor de r2 per parametre (si r2=0 -> !overflow, si r2=1 -> overflow)

	.global add_Q12     	
add_Q12:
	push {r3, lr}					@; Guardem les dades	
		adds r0, r1					@; Realitzem la suma a r0   						
		@;Afegim una "s" a la instruccio "add" per tal de poder actualitzar amb la opercaio els flags...
		@; ... i comprovar si ha hagut overflow o no
		movvc r3, #0	 			@; Si v=0 llavors direm a r3 que no hi ha overflow
		@; Amb la instrucci� "vc" que afegim a "mov" volem dir que no hi ha overflow
		movvs r3, #1				@; si v=1 llavors direm a r3 que si hi ha overflow
		@; Amb la instrucci� "vs" que afegim a "mov" volem dir que hi ha overflow
		strb r3, [r2]				@; Escriure resultat de si tenim overflow o no "overflow"
		@; "b" = escriu bits alts al signe
	pop {r3, pc}					@; recuperem les dades y tornem a la funcio que crida aquesta rutina.

@; RESTA
@; r0 -> num1 						
@; r1 -> num2			
@; r2 -> unsigned char *overflow
@; output -> sortida per r0 de num1 - num2, es modifica el valor de r2 per parametre (si r2=0 -> !overflow, si r2=1 -> overflow)
.global sub_Q12     
sub_Q12:
	push {r3, lr}					@; Guardem les dades		
		subs r0, r1					@; realitzem la resta a r0	
		@;Afegim una "s" a la instruccio "sub" per tal de poder actualitzar amb la opercaio els flags...
		@; ... i comprovar si ha hagut overflow o no.
		movvc r3, #0				@; Si v=0 llavors direm a r3 que no hi ha overflow
		@; Amb la instrucci� "vc" que afegim a "mov" volem dir que no hi ha overflow
		movvs r3, #1				@; si v=1 llavors direm a r3 que si hi ha overflow
		@; Amb la instrucci� "vs" que afegim a "mov" volem dir que hi ha overflow	
		strb r3, [r2]				@; Escriure resultat a "overflow"
		@; "b" = escriu bits alts al signe
	pop {r3, pc}					@; recuperem les dades y tornem a la funcio que truca aquesta rutina.

@; MULTI
	.global mul_Q12    			 	@; Si no definim ni incialitzem la funcio mul_Q12 peta el programa
mul_Q12:							@; Perque les llibreries del "makefile" les crida i al no estar "peta"
	push {lr}			
	pop {pc}

@; DIVI
	.global div_Q12     			@; Si no definim ni incialitzem la funcio div_Q12 peta el programa
div_Q12:							@; Perque les llibreries del "makefile" les crida i al no estar "peta"
	push {lr}	
	pop {pc}