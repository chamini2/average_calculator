#	PROYECTO 1
#	ORGANIZACION DEL COMPUTADOR
#
#	Alberto Cols, 09-10177
#	Matteo Ferrando, 09-10285
#	Grupo 20
#
#####Registros fijos
#
#	$s0 = File Descriptor del archivo principal
#	$s1 = File Descriptor de cada archivo secundario
#	$s2 = ";"
#	$s3 = Posicion del elemento en carrera a modificar
#	$s4 = Entero leido
#

###########Estructuras Estaticas#############
#cabeza: Bloque que contiene informacion de la universidad
##num carreras = 4 Bytes (+ 0)
##promedio de universidad = 4 Bytes (+ 4)
##num notas = 4 Bytes (+ 8)

#carrera: Arreglo de Carreras que contiene la informacion de las mismas
#Total por posicion= 52 Bytes 
#(pos= 0, 52, 104, 156, 208, 260, 312, 364, 416, 468)						 
##nombre= 28 Bytes	(+ 0)
##num de cursos = 4 Bytes (+ 28)
##promedio de carrera = 4 Bytes (+ 32)
##num estudiantes = 4 Bytes (+ 36)
##Lista de estudiantes = 4 Bytes (+ 40)
##Lista de cursos = 4 Bytes (+ 44)
##num notas = 4 Bytes (+ 48)
						
###########Estructuras Dinamicas#############

#Lista de Cursos: Lista que almacena la informacion util de los cursos
#Total por bloque= 40 Bytes 
##codigo = 12 Bytes (+ 0)
##num estudiantes = 4 Bytes (+12)
##nota minima = 4 Bytes (+ 16)
##nota maxima = 4 Bytes (+ 20)
##promedio = 4 Bytes (+ 24)
##desviacion media = 4 Bytes (+ 28)
##lista de notas = 4 Bytes (+ 32)
##siguiente = 4 Bytes	(+ 36)

#Lista de Notas: Lista que almacena las notas para cada curso
#Total por bloque= 8 Bytes
##nota = 4 Bytes (+ 0)
##siguiente = 4 Bytes (+ 4)

#Lista de Estudiantes: Lista que almacena la informacion util de los estudiantes
#Total por bloque= 12 Bytes
##carnet = 8 Bytes (+ 0)
##siguiente = 4 Bytes (+ 8)

		.data

cabeza:		.space 12	
			.align 4	
			
carrera:	.space 520	
			.align 	10	
			
principal:	.asciiz "datos.txt"		#nombre del archivo principal
			.align 3
			
file:		.space 32				#utilizado para leer los nombres de los archivos secundarios
			.align 5
			
temp:		.space 2				#utilizado para leer caracter por caracter
			.align 1
			
linea:		.space 128				#para almacenar las lineas de lectura
			.align 7

proyecto:	.asciiz	"################# PROYECTO ORANIZACION DE DEL COMPUTADOR #################"
			.align 5
nombres:	.asciiz "\n Grupo 20\n Alberto Cols, 09-10177\n Matteo Ferrando, 09-10285"
			.align 5
numEst:		.asciiz "\n\n>El numero de estudiantes con al menos una calificacion es: "
			.align 5
promUni:	.asciiz	"\n\n>El promedio de notas de toda la institucion es: "
			.align 5
promCarr:	.asciiz	"\n\n>Promedio de cada carrera: "
			.align 5
promCar:	.asciiz	"     //El promedio de la carrera es: "
			.align 5
Estadis:	.asciiz	"\n\n>Los datos estadisticos para cada curso son: "
			.align 5
Carrera:	.asciiz	"\n   -> Carrera: "
			.align 5
Curso:		.asciiz	"\n       *Curso: "
			.align 5
promCurs:	.asciiz	"\n          -El promedio del curso fue: "
			.align 5
desMed:		.asciiz	"\n          -La desviacion media del curso fue: "
			.align 5
maxNota:	.asciiz	"\n          -La maxima nota del curso fue: "
			.align 5
minNota:	.asciiz	"\n          -La minima nota del curso fue: "
			.align 5
igual:  .asciiz	" = "
			.align 2
sig:  .asciiz	" -> "
			.align 2
enter:  .asciiz	"\n"
			.align 2			
		.text
		
