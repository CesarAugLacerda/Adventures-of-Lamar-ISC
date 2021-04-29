###########################################
#                                         #
#             	MACROS GERAIS             #
#                                         #
###########################################




###########################################
#                                         #
#             Imprimir imagens            #
#                                         #
###########################################

.macro Impressao(%data, %hex, %time, %fun�ao)
#%data = arquivo.data a ser imprimido
#%hex = endere�o inicial de print/frame----> 0xFF000000, endere�o inicial no frame 0	
#%time = Pausa em milissegundos para mostrar a imagem,caso coloque zero,n�o havera pausa
#%fun�ao = nome de fun�ao para se seguir assim que a imagem for por completo imprimida
	la t0, %data		#endere�o de imagem
	lw t1, 0(t0) 		#x(linhas)
	lw t2, 4(t0) 		#y(colunas)
	mul t3, t1, t2		#numero total de pixels
	addi t0, t0, 8		#Primeiro pixel
	li t4, 0		#contador
	li s0, %hex  	#endere�o inicial de print/frame
	
# Pausa em milissegundos para mostrar a imagem
li a7, 32
li a0, %time
ecall	
	
#J� com a imagem carregada, ocorre impressao nesse loop	
IMPRIME:
	beq t4, t3, %fun�ao		#quando finalizar, pula para a fun��o desejada
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0, t0, 4
	addi s0, s0, 4	
	addi t4, t4, 4	
	j 	IMPRIME	
.end_macro
#==================================================================================================================

