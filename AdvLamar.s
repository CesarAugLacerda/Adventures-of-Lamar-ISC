##################################################################
#  Adventures of Lamar - Projeto final de ISC                    #
#  2020/2			  			         #
##################################################################
# Por favor, comente o codigo com clareza


.include "macro.s"
.include "MACROSv21.s"	
		
.text

j MENU


#Trampolim pra caixa:
CAIXA_T3:
	ImpressaopequenaC(meiochao, a6, s6, 0, 304, CAIXATEMP_T)
	CAIXATEMP_T:
		jr s5

CAIXA2_T3:
	ImpressaopequenaC(caixa, a6, s6, 0, 304, CAIXATEMP2_T)
	CAIXATEMP2_T:
		jr s5
			
ATACADIR2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, RECEBE_TECLA_T)
		
ATACACIMA2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, RECEBE_TECLA_T)

ATACAESQ2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, RECEBE_TECLA_T)

ATACABAIXO2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, RECEBE_TECLA_T)

INICIO_MENU:
#====================MENU=================================
# Prepara os endere?os para printar o menu na tela
	ImpressaoF(menu1, 0xFF000000, 0, MENU_F)

# Prepara os enderecos para printar a segunda parte do menu
MENU_F:
	Frame(0) #para poder surgir de uma vez a tela do menu
	Impressao(menu2,0xFF000000, 0xFF100000, 1000, MUSICA)

MUSICA:		# Vazio ate que o menu esteja pronto

# Prepara os enderecos para printar a segunda parte do menu e entra para a seta de sele??o do menu
MENU_TXT: 
	Impressao(menu3,0xFF000000, 0xFF100000, 0, SETA)
#========================================================
SETA:
	Impressaopequena(seta, 0xFF00BF98, 0xFF10BF98, 0, 0x12D, TECLADO)
	
TECLADO:
	li s8, 0 		# Nesse trecho, a1 vai definir em que opcao do menu estamos atualmente. 0 = start, 1 = password
	li s0, 0 		# Zera o contador utilizado nas imagens
	
INC_TECLA:	addi s0, s0, 1		# Incrementa o contador
	jal RECEBE_TECLA_MENU
	j INC_TECLA			# Retorna ao contador
	
#=================================TECLADO===============================
RECEBE_TECLA_MENU: 
	jal s5, MUSICA1
	li t1,0xFF200000		# carrega o KDMMIO

	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	
	
   	beq t0,zero,RECEBE_TECLA_MENU   	   	# Se n?o h¨¢ tecla pressionada ent?o vai para Retorno(fun?a {RETORNA: ret} deve estar no final da pagina do arquivo)
   	lw t2,4(t1)  			# le o valor da tecla
   	
	li t5, 115			# ascii de "w" para verificar se foi pressionado
	li t6, 119			# ascii de "s" para verificar se foi pressionado
	li t0, 102			# ascii de "f" para verificar se foi pressionado
	beq t2, t6, SETA_CIMA		#SETA vai pra cima	
	beq t2, t5, SETA_BAIXO		#SETA vai pra baixo
	beq t2, t0, SELECAO_MENU	#Entra no lugar desejado
	
#=========================================================================		
SETA_CIMA:
	li s8, 0		# carrega 0 em a1 para indicar que a seta esta em "start"
	apaga_cor(0xFF00E518, 19, 266, 0xFFFFFFFF, 0x12D, IMPRIME_SETA_CIMA )
	IMPRIME_SETA_CIMA:
		Impressaopequena(seta, 0xFF00BF98, 0xFF10BF98, 0, 0x12D, INC_TECLA)
	
#----------------------------------------------------------------------------------------------------------------#	
SETA_BAIXO:
	li s8, 1		# carrega 1 em a1 para indicar que a seta esta em "password"
	apaga_cor(0xFF00BF98, 19, 266, 0xFFFFFFFF, 0x12D, IMPRIME_SETA_BAIXO )
	IMPRIME_SETA_BAIXO:
		Impressaopequena(seta, 0xFF00E518, 0xFF10E518, 0, 0x12D, INC_TECLA)
	
#==========================SELE??O Start/Password ======================================
#s8 = 0 seta esta em start
#s8 = 1 seta esta em password
 
SELECAO_MENU:
	jal s5, MUSICA_RESET
	li t0, 1 
	beq s8, zero, START		#s8 = 0. vai para START
	beq s8, t0, PASSWORD		#s8 = 1. vai para PASSWORD
#+++++++++++++++++++++++++++MENU START++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
START:
.include "midi.s"	

    ImpressaoF(basehistoria, 0xFF000000, 0, HISTORIA)        #imagem contando historia do jogo
HISTORIA:
    ImpressaopequenaF(lamarhistinicial, 0xFF00D49C, 0, 0x118, ULA)
ULA:
    ImpressaopequenaF(ULALA, 0xFF0074BC, 0, 0xF8, SOM_ULA)
    
SOM_ULA:

play_sound(35, 250, 62, 50)
play_sound(35, 250, 62, 50)
play_sound(35, 600, 62, 50)

Delay(2000)

FALA:
ImpressaopequenaF(texto1, 0xFF002FE8, 0, 0xC8, VOZ)

VOZ:
play_sound(40, 150, 62, 50)
play_sound(42, 100, 62, 50)

Delay(5000)

FALA2:
ImpressaopequenaF(texto2, 0xFF002FE8, 0, 0xC8, VOZ2)

VOZ2:
play_sound(45, 150, 62, 50)
play_sound(47, 200, 62, 50)
play_sound(44, 100, 62, 50)

Delay(5000)


