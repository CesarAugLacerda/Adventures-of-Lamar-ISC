##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza

.include "MACROSv21.s"

.data
#macros
.include "macro.s"

# personagem para teste
.include "./Imagens/lamaresq.data"
.include "./Imagens/lamardir.data"
.include "./Imagens/lamarbaixo.data"
.include "./Imagens/lamarcima.data"

# mapa para teste
.include "./Imagens/MAPA1.data"

# macro para o menu funcional
.include "menu.s"

# chao para preencher onde o personagem estava
.include "./Imagens/meiochao.data"

.text
MENU:
Menu()


#=================================VIDAS=============================

VIDA:
li t0, 5
beq s7, t0, VIDA_5		#se lamar tiver 5 de vida, printa 5
li t0, 4
beq s7, t0, VIDA_4		#se lamar tiver 4 de vida, printa 4
li t0, 3
beq s7, t0, VIDA_3		#se lamar tiver 3 de vida, printa 3
li t0, 2
beq s7, t0, VIDA_2		#se lamar tiver 2 de vida, printa 2
li t0, 1
beq s7, t0, VIDA_1		#se lamar tiver 1 de vida, printa 1
beq s7, zero, VIDA_0		#se lamar tiver 0 de vida, printa 0


VIDA_5:
vida_lamar(5, IMPRIME_PERSONAGEM1)

VIDA_4:
vida_lamar(4, IMPRIME_PERSONAGEM1)

VIDA_3:
vida_lamar(3, IMPRIME_PERSONAGEM1)

VIDA_2:
vida_lamar(2, IMPRIME_PERSONAGEM1)

VIDA_1:
vida_lamar(1, IMPRIME_PERSONAGEM1)

VIDA_0:
vida_lamar(0, IMPRIME_PERSONAGEM1)



VIDA_DIMINUI:
li t0, 1
sub s7, s7, t0				#sempre que lamar morrer diminui -1 de vida(s8)
blt s7, zero, MENU
j MAIN
#=================================FASES=============================
#FASE1
MAIN:
IMPRIME_FASE1:
	Impressao(MAPA1, 0xFF000000, 0, VIDA)		#print da primeira fase com delay de 8seg para se ler a historia
		#MAIN seria o inicio da gameplay funçao localizada em ADVLAMAR.s
IMPRIME_PERSONAGEM1:
Imprimepersonagem(0xFF008C20, NEXT)

NEXT:
Andapersonagem()




	
.include "SYSTEMv21.s"
