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
	Impressao(menu1, 0xFF000000, 0, MENU_F)

# Prepara os enderecos para printar a segunda parte do menu
MENU_F:
	Impressao(menu2,0xFF000000,1000,MUSICA)

MUSICA:		# Vazio ate que o menu esteja pronto

# Prepara os enderecos para printar a segunda parte do menu e entra para a seta de seleção do menu
MENU_TXT: 
	Impressao(menu3,0xFF000000,0,SETA)
#========================================================

SETA:
	la t0, seta
	lw t1, 0(t0)
	lw t2, 4(t0)
	mul t3, t1, t2
	addi t0, t0, 8
	li t4, 0
	li t6, 19		# Largura x da seta, vai ser usada pra pular linhas.
	li s1, 0xFF00BF98 		# Endereco onde comeca a imprimir a seta.


# So para nao esquecer como funciona:
# Para imprimir uma imagem em um lugar especifico, preciso da posicao x e y
# de onde ela vai comecar. Entao conto quantos pixels a imagem tem ate aquele
# ponto. No caso da resolucao 320x240, seria 320 * (y - 1). Depois somo com o x,
# que e quantos pixels a mais na proxima linha sao necessarios pra chegar na
# posicao inicial.
IMPRIME_SETA: 
	beq t4, t3, TECLADO
	lb t5, 0(t0)
	sb t5, 0(s1)
	addi t0, t0, 1
	addi s1, s1, 1
	addi t4, t4, 1
	bge t4, t6, PULA_LINHA_SETA
	j IMPRIME_SETA

# Essa parte e usada para pular para a proxima linha. No caso da seta, ela tem 19px de largura
# portanto queremos que apos imprimir 19 pixels ele pule pra linha seguinte.
# Para isso, compara a quantidade de pixels ja impressos com t6, se forem iguais, aumenta 
# t6 em 19 (em preparacao pra proxima linha), e soma a diferenca entre 320 e a largura da imagem,
# que no caso e 0x12D, para mostrar a posicao da qual vai comecar na linha seguinte.
PULA_LINHA_SETA:
	addi t6, t6, 19
	addi s1,s1, 0x12D
	j IMPRIME_SETA

TECLADO:
	li a1, 0 		# Nesse trecho, a1 vai definir em que opcao do menu estamos atualmente. 0 = start, 1 = password
	li s0, 0 		# Zera o contador utilizado nas imagens
	
INC:	addi s0, s0, 1		# Incrementa o contador
	jal RECEBE_TECLA
	j INC			# Retorna ao contador
	
#=================================TECLADO===============================
RECEBE_TECLA: 
	li t1,0xFF200000		# carrega o KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,RETORNA   	   	# Se não há tecla pressionada então vai para Retorno(funça {RETORNA: ret} deve estar no final da pagina do arquivo)
   	lw t2,4(t1)  			# le o valor da tecla
   	
	li t5, 115			# ascii de "w" para verificar se foi pressionado
	li t6, 119			# ascii de "s" para verificar se foi pressionado
	li t0, 102			# ascii de "f" para verificar se foi pressionado
	beq t2, t6, SETA_CIMA		#SETA vai pra cima	
	beq t2, t5, SETA_BAIXO		#SETA vai pra baixo
	beq t2, t0, SELEÇAO_MENU	#Entra no lugar desejado	
#=========================================================================		
SETA_CIMA:
	li a1, 0		# carrega 0 em a1 para indicar que a seta esta em "start"
	
	# apaga a seta de baixo antes de printar a de cima
	APAGA_SETABAIXO:
	li t1, 0xFF00E518	# carrega o endereco inicial
	li t2, 266		# quantidade total de pixels a imprimir
	li t3, 0xFFFFFFFF	# cor branca
	li t4, 0		# contador de pixels
	li t6, 19		# contador para pular linha
	
LOOP_APAGAB:	beq t4, t2, SETA_CIMA_F		# imprime a seta de baixo quando apagar a de cima
		beq t4, t6, PULA_LINHA_APAGABAIXO	# pula linha quando chegou no final dos 19px
		sb t3, 0(t1)				# preenche o pixel de branco
		addi t4, t4, 1				
		addi t1, t1, 1
		j LOOP_APAGAB

PULA_LINHA_APAGABAIXO:
		addi t6, t6, 19
		addi t1, t1, 0x12D
		j LOOP_APAGAB
	
	
	# imprime a seta na posicao de cima
	SETA_CIMA_F:
	la t0, seta
	lw t1, 0(t0)
	lw t2, 4(t0)
	mul t3, t1, t2
	addi t0, t0, 8
	li t4, 0
	li t6, 19			
	li s1, 0xFF00BF98 		
	
	IMPRIME_SETACIMA: 
	beq t4, t3, INC		# retorna e volta a buscar por input do teclado
	lb t5, 0(t0)
	sb t5, 0(s1)
	addi t0, t0, 1
	addi s1, s1, 1
	addi t4, t4, 1
	bge t4, t6, PULA_LINHA_SETACIMA
	j IMPRIME_SETACIMA


	PULA_LINHA_SETACIMA:
	addi t6, t6, 19
	addi s1,s1, 0x12D
	j IMPRIME_SETACIMA
	
#----------------------------------------------------------------------------------------------------------------#	
SETA_BAIXO:
	li a1, 1		# carrega 1 em a1 para indicar que a seta esta em "password"
	
	APAGA_SETACIMA:
	li t1, 0xFF00BF98	# carrega o endereco inicial
	li t2, 266		# quantidade total de pixels a imprimir
	li t3, 0xFFFFFFFF	# cor branca
	li t4, 0		# contador de pixels
	li t6, 19		# contador para pular linha
	