APAGATEXTO:
apaga_cor(0xFF002FE8, 120, 4680, 233, 0xc8, LAMARMUDA)

LAMARMUDA:
ImpressaopequenaF(lamarcostashist, 0xFF00D49C, 0, 0x118, VOZLAMAR)

VOZLAMAR:
play_sound(55, 400, 62, 50)

PISCA:
ImpressaopequenaF(ULALAPISCA, 0xFF0074BC, 0, 0xF8, PISCA2)
PISCA2:
ImpressaopequenaF(ULALA, 0xFF0074BC, 0, 0xF8, PISCA3)
PISCA3:
ImpressaopequenaF(ULALAPISCA, 0xFF0074BC, 0, 0xF8, SOME)
SOME:
apaga_cor(0xFF0074BC, 72, 2880, 233, 0xF8, PAUSAFIM)

PAUSAFIM:
 Delay(2000)

	VIDA_INIC:
	li s7, 5				#lamar come?a com 5 de vida
	j MAIN					#em seguida vai pra VIDA conferir e printar a vida atual de lamar


#==================================TRAMPOLIN2==================
CAIXA_T2:
	j CAIXA_T3

CAIXA2_T2:
	j CAIXA2_T3
		
MUSICA1_T2:
	play_musica(68, 0, KH)
	jr s5


MUSICA2_T2:
	play_musica(97, 54, ZELDA)
	jr s5


MUSICA3_T2:
	 play_musica_notloop(9, 64, FANFARE)
	 jr s5

	  
RECEBE_TECLA_T:
j RECEBE_TECLA_T2
#================================================================

#+++++++++++++++++++++++++MENU PASSWORD++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
PASSWORD:
	ImpressaoF(password2, 0xFF100000, 0, PASSWORD2) 	#imagem sem asterisco
	PASSWORD2:
	Frame(1)				#Troca para frame 1
	ImpressaoF(password1, 0xFF100000, 800, BARRA_SELECAO) #imagem com asterisco e vai para o teclado
	BARRA_SELECAO:
	Impressaopequena(Barra_selecao, 0xFF00A53C, 0xFF10A53C, 0, 0x123, TECLADO_PASSWORD)#imprime a barra na sele?¡ìao da primeira letra

#===========================================VALIDA?AO SENHA=============
VALIDADOR_SENHA:
	lw s5, 0xFF20000C 	#carrega display do KDMMIO, quarta letra
	#----------------------------------------------------------------#
	
	li s7, 5				#lamar come?a com 5 de vida(s7) usando uma password
	
	#Primeira fase(senha: abba)
PRIMEIRA_FASE_SENHA:	
	senha(97, 98, 98, 97,SEGUNDA_FASE_SENHA, IMPRESSAO_MAPA1) #se senha correta imprime fase 1
	#Segunda fase(senha: lmao)		
SEGUNDA_FASE_SENHA:	
	senha(108, 109, 97, 111, TERCEIRA_FASE_SENHA, IMPRESSAO_MAPA2)	#se senha correta imprime fase 2	
	#Terceira fase(senha: dudu)	
TERCEIRA_FASE_SENHA:
	#senha(100, 117, 100, 117, QUARTA_FASE_SENHA, IMPRESSAO_MAPA3)	#se senha correta imprime fase 3
	#Quarta fase(senha: pokd)
QUARTA_FASE_SENHA:				
	#senha(112, 111, 107, 100, QUINTA_FASE_SENHA, IMPRESSAO_MAPA4)	#se senha correta imprime fase 4
	#Quinta fase(senha: dend)
QUINTA_FASE_SENHA:
	#senha(100, 101, 110, 100, SENHA_INCORRETA, IMPRESSAO_MAPA5)	#se senha correta imprime fase 5
	
SENHA_INCORRETA:	
	ret    #retorna para PASSWORD, senha incorreta	
	
