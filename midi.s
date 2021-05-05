###############################################
#               Syscall MIDI                  #
###############################################

.data
#=============================================SOUNDTRACK==============================================================================
#Jenova(tamanho:76)
JENOVA: 36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357

#Costa del sol(tamanho: 17)
FF17_COSTA_DEL_SOL:60,1282,67,513,65,256,67,2052,60,1282,71,513,68,256,67,2052,60,1282,67,513,68,256,69,2052,60,1282,72,513,71,256,69,2052,60,2052

#amongus(tamanho: 31) 
AMONGUS: 36,638,72,319,76,319,77,319,78,319,77,319,76,319,72,638,60,319,71,159,74,159,72,638,60,319,31,319,36,638,72,319,76,319,77,319,78,319,77,319,76,319,78,638,60,638,78,212,77,212,76,212,78,212,77,0,77,212,76,0,76,212

#Zelda(tamanho:97)
ZELDA: 60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1630,72,326,72,163,71,163,69,326,71,489,69,163,67,1304,67,652,65,326,65,163,67,163,69,1304,67,326,65,326,64,326,64,163,65,163,67,1304,65,326,64,326,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326,60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1956,76,652,74,652,73,1304,67,652,69,1956,72,652,73,652,67,1304,67,652,69,1956,72,652,73,652,67,1304,64,652,65,1956,69,652,67,652,64,1304,60,652,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326

#Kingdom Hearts(tamanho:68)
KH: 81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,79,682,79,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,88,682,88,227
#=====================================================================================================================================
.macro play_musica(%tamanho, %instrumento, %musica)



.data
LAST_DURATION:	.word 0		# duracao da ultima nota
LAST_PLAYED:	.word 0		# quando a ultima nota foi tocada
MUSIC_NUM:	.word %tamanho	# total de notas

.text
	jal a0,SET_PL		# reseta os valores padrões (define o valor de retorno em a0)
M_LOOP:	jal PLAY		# tocar música
	

	
	j M_LOOP		# continuar main loop

PLAY:	la t1,LAST_PLAYED	# endereço do last played
	lw t1,0(t1)		# t1 = last played
	beq t1,zero,P_CONT	# if last played == 0 THEN continue loop (primeira ocorrência)

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_DURATION	# endereço da last duration
	lw t0,0(t0)		# t0 = duracao da ultima nota
	sub t1,a0,t1		# t1 = agora - quando a ultima nota foi tocada (quanto tempo passou desde a ultima nota tocada)
	bge t1,t0,P_CONT	# if t1 >= last duration THEN continue loop (se o tempo que passou for maior que a duracao da nota, toca a proxima nota)
	ret			# retorna ao main loop

P_CONT:	bne s0,s1,P_NOTE	# if s0 != s1 THEN toca a proxima nota
	jal a0,SET_PL		# reseta os valores padrões (a musica vai ficar tocando num loop) (define o valor de retorno em a0)
	ret			# volta ao main loop

P_NOTE:	lw a0,0(s2)		# le o valor da nota
	lw a1,4(s2)		# le a duracao da nota
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	
	la t0,LAST_DURATION	# endereço da last duration
	sw a1,0(t0)		# salva a duracao da nota atual no last duration

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_PLAYED	# endereço do last played
	sw a0,0(t0)		# salva o instante atual no last played

	addi s2,s2,8		# incrementa para o endereço da próxima nota
	addi s0,s0,1		# incrementa o contador de notas
	ret			# volta ao main loop

# define os valores padrões
SET_PL: li s0,0			# contador notas
	la t0,MUSIC_NUM		# endereço do total de notas
	lw s1,0(t0)		# total de notas
	la s2,%musica	        # endereço das notas

	li a2,%instrumento	# instrumento
	li a3,127		# volume
	jr a0			# volta a quem chamou
	
.end_macro	

#Instrumentos
#0-7 	Piano			8-15 	Chromatic Percussion

#16-23	Organ			24-31	Guitar

#32-39 	Bass			40-47  Strings

#48-55 	Ensemble		56-63	Brass

#64-71	Reed			72-79	Pipe
	
#80-87	Synth Lead		88-95	Synth Pad

#96-103 Synth Effects		104-111 Ethnic

#112-119 Percussion		120-127	Sound Effects


#area de teste
play_musica(97, 56, AMONGUS)