main:
	abrirPrincipal:								#Abre el archivo principal
	
		la		$a0, principal					#Nombre archivo a abrir en la direccion de principal
		li		$a1, 0x0						#Flag
		li		$a2, 0444						#Modo de archivo (permisos)
		li		$v0, 13							#Abrir archivo
		syscall									#Devuelve en $v0 el descriptor del archivo
		
		move 	$s0, $v0						#Ahora $s0 tiene el descriptor del archivo
	
	endAbrirPrincipal:
	
	sw		$zero, cabeza + 0					#num carreras = 0
	sw		$zero, cabeza + 4					#promedio universidad = 0
	sw		$zero, cabeza + 8					#numero de notas = 0
	li		$s2, 0x3B
	
loop:	
	archivoPrincipal:							#Inicializacion registros de lectura del archivo principal
		move	$a0, $s0						#Descriptor de archivo principal en $a0
		la		$a1, temp						#Direccion en la cual escribir en $a1
		li		$a2, 1							#Numero de caracteres a leer (= 1)
		la		$t3, file						#Guarda el nombre del archivo secundario sin ";"
		li		$t4, 0							#Contador de ";"
		li		$t5, 4							#Numero de ";" para terminar programa
	
	endArchivoPrincipal:
	
	leerPrincipal:								#Leer caracter por caracter
		li		$v0, 14
		syscall									#Devuelve en $v0 numero de caracteres leidos (=1)
		
		lb		$t2, 0($a1)						#Carga a $t2 el caracter en la direccion de $a1
		beq		$t2, $s2, endLeerPrincipal		#Cuando consigue un ";"
		
		sb		$t2, 0($t3)						#Almacena en 0($t3) lo que esta en $t2
		addi	$t3, $t3, 1						#Mueve a $t3 en un Byte
		
		b		leerPrincipal					#Regresa para leer el siguiente caracter
		
	endLeerPrincipal:
		sb		$zero, 0($t3)					#Termina la palabra almacenada en file
	
	leyoPrincipalPyC:							#Si lee un ";"
		li		$v0, 14							#Lee el sig caracter para ver si es un ";"
		syscall									#Devuelve en $v0 numero de caracteres leidos 
		
		lb		$t2, 0($a1)						#Carga a $t2 el byte en la direccion de $a1
		addi 	$t4, $t4, 1						#Incrementa numero de ";"
		
		beq		$t4, $t5, fin					#Cuando consigue 4 ";" seguidos
		beq		$t2, $s2, leyoPrincipalPyC		#Cuando consigue un ";"
		
	endLeyoPrincipalPyC:
	
	abrirFile:									#Abre el archivo especificado en file
		la		$a0, file						#Nombre archivo a abrir en la direccion de file
		li		$a1, 0x0						#Flag
		li		$a2, 0444						#Modo de archivo (permisos)
		li		$v0, 13							#Abre el archivo secundario
		syscall									#Devuelve en $v0 el descriptor de file
	
		move	$s1, $v0						#Ahora $s1 tiene el descriptor de file
		
	endAbrirFile:
	
		########LECTURA DEL NOMBRE DE LA CARRERA########
	firstLnFile:								#Lee la primera linea (Nombre de la carrera)
		move	$a0, $s1						#Descriptor de file en $a0
		la		$a1, temp						#Direccion en la cual escribir en $a1
		li		$a2, 1							#Lee caracter por caracter
		la		$t3, linea						#Guarda la palabra sin ";"
		
		leerFirstLnFile:						#Lee caracter por caracter la primera linea de file
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)							#Carga a $t2 el caracter en la direccion de $a1
			beq		$t2, $s2, endLeerFirstLnFile		#Cuando consigue un ";"
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte
			
			b		leerFirstLnFile
		
		endLeerFirstLnFile:
			sb		$zero, 0($t3)				#Termina la palabra almacenada en linea
			
		leyoFirstLnFilePyC:						#Cuando lee un ";"
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el byte en la direccion de $a1
			
			beq		$t2, $s2, leyoFirstLnFilePyC		#Cuando consigue un ";"
			
		endLeyoFirstLnFilePyC:
		
	endFirstLnFile:

			########MANEJO DE LA CARRERA########	
	containsCarrera:							#Para revisar si la carrera leida ya estaba agregada
												#$s3: para moverse sobre el arreglo
												#$t1: para revisar el nombre de la carrera a incluir
												#$t2: para revisar el nombre de la carrera en el arreglo
												#$t3: contador de carreras leidas
												#$t4: numero de carreras almacenadas
												#$t5: para moverse sobre la palabra a incluir
												#$t6: para moverse sobre la palabra en arreglo
												
		move	$s3, $zero						#Para moverse sobre el arreglo							
		move	$t3, $zero						
		lw		$t4, cabeza + 0					#Almacena el numero de carreras almacenadas
		
		loopCarrera:							#Compara los nombres de las carreras
			beq		$t3, $t4, agregarCarrera    #Cuando ya reviso todas las carreras
			move	$t5, $zero
			move	$t6, $s3
		
			equalsCarrera:
				lb		$t2, carrera($t6)
				lb		$t1, linea($t5)
				
				bne		$t1, $t2, endEqualsCarrera	#Si son diferentes
				beqz	$t1, endAgregarCarrera		#Si consigue la carrera
			
				addi	$t5, $t5, 1				#Se mueve un caracter
				addi	$t6, $t6, 1				#Se mueve un caracter
				
				b		equalsCarrera
				
			endEqualsCarrera:		
		
			addi	$s3, $s3, 52				#Se mueve sobre el arreglo
			addi	$t3, $t3, 1
			
			b		loopCarrera					#Revisa el siguiente elemento
			
		endLoopCarrera:
		
	endContainsCarrera:
	
	agregarCarrera:								#Agrega una carrera al arreglo carrera
												#$s3: la posicion del arreglo en la que agregare la nueva carrera
												#$t4: numero de carreras en el arreglo
												#$t5: posicion en el atributo de la carrera a agregar

			addi	$t4, $t4, 1					#Incrementa el numero de carreras
			sw		$t4, cabeza + 0
			
			move	$t2, $s3
			move	$t6, $zero
			
			agregarNombreCarrera:				#Pasa el string en linea al arreglo
				lb		$t1, linea($t6)
				sb 		$t1, carrera($t2)
				addi	$t6, $t6, 1
				addi	$t2, $t2, 1
				
				bnez	$t1, agregarNombreCarrera
				
			endAgregarNombreCarrera:
			
			addi	$t2, $s3, 28
			sw		$zero, carrera($t2)			#Inicializa el numero de cursos de la carrera
			
			addi	$t2, $s3, 32
			sw		$zero, carrera($t2)			#Inicializa el promedio de la carrera
			
			addi	$t2, $s3, 36
			sw		$zero, carrera($t2)			#Inicializa el numero de estudiantes	
			
			addi	$t2, $s3, 40
			sw		$zero, carrera($t2)			#Asigna null a la lista de estudiantes
			
			addi	$t2, $s3, 44
			sw		$zero, carrera($t2)			#Asigna null a la lista de cursos
			
			addi	$t2, $s3, 48
			sw		$zero, carrera($t2)			#Inicializa el numero de notas
			
	endAgregarCarrera:
	
		########LECTURA DEL NOMBRE DEL CURSO########
		
	secondLnFile:								#Lee caracter por caracter la segunda linea de file
		move	$a0, $s1						#Descriptor de file en $a0
		la		$a1, temp						#Direccion en la cual escribir en $a1
		li		$a2, 1							#Numero de caracteres a leer (= 1)
		la		$t3, linea						#Donde guardare la palabra sin ";"
		
		leerSecondLnFile:
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)							#Carga a $t2 el byte en la direccion de $a1
			beq		$t2, $s2, endLeerSecondLnFile		#Cuando consigue un ";"
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte
			
			b		leerSecondLnFile
		
		endLeerSecondLnFile:
			sb		$zero, 0($t3)				#Termina la palabra en linea
		
		leyoSecondLnFilePyC:
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el byte en la direccion de $a1
			
			beq		$t2, $s2, leyoSecondLnFilePyC		#Cuando consigue un ";"
			
		endLeyoSecondLnFile:
		
	endSecondLnFile:
	
			########MANEJO DEL CURSO########	
	
	agregarCurso:								#Agrega el curso de file
												#$s3: direccion de la carrera a la que pertence el curso a agregar
												#$t0: direccion de la lista de cursos de dicha carrera
												#$t2: para moverse sobre la caja 
												#$t6: para moverse sobre la palabra en la Linea
								
			addi	$t2, $s3, 28
			lw		$t6, carrera($t2)
			addi	$t6, $t6, 1
			sw		$t6, carrera($t2)			#Incremento en 1 el numero de cursos
			
			crearCurso:							#Crea la caja que contiene la informacion del curso
				li		$a0, 40
				li		$v0, 9					#En $v0 esta la direccion de la nueva caja
				syscall							#Crea la caja
				
				move	$t2, $v0				#Inicializa $t2 en la direccion de la nueva caja
				move	$t6, $zero
				
				agregarNombreCurso:				#Pasamos el string en linea a la caja
					lb		$t1, linea($t6)		#Carga Byte a Byte el string en linea
					sb 		$t1, 0($t2)			#Guarda Byte a Byte el string en la caja
					addi	$t6, $t6, 1
					addi	$t2, $t2, 1
					
					bnez	$t1, agregarNombreCurso
					
				endAgregarNombreCurso:

				addi	$t2, $v0, 12
				sw		$zero, 0($t2)				#Inicializa el num de estudiantes

				addi	$t2, $v0, 16
				li		$t3, 100
				sw		$t3, 0($t2)					#Inicializa la nota minima
				
				addi	$t2, $v0, 20
				sw		$zero, 0($t2)				#Inicializa la nota maxima
				
				addi	$t2, $v0, 24
				sw		$zero, 0($t2)				#Inicializa el promedio
				
				addi	$t2, $v0, 28
				sw		$zero, 0($t2)				#Inicializa la desviacion media
				
				addi	$t2, $v0, 32
				sw		$zero, 0($t2)				#Apunta la lista de notas a null


				addi	$t2, $s3, 44				#Almacena en $t2 la posicion del arreglo que a modificar (apuntador a lista de cursos)			
				lw		$t0, carrera($t2)			#Carga en $t0 la direccion de memoria almacenada en carrera($t2)
				addi	$t3, $v0, 36
				sw		$t0, 0($t3)					#Apunta siguiente a null 
				sw 		$v0, carrera($t2)			#Almacena la direccion de memoria del elemento creado en el apuntador al primer elemento de la lista				
				
			endCrearCurso:			
			
	endAgregarCurso:
	
		########LECTURA RESTO DE LAS LINEAS########
		
	leerFile:									#Lee los datos de los estudiantes
		move	$a0, $s1						#Descriptor de file en $a0
		la		$a1, temp						#Direccion en la cual escribir en $a1
		li		$a2, 1							#Numero de caracteres a leer (= 1)
		la		$t3, linea						#Guardara la palabra sin ";" (Primera palabra = Carnet)
		
		termineFile:							#Lee el primer caracter de la siguiente linea,
												#si es un ";" se sabe que el archivo termino.
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el caracter en la direccion de $a1
			beq		$t2, $s2, leyoFile			#Cuando consigue un ";" termino el archivo, vuelvo al archivo principal
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte
			
		endTermineFile:
		
			########LECTURA DE CARNET########
			
		leerFileCarnet:
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el byte en la direccion de $a1
			beq		$t2, $s2, endLeerFileCarnet	#Cuando consigue un ";"
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte
			
			b		leerFileCarnet
		
		endLeerFileCarnet:
			sb		$zero, 0($t3)
		
	####MANEJO DE CARNET#####
	
	containsEstudiante:							#Para revisar si el estudiante ya estaba agregado
												#$s3: la carrera en cuestion
												#$t0: apuntador a estudiante
												#$t1: para revisar el carnet del estudiante a incluir
												#$t2: para revisar el carnet del estudiante en la lista
												#$t3: contador de estudiantes revisados
												#$t4: numero de estudiantes en el curso
												#$t5: para movernos sobre el carnet a incluir
												#$t6: para movernos sobre el carnet en lista

		move	$t3, $zero						
		addi	$t4, $s3, 36					#Almaceno el numero de estudiantes en $t4
		lw		$t4, carrera($t4)
		
		la		$t0, carrera($s3)
		addi	$t0, $t0, 32					#Si es la primera, le faltan 8 para la direccion a "siguiente"
		
		beq		$t3, $t4, agregarEstudiante		#Cuando la lista de estudiantes esta vacia
		addi	$t0, $s3, 40
		lw		$t0, carrera($t0)				#Apunto al primer estudiante
		
		loopEstudiante:							#Compara los carnets
			move	$t5, $zero
			move	$t6, $t0
		
			equalsEstudiante:
				lb		$t2, 0($t6)
				lb		$t1, linea($t5)
				
				bne		$t1, $t2, endEqualsEstudiante	#Si son diferentes
				beqz	$t1, endAgregarEstudiante		#Si consegui al estudiante, t0 apunta a este
				
				addi	$t5, $t5, 1				#Me muevo un caracter
				addi	$t6, $t6, 1				#Me muevo un caracter
				
				b		equalsEstudiante
				
			endEqualsEstudiante:		
		
			addi	$t3, $t3, 1
			
			beq		$t3, $t4, agregarEstudiante	#Cuando ya reviso todos los estudiantes
			lw		$t0, 8($t0)					#Apunta al siguiente estudiante

			b		loopEstudiante				#Revisa el siguiente elemento
			
		endLoopEstudiante:
		
	endContainsEstudiante:
	
	agregarEstudiante:							#Agrega el estudiante de file
												#$s3: direccion de la carrera a la que pertence el estudiante a agregar
												#$t0: direccion del ultimo estudiante de la lista
												#$t6: para movernos sobre la palabra en la Caja
												#$t4: numero de estudiantes
			
		crearEstudiante:						#Creo la caja que contiene la informacion del estudiante
			li		$a0, 12
			li		$v0, 9						#En $v0 esta la direccion de la nueva caja
			syscall								#Creo la caja
			
			move	$t2, $v0
			move	$t6, $zero
			
			agregarCarnetEstudiante:			#Pasamos el string en linea a la caja
				lb		$t1, linea($t6)
				sb 		$t1, 0($t2)
				addi	$t6, $t6, 1
				addi	$t2, $t2, 1
				
				bnez	$t1, agregarCarnetEstudiante
				
			endAgregarCarnetEstudiante:
			
			addi	$t2, $v0, 8
			sw		$zero, 0($t2)				#Apunto siguiente a null 
			
		endCrearEstudiante:
		
		sw		$v0, 8($t0)						#Apunto el ultimo al nuevo
		
		addi	$t1, $s3, 36					#Apunto al numero de estudiantes de la carrera
		addi 	$t4, $t4, 1						#Incremento el numero de estudiantes
		sw		$t4, carrera($t1)

	endAgregarEstudiante:
		
			########LECTURA DE NOMBRE########
			
		move	$a0, $s1						#Descriptor de file en $a0
		la		$a1, temp						#Direccion en la cual escribir en $a1
		li		$a2, 1							#Numero de caracteres a leer (= 1)
		la		$t3, linea						#Guardara la palabra sin ";" (Primera palabra = Carnet)
		
		leerFileNombre:
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el byte en la direccion de $a1
			beq		$t2, $s2, endLeerFileNombre	#Cuando consigue un ";"
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte	

			b		leerFileNombre
		
		endLeerFileNombre:	
			sb		$zero, 0($t3)				#Termina la palabra almacenada en linea
			
			######MANEJO DE NOMBRE######
			#No interesa el nombre delestudiante, por lo tanto no hace nada
			
			########LECTURA DE NOTA########		
			
			move	$t4, $zero					#Contador de caracteres
			la		$t3, linea					#Reapunta $t3 al inicio de linea para empezar a guardar la Nota
		leerFileNota:
			li		$v0, 14
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			lb		$t2, 0($a1)					#Carga a $t2 el byte en la direccion de $a1
			beq		$t2, $s2, endLeerFileNota	#Cuando consigue un ";"
			
			addi	$t2, $t2, -48				#Valor real del ASCII
			
			sb		$t2, 0($t3)					#Almacena en 0($t3) lo que esta en $t2
			addi	$t3, $t3, 1					#Mueve $t3 en un Byte
			addi	$t4, $t4, 1					#Incremento numero de caracteres leidos
			
			b		leerFileNota
			
		endLeerFileNota:
			sb		$zero, 0($t3)				#Termina la palabra almacenada en linea
			
			li		$s4, 0						#Entero leido
			li		$t5, 1
			li		$t6, 10
			addi	$t4, $t4, -1
			
			toInt:
				bltz	$t4, endToInt	
				lb		$t7, linea($t4)				#almaceno el byte en la pos linea + $t4
				mul		$t7, $t7, $t5
				add		$s4, $s4, $t7
				
				mul		$t5, $t5, $t6
				
				addi	$t4, $t4, -1
				b toInt
			endToInt:
			
			sb		$zero, 0($t3)				#Termina la palabra almacenada en linea

		######MANEJO DE NOTA######	
		agregarNota:								#Agrega una nota a la lista de notas del curso	
													#$s3: posicion de carrera en cuestion
													#$t0: curso a modificar
													#$s4: nota a introducir
			
			addi	$t0, $s3, 44				
			lw		$t0, carrera($t0)				#apunto $t0 al ultimo curso agregado
			
			lw		$t1, 24($t0)					#en $t1 esta la sumatoria de las notas (Para el promedio),
			add		$t1, $t1, $s4					#sumo la nueva nota
			sw		$t1, 24($t0)					#la asigno de nuevo, modificada
			
			lw		$t1, 12($t0)					#en $t1 esta el numero de estudiantes del curso,
			addi	$t1, $t1, 1						#lo incremento en uno y
			sw		$t1, 12($t0)					#lo asigno de nuevo, modificado
			
			li		$t2, 1
			beq		$t1, $t2, primeraNota			#cuando estoy agregando la primera nota del curso
			
			compareNota:
				lw		$t1, 16($t0)				#en $t1 esta la nota minima
				blt		$s4, $t1, newMinimaNota		#compara nota minima con nueva
				
				lw		$t1, 20($t0)				#en $t1 esta la nota maxima
				bgt		$s4, $t1, newMaximaNota		#compara nota maxima con nueva
				
				b		endCompareNota				#ni minimo ni maximo nuevo
				
				newMinimaNota:
					sw		$s4, 16($t0)			#cambio la nueva minima
					b		endCompareNota
					
				newMaximaNota:
					sw		$s4, 20($t0)			#cambio la nueva maxima
					
					b		endCompareNota
			
				primeraNota:
					sw		$s4, 16($t0)
					sw		$s4, 20($t0)
					
				endPrimeraNota:
			
			endCompareNota:

			crearNota:
				li		$a0, 8
				li		$v0, 9
				syscall								#$v0 apunta a la caja de nota nueva
				
				sw		$s4, 0($v0)					#coloco la nota en la caja
				
				lw		$t1, 32($t0)				#$t1 apunta al primer elemento de la lista de notas del curso
				sw		$t1, 4($v0)					#apunto la caja nueva a la primera
				sw		$v0, 32($t0)				#apunto la lista de notas a la nueva caja
				
			endCrearNota:

		endAgregarNota:
			
		endLeerFileLinea:						#Termina de leer la linea
			
			move	$a0, $s1					#Descriptor de file en $a0
			la		$a1, temp					#Direccion en la cual escribir en $a1
			li		$a2, 1						#Numero de caracteres a leer (= 1)
			li		$v0, 14						#Lee el segundo ";"
			syscall								#Devuelve en $v0 numero de caracteres leidos
			li		$v0, 14						#Lee el final de la linea
			syscall								#Devuelve en $v0 numero de caracteres leidos
			
			b		leerFile					#Salta a leer la siguiente linea
			
		endEndLeerFileLinea:
		
	endLeerFile:

	leyoFile:									#$s3: Carrera en cuestion
												#$t0: curso a modificar
												
		addi	$t0, $s3, 44
		lw		$t0, carrera($t0)
		
		lw		$t1, 24($t0)					#en $t1 esta la suma de las notas
		lw		$t6, 12($t0)					#en $t2 esta el numero de estudiantes
			
		beqz	$t6, endLeyoFile				#si no hay estudiantes
		
		addi	$t7, $s3, 48
		lw		$t2, carrera($t7)				#en $t2 esta el numero de notas de la carrera
		add		$t2, $t6, $t2					#sumo el numero de notas de este curso
		sw		$t2, carrera($t7)				#lo almaceno modificado
		
		lw		$t2, cabeza + 8					#en $t2 esta el umero de notas de la universidad
		add		$t2, $t6, $t2					#sumo el numero de nostas de est curso
		sw		$t2, cabeza + 8					#lo almaceno modificado
		
		addi	$t7, $s3, 32
		lw		$t2, carrera($t7)				#sumatoria de notas en carrera
		add		$t2, $t1, $t2					#sumo nota actual de curso
		sw		$t2, carrera($t7)				#almaceno en carrera
		
		lw		$t2, cabeza + 4					#sumatoria de notas en universidad
		add		$t2, $t1, $t2					#sumo nota actual de curso
		sw		$t2, cabeza + 4					#almaceno en universidad
		
		div		$t1, $t1, $t6					#en $t1 esta el promedio truncado
		sw		$t1, 24($t0)					#almaceno el promedio del curso
		
		move	$t5, $zero						#incializo $t5 en 0		
		lw		$t2, 32($t0)					#$t2 apunta a la lista de notas
		li		$t4, -1							#para valor absoluto
		
		desviacionMedia:
			beqz	$t2, endDesviacionMedia		#cuando se acaban los elementos
		
			lw		$t3, 0($t2)					#nota actual en $t3

			sub		$t3, $t3, $t1				#nota actual menos promedio
			
			bgez	$t3, vAbsoluto				#Si es positivo salta la instruccion de valor absoluto
			mul		$t3, $t3, $t4
			vAbsoluto:
			
			add		$t5, $t5, $t3
			lw		$t2, 4($t2)					#muevo $t2 al siguiente elemento
			b		desviacionMedia				
			
		endDesviacionMedia:
						
		div		$t5, $t5, $t6					#Divido entre el numeor de estudiantes
		sw		$t5, 28($t0)					#almaceno la desviacion media en el curso
		
	endLeyoFile:
	
	b		loop
