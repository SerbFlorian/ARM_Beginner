@;-------------------------------------------------------------------------------
@;	Programador/a 1: florian.serb@estudiants.urv.cat
@;	Programador/a 2: alan.rocha@estudiants.urv.cat
@;-------------------------------------------------------------------------------

.include "include/avgmaxmintemp.i"

.bss							
	data_c: .space 4 			@; Afegim la variable "data_c" i reservem un espai en memoria de 32bits
	data_r: .space 4			@; Afegim la variable "data_r" i reservem un espai en memoria de 32bits

.text
	.align 2
	.arm
	
@; Funcio Calcular mitjana/maxima/minima ciutats 
@; r0 = ttemp[][12]
@; r1 = nrows
@; r2 = id_city
@; r3 = *mmres
@; Output = r0 el cocient de la divisio "variable avg" i *mmres "temp min y max"
@; r4 = avg
@; r5 = max
@; r6 = min
@; r7 = idmin = 0
@; r8 = idmax = 0
@; r9 = i
@; r10 = tvar

	.global avgmaxmin_city      @; Definim la funcio com a global per a poder ser cridada desde altres funcions
avgmaxmin_city:					@; Inicialitzem la funcio "avgmaxmin_city"
	push {r1-r12, lr}			@; Guardem les dades
	
	mov r7, #0					@; Inicialitzem les direccions locals a 0
	mov r8, #0					@; Inicialitzem les direccions locals a 0
	
	mov r11, #12				@; Afegim a r11 -> 12 messos = "12 columnes"
	mul r11, r2, r11			@; Ara fem una multiplicacio a r11 = multipliquem  id_city * 12 messos
	ldr r4, [r0, r11, lsl #2] 	@; Carreguem a r4 el calcul de: r0 + r11 * 4 (dades tipus word = 32bits)
	mov r5, r4					@; Igualem el contingut de r4 a r5 "avg = max"
	mov r6, r4					@; Igualem el contingut de r4 a r6 "min = avg"
	
@; BUCLE
		mov r9, #1					@; Inicialtzem la i a 1 "r9 = 1"
.Lfor:							@; Inicialitzem el ".Lfor"
	add r12, r9, r11 			@; A r12 guardem el recorregut de la "i" fins a 12"maxim de messos" 
	ldr r10, [r0, r12, lsl #2] 	@; Carreguem el registre a tvar = taula tempereatura"ttemp[id_city][i]"
	add r4, r10					@; Afegim a avg += tvar
	@; IF per trobar el MAX
	cmp	r10, r5					@; Comparem si r10 es mes gran que r5 "tvar > max" si es compleix entra a la condicio
	ble .Lifmin					@; Si tvar es mes petit < que max saltara al IF MIN	
	mov r5, r10					@; Igualem el contingut de max = tvar "ja que em trobat el valor maxim"
	mov r8, r9					@; Igualem el contingut de idmax = i
	@; IF per trobar el MIN
.Lifmin:						@; Inicialitzem el ".Lifmin"
	cmp	r10, r6					@; Comparem si tvar < min si es compleix entra a la condicio
	bge .Lfif					@; Si no es compleix salta al .Lfif
	mov r6, r10					@; Igualem el min = tvar "ja que em trobat el valor minim"
	mov r7, r9					@; Igualem el idmin = i
.Lfif:							@; Inicialitzem el ".Lfif"
	add r9, #1					@; Per acabar amb el for, em d'afegir el i++
	cmp r9, #12					@; Tambe em d'afegir la comparacio, si la i < 12 entra a for
	blo .Lfor					@; Si no es compleix la condicio salta al if i < 12 fins trobar el valor mes petit que 12
@; FINAL del BUCLE
	
@; /12
	@; r0->ttemp[][12], r1->den=12, r2->&cociente, r3-> &resto, r4->avg, r11-> avgNeg
	mov r0, r4					@; Movem avg a r0
	mov r11, #0					@; Inicialitzem avg a Negatiu
	cmp r0, #0					@; Comparem el contingut de avg si es mes petit que 0 "if (avg < 0)"
	movlt r11, #1				@; Si es compleix la condicio avgNeg verifiquem que es negatiu
	@; lt = menos que movlt = movemos si es menos que 1
	rsblt r0, #0				@; Una vegada verifiquem que es NEGATIU ho passem a POSITIU
	@; rsblt fa una resta si el valor de r0 es MENOR que 0
	mov r1, #12					@; Afegim a r1 el denominador 12"messos"
	mov r4, r3					@; Passem avg a r3 "residu"
	
	ldr r2, =data_c				@; Carreguem a r2 el registre de data_c
	ldr r3, =data_r				@; Carreguem a r3 el registre de data_r
	
	bl div_mod					@; Cridem la funcio per a fer la divisio entre 12
	@; Sols ens importa el COCIENT
	ldr r1, [r2]				@; Carreguem a r1 el registre de r2"data_c"
	
	cmp r11, #1					@; Comparem si avgNeg si es NEGATIU
	rsbeq r1, #0 				@; Si es NEGATIU ho passem a POSITIU
@; FINAL /12
	
	@; transferir datos al struct
	str r6, [r4, #MM_TMINC]		@; Guardem les dades en memoria, en aquest cas temperatura minima en MM_TMINC "mmres->tmin_C = min;"
	str r5, [r4, #MM_TMAXC]		@; Guardem les dades en memoria, en aquest cas temperatura maxima en MM_TMAXC "mmres->tmax_C = max;"
	mov r0, r6 					@; Igualem el contingut de "ttemp a min"
	bl Celsius2Fahrenheit		@; Invoquem/Cridem la funcio "Celsius2Fahrenheit(min);"
	str r0, [r4, #MM_TMINF]		@; Guardem les dades en memoria, en aquest cas temperatura minima Fahrenheit en MM_TMINF 
								@; "mmres->tmin_F = Celsius2Fahrenheit(min)"
	mov r0, r5					@; Igualem el contingut de "ttemp a max"
	bl Celsius2Fahrenheit		@; Invoquem/Cridem la funcio "Celsius2Fahrenheit(max);"
	str r0, [r4, #MM_TMAXF]		@; Guardem les dades en memoria, en aquest cas temperatura maxima Fahrenheit en MM_TMAXF
								@; "mmres->tmax_F = Celsius2Fahrenheit(max);"
	strh r7, [r4, #MM_IDMIN]	@; Guardem les dades en una memoria de 16 bits"short", la ID de temperatura minima MM_IDMIN
								@; "mmres->id_min = idmin (2bytes);"
	strh r8, [r4, #MM_IDMAX]	@; Guardem les dades en una memoria de 16 bits"short", la ID de temperatura maxima MM_IDMAX 
								@; "mmres->id_max = idmax (2bytes);"
	
	mov r0, r1					@; Igualem el contingut de ttemp a files "return(cociente=avg);"
	pop {r1-r12, pc}			@; Recuperem les dades i tornem a la funcio que crida aquesta rutina
	

@; Funcio calcular mijana, maxim i minim de un mes de varies ciutats
@; r0 -> ttemp[][12]
@; r1 -> nrows
@; r2 -> id_month
@; r3 -> *mmres
@; Output -> r0 el cocient de la divisio "variable avg" i *mmres "temp min y max")
@; r4->avg 
@; r5->max
@; r6->min
@; r7->idmin = 0
@; r8->idmax = 0
@; r9->i
@; r10 -> tvar

	.global avgmaxmin_month     @;Definim la funcio com a global per a poder ser cridada desde altres funcions
avgmaxmin_month:				@; Inicialitzem la funcio "avgmaxmin_month"
	push {r1-r12, lr}			@; Guardem les dades

	mov r7, #0					@; Inicialitzem les direccions locals a 0
	mov r8, #0					@; Inicialitzem les direccions locals a 0
	
	ldr r4, [r0, r2, lsl #2] 	@; Carreguem a r4 el calcul de: r0 + r11 * 4 (dades tipus word = 32bits)
	mov r5, r4					@; Igualem el contingut de r4 a r5 "max = avg"
	mov r6, r4					@; Igualem el contingut de r4 a r6 "min = avg"
	
@; BUCLE
	mov r9, #1					@; Inicialitzem la i a 1 "r9 = i = 1"
	mov r12, #12				@; Inicialitzem r12 amb 12 volors "12 messos"
.Lfor2:							@; Inicialitzem el ".Lfor2"
	cmp r9, r1					@; Comparem si r1 es major a r9 "i < n_rows"
	bhs .Lfifor2				@; Si la condicio no es compleix salta al final del for
	mul r11, r9, r12			@; Ara fem una multiplicacio de "i*12 messos" i ho guardem en r11
	add r11, r2					@; Al resultat de la multiplicacio sumem r2 "r11 = (i*12 + r2)"
	ldr r10, [r0, r11, lsl #2] 	@; Carreguem a r10 la ttempertura calculada en r11 i desplacem dos bits  
								@; "tvar = ttemp[id_city][i] = r0 + (r9*12 + r2) * 4"
	add r4, r10					@; Afegim a avg el contingut de tvar
	@; IF per trobar el MAX
	cmp	r10, r5					@; Comparem si tvar es MAJOR que MAX "tvar > max"
	ble .Lifmin2				@; Si tvar es mes petit < que max saltara al IF MIN
	mov r5, r10					@; Igualem el contingut de max = tvar "perque es el valor maxim"
	mov r8, r9					@; Igualem el la ID MAXIMA a i
	@;IF per trobar el MIN
.Lifmin2:						@; Inicialitzem el ".Lifmin2"
	cmp	r10, r6					@; Comparem si tvar < min si es compleix entra a la condicio
	bge .Lfif2					@; Si no es compleix salta a .lfif2
	mov r6, r10					@; Igualem el min = tvar "ja que em trobat el valor minim"
	mov r7, r9					@; idmin = i
.Lfif2:							@; Inicialitzem el ".Lfif2"
	add r9, #1					@; Per acabar amb el for, em d'afegir el i++
	b .Lfor2					@; Al acabar d'incrementar la "i++" fem un salt a .Lfor2
.Lfifor2:						@; Inicialitzem el ".Lfifor2"	
@; FINAL DEL BUCLE
	
@; /12
	@; r0->ttemp[][12], r1->den=12, r2->&cociente, r3-> &resto, r4->avg, r11-> avgNeg
	mov r0, r4					@; Movem avg a r0
	mov r11, #0					@; Inicialitzem avg a Negatiu
	cmp r0, #0					@; Comparem el contingut de avg si es mes petit que 0 "if (avg < 0)"
	movlt r11, #1				@; Si avgNeg es menos que 1 se movera el contenido
	@; lt = menos que movlt = movemos si es menos que 1
	rsblt r0, #0				@; Una vegada verifiquem que es NEGATIU ho passem a POSITIU
	@; rsblt fa una resta si el valor de r0 es MENOR que 0
	mov r1, #12					@; Afegim a r1 el denominador 12"messos"
	mov r4, r3					@; Passem avg a r3 "residu"
	
	ldr r2, =data_c				@; Carreguem a r2 el registre de data_c
	ldr r3, =data_r				@; Carreguem a r3 el registre de data_r
	
	bl div_mod					@; Cridem la funcio per a fer la divisio entre 12
	@; Sols ens importa el COCIENT
	ldr r1, [r2]				@; Carreguem a r1 el registre de r2"data_c"
	
	cmp r11, #1					@; Comparem si avgNeg si es NEGATIU
	rsbeq r1, #0 				@; Si es NEGATIU ho passem a POSITIU
@; FINAL /12
	
	@; transferir datos al struct
	str r6, [r4, #MM_TMINC]		@; Guardem les dades en memoria, en aquest cas temperatura minima en MM_TMINC "mmres->tmin_C = min;"
	str r5, [r4, #MM_TMAXC]		@; Guardem les dades en memoria, en aquest cas temperatura maxima en MM_TMAXC "mmres->tmax_C = max;"
	mov r0, r6 					@; Igualem el contingut de "ttemp a min"
	bl Celsius2Fahrenheit		@; Invoquem/Cridem la funcio "Celsius2Fahrenheit(min);"
	str r0, [r4, #MM_TMINF]		@; Guardem les dades en memoria, en aquest cas temperatura minima Fahrenheit en MM_TMINF
								@; "mmres->tmin_F = Celsius2Fahrenheit(min)"
	mov r0, r5					@; Igualem el contingut de "ttemp a max"
	bl Celsius2Fahrenheit		@; Invoquem/Cridem la funcio "Celsius2Fahrenheit(max);"
	str r0, [r4, #MM_TMAXF]		@; Guardem les dades en memoria, en aquest cas temperatura maxima Fahrenheit en MM_TMAXF
								@; "mmres->tmax_F = Celsius2Fahrenheit(max);"
	strh r7, [r4, #MM_IDMIN]	@; Guardem les dades en una memoria de 16 bits"short", la ID de temperatura minima MM_IDMIN
								@; "mmres->id_min = idmin (2bits);"
	strh r8, [r4, #MM_IDMAX]	@; Guardem les dades en una memoria de 16 bits"short", la ID de temperatura maxima MM_IDMAX
								@; "mmres->id_max = idmax (2bits);"
	
	mov r0, r1					@; Igualem el contingut de ttemp a files "return(cociente=avg);"
	pop {r1-r12, pc}			@; Recuperem les dades i tornem a la funcio que crida aquesta rutina	