#=================================SENHAS===============================
#apaga barra da letra anterior e imprime na proxima
#senha:(* * * *),(0 1 2 3),(s2, s3, s4, s5)--------> posi?ao logica de cada valor sendo respectivamente, apenas asteriscos, posi?ao em a1 de cada e registradores onde o valor esta armazendado
SEGUNDA_LETRA:
	lw s2, 0xFF20000C 	#carrega display do KDMMIO, primeira letra
	play_sound(80, 150, 99, 127)
	apaga_cor(0xFF10A53C, 29 ,145,146, 0x123, IMPRIME_SEGUNDA)#apaga barra primeira letra(cor azul)
	IMPRIME_SEGUNDA:
		Impressaopequena(Barra_selecao, 0xFF00A572, 0xFF10A572 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na sele?ao da segunda letra
		
TERCEIRA_LETRA:			#carrega display do KDMMIO, segunda letra
	lw s3, 0xFF20000C 
	play_sound(80, 150, 99, 127)	
	apaga_cor(0xFF10A572, 29 ,145,146, 0x123, IMPRIME_TERCEIRA)#apaga barra primeira letra(cor azul)
	IMPRIME_TERCEIRA:
		Impressaopequena(Barra_selecao, 0xFF00A5A7, 0xFF10A5A7 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na sele?ao da terceira letra
		
QUARTA_LETRA:
	lw s4, 0xFF20000C 	##carrega display do KDMMIO, terceira letra	
	play_sound(80, 150, 99, 127)
	apaga_cor(0xFF10A5A7, 29 ,145,146, 0x123, IMPRIME_QUARTA)#apaga barra primeira letra(cor azul)
	IMPRIME_QUARTA:
		Impressaopequena(Barra_selecao, 0xFF00A5DC, 0xFF10A5DC, 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na sele?ao da quarta letra														
#=================================TECLADO================================
MENU_TROCAFRAME:
	ImpressaoF(menu3,0xFF000000, 0, PROXIMO)
	PROXIMO:
	Trocaframe(0)
	Impressao(menu3,0xFF000000,0xFF100000, 0, SETA)

#vai se esperar o jogador apertar uma tecla
TECLADO_PASSWORD:
	li s8, 0 		# a1 vai definir a posicao do asterisco(0,1,2,3)    
	li s0, 0		# Zera o contador utilizado nas imagens
	
	
CONTA: 	addi s0,s0,1			#incrementa contador
	jal RECEBE_TECLA_PASSWORD
	j CONTA			        # Retorna ao contador
	
RECEBE_TECLA_PASSWORD: 
	li t1,0xFF200000		# carrega o KDMMIO
LOOP:	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,RETORNA2  	   	# Se n?o h¨¢ tecla pressionada entao faz o LOOP
   	lw t2,4(t1)  			# le o valor da tecla
   	sw t2, 12(t1)			#escreve a tecla no display
   	#AVISO
   	#por algum motivo sempre que for reiniciar o BITMAP DISPLAY,caso queira que as teclas sejam digitadas no
   	#display do KDMMIO ¨¦ necessario desconectar e conectar ele
   	
   	li t0, 27			# ascii de "esc" para verificar se foi pressionado
	beq t2, t0, MENU_TROCAFRAME 		#sai do password de volta para o menu
   	
   	addi s8,s8, 1 			#move posi?ao tecla
   	
   	li t0, 1
   	beq t0, s8, SEGUNDA_LETRA	#se a1 determinar que esta na segunda posi?ao(1) vai para segunda letra 
   	
   	li t0, 2
   	beq t0, s8, TERCEIRA_LETRA	#se a1 determinar que esta na terceira posi?ao(2) vai para segunda letra
   	
   	li t0, 3
   	beq t0, s8, QUARTA_LETRA	#se a1 determinar que esta na quarta posi?ao(3) vai para segunda letra
   	
   	li t0, 4
   	beq t0,s8, VALIDADOR_SENHA_PRE       #quando ultima senha for digitada ele faz a valida?ao da senha	

   	
VALIDADOR_SENHA_PRE:
	play_sound(80, 150, 99, 127)
	ImpressaoF(password2, 0xFF000000, 0, VALIDADOR) 	#imagem sem asterisco
	VALIDADOR:
	Frame(0)
	jal VALIDADOR_SENHA
	j PASSWORD	  	
   	
	
#=========================================================================
RETORNA2: ret


.data

POSICAO_LAMAR:  .word 0, 0	# o primeiro valor corresponde ao frame 0, o segundo ao frame 1. uso: 0(t0), 4(s0)
DIRECAO_LAMAR:  .half 0		# Indica a direcao em que o personagem esta olhando. 1 = direita; 2 = cima; 3 = esquerda; 4 = baixo
VIDAS_LAMAR:	.word 5		# quando a ultima nota foi tocada
POWER_LAMAR:	.word 0		# duracao da ultima nota
ABRIR_BAU:      .word 0		#valor determinado para lamar abrir o bau com os powers

#=============================================SOUNDTRACK==============================================================================
#Jenova(tamanho:76)
JENOVA: 36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,36,357,36,357,36,357,40,1071,36,357,36,357,36,357,41,1071,36,357,36,357,36,357,42,357,41,357,40,357,41,357,40,357,38,357,40,714,38,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357,40,357,40,357,40,357,42,1071,40,357,40,357,40,357,45,1071,40,357,40,357,40,357,46,357,45,357,42,357,45,357,42,357,41,357,42,714,41,357

#Costa del sol(tamanho: 17)
FF17_COSTA_DEL_SOL:60,1282,67,513,65,256,67,2052,60,1282,71,513,68,256,67,2052,60,1282,67,513,68,256,69,2052,60,1282,72,513,71,256,69,2052,60,2052

#Tela de vitoria FFVII(tamanho: 9) 
FANFARE: 72,140,72,140,72,140,72,420,68,420,73,420,72,280,73,140,72,1262
#Zelda(tamanho:97)
ZELDA: 60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1630,72,326,72,163,71,163,69,326,71,489,69,163,67,1304,67,652,65,326,65,163,67,163,69,1304,67,326,65,326,64,326,64,163,65,163,67,1304,65,326,64,326,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326,60,652,55,978,60,326,60,163,62,163,64,163,65,163,67,1630,67,326,67,163,69,163,71,326,72,1956,76,652,74,652,73,1304,67,652,69,1956,72,652,73,652,67,1304,67,652,69,1956,72,652,73,652,67,1304,64,652,65,1956,69,652,67,652,64,1304,60,652,62,326,62,163,64,163,66,1304,70,652,67,326,55,163,55,163,55,326,55,163,55,163,55,326,55,163,55,163,55,326,55,326

#Kingdom Hearts(tamanho:68)
KH: 81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,79,682,79,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,81,682,81,227,76,682,76,227,74,682,74,227,83,682,83,227,84,682,84,227,83,682,83,227,88,682,88,227,86,113,88,113,86,455,86,227,84,682,84,227,83,682,83,227,81,682,81,227,88,682,88,227
#=====================================================================================================================================

# macro para o menu funcional
#.include "menu.s"



.text

#===============Trampolin===========
PASSWORD_T:
	reset()
	la t0,VIDAS_LAMAR	# endere?¡ìo da VIDAS_LAMAR
	li t1, 5		#determina como 5 a vida do lamar
	sw t1,0(t0)		# salva a vida do lamar
 	j PASSWORD
 
CAIXA_T:		j CAIXA_T2
CAIXA2_T:		j CAIXA2_T2
MUSICA1_T:	j MUSICA1_T2 	 	
MUSICA2_T:	j MUSICA2_T2 					
MUSICA3_T:	j MUSICA3_T2

ATACADIR2_T2:
j ATACADIR2_T3

ATACACIMA2_T2:
j ATACACIMA2_T3

ATACAESQ2_T2:
j ATACAESQ2_T3

ATACABAIXO2_T2:
j ATACABAIXO2_T3
 	
 RECEBE_TECLA_T2:
j RECEBE_TECLA
#=================================
MENU:
Frame(1) #sempre vai estar no frame 0

la t0,VIDAS_LAMAR	# endere?¡ìo da VIDAS_LAMAR
li t1, 5		#determina como 5 a vida do lamar
sw t1,0(t0)		# salva a vida do lamar

j INICIO_MENU

#=================================VIDAS=============================
VIDA:

la t0,VIDAS_LAMAR	# endere?¡ìo da VIDAS_LAMAR
lw t1,0(t0)		# t1 = vida atual lamar


li t0, 5
beq t1, t0, VIDA_5		#se lamar tiver 5 de vida, printa 5
li t0, 4
beq t1, t0, VIDA_4		#se lamar tiver 4 de vida, printa 4
li t0, 3
beq t1, t0, VIDA_3		#se lamar tiver 3 de vida, printa 3
li t0, 2
beq t1, t0, VIDA_2		#se lamar tiver 2 de vida, printa 2
li t0, 1
beq t1, t0, VIDA_1		#se lamar tiver 1 de vida, printa 1
beq t1, zero, VIDA_0		#se lamar tiver 0 de vida, printa 0


VIDA_5:
vida_lamar(5, VERIFICADOR_DE_FASE)

VIDA_4:
vida_lamar(4, VERIFICADOR_DE_FASE)

VIDA_3:
vida_lamar(3, VERIFICADOR_DE_FASE)

VIDA_2:
vida_lamar(2, VERIFICADOR_DE_FASE)

VIDA_1:
vida_lamar(1, VERIFICADOR_DE_FASE)

VIDA_0:
vida_lamar(0, VERIFICADOR_DE_FASE)


VIDA_DIMINUI:
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
la t0,VIDAS_LAMAR	# endere?¡ìo da VIDAS_LAMAR
lw t1,0(t0)		# t1 = vida atual lamar
li t0, 1
sub t1, t1, t0		#sempre que lamar morrer diminui -1 de vida
la t0,VIDAS_LAMAR	# endere?¡ìo do VIDAS_LAMAR
sw t1,0(t0)		# salva a vida do lamar diminuida
blt t1, zero, MENU	#se lamar chegar a zero vida, volta para o menu

#-------------verificador de fase---------

#s2 determina a fase que lamar esta
li t0, 1
beq s2, t0, IMPRESSAO_MAPA1	#vai para a primeira fase
li t0, 2
beq s2, t0, IMPRESSAO_MAPA2	#vai para a segunda fase

#para a impressao do personagem
VERIFICADOR_DE_FASE:
#s2 determina a fase que lamar esta
li t0, 1
beq s2, t0, IMPRIME_PERSONAGEM1	 #vai para a primeira fase
li t0, 2
beq s2, t0, IMPRIME_PERSONAGEM2 #vai para a segunda fase
#=================================CORA??AO/PODER=============================
CORACAO:
la t0,POWER_LAMAR	# endere?¡ìo da POWER_LAMAR
lw t1,0(t0)

beq, t1, zero, POWER0
li t0, 1
beq, t1, t0, POWER1	
li t0, 2
beq t1, t0, POWER2
li t0, 3
beq t1, t0, POWER3

POWER0:poder_lamar(0, VERIFICADOR_POWER)
POWER1:poder_lamar(1, VERIFICADOR_POWER)
POWER2:poder_lamar(2, VERIFICADOR_POWER)
POWER3:poder_lamar(3, VERIFICADOR_POWER)

CORACAO_AUMENTA:
la t0,POWER_LAMAR	# endere?¡ìo da POWER_LAMAR
lw t1,0(t0)		# t1 = power atual lamar

addi t1, t1, 1		#sempre que lamar pegar cora?¡ìao,aumenta em 1 seu power
la t0,POWER_LAMAR	# endere?¡ìo do VIDAS_LAMAR
sw t1,0(t0)		# salva a vida do lamar diminuida
j   CORACAO

#verifica se lamar pegou todos os powers para abrir a caixa
VERIFICADOR_POWER:
	la t0, POWER_LAMAR
	lw t1, 0(t0)
	
	la t0, ABRIR_BAU
	lw t2, 0(t0)
	
	beq t2, t1, BAU_ABERTA_MAPA
	j RETORNA_JR
	
	BAU_ABERTA_MAPA:
		#s2 determina a fase que lamar esta
	li t0, 1
	beq s2, t0, BAU_ABERTA_MAPA1	 #abre bau primeira fase
	li t0, 2
	beq s2, t0, BAU_ABERTA_MAPA2 #abre bau segunda fase
	
		
RETORNA_JR:
	jr s5

#===========================================================================
#bau abre porta
BAU_PORTA:
	#verifica em qual fase esta
	#s2 determina a fase que lamar esta
	li t0, 1
	beq s2, t0, IMPRIME_PORTA1	 #abre porta da primeira fase
	li t0, 2
	beq s2, t0, IMPRIME_PORTA2      #abre porta da primeira fase	
	
	#Musica vitoria FFVII(tamanho:9)
#FANFARE: 72,140,72,140,72,140,72,420,68,420,73,420,72,280,73,140,72,1262
#===============================MUSICAS=====================================
MUSICA1:	j MUSICA1_T
MUSICA2:	j MUSICA2_T
MUSICA3:	j MUSICA3_T

		
MUSICA_RESET:
	reset()	#reseta a musica
	jr s5	
	
	
		
#=====================================================================================
###########################################
#                                         #
#             	 FASES                    #
#                                         #
###########################################



#=================================FASES=============================
#FASE1
MAIN:
IMPRIME_FASE1:	
	ImpressaoF(Transicao1, 0xFF100000, 0, TROCA_FRAMEI)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEI:
		Frame(1)
		Delay(5000)
		ImpressaoF(MAPA1, 0xFF000000, 0, IMPRESSAO_MAPA1) #impressao no frame 0 para nao mostrar o mapa ser imprimido
		
		IMPRESSAO_MAPA1:
		Frame(0)
		li s2, 1	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA1, 0xFF000000, 0xFF100000, 0, VIDA)
		

IMPRIME_PERSONAGEM1:

#==========Equivalendo valores de power=======
la t0, ABRIR_BAU	# endere???¡ìo do POWER_LAMAR

li t1, 2		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
	
sw t1, 0(t0)		# salva o power do lamar minimo para abrir bau

la t0,POWER_LAMAR	# endere???¡ìo do POWER_LAMAR
li t1, 0		#lamar come?¡ìa com 0 de power sempre
sw t1,0(t0)		# salva o power do lamar 	

#=============================================
jal s5, CORACAO	
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT1)

NEXT1:
la t0, DIRECAO_LAMAR
li t1, 1
sw t1, 0(t0)

jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
Impressaopequena(caixa,0xFF00DCA0,0xFF10DCA0, 0, 0x130, ANDARLAMAR)

BAU_ABERTA_MAPA1:
Impressaopequena(bauaberto,0xFF00DC50,0xFF10DC50, 0, 0x130, RETORNA_JR)

IMPRIME_PORTA1:
Impressaopequena(portaaberta,0xFF0014A0,0xFF1014A0, 0, 0x130, RETORNA_JR)

#FASE2
IMPRIME_FASE2:	
	jal s5, MUSICA_RESET		
	jal s5, MUSICA3
	ImpressaoF(Transicao2, 0xFF100000, 0, TROCA_FRAMEII)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEII:
		Frame(1)
		Delay(5000)
		ImpressaoF(MAPA2, 0xFF000000, 0, IMPRESSAO_MAPA2) #impressao no frame 0 para nao mostrar o mapa ser imprimido
		
		IMPRESSAO_MAPA2:
		Frame(0)
		li s2, 2	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA2, 0xFF000000, 0xFF100000, 0, VIDA)
		