endLoop:
	
fin:


		######################
		#######IMPRESION######
		######################

		la	$a0, proyecto
		li	$v0, 4
		syscall									#Imprimo el mensaje
		
		la	$a0, nombres
		li	$v0, 4
		syscall									#Imprimo el mensaje
				
	#######IMPRESION DE NUMERO DE ESTUDIANTES######	
	impresionNumEstudiantes:
	
		la	$a0, numEst
		li	$v0, 4
		syscall									#Imprimo el mensaje
				
		move	$a0, $zero						
		li		$s3, 36							#Para mover sobre el arreglo
		li		$t0, 0							#Contador numero de carreras
		lw		$t1, cabeza + 0					#Carga el numero de carreras
				
		numEstudiantes:		
			beq		$t0, $t1, endNumEstudiantes	#Cuando ya reviso los estudiantes de todas las carreras
	
			lw		$t2, carrera($s3)			#Carga el numero de estudiante de una carrera
			add		$a0, $a0, $t2				#Suma al total de estudiantes
			
			addi	$s3, $s3, 52				#Se mueve sobre el arreglo
			addi	$t0, $t0, 1
			b numEstudiantes
		endNumEstudiantes:
	
		li	$v0, 1
		syscall
		
	endImpresionNumEstudiantes:
	
	#######IMPRESION DE PROMEDIO DE LA UNIVERSIDAD######
	impresionPromedioUSL:
		la		$a0, promUni
		li		$v0, 4
		syscall									#imprimo msj de promedio de la universidad
	
		lw		$a0, cabeza + 4					#sumatoria de notas de la universidad
		lw		$t1, cabeza + 8					#numero de notas en la universidad
		div		$a0, $a0, $t1					#calculo el promedio
		
		sw		$a0, cabeza + 4					#almacenamos el promedio de la universidad
		
		li		$v0, 1
		syscall									#imprimo el promedio de la universidad
	
	endImpresionPromedioUSL:

	
	#######IMPRESION DE LOS PROMEDIOS DE LAS CARRERAS######	
	la		$a0, promCarr
	li		$v0, 4
	syscall										#imprimo msj de promedio de carreras

	move	$s3, $zero							#Se mueve sobre los elemntos de carrera	
	lw		$t1, cabeza + 0
	move	$t2, $zero
	
	imprimirPromedioCarrera:
	
		beq		$t1, $t2, endImprimirPromedioCarrera	#Cuando ya reviso todas las carreras
		
		la		$a0, Carrera
		li		$v0, 4
		syscall									#Imprime el msj de nombre de carrera
		
		la	 	$a0, carrera($s3)
		li		$v0, 4
		syscall									#Imprime el nombre de la carrera
	
		la		$a0, igual
		li		$v0, 4
		syscall
		
		addi	$a0, $s3, 48
		lw		$a0, carrera($a0)				#Numero de estudiantes en la carrera
		addi	$t8, $s3, 32
		lw		$t9, carrera($t8)				#Sumatoria de notas de la carrera
		
		div		$a0, $t9, $a0 
		
		sw		$a0, carrera($t8)				#Almaceno el promedio en la carrera
		
		li		$v0, 1
		syscall
		
		addi	$t2, $t2, 1						#Incrementa en 1 la cantidad de carreras revisadas
		addi	$s3, $s3, 52					#Se mueve a la siguiente carrera
		b		imprimirPromedioCarrera
		
	endImprimirPromedioCarrera:
	
	#######IMPRESION DE ESTADISTICAS DE LOS CURSOS######
	la	$a0, Estadis
	li	$v0, 4
	syscall										#Imprime mensaje

	move	$s3, $zero							#Se mueve sobre los elemntos de carrera
	lw		$t1, cabeza + 0						#Almacena el numero de carreras
	move	$t2, $zero							#Numero de carreras revisadas
	
	imprimirCarrera:
	
		beq		$t1, $t2, endImprimirCarrera	#Cuando ya reviso todas las carreras
		
		la		$a0, enter
		li		$v0, 4
		syscall
		
		la		$a0, enter
		li		$v0, 4
		syscall
				
		la		$a0, Carrera
		li		$v0, 4
		syscall									#Imprime el msj de nombre de carrera
		
		la	 	$a0, carrera($s3)
		li		$v0, 4
		syscall									#Imprime el nombre de la carrera
		
		la		$a0, promCar
		li		$v0, 4
		syscall									#Imprime el msj de promedio de carrera
		
		addi	$t8, $s3, 32		
		lw		$a0, carrera($t8)
		li		$v0, 1
		syscall
		
		addi	$t3, $s3, 28					
		lw		$t3, carrera($t3)				#En $t3 almacena el numero de cursos de la carrera
		move	$t4, $zero						#Contador de numero de cursos de la carrera
		
		addi	$t6, $s3, 44					
		lw		$t6, carrera($t6)				#$t6 apunta a la lista de cursos
		
		imprimirCursos:
		
			beq		$t3, $t4, endImprimirCursos		#Si ya revise todas las carreras
			
			la		$a0, enter
			li		$v0, 4
			syscall
			
			la		$a0, Curso
			li		$v0, 4
			syscall								
			
			la		$a0, 0($t6)
			li		$v0, 4
			syscall								#Imprime el nombre del curso
			
			la		$a0, minNota
			li		$v0, 4
			syscall 
			lw		$a0, 16($t6)
			li		$v0, 1
			syscall								#Imprime la nota minima
			
			la		$a0, maxNota
			li		$v0, 4
			syscall 
			lw		$a0, 20($t6)
			li		$v0, 1
			syscall								#Imprime la nota maxima
					
			la		$a0, promCurs
			li		$v0, 4
			syscall	 
			lw		$a0, 24($t6)
			li		$v0, 1
			syscall								#Imprime el promedio del curso
			
			la		$a0, desMed
			li		$v0, 4
			syscall		 
			lw		$a0, 28($t6)
			li		$v0, 1
			syscall								#Imprime la desviacion media del curso
			
			
			lw		$t6, 36($t6)				#$t6 apunta al siguiente curso

			addi	$t4, $t4, 1					#Incremento en 1 el numero de cursos revisados
			b	imprimirCursos
			
		endImprimirCursos:
		
		addi	$t2, $t2, 1						#Incrementa en 1 la cantidad de carreras revisadas
		addi	$s3, $s3, 52					#Se mueve a la siguiente carrera
		b		imprimirCarrera
	endImprimirCarrera:
	
	li		$v0, 10
	syscall										#Termina el programa