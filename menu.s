.macro  Menu

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
.include "./Imagens/Barra_seleçao.data"

.text

#====================MENU=================================
# Prepara os endereços para printar o menu na tela
	ImpressaoF(menu1, 0xFF000000, 0, MENU_F)

# Prepara os enderecos para printar a segunda parte do menu
MENU_F:
	Frame(0) #para poder surgir de uma vez a tela do menu
	Impressao(menu2,0xFF000000, 0xFF100000, 1000, MUSICA)

MUSICA:		# Vazio ate que o menu esteja pronto

# Prepara os enderecos para printar a segunda parte do menu e entra para a seta de seleção do menu
MENU_TXT: 
	Impressao(menu3,0xFF000000, 0xFF100000, 0, SETA)
#========================================================
SETA:
	Impressaopequena(seta, 0xFF00BF98, 0xFF10BF98, 0, 0x12D, TECLADO)
	
TECLADO:
	li s8, 0 		# Nesse trecho, a1 vai definir em que opcao do menu estamos atualmente. 0 = start, 1 = password
	li s0, 0 		# Zera o contador utilizado nas imagens
	
INC:	addi s0, s0, 1		# Incrementa o contador
	jal RECEBE_TECLA
	j INC			# Retorna ao contador
	
#=================================TECLADO===============================
RECEBE_TECLA: 
	jal s5, MUSICA1
	li t1,0xFF200000		# carrega o KDMMIO

	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
	
	
   	beq t0,zero,RECEBE_TECLA   	   	# Se não há tecla pressionada então vai para Retorno(funça {RETORNA: ret} deve estar no final da pagina do arquivo)
   	lw t2,4(t1)  			# le o valor da tecla
   	
	li t5, 115			# ascii de "w" para verificar se foi pressionado
	li t6, 119			# ascii de "s" para verificar se foi pressionado
	li t0, 102			# ascii de "f" para verificar se foi pressionado
	beq t2, t6, SETA_CIMA		#SETA vai pra cima	
	beq t2, t5, SETA_BAIXO		#SETA vai pra baixo
	beq t2, t0, SELEÇAO_MENU	#Entra no lugar desejado
	
#=========================================================================		
SETA_CIMA:
	li s8, 0		# carrega 0 em a1 para indicar que a seta esta em "start"
	apaga_cor(0xFF00E518, 19, 266, 0xFFFFFFFF, 0x12D, IMPRIME_SETA_CIMA )
	IMPRIME_SETA_CIMA:
		Impressaopequena(seta, 0xFF00BF98, 0xFF10BF98, 0, 0x12D, INC)
	
#----------------------------------------------------------------------------------------------------------------#	
SETA_BAIXO:
	li s8, 1		# carrega 1 em a1 para indicar que a seta esta em "password"
	apaga_cor(0xFF00BF98, 19, 266, 0xFFFFFFFF, 0x12D, IMPRIME_SETA_BAIXO )
	IMPRIME_SETA_BAIXO:
		Impressaopequena(seta, 0xFF00E518, 0xFF10E518, 0, 0x12D, INC)
	
#==========================SELEÇÃO Start/Password ======================================
#s8 = 0 seta esta em start
#s8 = 1 seta esta em password
 
SELEÇAO_MENU:
	jal s5, MUSICA_RESET
	li t0, 1 
	beq s8, zero, START		#s8 = 0. vai para START
	beq s8, t0, PASSWORD		#s8 = 1. vai para PASSWORD
#+++++++++++++++++++++++++++MENU START++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
START:
	Impressao(Historia, 0xFF000000, 0xFF100000, 0, DELAYHIST)		#imagem contando historia do jogo
	
DELAYHIST:
	li s7, 32
	li a0, 0 #TEMP
	ecall
		
	VIDA_INIC:
	li s7, 5				#lamar começa com 5 de vida
	j MAIN					#em seguida vai pra VIDA conferir e printar a vida atual de lamar

#+++++++++++++++++++++++++MENU PASSWORD++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
PASSWORD:
	ImpressaoF(password2, 0xFF100000, 0, PASSWORD2) 	#imagem sem asterisco
	PASSWORD2:
	Frame(1)				#Troca para frame 1
	ImpressaoF(password1, 0xFF100000, 800, BARRA_SELEÇAO) #imagem com asterisco e vai para o teclado
	BARRA_SELEÇAO:
	Impressaopequena(Barra_seleçao, 0xFF00A53C, 0xFF10A53C, 0, 0x123, TECLADO_PASSWORD)#imprime a barra na seleÃ§ao da primeira letra