IMPRIME_PERSONAGEM2:
#==========Equivalendo valores de power=======
la t0, ABRIR_BAU	# endere???¡ìo do POWER_LAMAR

li t1, 3		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
	
sw t1, 0(t0)		# salva o power do lamar minimo para abrir bau

la t0,POWER_LAMAR	# endere???¡ìo do POWER_LAMAR
li t1, 0		#lamar come?¡ìa com 0 de power sempre
sw t1,0(t0)		# salva o power do lamar 	

#=============================================
jal s5, CORACAO	
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT2)

NEXT2:
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
j ANDARLAMAR

BAU_ABERTA_MAPA2:
Impressaopequena(bauaberto,0xFF008C30,0xFF108C30, 0, 0x130, RETORNA_JR)

IMPRIME_PORTA2:
Impressaopequena(portaaberta,0xFF0014D0 ,0xFF1014D0 , 0, 0x130, RETORNA_JR)



#======================================================================================================
#======================================================================================================

	
###########################################
#                                         #
#             	ANDAR LAMAR               #
#                                         #
###########################################
	
#==============================O PASSINHO DO LAMAR=========================	
ANDARLAMAR:
	li s0, 0 		# reseta o s0

INC:	addi s0, s0, 1		# Incrementa o contador
	#Trocaframe(40)		# Alterna entre os frames 0 e 1 com 40ms de delay.
	jal RECEBE_TECLA
	j INC			# Retorna ao contador

