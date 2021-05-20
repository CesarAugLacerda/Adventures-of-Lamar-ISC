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
		
CAIXAELE_T3:
	ImpressaopequenaC(meiochao, a6, s6, 0, 304, CAIXAELETEMP_T)
	CAIXAELETEMP_T:
		jr s5
	
CAIXAELE2_T3:
	ImpressaopequenaC(caixaeletrizada, a6, s6, 0, 304, CAIXAELE2TEMP_T)
	CAIXAELE2TEMP_T:
		jr s5
			
ATACADIR2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, ATACADIR2_T3_PULA)
ATACADIR2_T3_PULA:jal s5,CORACAO_DIMINUI
j RECEBE_TECLA_T
				
ATACACIMA2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, ATACACIMA2_T3_PULA)
ATACACIMA2_T3_PULA:jal s5,CORACAO_DIMINUI
j RECEBE_TECLA_T

ATACAESQ2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, ATACAESQ2_T3_PULA)
ATACAESQ2_T3_PULA:jal s5,CORACAO_DIMINUI
j RECEBE_TECLA_T

ATACABAIXO2_T3:
ImpressaopequenaC(meiochao,s6 , s8, 250, 0x130, ATACABAIXO2_T3_PULA)
ATACABAIXO2_T3_PULA:jal s5,CORACAO_DIMINUI
j RECEBE_TECLA_T

BAU_ABERTA_MAPA1_T4:Impressaopequena(bauaberto,0xFF00DC50,0xFF10DC50, 0, 0x130, RETORNA_JR_T4)
IMPRIME_PORTA1_T4:Impressaopequena(portaaberta,0xFF0014A0,0xFF1014A0, 0, 0x130, RETORNA_JR_T4)

BAU_ABERTA_MAPA2_T4:Impressaopequena(bauaberto,0xFF008C30,0xFF108C30, 0, 0x130, RETORNA_JR_T4)
IMPRIME_PORTA2_T4:Impressaopequena(portaaberta,0xFF0014D0 ,0xFF1014D0 , 0, 0x130, RETORNA_JR_T4)

BAU_ABERTA_MAPA3_T4:Impressaopequena(bauaberto,0xFF00A0E0,0xFF10A0E0, 0, 0x130, RETORNA_JR_T4)
IMPRIME_PORTA3_T4:Impressaopequena(portaaberta,0xFF001490 ,0xFF101490 , 0, 0x130, RETORNA_JR_T4)

MAPA4_T4: Impressao(MAPA4, 0xFF000000, 0xFF100000, 0, VIDA_T)
BAU_ABERTA_MAPA4_T4:Impressaopequena(bauaberto,0xFF00A0B0,0xFF10A0B0, 0, 0x130, RETORNA_JR_T4)
IMPRIME_PORTA4_T4:Impressaopequena(portaaberta,0xFF0014D0 ,0xFF1014D0 , 0, 0x130, RETORNA_JR_T4)

TRANSICAO5_T4: ImpressaoF(Transicao5, 0xFF100000, 0, RETORNA_JR_T4)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
MAPA5_T4: Impressao(MAPA5, 0xFF000000, 0xFF100000, 0, VIDA_T)
BAU_ABERTA_MAPA5_T4:Impressaopequena(bauaberto,0xFF008CE0,0xFF108CE0, 0, 0x130, RETORNA_JR_T4)	
IMPRIME_PORTA5_T4:Impressaopequena(portaaberta,0xFF001440 ,0xFF101440 , 0, 0x130, RETORNA_JR_T4)	

RETORNA_JR_T4: jr s5

VITORIA_T4: 
ImpressaoF(transicaovitoria, 0xFF100000, 0, MUSICA3_T2)

#====================MENU=================================
INICIO_MENU:
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
	
	
   	beq t0,zero,RECEBE_TECLA_MENU   	   	# Se n?o h¡§? tecla pressionada ent?o vai para Retorno(fun?a {RETORNA: ret} deve estar no final da pagina do arquivo)
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
	Frame(0)	
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
		
CAIXAELE_T2:
	j CAIXAELE_T3
	
CAIXAELE2_T2:
	j CAIXAELE2_T3	
			
MUSICA1_T2:
	play_musica(49, 112, LAMAR_THEME)
	jr s5


MUSICA2_T2:
	#play_musica(49, 112, LAMAR_THEME)
	jr s5


MUSICA3_T2:
	 Frame(1)	
	 play_musica_notloop(9, 112, FANFARE)
	 Delay(4000)
	 jr s5
	  
RECEBE_TECLA_T:
j RECEBE_TECLA_T2

BAU_ABERTA_MAPA1_T3: j BAU_ABERTA_MAPA1_T4	
IMPRIME_PORTA1_T3: j IMPRIME_PORTA1_T4

BAU_ABERTA_MAPA2_T3: j BAU_ABERTA_MAPA2_T4
IMPRIME_PORTA2_T3: j IMPRIME_PORTA2_T4

BAU_ABERTA_MAPA3_T3: j BAU_ABERTA_MAPA3_T4
IMPRIME_PORTA3_T3: j IMPRIME_PORTA3_T4

