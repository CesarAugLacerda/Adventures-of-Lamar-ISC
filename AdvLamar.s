##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza

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

Menu

MAIN:
Imprimepersonagem(0xFF008C20, NEXT)

NEXT:

Andapersonagem()