RECEBE_TECLA: 
	jal s5, MUSICA2
	li t1,0xFF200000		# carrega o KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero, RECEBE_TECLA  	   	# Se n????o h???? tecla pressionada ent????o vai para Retorno(fun????¨¬a {RETORNA: ret} deve estar no final da pagina do arquivo)
   	lw t2,4(t1)  			# le o valor da tecla
   	li t3, 115			# ascii de "s"
   	li t4, 119			# ascii de "w" para verificar se foi pressionado
	li t5, 97			# ascii de "a" para verificar se foi pressionado
	li t6, 100			# ascii de "d" para verificar se foi pressionado
	li t0, 102			# ascii de "f" para verificar se foi pressionado

	beq t2, t6, COLISAODIR		# verifica colisao para a direita
	beq t2, t5, COLISAOESQ		# verifica colisao para esquerda
	beq t2, t4, COLISAOCIMA		# verifica colisao para cima
	beq t2, t3, COLISAOBAIXO	# verifica colisao para baixo
	beq t2, t0, VERIFICADIRECAO	# verifica a direcao que personagem esta virado para iniciar a rotina do ataque

	li t0, 27			# ascii de "esc" para verificar se foi pressionado
	beq t2, t0, VIDA_DIMINUI 	#seppuku

	li t0, 112			#ascii de "p" para verificar se foi pressionada
	beq t2, t0, PASSWORD_T		#entra na tela de password