MAPA4_T3: j MAPA4_T4
BAU_ABERTA_MAPA4_T3: j BAU_ABERTA_MAPA4_T4
IMPRIME_PORTA4_T3: j IMPRIME_PORTA4_T4

TRANSICAO5_T3:j TRANSICAO5_T4
MAPA5_T3: j MAPA5_T4

BAU_ABERTA_MAPA5_T3 : j BAU_ABERTA_MAPA5_T4	
IMPRIME_PORTA5_T3: j IMPRIME_PORTA5_T4	

VIDA_T: j VIDA_T2
VITORIA_T3: j VITORIA_T4
#================================================================

#+++++++++++++++++++++++++MENU PASSWORD++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
PASSWORD:
	ImpressaoF(password2, 0xFF100000, 0, PASSWORD2) 	#imagem sem asterisco
	PASSWORD2:
	Frame(1)				#Troca para frame 1
	ImpressaoF(password1, 0xFF100000, 800, BARRA_SELECAO) #imagem com asterisco e vai para o teclado
	BARRA_SELECAO:
	Impressaopequena(Barra_selecao, 0xFF00A53C, 0xFF10A53C, 0, 0x123, TECLADO_PASSWORD)#imprime a barra na sele??¨¬ao da primeira letra

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
	senha(100, 117, 100, 117, QUARTA_FASE_SENHA, IMPRESSAO_MAPA3_T)	#se senha correta imprime fase 3
	#Quarta fase(senha: pokd)
QUARTA_FASE_SENHA:				
	senha(112, 111, 107, 100, QUINTA_FASE_SENHA, IMPRESSAO_MAPA4_T)	#se senha correta imprime fase 4
	#Quinta fase(senha: dend)
QUINTA_FASE_SENHA:
	senha(100, 101, 110, 100, SENHA_INCORRETA, IMPRESSAO_MAPA5_T)	#se senha correta imprime fase 5
	
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
	#ImpressaoF(menu3,0xFF000000, 0, PROXIMO)
	PROXIMO:
	#Trocaframe(0)
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
   	beq t0,zero,RETORNA2  	   	# Se n?o h¡§? tecla pressionada entao faz o LOOP
   	lw t2,4(t1)  			# le o valor da tecla
   	sw t2, 12(t1)			#escreve a tecla no display
   	#AVISO
   	#por algum motivo sempre que for reiniciar o BITMAP DISPLAY,caso queira que as teclas sejam digitadas no
   	#display do KDMMIO ¡§? necessario desconectar e conectar ele
   	
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
	#ImpressaoF(password2, 0xFF000000, 0, VALIDADOR) 	#imagem sem asterisco
	VALIDADOR:
	#Frame(0)
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
PONTOS:		.word 0 	#pontuacao por fases, quantidade de pontos para abrir o bau

#=============================================SOUNDTRACK==============================================================================
#Dtermination - Undertale(tamanho:28)
DEATH: 64,261,62,261,60,261,59,261,60,261,55,261,57,522,53,522,60,261,62,261,64,522,65,522,71,522,67,1565,64,261,62,261,60,261,59,261,60,261,55,261,57,522,53,522,48,261,50,261,52,522,50,522,47,522,48,1565

#musica do jogo(tamanho: 49)
LAMAR_THEME: 67,450,71,450,72,450,74,450,67,450,71,450,72,450,74,450,67,450,71,450,74,450,77,450,76,450,74,450,72,350,74,350,72,350,71,450,67,450,67,450,72,350,74,350,72,350,71,450,67,450,67,450,62,450,65,550,66,550,67,450,67,450,71,450,72,450,74,450,76,450,77,450,76,450,74,450,77,350,76,350,77,350,79,350,77,350,77,350,82,350,79,450,74,550,77,550,78,550

#Tela de vitoria FFVII(tamanho: 9) 
FANFARE: 72,140,72,140,72,140,72,420,68,420,73,420,72,280,73,140,72,1262

#=====================================================================================================================================

.text

#===============Trampolin===========
PASSWORD_T:
	reset()
	la t0,VIDAS_LAMAR	# endere??¨¬o da VIDAS_LAMAR
	li t1, 5		#determina como 5 a vida do lamar
	sw t1,0(t0)		# salva a vida do lamar
 	j PASSWORD
 
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

IMPRESSAO_MAPA3_T: j IMPRESSAO_MAPA3
IMPRESSAO_MAPA4_T: j IMPRESSAO_MAPA4
IMPRESSAO_MAPA5_T: j IMPRESSAO_MAPA5

BAU_ABERTA_MAPA1_T2: j BAU_ABERTA_MAPA1_T3	
IMPRIME_PORTA1_T2: j IMPRIME_PORTA1_T3

BAU_ABERTA_MAPA2_T2: j BAU_ABERTA_MAPA2_T3
IMPRIME_PORTA2_T2: j IMPRIME_PORTA2_T3
						
BAU_ABERTA_MAPA3_T2: j BAU_ABERTA_MAPA3_T3
IMPRIME_PORTA3_T2: j IMPRIME_PORTA3_T3


