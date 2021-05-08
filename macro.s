###########################################
#                                         #
#             	MACROS GERAIS             #
#                                         #
###########################################

.macro Trocaframe(%delay)

#Delay antes de trocar o frame
li a7, 32	
li a0, %delay
ecall

li a5, 0xFF200604	#Carrega o endere�o respons�vel pela troca de frame
lw t1, 0(a5)		#Carrega-o em t1 para manipular
xori t1, t1, 0x001 	#Inverte o valor atual
sw t1, 0(a5)		#Armazena de volta em a5 o valor invertido
.end_macro
 

###########################################
#                                         #
#             Imprimir imagens            #
#                                         #
###########################################
# Todos os macros de impress�o imprimem a imagem nos dois frames, separados em xxxx_F0 e xxxx_F1
# para evitar que algo seja impresso apenas em um e cause flickering na imagem.



.macro Impressao(%data, %hexf0, %hexf1, %time, %fun�ao)
#%data = arquivo.data a ser imprimido
#%hex = endere�o inicial de print/frame----> 0xFF000000, endere�o inicial no frame 0.
#a diferen�a entre hexf0 e hexf1 deve ser apenas o FF0 / FF1.	
#%time = Pausa em milissegundos para mostrar a imagem,caso coloque zero,n�o havera pausa
#%fun�ao = nome de fun�ao para se seguir assim que a imagem for por completo imprimida

F0:				#imprime a imagem no frame 0
	la t0, %data		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf0  	#endere�o inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME_F0
	
F1:				#imprime a imagem no frame 1
	la t0, %data		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf1  	#endere�o inicial de print no frame 1
	

#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %fun�ao		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME_F1		
.end_macro

#--------------------------------------------------------------#


.macro Impressaopequena(%data, %hexf0, %hexf1, %time, %pula, %fun�ao)
#Mesma fun��o, mas feita para imprimir imagens de tamanho espec�fico em um lugar
#espec�fico da tela.
#Lembre-se que hexf0 e hexf1 devem ser iguais, salvo o bit que indica o frame: FF"0" ou FF"1"
#%pula = valor em hex de quantos pixels se deve pular para come�ar a imprimir
# na pr�xima linha.

#-------------------------------FRAME 0---------------------------------#
F0:
	la t0, %data		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf0  		#endere�o inicial de print no frame 0
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, F1		#quando finalizar, pula para a fun��o desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o pr�ximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F0	
	
#-------------------------------FRAME 1---------------------------------#	
F1:	
	la t0, %data		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hexf1  		#endere�o inicial de print no frame 1
	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, %fun�ao		#quando finalizar, pula para a fun��o desejada
	lb t5, 0(t0)
	sb t5, 0(s0)
	addi t0, t0, 1
	addi s0, s0, 1	
	addi t4, t4, 1
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos pelo n de linhas para o pr�ximo beq ainda pular linha.
	addi s0, s0, %pula
	j IMPRIME_F1		
.end_macro

#---------------------------------------------------------------------#
.macro apaga_cor(%hex, %largura, %total_pixels, %cor, %pula, %fun�ao)
#%hex = endere�o inicial de print/frame----> 0xFF000000, endere�o inicial no frame 0	
#total_pixel = quantidade total de pixel a serem imprimidos(largura x altura)
#%cor = cor em hexadecimal a ser imprimida
#%pula = valor em hex de quantos pixels se deve pular para come�ar a imprimir 
#%fun�ao = nome de fun�ao para se seguir assim que a imagem for por completo imprimida
APAGA_:
	li t1, %hex			# carrega o endereco inicial
	li t2, %total_pixels		# quantidade total de pixels a imprimir(X * Y)
	li t3, %cor	        	# cor desejada em hexadecimal
	li t4, 0			# contador de pixels
	li t6, %largura			# contador para pular linha
	
LOOP_APAGA:	beq t4, t2, %fun�ao			# imprime a seta de baixo quando apagar a de cima
		beq t4, t6, PULA_LINHA_APAGA	# pula linha quando chegou no final dos pixel
		sb t3, 0(t1)				# preenche o pixel com a cor
		addi t4, t4, 1				
		addi t1, t1, 1
		j LOOP_APAGA

PULA_LINHA_APAGA:
		addi t6, t6, %largura
		addi t1, t1, %pula
		j LOOP_APAGA
.end_macro


###########################################
#                                         #
#            	Andar		          #
#                                         #
###########################################
# e preciso guardar o endereco inicial do frame onde o personagem esta em um registrador que nao vai
# ser utilizado por mais nada. Assim podemos usar ele para imprimir o chao quando o personagem andar
# e atualizar esse registrador com o novo endereco do personagem.
# Para isso vou fazer um macro separado so para imprimir o personagem.

.macro Imprimepersonagem(%hexf0, %hexf1, %fun�ao)