COLISAODIR:
	li t1, 1630 # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 #cor da caixa
	li t3, 78 #cor do bau
	li t4, 7 #cor do coracao
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAODIR2 # se o pixel for da mesma cor do chao va pra COLISAODIR2
	beq s6, t2, CAIXADIR # se o pixel for da mesma cor da caixa va pra CAIXADIR
	beq s6, t3, BAUDIR # se o pixel for da mesma cor da caixa va pra BAUDIR
	beq s6, t4, CORACAODIR # se o pixel for da mesma cor da caixa va pra CORACAODIR
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo


COLISAODIR2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 3550
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_DIR
	j RECEBE_TECLA

CAIXADIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 3550
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXADIR2
	j RECEBE_TECLA

	CAIXADIR2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li s6, 0
		li a6, 0
		li t1, 1646 # Avalia a posicao futura da caixa / +16
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXADIR3
		j RECEBE_TECLA

		CAIXADIR3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li s6, 0
			li a6, 0
			li t1, 3566 # Avalia a posicao futura da caixa / +16
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXADIR4
			j RECEBE_TECLA
				
			CAIXADIR4:
				#posicao atual da caixa = ( s10 + 8 ) + 16
				li s6, 0
				li a6, 0
				li t1, 24
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXADIR5:
					#Imprime a caixa +8 da posicao atual
					li s6, 0
					li a6, 0
					li t1, 32
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGADIR
CORACAODIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 3550
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAODIR2
	j RECEBE_TECLA

	CORACAODIR2:
		#Imprime meio chao no lugar do coracao:
		li s6, 0
		li a6, 0
		li t1, 24
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAODIR3)

		CORACAODIR3:
			jal s5, CORACAO_AUMENTA
			j APAGADIR

BAUDIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 3550
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUDIR2
	j RECEBE_TECLA

		BAUDIR2:
			jal s5, BAU_PORTA
			#Imprime bau vazio no lugar do bau:
			li s6, 0
			li a6, 0
			li t1, 24
			add a6, s10, t1
			li t2, 0x100000
			add s6, a6, t2
			ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)


COLISAOESQ:
	li t1, 963 # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 # cor da caixa
	li t3, 78 # cor do bau
	li t4, 7 #cor do coracao
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOESQ2 # se o pixel for da mesma cor do chao va pra COLISAOESQ2
	beq s6, t2, CAIXAESQ # se o pixel for da mesma cor da caixa va pra CAIXAESQ
	beq s6, t3, BAUESQ # se o pixel for da mesma cor da caixa va pra BAUESQ
	beq s6, t4, CORACAOESQ # se o pixel for da mesma cor da caixa va pra CORACAOESQ
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo


COLISAOESQ2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 2883
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_ESQ
	j RECEBE_TECLA

CAIXAESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 2883
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXAESQ2
	j RECEBE_TECLA

	CAIXAESQ2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li s6, 0
		li a6, 0
		li t1, 947 # Avalia a posicao futura da caixa / -16
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXAESQ3
		j RECEBE_TECLA

		CAIXAESQ3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li s6, 0
			li a6, 0
			li t1, 2867 # Avalia a posicao futura da caixa / -16
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXAESQ4
			j RECEBE_TECLA 

			CAIXAESQ4:
				#Imprime chao no lugar da caixa
				#posicao atual da caixa = ( s10 + 8 ) - 16
				li s6, 0
				li a6, 0
				li t1, -8
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXAESQ5:
					#Imprime a caixa -8 da posicao atual
					li s6, 0
					li a6, 0
					li t1, -16
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGAESQ
CORACAOESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 2883 
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAOESQ2
	j RECEBE_TECLA
	
#===============TRAMPOLIM 1 ATAQUES===========================#
ATACADIR2_T:
j ATACADIR2_T2

ATACACIMA2_T:
j ATACACIMA2_T2

ATACAESQ2_T:
j ATACAESQ2_T2

ATACABAIXO2_T:
j ATACABAIXO2_T2
#=============================================================# 	

	CORACAOESQ2:
		#Imprime meio chao no lugar do coracao:
		li s6, 0
		li a6, 0
		li t1, -8
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOESQ3)

		CORACAOESQ3:		
			jal s5, CORACAO_AUMENTA
			j APAGAESQ

BAUESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 2883
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUESQ2
	j RECEBE_TECLA

	BAUESQ2:
		jal s5, BAU_PORTA
		#Imprime bau vazio no lugar do bau:
		li s6, 0
		li a6, 0
		li t1, -8
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)


COLISAOCIMA:
	li t1, -1909  # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 #cor da caixa
	li t3, 78 #cor do bau
	li t4, 7 #cor do coracao
	li t5, 11 #cor da porta
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOCIMA2 # se o pixel for da mesma cor do chao va pra COLISAOCIMA2
	beq s6, t2, CAIXACIMA # se o pixel for da mesma cor da caixa va pra CAIXACIMA
	beq s6, t3, BAUCIMA # se o pixel for da mesma cor da caixa va pra BAUCIMA
	beq s6, t4, CORACAOCIMA # se o pixel for da mesma cor da caixa va pra CORACAOCIMA
	beq s6, t5, PORTA # se o pixel for da mesma cor da caixa va pra PORTA
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo

COLISAOCIMA2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, -1902
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_CIMA
	j RECEBE_TECLA

