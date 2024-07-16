/*----------------------------------------------------------------
|   Q12.c: rutines aritmètiques en format Coma Fixa 1:19:12. 
| ----------------------------------------------------------------
|	pere.millan@urv.cat
|	santiago.romani@urv.cat
|	(Abril 2021, Març 2022)
| ----------------------------------------------------------------*/

#include "Q12.h"	/* Q12: tipus Coma Fixa 1:19:11
					   MAKE_Q12(real): codifica un valor real en format Q12
					   MASK_SIGN: màscara per obtenir el bit de signe
					*/
#include "divmod.h"		/* rutina div_mod() de divisió entera */

	/* MÀSCARA per als 33 bits alts d'una multiplicació llarga */
#define MASK_SIGN_64	0xFFFFFFFF80000000	/* bits 63..31 */


/* Operacions aritmètiques bàsiques en Coma Fixa 1:19:12 */

/* add_Q12():	calcula i retorna la suma dels 2 primers operands,
  (num1 + num2)	codificats en Coma fixa 1:19:12.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q12 add_Q12(Q12 num1, Q12 num2, unsigned char * overflow)
{
	Q12 suma;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow
	
	suma = num1 + num2;
	
		// Detecció overflow
	if (((MASK_SIGN & num1) == (MASK_SIGN & num2)) 
			&& ((MASK_SIGN & num1) != (MASK_SIGN & suma)))
		ov = 1;
	
	*overflow = ov;
	return(suma);
}


/* sub_Q12():	calcula i retorna la resta dels 2 primers operands,
  (num1 - num2) codificats en Coma fixa 1:19:12.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q12 sub_Q12(Q12 num1, Q12 num2, unsigned char * overflow)
{
	Q12 resta;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow
	
	resta = num1 - num2;
	
		// Detecció overflow
	if (((MASK_SIGN & num1) != (MASK_SIGN & num2)) 
			&& ((MASK_SIGN & num1) != (MASK_SIGN & resta)))
		ov = 1;
	
	*overflow = ov;
	return(resta);
}