BAU_ABERTA_MAPA4_T2: j BAU_ABERTA_MAPA4_T3
IMPRIME_PORTA4_T2: j IMPRIME_PORTA4_T3
MAPA4_T2: j MAPA4_T3

TRANSICAO5_T2:j TRANSICAO5_T3
BAU_ABERTA_MAPA5_T2 : j BAU_ABERTA_MAPA5_T3	
IMPRIME_PORTA5_T2: j IMPRIME_PORTA5_T3	
MAPA5_T2: j MAPA5_T3 

CAIXAELE_T:	j CAIXAELE_T2
CAIXAELE2_T:	j CAIXAELE2_T2
CAIXA_T:		j CAIXA_T2
CAIXA2_T:		j CAIXA2_T2

VIDA_T2: j VIDA
VITORIA_T2: j VITORIA_T3
#=================================
MENU_DEATH:
Impressao(Transicaogameover,  0xFF000000,  0xFF100000, 0, MUSICA_MORTE)
MUSICA_MORTE:  
Delay(5000)
jal s5,MUSICA2_T2

MENU:
Frame(1) #sempre vai estar no frame 0

la t0,VIDAS_LAMAR	# endere??¨¬o da VIDAS_LAMAR
li t1, 5		#determina como 5 a vida do lamar
sw t1,0(t0)		# salva a vida do lamar

j INICIO_MENU

#=================================VIDAS=============================
VIDA:

la t0,VIDAS_LAMAR	# endere??¨¬o da VIDAS_LAMAR
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
la t0,VIDAS_LAMAR	# endere??¨¬o da VIDAS_LAMAR
lw t1,0(t0)		# t1 = vida atual lamar
li t0, 1
sub t1, t1, t0		  #sempre que lamar morrer diminui -1 de vida
la t0,VIDAS_LAMAR	  # endere??¨¬o do VIDAS_LAMAR
sw t1,0(t0)		  # salva a vida do lamar diminuida
blt t1, zero, MENU_DEATH	#se lamar chegar a zero vida, volta para o menu

#-------------verificador de fase---------

#s2 determina a fase que lamar esta
li t0, 1
beq s2, t0, IMPRESSAO_MAPA1	#vai para a primeira fase
li t0, 2
beq s2, t0, IMPRESSAO_MAPA2	#vai para a segunda fase
li t0, 3
beq s2, t0, IMPRESSAO_MAPA3
li t0, 4
beq s2, t0,IMPRESSAO_MAPA4
li t0, 5
beq s2, t0,IMPRESSAO_MAPA5
#para a impressao do personagem
VERIFICADOR_DE_FASE:
#s2 determina a fase que lamar esta
li t0, 1
beq s2, t0, IMPRIME_PERSONAGEM1	 #vai para a primeira fase
li t0, 2
beq s2, t0, IMPRIME_PERSONAGEM2 #vai para a segunda fase
li t0,3
beq s2, t0, IMPRIME_PERSONAGEM3
li t0,4
beq s2, t0, IMPRIME_PERSONAGEM4
li t0,5
beq s2, t0, IMPRIME_PERSONAGEM5
#=================================CORACAO/PODER=============================
CORACAO:
la t0,POWER_LAMAR	# endere??¨¬o da POWER_LAMAR
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
la t0,POWER_LAMAR	# endere??¨¬o da POWER_LAMAR
lw t1,0(t0)		# t1 = power atual lamar

addi t1, t1, 1		#sempre que lamar pegar cora??¨¬ao,aumenta em 1 seu power
la t0,POWER_LAMAR	# endere??¨¬o do VIDAS_LAMAR
sw t1,0(t0)		# salva a vida do lamar diminuida

la t0,PONTOS		# endere??¨¬o da POWER_LAMAR
lw t1,0(t0)		# t1 = power atual lamar

addi t1, t1, 1		#sempre que lamar pegar cora??¨¬ao,aumenta em 1 seu power
la t0, PONTOS		#endereco do PONTOS
sw t1,0(t0)		#salva o PONTOS do lamar aumentada
j   CORACAO

CORACAO_DIMINUI:
la t0,POWER_LAMAR	# endere?¡ìo da POWER_LAMAR
lw t1,0(t0)		# t1 = power atual lamar

addi t1, t1, -1		#sempre que lamar pegar cora?¡ìao,aumenta em 1 seu power
la t0,POWER_LAMAR	# endere?¡ìo do VIDAS_LAMAR
sw t1,0(t0)		# salva a vida do lamar diminuida
j   CORACAO

#verifica se lamar pegou todos os powers para abrir a caixa
VERIFICADOR_POWER:
	la t0, PONTOS
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
	li t0, 3
	beq s2, t0, BAU_ABERTA_MAPA3
	li t0, 4
	beq s2, t0, BAU_ABERTA_MAPA4
	li t0, 5	
	beq s2, t0, BAU_ABERTA_MAPA5
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
	li t0, 3
	beq s2, t0, IMPRIME_PORTA3
	li t0, 4
	beq s2, t0, IMPRIME_PORTA4
 	li t0, 5
 	beq s2, t0, IMPRIME_PORTA5