PORTA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, -1902
	add a6, s10, t1
	li t0, 11
	lb s6 0(a6)
	beq s6, t0, IMPRIME_FASE2
	j RECEBE_TECLA

CAIXACIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, -1902
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXACIMA2
	j RECEBE_TECLA

	CAIXACIMA2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li s6, 0
		li a6, 0
		li t1, -7029 #avalia a posicao futura da caixa / -5120
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXACIMA3
		j RECEBE_TECLA

		CAIXACIMA3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li s6, 0
			li a6, 0
			li t1, -7022 #avalia a posicao futura da caixa / -5120
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXACIMA4
			j RECEBE_TECLA

			CAIXACIMA4:
				#Imprime chao no lugar da caixa
				#posicao atual da caixa = ( s10 + 8 ) - 5120
				li s6, 0
				li a6, 0
				li t1, -5112
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXACIMA5:
					#Imprime a caixa -2560 da posicao atual
					li s6, 0
					li a6, 0
					li t1, -7672
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGACIMA

CORACAOCIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, -1902
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAOCIMA2
	j RECEBE_TECLA	

	CORACAOCIMA2:
		#Imprime meio chao no lugar do coracao:
		li s6, 0
		li a6, 0
		li t1, -5112
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOCIMA3)

		CORACAOCIMA3:
			jal s5, CORACAO_AUMENTA
			j APAGACIMA

BAUCIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, -1902
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUCIMA2
	j RECEBE_TECLA

	BAUCIMA2:
		jal s5, BAU_PORTA
		#Imprime bau vazio no lugar do bau:
		li s6, 0
		li a6, 0
		li t1, -5112
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)



COLISAOBAIXO:
	li t1, 5771 # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 #cor da caixa
	li t3, 78 #cor do bau
	li t4, 7 #cor do coracao
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOBAIXO2 # se o pixel for da mesma cor do chao va pra COLISAOBAIXO2
	beq s6, t2, CAIXABAIXO # se o pixel for da mesma cor da caixa va pra CAIXABAIXO
	beq s6, t3, BAUBAIXO # se o pixel for da mesma cor da caixa va pra BAUBAIXO
	beq s6, t4, CORACAOBAIXO # se o pixel for da mesma cor da caixa va pra CORACAOBAIXO
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo

COLISAOBAIXO2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 5778
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_BAIXO
	j RECEBE_TECLA	

CAIXABAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 5778
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXABAIXO2
	j RECEBE_TECLA

	CAIXABAIXO2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li s6, 0
		li a6, 0
		li t1, 10891 #avalia a posicao futura da caixa / +5120
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXABAIXO3
		j RECEBE_TECLA

		CAIXABAIXO3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li s6, 0
			li a6, 0
			li t1, 10898 #avalia a posicao futura da caixa / +5120
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXABAIXO4
			j RECEBE_TECLA

			CAIXABAIXO4:
				#Imprime a chao na posicao atual da caixa
				#posicao atual da caixa = ( s10 + 8 ) + 5120
				li s6, 0
				li a6, 0
				li t1, 5128
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				COLISAOBAIXO5:
				#Imprime a caixa +2560 da posicao atual
				li s6, 0
				li a6, 0
				li t1, 7688
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA2_T
				j APAGABAIXO

CORACAOBAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 5778
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAOBAIXO2
	j RECEBE_TECLA

	CORACAOBAIXO2:
		##jal s5, CORACAO
		li s6, 0
		li a6, 0
		li t1, 5128
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOBAIXO3)

		CORACAOBAIXO3:
			jal s5, CORACAO_AUMENTA
			j APAGABAIXO

BAUBAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li s6, 0
	li a6, 0
	li t1, 5778
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUBAIXO2
	j RECEBE_TECLA

	BAUBAIXO2:
		jal s5, BAU_PORTA
		#Imprime bau vazio no lugar do bau:
		li s6, 0
		li a6, 0
		li t1, 5128
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)
		
##############################################################################################################################
VERIFICADIRECAO:
li s1, 1			#Se s1 = 1, indica que o personagem esta atacando
la t0, DIRECAO_LAMAR
lw t0, 0(t0)
li t1, 1
li t2, 2
li t3, 3
li t4, 4
beq t0, t1, COLISAODIR		#Se o lamar estiver virado pra direita
beq t0, t2, COLISAOCIMA		#Se o lamar estiver virado pra cima
beq t0, t3, COLISAOESQ		#Se o lamar estiver virado pra esquerda
beq t0, t4, COLISAOBAIXO	#Se o lamar estiver virado pra baixo

VERIFICA_ACAO_DIR:
li t0, 1
beq s1, zero, APAGADIR		#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar
beq s1, t0, ATACADIR		#Se o lamar estiver atacando, rotina de ataque

VERIFICA_ACAO_CIMA:
li t0, 1
beq s1, zero, APAGACIMA		#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar
beq s1, t0, ATACACIMA		#Se o lamar estiver atacando, rotina de ataque

VERIFICA_ACAO_ESQ:
li t0, 1
beq s1, zero, APAGAESQ		#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar
beq s1, t0, ATACAESQ		#Se o lamar estiver atacando, rotina de ataque

VERIFICA_ACAO_BAIXO:
li t0, 1
beq s1, zero, APAGABAIXO	#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar
beq s1, t0, ATACABAIXO		#Se o lamar estiver atacando, rotina de ataque

#-----------------------------------------------------------#
ATACADIR:
la t0, POSICAO_LAMAR
lw t1, 0(t0)			# Recebe as posicoes do lamar nos dois frames para imprimir o raio 16px a frente
lw t2, 4(t0)
li t3, 24			# Quantos pixels a frente do lamar ele imprime o ataque
add s6, t1, t3
add s8, t2, t3
li s1, 0
ImpressaopequenaC(ataquelamardir, s6, s8, 0, 0x130, ATACADIR2)