#-------------------------------FRAME 0---------------------------------#
IMPRIMEPER_F0:
	la t0, lamardir		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s10, %hexf0		#armazena o endereco inicial separadamente para preencher o chao quando o personagem andar.
	li s0, %hexf0  		#endere�o inicial de print/frame

	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, COMPENSA_F0		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi s0, s0, 0x130
	j IMPRIME_F0

#Tira 8 pixels que j� ser�o somados em "APAGA", isso evita que ele d� um pulo de
#8 pixels na primeira vez que anda e deixa metade da primeira sprite sem apagar.
COMPENSA_F0:
addi s10, s10, -8

#-------------------------------FRAME 1---------------------------------#
IMPRIMEPER_F1:
	la t0, lamardir		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li a4, %hexf1		#armazena o endereco inicial separadamente para preencher o chao quando o personagem andar. // EQUIVALENTE AO S10
	li a3, %hexf1  		#endere�o inicial de print/frame // EQUIVALENTE AO S0

	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, COMPENSA_F1		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(a3)
	addi t0, t0, 4
	addi a3, a3, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi a3, a3, 0x130
	j IMPRIME_F1

#Tira 8 pixels que j� ser�o somados em "APAGA", isso evita que ele d� um pulo de
#8 pixels na primeira vez que anda e deixa metade da primeira sprite sem apagar.
COMPENSA_F1:
addi a4, a4, -8

.end_macro

###################################################################
###################################################################

# O s9 � necess�rio para manipular os valores da impress�o do personagem fora de s10. 
# Tentei usar somente o s10, onde o endere�o inicial do personagem � armazenado diretamente, 
# mas fazer manipula��es direto nele causa problemas. O ideal � que s10 apenas guarde os 
# valores atualizados.

.macro Apagachao(%dir)
# %dir � o valor que vai ser somado ou subtra�do do endere�o inicial para apagar o lolo anterior e definir a 
# pr�xima posi��o dele.
#-------------------------------FRAME 0---------------------------------#
APAGA_F0:
	la t0, meiochao		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	addi s9, s10, 8		#guarda em s9 o endere�o em que deve come�ar a apagar

APAGA_IMPRIME_F0:
	bge t4, t3, NOVOVAL_F0		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s9)
	addi t0, t0, 4
	addi s9, s9, 4	
	addi t4, t4, 4
	beq t4, t6, APAGA_PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	APAGA_IMPRIME_F0
	
	APAGA_PULA_F0:
	addi t6, t6, 16			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi s9, s9, 0x130		
	j APAGA_IMPRIME_F0

NOVOVAL_F0:
	
	li t5, %dir
	add s10, s10, t5		# Passa o endere�o incial que vai ser apagado %dir pixels para a dire��o que vai andar

#-------------------------------FRAME 1---------------------------------#
APAGA_F1:
	la t0, meiochao		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	addi a2, a4, 8		#guarda em s9 o endere�o em que deve come�ar a apagar

APAGA_IMPRIME_F1:
	bge t4, t3, NOVOVAL_F1		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(a2)
	addi t0, t0, 4
	addi a2, a2, 4	
	addi t4, t4, 4
	beq t4, t6, APAGA_PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	APAGA_IMPRIME_F1
	
	APAGA_PULA_F1:
	addi t6, t6, 16			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi a2, a2, 0x130		
	j APAGA_IMPRIME_F1

NOVOVAL_F1:
	
	li t5, %dir
	add a4, a4, t5		# Passa o endere�o incial que vai ser apagado %dir pixels para a dire��o que vai andar

.end_macro

###################################################################
###################################################################

.macro Anda(%sprite)
# %sprite pede a sprite da dire��o em que a instru��o est� levando o personagem
# "lamardir", "lamaresq", "lamarcima", "lamarbaixo" ou seus correspondentes do frame 1 para animar.

# %INC pula de volta para receber o input do teclado, no geral vamos tentar usar sempre INC mesmo,
# mas � preciso incluir toda vez.

#-------------------------------FRAME 0---------------------------------#
ANDA_F0:
	la t0, %sprite	#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, 0  		#endere�o inicial de print/frame da proxima posicao do personagem
	add s9, s10, zero	#armazena em s9 o endere�o em que o personagem deve ser impresso
	add s0, s0, s9		#passa o endere�o para s0, de forma a n�o manipular diretamente no s9
	addi s0, s0, 8		#soma 8 pixels no endereco inicial, que e a quantidade que o personagem anda
	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F0:
	beq t4, t3, FIMF0			#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F0		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F0
	
	PULA_F0:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi s0, s0, 0x130
	j IMPRIME_F0
FIMF0:		 