#===============================MUSICAS=====================================
MUSICA1:	j MUSICA1_T
MUSICA2:	j MUSICA2_T
MUSICA3:	j MUSICA3_T

		
MUSICA_RESET:
	reset()	#reseta a musica
	jr s5	

BAU_ABERTA_MAPA1_T : j BAU_ABERTA_MAPA1_T2
IMPRIME_PORTA1_T: j IMPRIME_PORTA1_T2
		
BAU_ABERTA_MAPA2_T: j BAU_ABERTA_MAPA2_T2
IMPRIME_PORTA2_T: j IMPRIME_PORTA2_T2		
			
NEXT3_T:Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT3)
jr s5	
BAU_ABERTA_MAPA3_T: j BAU_ABERTA_MAPA3_T2	
IMPRIME_PORTA3_T:   j IMPRIME_PORTA3_T2

MAPA4_T: j MAPA4_T2
NEXT4_T:
Imprimepersonagem(0xFF00A030, 0xFF10A030, NEXT4)
jr s5		
BAU_ABERTA_MAPA4_T : j BAU_ABERTA_MAPA4_T2	
IMPRIME_PORTA4_T: j IMPRIME_PORTA4_T2	

	
TRANSICAO5_T: j TRANSICAO5_T2
MAPA5_T: j MAPA5_T2
NEXT5_T: 
Imprimepersonagem(0xFF00C820, 0xFF10C820, NEXT5)
jr s5	
BAU_ABERTA_MAPA5_T : j BAU_ABERTA_MAPA5_T2	
IMPRIME_PORTA5_T: j IMPRIME_PORTA5_T2	

VITORIA_T: j VITORIA_T2
#=====================================================================================
###########################################
#                                         #
#             	 FASES                    #
#                                         #
###########################################
EQUIVALER_VALORES:
#==========Equivalendo valores de power=======
la t0, ABRIR_BAU	# endere???¡ìo do POWER_LAMAR	
sw t1, 0(t0)		# salva o power do lamar minimo para abrir bau

la t0,POWER_LAMAR	# endere???¡ìo do POWER_LAMAR
li t1, 0		#lamar come?¡ìa com 0 de power sempre
sw t1,0(t0)		# salva o power do lamar 	

la t0,PONTOS	# endere???¡ìo do POWER_LAMAR
li t1, 0		#lamar come?¡ìa com 0 de power sempre
sw t1,0(t0)		# salva o power do lamar 
jr s5
#=================================FASES=============================
#FASE1
MAIN:
IMPRIME_FASE1:	
	ImpressaoF(Transicao1, 0xFF100000, 0, TROCA_FRAMEI)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEI:
		jal s5, MUSICA3
		
		IMPRESSAO_MAPA1:
		li s2, 1	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA1, 0xFF000000, 0xFF100000, 0, VIDA)
		

IMPRIME_PERSONAGEM1:
li t1, 2		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
jal s5, EQUIVALER_VALORES
jal s5, CORACAO	
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT1)

NEXT1:

jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
j ANDARLAMAR

BAU_ABERTA_MAPA1:
j BAU_ABERTA_MAPA1_T 

IMPRIME_PORTA1:
j IMPRIME_PORTA1_T


#=========================================================================================================================================
#FASE2
IMPRIME_FASE2:	
	jal s5, MUSICA_RESET		
	ImpressaoF(Transicao2, 0xFF100000, 0, TROCA_FRAMEII)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEII:
		jal s5, MUSICA3
		
		IMPRESSAO_MAPA2:
		li s2, 2	#determina que lamar esta na primeira fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA2, 0xFF000000, 0xFF100000, 0, VIDA)
		
IMPRIME_PERSONAGEM2:
li t1, 3		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
jal s5, EQUIVALER_VALORES
jal s5, CORACAO	
Imprimepersonagem(0xFF008C20, 0xFF108C20, NEXT2)

NEXT2:
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
j ANDARLAMAR

BAU_ABERTA_MAPA2:
j BAU_ABERTA_MAPA2_T 

IMPRIME_PORTA2:
j IMPRIME_PORTA2_T

#======================================================================================================
#FASE3
IMPRIME_FASE3:	
	jal s5, MUSICA_RESET		
	ImpressaoF(Transicao3, 0xFF100000, 0, TROCA_FRAMEIII)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEIII:
		jal s5, MUSICA3

		IMPRESSAO_MAPA3:
		li s2, 3	#determina que lamar esta na x fase, para quando ele morrer dar respawn na fase certa	
		Impressao(MAPA3, 0xFF000000, 0xFF100000, 0, VIDA)

IMPRIME_PERSONAGEM3:
li t1, 2		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
jal s5, EQUIVALER_VALORES
jal s5, CORACAO	
jal s5, NEXT3_T
NEXT3:
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
j ANDARLAMAR

BAU_ABERTA_MAPA3:
j BAU_ABERTA_MAPA3_T 

IMPRIME_PORTA3:
j IMPRIME_PORTA3_T