LOOP_APAGAC:	beq t4, t2, SETA_BAIXO_F		# imprime a seta de baixo quando apagar a de cima
		beq t4, t6, PULA_LINHA_APAGACIMA	# pula linha quando chegou no final dos 19px
		sb t3, 0(t1)				# preenche o pixel de branco
		addi t4, t4, 1				
		addi t1, t1, 1
		j LOOP_APAGAC

PULA_LINHA_APAGACIMA:
		addi t6, t6, 19
		addi t1, t1, 0x12D
		j LOOP_APAGAC
	
	SETA_BAIXO_F:
	la t0, seta
	lw t1, 0(t0)
	lw t2, 4(t0)
	mul t3, t1, t2
	addi t0, t0, 8
	li t4, 0
	li t6, 19			
	li s1, 0xFF00E518		
	
	
	IMPRIME_SETABAIXO: 
	beq t4, t3, INC		# retorna e volta a buscar por input do teclado
	lb t5, 0(t0)
	sb t5, 0(s1)
	addi t0, t0, 1
	addi s1, s1, 1
	addi t4, t4, 1
	bge t4, t6, PULA_LINHA_SETABAIXO
	j IMPRIME_SETABAIXO


	PULA_LINHA_SETABAIXO:
	addi t6, t6, 19
	addi s1,s1, 0x12D
	j IMPRIME_SETABAIXO
#==========================SELEÇÃO Start/Password ======================================
#a1 = 0 seta esta em start
#a1 = 1 seta esta em password
 
SELEÇAO_MENU:
	li t0, 1 
	beq a1, zero, START
	beq a1, t0, PASSWORD
#+++++++++++++++++++++++++++MENU START++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
START:
	Impressao(Historia, 0xFF000000, 0, IMPRIME_FASE1)		#imagem contando historia do jogo
IMPRIME_FASE1:
	Impressao(MAPA1, 0xFF000000, 8000, MAIN)			#print da primeira fase com delay de 8seg para se ler a historia
		#MAIN seria o inicio da gameplay funçao localizada em ADVLAMAR.s
#+++++++++++++++++++++++++MENU PASSWORD++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
PASSWORD:
	Impressao(password2, 0xFF000000, 0, PASSWORD2) 	#imagem sem asterisco
	PASSWORD2:
	Impressao(password1, 0xFF000000, 800, BARRA_SELEÇAO) #imagem com asterisco e vai para o teclado
	BARRA_SELEÇAO:
	Impressaopequena(Barra_seleçao, 0xFF00A53C, 0, 0x123, TECLADO_PASSWORD)#imprime a barra na seleçao da primeira letra
#===========================================VALIDAÇAO SENHA=============
VALIDADOR_SENHA:
	lw s5, 0xFF20000C 	#carrega display do KDMMIO, quarta letra
	#----------------------------------------------------------------#
	#Primeira fase(senha: abba)
PRIMEIRA_FASE_SENHA:	
	senha(97, 98, 98, 97,SEGUNDA_FASE_SENHA, START) #vai para START
	#Segunda fase()		
SEGUNDA_FASE_SENHA:	
				
	
	 j MENU	
#=================================SENHAS===============================
#apaga barra da letra anterior e imprime na proxima
#senha:(* * * *),(0 1 2 3),(s2, s3, s4, s5)--------> posiçao logica de cada valor sendo respectivamente, apenas asteriscos, posiçao em a1 de cada e registradores onde o valor esta armazendado
SEGUNDA_LETRA:
	lw s2, 0xFF20000C 	#carrega display do KDMMIO, primeira letra
	apaga_cor(0xFF00A53C, 29 ,145,0x03008050, 0x123, IMPRIME_SEGUNDA)#apaga barra primeira letra(cor azul)
	IMPRIME_SEGUNDA:
		Impressaopequena(Barra_seleçao, 0xFF00A572, 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da segunda letra
		
TERCEIRA_LETRA:			#carrega display do KDMMIO, segunda letra
	lw s3, 0xFF20000C 
	apaga_cor(0xFF00A572, 29 ,145,0x03008050, 0x123, IMPRIME_TERCEIRA)#apaga barra primeira letra(cor azul)
	IMPRIME_TERCEIRA:
		Impressaopequena(Barra_seleçao, 0xFF00A5A7, 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da terceira letra
		
QUARTA_LETRA:
	lw s4, 0xFF20000C 	##carrega display do KDMMIO, terceira letra
	apaga_cor(0xFF00A5A7, 29 ,145,0x03008050, 0x123, IMPRIME_QUARTA)#apaga barra primeira letra(cor azul)
	IMPRIME_QUARTA:
		Impressaopequena(Barra_seleçao, 0xFF00A5DC, 0, 0x123, RECEBE_TECLA_PASSWORD)#imprime a barra na seleçao da quarta letra														
#=================================TECLADO================================
#vai se esperar o jogador apertar uma tecla
TECLADO_PASSWORD:
	li a1, 0 		# a1 vai definir a posicao do asterisco(0,1,2,3)    
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
   	
   	addi a1,a1, 1 			#move posiçao tecla
   	
   	li t0, 1
   	beq t0, a1, SEGUNDA_LETRA	#se a1 determinar que esta na segunda posiçao(1) vai para segunda letra 
   	
   	li t0, 2
   	beq t0, a1, TERCEIRA_LETRA	#se a1 determinar que esta na terceira posiçao(2) vai para segunda letra
   	
   	li t0, 3
   	beq t0, a1, QUARTA_LETRA	#se a1 determinar que esta na quarta posiçao(3) vai para segunda letra
   	
   	li t0, 4
   	beq t0,a1, VALIDADOR_SENHA      #quando ultima senha for digitada ele faz a validaçao da senha	

   	
	  	
   	
	
#=========================================================================
RETORNA: ret
		
.end_macro
