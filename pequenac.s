.macro ImpressaopequenaC(%data, %hexf0, %hexf1, %time, %pula, %funcao)
#Mesma fun??o, mas feita para imprimir imagens de tamanho espec¨ªfico em um lugar
#espec¨ªfico da tela.
#Lembre-se que hexf0 e hexf1 devem ser iguais, salvo o bit que indica o frame: FF"0" ou FF"1"
#%pula = valor em hex de quantos pixels se deve pular para come?ar a imprimir
# na pr¨®xima linha.

#-------------------------------FRAME 0---------------------------------#
F0:
	la t0, %data		#endere?o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            	#armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0			#contador
	mv s0, %hexf0  		#endere?o inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#J¨¢ com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a fun??o desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o pr¨®ximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F0	
	
#-------------------------------FRAME 1---------------------------------#	
F1:	
	la t0, %data		#endere?o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	mv s0, %hexf1  		#endere?o inicial de print no frame 1
	
	
#J¨¢ com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %funcao		#quando finalizar, pula para a fun??o desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o pr¨®ximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F1		
.end_macro