#-------------------------------FRAME 1---------------------------------#	
	ANDA_F1:
	la t0, %sprite	#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	lw t6, 0(t0)            #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li a2, 0  		#endere�o inicial de print/frame da proxima posicao do personagem
	add a3, a4, zero	#armazena em s9 o endere�o em que o personagem deve ser impresso
	add a2, a2, a3		#passa o endere�o para s0, de forma a n�o manipular diretamente no s9
	addi a2, a2, 8		#soma 8 pixels no endereco inicial, que e a quantidade que o personagem anda
	

#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME_F1:
	beq t4, t3, FIMF1		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(a2)
	addi t0, t0, 4
	addi a2, a2, 4	
	addi t4, t4, 4
	beq t4, t6, PULA_F1		#quando chegar ao final de uma linha, pula para a seguinte	
	j 	IMPRIME_F1
	
	PULA_F1:
	add t6, t6, t1			#incrementa o numero de pixels impressos em 16 para o pr�ximo beq ainda pular linha.
	addi a2, a2, 0x130
	j IMPRIME_F1

FIMF1:	
.end_macro

###################################################################
###################################################################

.macro Andapersonagem()

	li s0, 0 		# reseta o s0

INC:	addi s0, s0, 1		# Incrementa o contador
	#Trocaframe(40)		# Alterna entre os frames 0 e 1 com 40ms de delay.
	jal RECEBE_TECLA
	j INC			# Retorna ao contador

RECEBE_TECLA: 
	li t1,0xFF200000		# carrega o KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero, RETORNA  	   	# Se n�o h� tecla pressionada ent�o vai para Retorno(fun�a {RETORNA: ret} deve estar no final da pagina do arquivo)
   	lw t2,4(t1)  			# le o valor da tecla
   	li t3, 115			# ascii de "s"
   	li t4, 119			# ascii de "w" para verificar se foi pressionado
	li t5, 97			# ascii de "a" para verificar se foi pressionado
	li t6, 100			# ascii de "d" para verificar se foi pressionado
	li t0, 102			# ascii de "f" para verificar se foi pressionado
	
	beq t2, t6, APAGADIR		# anda para a direita
	beq t2, t5, APAGAESQ		# anda para a esquerda
	beq t2, t4, APAGACIMA		# anda para cima
	beq t2, t3, APAGABAIXO		# anda para baixo
	
	li t0, 27			# ascii de "esc" para verificar se foi pressionado
	beq t2, t0, VIDA_DIMINUI 	#seppuku
			

APAGADIR:
Apagachao(8)

ANDA_DIR:
Anda(lamardir_walk)	#Sprite andando para anima��o
Trocaframe(65)		#Delay m�nimo para que a anima��o possa ser vista
Apagachao(0)		#Apaga a sprite para n�o ocorrer sobreposi��o
Anda(lamardir)		#Sprite parado novamente
Trocaframe(65)		#Delay m�nimo para que a anima��o possa ser vista
j INC	
	

APAGAESQ:
Apagachao(-8)


ANDA_ESQ:
Anda(lamaresq_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamaresq)
Trocaframe(65)
j INC
	
	
APAGACIMA:
Apagachao(-0xA00)
			
ANDA_CIMA:
Anda(lamarcima_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamarcima)
Trocaframe(65)
j INC


APAGABAIXO:
Apagachao(0xA00)

ANDA_BAIXO:
Anda(lamarbaixo_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamarbaixo)
Trocaframe(65)
j INC

RETORNA:ret												
.end_macro

#==================================================================================================================
###########################################
#                                         #
#            	SENHA		          #
#                                         #
###########################################
.macro senha(%primeira, %segunda, %terceira, %quarta, %fun�ao, %fun�ao_de_acerto)
#em ordem os valores sao armazendas em s2, s3, s4, s5.
#com seus respectivos valores em ASCII
#%fun�ao sereve para pular para proxima posibilidade de senha caso essa esteja errada
#%fun�ao_de_acerto = fun�ao que vai se seguir caso esteja certa a senha
	
	li t0, %primeira			
	beq s2, t0, SEG_LETRA
	j	%fun�ao
	
	SEG_LETRA:
	li t0, %segunda                         
	beq s3, t0, TER_LETRA
	j	%fun�ao
	
	TER_LETRA:
	li t0, %terceira			
	beq s4, t0, QUA_LETRA
	j	%fun�ao
	
	QUA_LETRA:
	li t0, %quarta				
	beq s5, t0, %fun�ao_de_acerto
	j	%fun�ao
.end_macro	


###########################################
#                                         #
#            Print screen	          #
#                                         #
###########################################
.macro print_int_screen(%r, %x, %y, %cor, %frame)
li a0, %r		# Int a ser impresso
li a1, %x		# Coluna
li a2, %y		# Linha
li a3, %cor
li a4, %frame		# Define o frame em que ser� impresso
li a7, 101		# PrintInt
ecall
.end_macro

.macro vida_lamar(%vida, %fun�ao)
print_int_screen(%vida, 263, 35, 100, 0)
print_int_screen(%vida, 263, 35, 100, 1)
j %fun�ao
.end_macro