ATACADIR2:
j ATACADIR2_T

#----------------------------------------------------------#

ATACACIMA:
la t0, POSICAO_LAMAR
lw t1, 0(t0)			# Recebe as posicoes do lamar nos dois frames para imprimir o raio 16px a frente
lw t2, 4(t0)
li t3, -0x13F8			# Quantos pixels a frente do lamar ele imprime o ataque
add s6, t1, t3
add s8, t2, t3
li s1, 0
ImpressaopequenaC(ataquelamar, s6, s8, 0, 0x130, ATACACIMA2)

ATACACIMA2:
j ATACACIMA2_T


#----------------------------------------------------------#

ATACAESQ:
la t0, POSICAO_LAMAR
lw t1, 0(t0)			# Recebe as posicoes do lamar nos dois frames para imprimir o raio 16px a frente
lw t2, 4(t0)
li t3, -8			# Quantos pixels a frente do lamar ele imprime o ataque
add s6, t1, t3
add s8, t2, t3
li s1, 0
ImpressaopequenaC(ataquelamaresq, s6, s8, 0, 0x130, ATACAESQ2)

ATACAESQ2:
j ATACAESQ2_T
#----------------------------------------------------------#

ATACABAIXO:
la t0, POSICAO_LAMAR
lw t1, 0(t0)			# Recebe as posicoes do lamar nos dois frames para imprimir o raio 16px a frente
lw t2, 4(t0)
li t3, 0x1408			# Quantos pixels a frente do lamar ele imprime o ataque
add s6, t1, t3
add s8, t2, t3
li s1, 0
ImpressaopequenaC(ataquelamar, s6, s8, 100, 0x130, ATACABAIXO2)

ATACABAIXO2:
j ATACABAIXO2_T



APAGADIR:

Apagachao(8)

ANDA_DIR:
li t1, 1
sh t1, DIRECAO_LAMAR, t0
Anda(lamardir_walk)	#Sprite andando para anima??¨¬??o
Trocaframe(65)		#Delay m??nimo para que a anima??¨¬??o possa ser vista
Apagachao(0)		#Apaga a sprite para n??o ocorrer sobreposi??¨¬??o
Anda(lamardir)		#Sprite parado novamente
Trocaframe(65)		#Delay m??nimo para que a anima??¨¬??o possa ser vista
j INC	


APAGAESQ:
Apagachao(-8)


ANDA_ESQ:
li t1, 3
sh t1, DIRECAO_LAMAR, t0
Anda(lamaresq_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamaresq)
Trocaframe(65)
j INC


APAGACIMA:
Apagachao(-0xA00)

ANDA_CIMA:
li t1, 2
sh t1, DIRECAO_LAMAR, t0
Anda(lamarcima_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamarcima)
Trocaframe(65)
j INC


APAGABAIXO:
Apagachao(0xA00)

ANDA_BAIXO:
li t1, 4
sh t1, DIRECAO_LAMAR, t0
Anda(lamarbaixo_walk)
Trocaframe(65)
Apagachao(0)
Anda(lamarbaixo)
Trocaframe(65)
j INC

RETORNA:ret	
#=========================================================================																							
																												
																																										
.data

#MAPAS
.include "./Imagens/MAPA1.data"
.include "./Imagens/MAPA2.data"
#Transi?ao
.include "./Imagens/Transicao1.data"
.include "./Imagens/Transicao2.data"
.include "./Imagens/Transicao3.data"
.include "./Imagens/Transicao4.data"
.include "./Imagens/Transicao5.data"

# personagem para teste
.include "./Imagens/lamaresq.data"
.include "./Imagens/lamaresq_walk.data"
.include "./Imagens/lamardir.data"
.include "./Imagens/lamardir_walk.data"
.include "./Imagens/lamarbaixo.data"
.include "./Imagens/lamarbaixo_walk.data"
.include "./Imagens/lamarcima.data"
.include "./Imagens/lamarcima_walk.data"
.include "./Imagens/ataquelamar.data"
.include "./Imagens/ataquelamardir.data"
.include "./Imagens/ataquelamaresq.data"


#Historia inicial
.include "./Imagens/basehistoria.data"
.include "./Imagens/lamarhistinicial.data"
.include "./Imagens/lamarcostashist.data"
.include "./Imagens/ULALA.data"
.include "./Imagens/ULALAPISCA.data"
.include "./Imagens/texto1.data"
.include "./Imagens/texto2.data"
		
#MENU			

.data
# imagem inicial do menu
.include "./Imagens/menu1.data"

# imagem final do menu
.include "./Imagens/menu2.data"

# botoes de start e password
.include "./Imagens/menu3.data"

# imagem da seta que aparece ao lado dos botoes
.include "./Imagens/seta.data"

#imagem a ser MUDAR para contar contexto e historia do jogo
.include "./Imagens/Historia.data"

#Imagens incluidas na intrface de password
.include "./Imagens/password1.data"
.include "./Imagens/password2.data"
.include "./Imagens/Barra_selecao.data"

.include "./Imagens/meiochao.data"
.include "./Imagens/bauvazio.data"		

#itens mapa																																																																																																																														
.include "./Imagens/caixa.data"
.include "./Imagens/coracao.data"
.include "./Imagens/bauaberto.data"																																																																																																																																																																		
.include "./Imagens/portaaberta.data"
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																			
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									
.text	
																									
.include "SYSTEMv21.s"
