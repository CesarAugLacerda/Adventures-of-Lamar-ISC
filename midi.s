###############################################
#               Syscall MIDI                  #
###############################################

.data
LAST_DURATION:	.word 0		# duracao da ultima nota
LAST_PLAYED:	.word 0		# quando a ultima nota foi tocada
INSTRUMENTO:	.word 0		#instrumento a ser tocado
.text

.macro play_musica(%tamanho, %instrumento, %musica)

.data
MUSIC_NUM:	.word %tamanho	# total de notas

.text

M_LOOP:	jal PLAY		# tocar musica
	
	
	
	j FIM			# pula para o final

PLAY:	la t1,LAST_PLAYED	# endere?¡ìo do last played
	lw t1,0(t1)		# t1 = last played
	beq t1,zero,P_CONT	# if last played == 0 THEN continue loop (primeira ocorr??ncia)

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_DURATION	# endere?¡ìo da last duration
	lw t0,0(t0)		# t0 = duracao da ultima nota
	sub t1,a0,t1		# t1 = agora - quando a ultima nota foi tocada (quanto tempo passou desde a ultima nota tocada)
	bge t1,t0,P_CONT	# if t1 >= last duration THEN continue loop (se o tempo que passou for maior que a duracao da nota, toca a proxima nota)
	ret			# retorna ao main loop

P_CONT:	bne s4,s3,P_NOTE	# if s4 != s3 THEN toca a proxima nota
	jal a0, RESTART		# reseta os valores padr??es (a musica vai ficar tocando num loop) (define o valor de retorno em a0)
	ret			# volta ao main loop

P_NOTE:	lw a0,0(s11)		# le o valor da nota
	lw a1,4(s11)		# le a duracao da nota
	la t0, INSTRUMENTO	#entra no instrumento
	lw a2, 0(t0)		#determina o instrumento
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	
	la t0,LAST_DURATION	# endere?¡ìo da last duration
	sw a1,0(t0)		# salva a duracao da nota atual no last duration

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_PLAYED	# endere?¡ìo do last played
	sw a0,0(t0)		# salva o instante atual no last played

	addi s11,s11,8		# incrementa para o endere?¡ìo da pr??xima nota
	addi s4,s4,1		# incrementa o contador de notas
	ret			# volta ao main loop

# define os valores padr??es

RESTART:li s4,0			# reseta contador notas 
	 la t0,MUSIC_NUM		# endere?¡ìo do total de notas
	 lw s3,0(t0)		# total de notas
	 la s11,%musica	        # endere?¡ìo das notas
	 li a2,%instrumento	# instrumento
	 la t0, INSTRUMENTO
	 sw a2, 0(t0)
	 li a3,100		# volume
	 jr a0			# volta a quem chamou
FIM:
				
.end_macro	

.macro play_musica_notloop(%tamanho, %instrumento, %musica)

.data
MUSIC_NUM:	.word %tamanho	# total de notas

.text

M_LOOP:	jal PLAY		# tocar musica
	
	beq s4,s3,FIM		#se essa for a ultima nota a ser tocada termina a fun?ao e vai para o fim
	
	j M_LOOP			# pula para o final

PLAY:	la t1,LAST_PLAYED	# endere?¡ìo do last played
	lw t1,0(t1)		# t1 = last played
	beq t1,zero,P_CONT	# if last played == 0 THEN continue loop (primeira ocorr??ncia)

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_DURATION	# endere?¡ìo da last duration
	lw t0,0(t0)		# t0 = duracao da ultima nota
	sub t1,a0,t1		# t1 = agora - quando a ultima nota foi tocada (quanto tempo passou desde a ultima nota tocada)
	bge t1,t0,P_CONT	# if t1 >= last duration THEN continue loop (se o tempo que passou for maior que a duracao da nota, toca a proxima nota)
	ret			# retorna ao main loop

P_CONT:	bne s4,s3,P_NOTE	# if s4 != s3 THEN toca a proxima nota
	jal a0, RESTART		# reseta os valores padr??es (a musica vai ficar tocando num loop) (define o valor de retorno em a0)
	ret			# volta ao main loop

P_NOTE:	lw a0,0(s11)		# le o valor da nota
	lw a1,4(s11)		# le a duracao da nota
	la t0, INSTRUMENTO	#entra no instrumento
	lw a2, 0(t0)		#determina o instrumento
	li a7,31		# define a chamada de syscall
	ecall			# toca a nota
	
	la t0,LAST_DURATION	# endere?¡ìo da last duration
	sw a1,0(t0)		# salva a duracao da nota atual no last duration

	li a7,30		# define o syscall Time
	ecall			# time
	la t0,LAST_PLAYED	# endere?¡ìo do last played
	sw a0,0(t0)		# salva o instante atual no last played

	addi s11,s11,8		# incrementa para o endere?¡ìo da pr??xima nota
	addi s4,s4,1		# incrementa o contador de notas
	ret			# volta ao main loop

# define os valores padr??es

RESTART:li s4,0			# reseta contador notas 
	 la t0,MUSIC_NUM		# endere?¡ìo do total de notas
	 lw s3,0(t0)		# total de notas
	 la s11,%musica	        # endere?¡ìo das notas
	 li a2,%instrumento	# instrumento
	 la t0, INSTRUMENTO
	 sw a2, 0(t0)
	 li a3,100		# volume
	 jr a0			# volta a quem chamou
FIM:	#termina a funcao
				
.end_macro	

#play_musica_notloop(9, 80, FANFARE)
#Instrumentos
#0-7 	Piano			8-15 	Chromatic Percussion

#16-23	Organ			24-31	Guitar

#32-39 	Bass			40-47  Strings

#48-55 	Ensemble		56-63	Brass

#64-71	Reed			72-79	Pipe
	
#80-87	Synth Lead		88-95	Synth Pad

#96-103 Synth Effects		104-111 Ethnic

#112-119 Percussion		120-127	Sound Effects


#efeitos sonoros de uma nota
.macro play_sound(%a0, %a1, %a2, %a3)
li a0,%a0	#nota
li a1,%a1	#time
li a2,%a2	#instrumento
li a3,%a3	#volume
li a7,33
ecall
.end_macro

#reseta a musica
.macro reset()
	li s3,0
	li s4,0			# reseta contador notas (midi) 
	la t0,LAST_DURATION	# endere?¡ìo da last duration
	sw zero,0(t0)		#reseta para zero o valor
		
	la t0,LAST_PLAYED	# endere?¡ìo do last played
	sw zero,0(t0)		#reseta para zero o valor
.end_macro




#================================================================