#===========================================VALIDAÇAO SENHA=============
VALIDADOR_SENHA:
	lw s5, 0xFF20000C 	#carrega display do KDMMIO, quarta letra
	#----------------------------------------------------------------#
	
	li s7, 5				#lamar começa com 5 de vida(s7) usando uma password
	
	#Primeira fase(senha: abba)
PRIMEIRA_FASE_SENHA:	
	senha(97, 98, 98, 97,SEGUNDA_FASE_SENHA, IMPRESSAO_MAPA1) #se senha correta imprime fase 1
	#Segunda fase(senha: lmao)		
SEGUNDA_FASE_SENHA:	
	#senha(108, 109, 97, 111, TERCEIRA_FASE_SENHA, IMPRESSAO_MAPA2)	#se senha correta imprime fase 2	
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
#senha:(* * * *),(0 1 2 3),(s2, s3, s4, s5)--------> posiçao logica de cada valor sendo respectivamente, apenas asteriscos, posiçao em a1 de cada e registradores onde o valor esta armazendado
SEGUNDA_LETRA:
	lw s2, 0xFF20000C 	#carrega display do KDMMIO, primeira letra
	play_sound(72, 1000, 120, 127)
	apaga_cor(0xFF10A53C, 29 ,145,146, 0x123, IMPRIME_SEGUNDA)#apaga barra primeira letra(cor azul)
	IMPRIME_SEGUNDA:
		Impressaopequena(Barra_seleçao, 0xFF00A572, 0xFF10A572 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da segunda letra
		
TERCEIRA_LETRA:			#carrega display do KDMMIO, segunda letra
	lw s3, 0xFF20000C 
	play_sound(72, 1000, 120, 127)	
	apaga_cor(0xFF10A572, 29 ,145,146, 0x123, IMPRIME_TERCEIRA)#apaga barra primeira letra(cor azul)
	IMPRIME_TERCEIRA:
		Impressaopequena(Barra_seleçao, 0xFF00A5A7, 0xFF10A5A7 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da terceira letra
		
QUARTA_LETRA:
	lw s4, 0xFF20000C 	##carrega display do KDMMIO, terceira letra
	play_sound(72, 1000, 120, 127)
	apaga_cor(0xFF10A5A7, 29 ,145,146, 0x123, IMPRIME_QUARTA)#apaga barra primeira letra(cor azul)
	IMPRIME_QUARTA:
		Impressaopequena(Barra_seleçao, 0xFF00A5DC, 0xFF10A5DC, 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da quarta letra														
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
   	beq t0,zero,RETORNA  	   	# Se não há tecla pressionada entao faz o LOOP
   	lw t2,4(t1)  			# le o valor da tecla
   	sw t2, 12(t1)			#escreve a tecla no display
   	#AVISO
   	#por algum motivo sempre que for reiniciar o BITMAP DISPLAY,caso queira que as teclas sejam digitadas no
   	#display do KDMMIO é necessario desconectar e conectar ele
   	
   	li t0, 27			# ascii de "esc" para verificar se foi pressionado
	beq t2, t0, MENU_TROCAFRAME 		#sai do password de volta para o menu
   	
   	addi s8,s8, 1 			#move posiçao tecla
   	
   	li t0, 1
   	beq t0, s8, SEGUNDA_LETRA	#se a1 determinar que esta na segunda posiçao(1) vai para segunda letra 
   	
   	li t0, 2
   	beq t0, s8, TERCEIRA_LETRA	#se a1 determinar que esta na terceira posiçao(2) vai para segunda letra
   	
   	li t0, 3
   	beq t0, s8, QUARTA_LETRA	#se a1 determinar que esta na quarta posiçao(3) vai para segunda letra
   	
   	li t0, 4
   	beq t0,s8, VALIDADOR_SENHA_PRE       #quando ultima senha for digitada ele faz a validaçao da senha	

   	
VALIDADOR_SENHA_PRE:
	play_sound(72, 1000, 120, 127)
	ImpressaoF(password2, 0xFF000000, 0, VALIDADOR) 	#imagem sem asterisco
	VALIDADOR:
	Frame(0)
	jal VALIDADOR_SENHA
	j PASSWORD	  	
   	
	
#=========================================================================
RETORNA: ret
		
.end_macro