#======================================================================================================
#FASE4
IMPRIME_FASE4:	
	jal s5, MUSICA_RESET		
	ImpressaoF(Transicao4, 0xFF100000, 0, TROCA_FRAMEIV)	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEIV:
		jal s5, MUSICA3

		IMPRESSAO_MAPA4:
		li s2, 4	#determina que lamar esta na x fase, para quando ele morrer dar respawn na fase certa	
		j MAPA4_T

IMPRIME_PERSONAGEM4:
li t1, 3		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
jal s5, EQUIVALER_VALORES
jal s5, CORACAO	
jal s5, NEXT4_T
NEXT4:
jal s5, MUSICA_RESET	#reseta os conatdores da musica, ela toca desde o inicio
j ANDARLAMAR

BAU_ABERTA_MAPA4:
j BAU_ABERTA_MAPA4_T 

IMPRIME_PORTA4:
j IMPRIME_PORTA4_T
	
#======================================================================================================
#FASE5
IMPRIME_FASE5:	
	jal s5, MUSICA_RESET		
	jal s5, TRANSICAO5_T	#tela de transi???????¡ìao com informa???????¡ìoes da fase e senha
	TROCA_FRAMEV:
		jal s5, MUSICA3
		
		IMPRESSAO_MAPA5:
		li s2, 5	#determina que lamar esta na x fase, para quando ele morrer dar respawn na fase certa	
		j MAPA5_T
		
IMPRIME_PERSONAGEM5:
li t1, 5		# <----------------------------------------------------------------------------DETERMINAR QUANTIDADE DE POWERS DA FASE
jal s5, EQUIVALER_VALORES
jal s5, CORACAO	
jal s5, NEXT5_T
j ANDARLAMAR

BAU_ABERTA_MAPA5:
j BAU_ABERTA_MAPA5_T 

IMPRIME_PORTA5:
j IMPRIME_PORTA5_T

#======================================================================================================
#Vitoria de lamar
VITORIA: 
jal s5, VITORIA_T
call MENU
###########################################
#                                         #
#             	ANDAR LAMAR               #
#                                         #
###########################################
BAU_PORTA_T2: j BAU_PORTA
CORACAO_AUMENTA_T2: j CORACAO_AUMENTA



#==============================O PASSINHO DO LAMAR=========================	
ANDARLAMAR:
	li s0, 0 		# reseta o s0

INC:	addi s0, s0, 1		# Incrementa o contador
	#Trocaframe(40)		# Alterna entre os frames 0 e 1 com 40ms de delay.
	jal RECEBE_TECLA
	j INC			# Retorna ao contador

RECEBE_TECLA: 
	jal s5, MUSICA1
	li t1,0xFF200000		# carrega o KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero, RECEBE_TECLA  	   	# Se n????o h???? tecla pressionada ent????o vai para Retorno(fun????¡§?a {RETORNA: ret} deve estar no final da pagina do arquivo)
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
	li t5, 16 # cor do inimigo
	li t6, 1 #cor do bloco da morte
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAODIR2 # se o pixel for da mesma cor do chao va pra COLISAODIR2
	beq s6, t2, CAIXADIR # se o pixel for da mesma cor da caixa va pra CAIXADIR
	beq s6, t3, BAUDIR # se o pixel for da mesma cor da caixa va pra BAUDIR
	beq s6, t4, CORACAODIR # se o pixel for da mesma cor da caixa va pra CORACAODIR
	beq s6, t5, RAIODIR # se o pixel for da mesma cor do inimigo va pra RAIODIR
	beq s6, t6, BLOCOMORTEDIR
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo


COLISAODIR2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 3550
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_DIR
	j RECEBE_TECLA

BLOCOMORTEDIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 3550 #Verifica se eh o chao da morte na esq
	add a6, s10, t1
	li t0, 1
	lb s6 0(a6)
	beq s6, t0, BLOCOMORTEDIR2
	j RECEBE_TECLA
	
	BLOCOMORTEDIR2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, -3490 #Verifica se tem uma caixa em cima
		li a6, 0
		add a6, s10, t1
		li t0, 31
		li s6, 0
		lb s6 0(a6)
		beq s6, t0, BLOCOMORTEDIR3
		j VIDA_DIMINUI
		
		BLOCOMORTEDIR3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, -1570 #Verifica se tem uma caixa em cima
			li a6, 0
			add a6, s10, t1
			li t0, 31
			li s6, 0
			lb s6 0(a6)
			beq s6, t0, APAGADIR_T
			j VIDA_DIMINUI

RAIODIR:
	beq s1, t6, ATACADIR #Se apertar f, va pra ATACADIR
	j RECEBE_TECLA #Caso o contrario, recebe tecla

CAIXADIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 3550
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXADIR2
	j RECEBE_TECLA

	CAIXADIR2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, 1646 # Avalia a posicao futura da caixa / +16
		add a6, s10, t1
		li t0, 10
		li t2, 1
		lb s6 0(a6)
		beq s6, t0, CAIXADIR3
		beq s6, t2, CAIXADIR3
		j RECEBE_TECLA
		
		CAIXADIR3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, 3566 # Avalia a posicao futura da caixa / +16
			add a6, s10, t1
			li t0, 10
			li t2, 1
			lb s6 0(a6)
			beq s6, t0, CAIXADIR4
			beq s6, t2, CAIXADIRELE
			j RECEBE_TECLA
			
			CAIXADIRELE:
				#posicao atual da caixa = ( s10 + 8 ) + 16
				li t1, 24
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXAELE_T
				
				CAIXADIRELE2:
					#Imprime a caixa +8 da posicao atual
					li t1, 40
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXAELE2_T
					j APAGADIR_T
				
			CAIXADIR4:
				#posicao atual da caixa = ( s10 + 8 ) + 16
				li t1, 24
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXADIR5:
					#Imprime a caixa +8 da posicao atual
					li t1, 32
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGADIR_T
CORACAODIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 3550
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAODIR2
	j RECEBE_TECLA

	CORACAODIR2:
		#Imprime meio chao no lugar do coracao:

		li t1, 24
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAODIR3)

		CORACAODIR3:
			jal s5, CORACAO_AUMENTA_T
			j APAGADIR_T

BAUDIR:
	#mesma coisa do codigo de cima, porem analisa outro pixel

	li t1, 3550
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUDIR2
	j RECEBE_TECLA

		BAUDIR2:
			jal s5, BAU_PORTA_T
			#Imprime bau vazio no lugar do bau:
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
	li t5, 16 # cor do inimigo
	li t0, 10 # cor do chao
	li t6, 1 #cor do bloco da morte
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOESQ2 # se o pixel for da mesma cor do chao va pra COLISAOESQ2
	beq s6, t2, CAIXAESQ # se o pixel for da mesma cor da caixa va pra CAIXAESQ
	beq s6, t3, BAUESQ # se o pixel for da mesma cor da caixa va pra BAUESQ
	beq s6, t5, RAIOESQ # se o pixel for da mesma cor do inimigo va pra RAIOESQ
	beq s6, t4, CORACAOESQ # se o pixel for da mesma cor da caixa va pra CORACAOESQ
	beq s6, t6, BLOCOMORTEESQ
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo


COLISAOESQ2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 2883
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_ESQ
	j RECEBE_TECLA

BLOCOMORTEESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 2883 #Verifica se eh o chao da morta na esq
	add a6, s10, t1
	li t0, 1
	lb s6 0(a6)
	beq s6, t0, BLOCOMORTEESQ2
	j RECEBE_TECLA
	
	BLOCOMORTEESQ2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, -4157 #Verifica se tem uma caixa em cima
		add a6, s10, t1
		li t0, 31
		lb s6 0(a6)
		beq s6, t0, BLOCOMORTEESQ3
		j VIDA_DIMINUI
		
		BLOCOMORTEESQ3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, -2237 #Verifica se tem uma caixa em cima
			add a6, s10, t1
			li t0, 31
			lb s6 0(a6)
			beq s6, t0, APAGAESQ_T
			j VIDA_DIMINUI

RAIOESQ:
	beq s1, t6, ATACAESQ #Se apertar f, va pra ATACADIR
	j RECEBE_TECLA #Caso o contrario, recebe tecla

CAIXAESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 2883
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXAESQ2
	j RECEBE_TECLA

	CAIXAESQ2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, 947 # Avalia a posicao futura da caixa / -16
		add a6, s10, t1
		li t0, 10
		li t2, 1
		lb s6 0(a6)
		beq s6, t0, CAIXAESQ3
		beq s6, t2, CAIXAESQ3
		j RECEBE_TECLA

		CAIXAESQ3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, 2867 # Avalia a posicao futura da caixa / -16
			add a6, s10, t1
			li t0, 10
			li t2, 1
			lb s6 0(a6)
			beq s6, t0, CAIXAESQ4
			beq s6, t2, CAIXAELEESQ
			j RECEBE_TECLA 
			
			CAIXAELEESQ:
				#Imprime chao no lugar da caixa
				#posicao atual da caixa = ( s10 + 8 ) - 16
				li t1, -8
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXAELE_T
				
				CAIXAELEESQ2:
					#Imprime a caixa -8 da posicao atual
					li t1, -24
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXAELE2_T
					j APAGAESQ_T

			CAIXAESQ4:
				#Imprime chao no lugar da caixa
				#posicao atual da caixa = ( s10 + 8 ) - 16
				li t1, -8
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXAESQ5:
					#Imprime a caixa -8 da posicao atual
					li t1, -16
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGAESQ_T
CORACAOESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
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
		li t1, -8
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOESQ3)

		CORACAOESQ3:		
			jal s5, CORACAO_AUMENTA_T
			j APAGAESQ_T

BAUESQ:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 2883
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUESQ2
	j RECEBE_TECLA

	BAUESQ2:
		jal s5, BAU_PORTA_T
		#Imprime bau vazio no lugar do bau:
		li t1, -8
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)

############TRAMPOLIM#############
APAGADIR_T:
	j APAGADIR_T2

BAU_PORTA_T: j BAU_PORTA_T2

CORACAO_AUMENTA_T: j CORACAO_AUMENTA_T2
##################################


