#-------------------------------------------------------------------------------
#	Programador/a 1: florian.serb@estudiants.urv.cat
#	Programador/a 2: alan.rocha@estudiants.urv.cat
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Variables para la generacion de codigo
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
# FLAGS = comprovar si tenim overflow o no
ASFLAGS	:= $(ARCH) -g
# ASFLAGS = s'utilitza per a passar els fitxers .s "ENSAMBLADOR GAS" a .o "CODI COMPRES"
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) -I./include
# CCFLAGS = s'utilitza per a passar els fitxers .c "CODI C/ALT NIVELL" a .o "CODI COMPRES"
LDFLAGS := -z max-page-size=0x8000 -Lp_lib
# LDFLAGS = s'utilitza per a cridar tots els fitxers amb l'ajuda de \ i crear el fitxer .elf

#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------
# ---------.o ejecutable en formato comprimido "data.o" ----------
# ---------.a es una llibreria en la cual tenim gran cantitat de CODI MAQUINA, 
#			en el cual la MAJORIA D'AQUEST ES CODI MORT	"que no s'executa" el 95% MAI s'executara
# ---------.s codi ENSAMBLADOR GAS ho passem a executable en format comprimit .o

# fem els includes de tots els fitxer de dins de data.c per a poder generar el .o
build/data.o : include/Q12.h include/geotemp.h include/data.h
	arm-none-eabi-gcc $(CCFLAGS) -c source/data.c -o build/data.o

# en aquest cas tenim .s "ENSAMBLADOR GAS" i volem passar aquest fitxer a .o per a que estigui mes comprimit
# per a passar de .s fem = arm-none-eabi-as ASFLAGS "fitxer .s" -o "fitxer .o" per a crar el fitxer .o
build/avgmaxmintemp.o : source/avgmaxmintemp.s include/avgmaxmintemp.i
	arm-none-eabi-as $(ASFLAGS) source/avgmaxmintemp.s -o build/avgmaxmintemp.o

# fem els includes de tots els fitxer de dins de data.c per a poder generar el .o
build/geotemp.o : source/geotemp.c include/Q12.h include/divmod.h include/avgmaxmintemp.h include/geotemp.h include/data.h include/CelsiusFahrenheit.h 
	arm-none-eabi-gcc $(CCFLAGS) -c source/geotemp.c -o build/geotemp.o

# fem els includes que tenim dins de "test_geotemp.c"
# seguidament convertim .c a .o "codi comprimit"
build/test_geotemp.o : include/avgmaxmintemp.h include/Q12.h
	arm-none-eabi-gcc $(CCFLAGS) -c tests/test_geotemp.c -o build/test_geotemp.o

# cridem tots els fitxer .o per a poder crear l'executable "geotem.elf"
# LDFLAGS es la regla principal para poder crear el .elf
geotemp.elf : build/avgmaxmintemp.o build/data.o build/geotemp.o
	arm-none-eabi-ld $(LDFLAGS) build/avgmaxmintemp.o build/data.o build/geotemp.o \
						p_lib/startup.o p_lib/CelsiusFahrenheit.o p_lib/libfoncompus.a -o geotemp.elf

# aqui cridem tots els .o per a poder crear l'executable test_geotemp.elf, utilitzem LDFLAGS
test_geotemp.elf : build/test_geotemp.o build/avgmaxmintemp.o
	arm-none-eabi-ld $(LDFLAGS) build/test_geotemp.o build/avgmaxmintemp.o \
						p_lib/startup.o p_lib/CelsiusFahrenheit.o p_lib/libfoncompus.a -o test_geotemp.elf

#-------------------------------------------------------------------------------
# clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf


#-----------------------------------------------------------------------------
# run commands
#-----------------------------------------------------------------------------
run : geotemp.elf
	arm-eabi-insight geotemp.elf &


#-----------------------------------------------------------------------------
# debug commands
#-----------------------------------------------------------------------------
debug : test_geotemp.elf
	arm-eabi-insight test_geotemp.elf &