COLISAOCIMA:
	li t1, -1909  # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 #cor da caixa
	li t3, 78 #cor do bau
	li t4, 7 #cor do coracao
	li t5, 11 #cor da porta
	li t6, 16 #cor do inimigo
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOCIMA2 # se o pixel for da mesma cor do chao va pra COLISAOCIMA2
	beq s6, t2, CAIXACIMA # se o pixel for da mesma cor da caixa va pra CAIXACIMA
	beq s6, t3, BAUCIMA # se o pixel for da mesma cor da caixa va pra BAUCIMA
	beq s6, t4, CORACAOCIMA # se o pixel for da mesma cor da caixa va pra CORACAOCIMA
	beq s6, t5, PORTA # se o pixel for da mesma cor da caixa va pra PORTA
	beq s6, t6, RAIOCIMA
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo

COLISAOCIMA2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, -1902
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_CIMA
	j RECEBE_TECLA

PORTA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, -1902
	add a6, s10, t1
	li t0, 11
	lb s6 0(a6)
        beq s6, t0, VERIFICADOR_DE_FASE_PORTA
	j RECEBE_TECLA
VERIFICADOR_DE_FASE_PORTA:
#s2 determina a fase que lamar esta
addi s2,s2, 1
li t0, 1
beq s2, t0, IMPRIME_FASE1	 #vai para a primeira fase
li t0, 2
beq s2, t0, IMPRIME_FASE2 #vai para a segunda fase
li t0, 3
beq s2,t0,  IMPRIME_FASE3#vai para terceira fase
li t0, 4
beq s2,t0,IMPRIME_FASE4
li t0, 5
beq s2,t0, IMPRIME_FASE5
li t0, 6
beq s2,t0, VITORIA

RAIOCIMA:
	li t1, 1
	beq s1, t1, ATACACIMA #Se apertar f, va pra ATACADIR
	j RECEBE_TECLA #Caso o contrario, recebe tecla

CAIXACIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, -1902
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXACIMA2
	j RECEBE_TECLA

	CAIXACIMA2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, -7029 #avalia a posicao futura da caixa / -5120
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXACIMA3
		j RECEBE_TECLA

		CAIXACIMA3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, -7022 #avalia a posicao futura da caixa / -5120
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXACIMA4
			j RECEBE_TECLA

			CAIXACIMA4:
				#Imprime chao no lugar da caixa
				#posicao atual da caixa = ( s10 + 8 ) - 5120
				li t1, -5112
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				CAIXACIMA5:
					#Imprime a caixa -2560 da posicao atual
					li t1, -7672
					add a6, s10, t1
					li t2, 0x100000
					add s6, a6, t2
					jal s5, CAIXA2_T
					j APAGACIMA

CORACAOCIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, -1902
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAOCIMA2
	j RECEBE_TECLA	

	CORACAOCIMA2:
		#Imprime meio chao no lugar do coracao:
		li t1, -5112
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOCIMA3)

		CORACAOCIMA3:
			jal s5, CORACAO_AUMENTA_T
			j APAGACIMA

BAUCIMA:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, -1902
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUCIMA2
	j RECEBE_TECLA

	BAUCIMA2:
		jal s5, BAU_PORTA_T
		#Imprime bau vazio no lugar do bau:
		li t1, -5112
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(bauvazio, a6, s6, 0, 304, RECEBE_TECLA)

############TRAMPOLIM#############
APAGADIR_T2:
	j APAGADIR
APAGAESQ_T:
	j APAGAESQ

##################################




COLISAOBAIXO:
	li t1, 5771 # posicao do pixel a ser analisado a partir da posicao do lolo
	la s0, POSICAO_LAMAR
	lw s10, 0(s0)
	add a6, s10, t1 # posicao do pixel a ser analisado
	li t2, 30 #cor da caixa
	li t3, 78 #cor do bau
	li t4, 7 #cor do coracao
	li t5, 16 #cor do inimigo
	li t0, 10 # cor do chao
	lb s6 0(a6) # carrega a cor do pixel a ser analisado
	beq s6, t0, COLISAOBAIXO2 # se o pixel for da mesma cor do chao va pra COLISAOBAIXO2
	beq s6, t2, CAIXABAIXO # se o pixel for da mesma cor da caixa va pra CAIXABAIXO
	beq s6, t3, BAUBAIXO # se o pixel for da mesma cor da caixa va pra BAUBAIXO
	beq s6, t4, CORACAOBAIXO # se o pixel for da mesma cor da caixa va pra CORACAOBAIXO
	beq s6, t5, RAIOBAIXO
	li s1, 0	#Volta o estado do Lamar para o padrao, que e s1 = 0 para andar
	j RECEBE_TECLA # caso contrario, eh um obstaculo

COLISAOBAIXO2:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 5778
	add a6, s10, t1
	li t0, 10
	lb s6 0(a6)
	beq s6, t0, VERIFICA_ACAO_BAIXO
	j RECEBE_TECLA	

RAIOBAIXO:
	li t1, 1
	beq s1, t1, ATACABAIXO #Se apertar f, va pra ATACADIR
	j RECEBE_TECLA #Caso o contrario, recebe tecla

CAIXABAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 5778
	add a6, s10, t1
	li t0, 30
	lb s6 0(a6)
	beq s6, t0, CAIXABAIXO2
	j RECEBE_TECLA

	CAIXABAIXO2:
		#mesma coisa do codigo de cima, porem analisa outro pixel
		li t1, 10891 #avalia a posicao futura da caixa / +5120
		add a6, s10, t1
		li t0, 10
		lb s6 0(a6)
		beq s6, t0, CAIXABAIXO3
		j RECEBE_TECLA

		CAIXABAIXO3:
			#mesma coisa do codigo de cima, porem analisa outro pixel
			li t1, 10898 #avalia a posicao futura da caixa / +5120
			add a6, s10, t1
			li t0, 10
			lb s6 0(a6)
			beq s6, t0, CAIXABAIXO4
			j RECEBE_TECLA

			CAIXABAIXO4:
				#Imprime a chao na posicao atual da caixa
				#posicao atual da caixa = ( s10 + 8 ) + 5120
				li t1, 5128
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA_T
				
				COLISAOBAIXO5:
				#Imprime a caixa +2560 da posicao atual
				li t1, 7688
				add a6, s10, t1
				li t2, 0x100000
				add s6, a6, t2
				jal s5, CAIXA2_T
				j APAGABAIXO

CORACAOBAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 5778
	add a6, s10, t1
	li t0, 7
	lb s6 0(a6)
	beq s6, t0, CORACAOBAIXO2
	j RECEBE_TECLA

	CORACAOBAIXO2:
		##jal s5, CORACAO
		li t1, 5128
		add a6, s10, t1
		li t2, 0x100000
		add s6, a6, t2
		ImpressaopequenaC(meiochao, a6, s6, 0, 304, CORACAOBAIXO3)

		CORACAOBAIXO3:
			jal s5, CORACAO_AUMENTA_T
			j APAGABAIXO

BAUBAIXO:
	#mesma coisa do codigo de cima, porem analisa outro pixel
	li t1, 5778
	add a6, s10, t1
	li t0, 78
	lb s6 0(a6)
	beq s6, t0, BAUBAIXO2
	j RECEBE_TECLA

	BAUBAIXO2:
		jal s5, BAU_PORTA_T
		#Imprime bau vazio no lugar do bau:
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

la t1,POWER_LAMAR
lw t1,0(t1)
beqz t1,ATUALIZADIR		#se power for zero, lamar nao ataca

beq s1, t0, ATACADIR		#Se o lamar estiver atacando, rotina de ataque
	ATUALIZADIR:
	li s1, 0
	j RECEBE_TECLA

VERIFICA_ACAO_CIMA:
li t0, 1
beq s1, zero, APAGACIMA		#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar

la t1,POWER_LAMAR
lw t1,0(t1)
beqz t1,ATUALIZACIMA		#se power for zero, lamar nao ataca

beq s1, t0, ATACACIMA			#Se o lamar estiver atacando, rotina de ataque
	ATUALIZACIMA:
	li s1, 0
	j RECEBE_TECLA

VERIFICA_ACAO_ESQ:
li t0, 1
beq s1, zero, APAGAESQ		#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar

la t1,POWER_LAMAR
lw t1,0(t1)
beqz t1,ATUALIZAESQ		#se power for zero, lamar nao ataca

beq s1, t0, ATACAESQ			#Se o lamar estiver atacando, rotina de ataque
	ATUALIZAESQ:
	li s1, 0
	j RECEBE_TECLA

VERIFICA_ACAO_BAIXO:
li t0, 1
beq s1, zero, APAGABAIXO	#Se o lamar nao estiver atacando, ele esta andando, pula pra rotina de andar

la t1,POWER_LAMAR
lw t1,0(t1)
beqz t1, ATUALIZABAIXO		#se power for zero, lamar nao ataca

beq s1, t0, ATACABAIXO			#Se o lamar estiver atacando, rotina de ataque
	ATUALIZABAIXO:
	li s1, 0
	j RECEBE_TECLA

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
Anda(lamardir_walk)	#Sprite andando para anima??¡§???o
Trocaframe(65)		#Delay m??nimo para que a anima??¡§???o possa ser vista
Apagachao(0)		#Apaga a sprite para n??o ocorrer sobreposi??¡§???o
Anda(lamardir)		#Sprite parado novamente
Trocaframe(65)		#Delay m??nimo para que a anima??¡§???o possa ser vista
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
.include "./Imagens/MAPA3.data"
.include "./Imagens/MAPA4.data"
.include "./Imagens/MAPA5.data"
#Transi?ao
.include "./Imagens/Transicao1.data"
.include "./Imagens/Transicao2.data"
.include "./Imagens/Transicao3.data"
.include "./Imagens/Transicao4.data"
.include "./Imagens/Transicao5.data"
.include "./Imagens/Transicaogameover.data"
.include "./Imagens/transicaovitoria.data"

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
.include "./Imagens/caixaeletrizada.data"																																																																																																																													
.include "./Imagens/caixa.data"
.include "./Imagens/coracao.data"
.include "./Imagens/bauaberto.data"																																																																																																																																																																		
.include "./Imagens/portaaberta.data"
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																			
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									
.text	
																									
.include "SYSTEMv21.s"
