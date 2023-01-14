;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d
END_JUMP		EQU	    844d 
PACMAN			EQU		'C'
ESPACO			EQU     ' '
PAREDE			EQU		'#'
LINHA			EQU		81d
PONTO			EQU		'.'
FANTASMA	    EQU		'X'
FINAL_LINHA	    EQU     24d


;Posições originais do PACMAN
ORIG_PC_COL	 	EQU		34d
ORIG_PC_LIN		EQU		10d

;Para função  de perder/ganhou
GANHOU			EQU		776d
PERDEU			EQU		0d

;Timer
TIMER_END		EQU		FFF6h
ACTIVATE_TIMER	EQU		FFF7h
ON 				EQU		1d
OFF				EQU		0d
TIME_TO_WAIT	EQU		4d

;Função Random
RND_MASK		EQU		8016h	; 1000 0000 0001 0110b
LSB_MASK		EQU		0001h	; Mascara para testar o bit menos significativo do Random_Var
PRIME_NUMBER_1	EQU 	11d
PRIME_NUMBER_2	EQU 	13d

;Direcao fantasma
RIGHT			EQU		0d
LEFT			EQU		1d
UP 				EQU	    2d
DOWN			EQU		3d



;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d

;889 pontos
L1     			STR 	'################################################################################', FIM_TEXTO
L2     			STR 	'#......................................##......................................#', FIM_TEXTO
L3			    STR 	'#.####################################.##.####################################.#', FIM_TEXTO
L4			    STR		'#................##.....X..............##...................##..X..............#', FIM_TEXTO
L5			    STR		'#.##############.##.##################.##.#################.##.###############.#', FIM_TEXTO
L6			    STR		'#......................................##......................................#', FIM_TEXTO
L7			    STR		'#.####################################.##.####################################.#', FIM_TEXTO
L8			    STR		'#................................................................#.............#', FIM_TEXTO
L9			    STR		'#.#############################################.###############.....############', FIM_TEXTO
L10			    STR		'#.######################.....................##.#####............#............##', FIM_TEXTO
L11			    STR		'#.######################..........C.............#####...###################...##', FIM_TEXTO
L12			    STR		'#.######################.....................##.#####.........................##', FIM_TEXTO
L13			    STR		'#.#############################################.################...#############', FIM_TEXTO 
L14			    STR		'#..............................................................................#', FIM_TEXTO
L15			    STR		'#.####################################.##.####################################.#', FIM_TEXTO
L16			    STR		'#.#####################................##................#####################.#', FIM_TEXTO
L17			    STR		'#.......................################################.......................#', FIM_TEXTO
L18			    STR		'###############......X...................................X.....#################', FIM_TEXTO
L19			    STR		'#...............##############################################.................#', FIM_TEXTO
L20			    STR		'#.####################..............#######...............####################.#', FIM_TEXTO
L21			    STR		'#......................############.........#############......................#', FIM_TEXTO
L22			    STR		'################################################################################', FIM_TEXTO
L23			    STR		'# SCORE:  000  ++++++++++++++++++++++++++++++++++++++++++++   VIDAS S2 S2 S2   #', FIM_TEXTO
L24			    STR		'################################################################################', FIM_TEXTO

L25			    STR		'#######################            VOCE GANHOU            ######################', FIM_TEXTO
L26			    STR		'#######################            VOCE PERDEU            ######################', FIM_TEXTO


;PACMAN
pcend			WORD	34d
pcend_init		WORD	0d
pccol			WORD	34d
pclin			WORD	10d

;FANTASMAS
;################# FANTASMA 1 #################
g1end			WORD	24d
g1col			WORD	24d
g1lin			WORD	3d
g1dir			WORD    RIGHT
;################# FANTASMA 2 #################
g2end			WORD	64d
g2col			WORD	64d
g2lin			WORD	3d
g2dir			WORD	LEFT
;################# FANTASMA 3 #################
g3end			WORD	21d
g3col			WORD	21d
g3lin			WORD	17d
g3dir			WORD	LEFT
;################# FANTASMA 4 #################
g4end			WORD	57d
g4col			WORD	57d
g4lin			WORD	17d
g4dir			WORD	LEFT
;################ GENERICO(ARG) ###############
ggend			WORD	0d
ggcol			WORD	0d
gglin			WORD	0d
ggdir			WORD	0d

;PROXIMA POSIÇÃO DO FANTASMA
prox_posg		WORD	0d


;PONTUAÇÃO
pontcol_c		WORD	10d ;colunas
pontcol_d		WORD	11d
pontcol_u		WORD	12d
pontlin			WORD	22d ;linha 
pontuacao		WORD	0d 

;CORAÇÕES (vida)
coracao1_colp1	WORD	68d
coracao1_colp2  WORD	69d
coracao2_colp1  WORD	71d
coracao2_colp2  WORD	72d
coracao3_colp1  WORD	74d
coracao3_colp2  WORD	75d

coracao_lin		WORD	22d

vida			WORD	3d 

;TIMER
f_right			WORD	0d
f_left			WORD	0d
f_down   		WORD    0d
f_up			WORD	0d

;RANDOM
Random_Var	WORD	A5A5h  ; 1010 0101 1010 0101

RandomState WORD	1d



;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    Flag_right
INT1            WORD    Flag_left
INT2			WORD	Flag_up
INT3			WORD	Flag_down


				ORIG 	FE0Fh
INT15			WORD    Ciclo


;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main
;------------------------------------------------------------------------------
; VERIFICAR A DIREÇÃO DO FANTASMA E ANDAR 
;------------------------------------------------------------------------------
Mover_ghost:   	PUSH R1

				MOV R1, M[ggdir]

				CMP R1, RIGHT
				CALL.Z	Mov_right_g

				CMP R1, LEFT
				CALL.Z	Mov_left_g

				CMP R1, UP
				CALL.Z	Mov_up_g

				CMP R1, DOWN
				CALL.Z	Mov_down_g

				POP R1

				RET
;------------------------------------------------------------------------------
; TIMER 
;------------------------------------------------------------------------------
Config_timer: 	PUSH 	R1
				PUSH 	R2

				MOV 	R1, TIMER_END
				MOV		R2, TIME_TO_WAIT
				MOV 	M[R1], R2

				MOV 	R1, ACTIVATE_TIMER
				MOV		R2, ON
				MOV 	M[R1], R2

				POP 	R2
				POP 	R1
				
				RET
;------------------------------------------------------------------------------
; CICLO 
;------------------------------------------------------------------------------
Ciclo:			PUSH	R1

				MOV 	R1, 0d

				MOV 	R1, M[f_right]
				CMP 	R1, ON
				CALL.Z	mov_right

				MOV 	R1, M[f_left]
				CMP		R1, ON
				CALL.Z	mov_left

				MOV 	R1, M[f_up]
				CMP		R1, ON
				CALL.Z	mov_up

				MOV 	R1, M[f_down]
				CMP		R1, ON
				CALL.Z	mov_down

				;fantasmas

;############### fantasma 1
				MOV 	R1, M[g1end]
				MOV 	M[ggend],R1
				MOV 	R1, M[g1col]
				MOV 	M[ggcol],R1
				MOV 	R1, M[g1lin]
				MOV 	M[gglin],R1
				MOV 	R1, M[g1dir]
				MOV 	M[ggdir],R1

				CALL Mover_ghost

				MOV 	R1, M[ggend]
				MOV 	M[g1end],R1
				MOV 	R1, M[ggcol]
				MOV 	M[g1col],R1	
				MOV 	R1, M[gglin]
				MOV 	M[g1lin],R1
				MOV 	R1, M[ggdir]
				MOV 	M[g1dir],R1
				
;############### fantasma 2
				MOV 	R1, M[g2end]
				MOV 	M[ggend],R1
				MOV 	R1, M[g2col]
				MOV 	M[ggcol],R1
				MOV 	R1, M[g2lin] 
				MOV 	M[gglin],R1
				MOV 	R1, M[g2dir]
				MOV 	M[ggdir],R1

				CALL Mover_ghost

				MOV 	R1, M[ggend]
				MOV 	M[g2end],R1
				MOV 	R1, M[ggcol]
				MOV 	M[g2col],R1	
				MOV 	R1, M[gglin]
				MOV 	M[g2lin],R1
				MOV 	R1, M[ggdir]
				MOV 	M[g2dir],R1

;############### fantasma 3
				MOV 	R1, M[g3end]
				MOV 	M[ggend],R1
				MOV 	R1, M[g3col]
				MOV 	M[ggcol],R1
				MOV 	R1, M[g3lin]
				MOV 	M[gglin],R1
				MOV 	R1, M[g3dir]
				MOV 	M[ggdir],R1
				
				CALL Mover_ghost

				MOV 	R1, M[ggend]
				MOV 	M[g3end],R1
				MOV 	R1, M[ggcol]
				MOV 	M[g3col],R1	
				MOV 	R1, M[gglin]
				MOV 	M[g3lin],R1
				MOV 	R1, M[ggdir]
				MOV 	M[g3dir],R1

;############### fantasma 4
				MOV 	R1, M[g4end]
				MOV 	M[ggend],R1
				MOV 	R1, M[g4col]
				MOV 	M[ggcol],R1
				MOV 	R1, M[g4lin]
				MOV 	M[gglin],R1
				MOV 	R1, M[g4dir]
				MOV 	M[ggdir],R1

				CALL Mover_ghost	

				MOV 	R1, M[ggend]
				MOV 	M[g4end],R1
				MOV 	R1, M[ggcol]
				MOV 	M[g4col],R1	
				MOV 	R1, M[gglin]
				MOV 	M[g4lin],R1
				MOV 	R1, M[ggdir]
				MOV 	M[g4dir],R1

				CALL    Config_timer

				POP R1
				RTI

;------------------------------------------------------------------------------
; FLAGS - Direciona o PACMAN
;------------------------------------------------------------------------------
Flag_right:		PUSH 	R1
				MOV 	R1, ON
				MOV 	M[f_right], R1

				MOV 	R1, OFF
				MOV 	M[f_up], R1
				MOV 	M[f_down], R1
				MOV 	M[f_left], R1

				POP 	R1
				RTI

Flag_left: 		PUSH R1
				MOV 	R1, ON
				MOV 	M[f_left], R1

				MOV 	R1, OFF
				MOV 	M[f_up], R1
				MOV 	M[f_down], R1
				MOV 	M[f_right], R1


				POP 	R1
				RTI


Flag_up: 		PUSH R1
				MOV 	R1, ON
				MOV 	M[f_up], R1

				MOV 	R1, OFF
				MOV 	M[f_left], R1
				MOV 	M[f_down], R1
				MOV 	M[f_right], R1

				POP 	R1
				RTI


Flag_down: 		PUSH R1
				MOV 	R1, ON
				MOV 	M[f_down], R1

				MOV 	R1, OFF
				MOV 	M[f_up], R1
				MOV 	M[f_left], R1
				MOV 	M[f_right], R1

				POP 	R1
				RTI

;------------------------------------------------------------------------------
; Loop_Mapa - Loop que vai imprimindo linha por linha
;------------------------------------------------------------------------------
Mapa:		PUSH		R1
			PUSH		R2
			PUSH		R3
			MOV 		R3, 0d

While1:		CMP 		R3, FINAL_LINHA
			JMP.Z 		Endwhile2
			CALL		PrintString
			INC			M[ TextIndex ]
			INC			R3
			MOV         R2, 0
			INC 		M[ RowIndex ]
			MOV			R1, M[RowIndex ]
			MOV         M[ ColumnIndex ], R2
			SHL			R1, ROW_SHIFT
			OR 			R1, R2
			MOV			M[ CURSOR ], R1
			JMP			While1

Endwhile2:	POP			R3
			POP			R2
			POP			R1
			RET

;------------------------------------------------------------------------------
; Função PrintString
;------------------------------------------------------------------------------
PrintString: PUSH		R1
			 PUSH		R2

While:		 MOV		R1, M[ TextIndex ]
			 MOV		R1, M[ R1 ]
			 CMP		R1, FIM_TEXTO
			 JMP.Z 		Endwhile1
			 MOV		M[ IO_WRITE ], R1
			 INC 		M[ ColumnIndex ]
			 INC		M[ TextIndex ]
			 MOV		R1, M[ RowIndex ]
			 MOV		R2, M[ ColumnIndex ]
			 SHL		R1, ROW_SHIFT
			 OR   		R1, R2
			 MOV		M[ CURSOR ], R1
			 JMP		While

Endwhile1:   POP	    R2
		  	 POP		R1
		  	 RET

;------------------------------------------------------------------------------
;  VOLTAR O PACMAN PARA A POSIÇÃO INICIAL 
;------------------------------------------------------------------------------
Orig_PC: 	PUSH		R1
			PUSH		R2

			;Limpar o lugar que ta o PACMAN
			MOV		    R1, M[ pclin ]
			MOV		    R2, M[ pccol ]
			SHL		    R1, ROW_SHIFT
			OR   	    R1, R2
			MOV		    M[ CURSOR ], R1
			MOV 	    R1, ESPACO
			MOV		    M[ IO_WRITE ], R1

			;Atualizar o endereço do pacman antigo e novo
			MOV         R1, M[pcend]
			MOV 	    R2, ESPACO
			MOV         M[R1], R2

			MOV 	    R1, M[pcend_init]
			MOV 	    M[pcend], R1

			MOV         R1, M[pcend]
			MOV 	    R2, PACMAN
			MOV         M[R1], R2

			;Coloca o PACMAN na posicao original
			MOV		    R1, ORIG_PC_COL	
			MOV 	    M[pccol], R1
			MOV		    R1, ORIG_PC_LIN
			MOV 	    M[pclin], R1

			MOV		    R1, M[ pclin ]
			MOV		    R2, M[ pccol ]
			SHL		    R1, ROW_SHIFT
			OR   	    R1, R2
			MOV		    M[ CURSOR ], R1
			MOV 	    R1, PACMAN
			MOV		    M[ IO_WRITE ], R1

			POP 	    R2
			POP 	    R1

			RET
			
;------------------------------------------------------------------------------
; TELA GANHOU JOGO
;------------------------------------------------------------------------------
Tela_ganhou:	PUSH R1
				PUSH R2
				;imprime a linha de ganhar
				MOV     R1, L25
				MOV		M[ TextIndex ], R1
				MOV     R2, 0d
				MOV		R1, 22d
				MOV 	M[ RowIndex ], R1
				MOV		R1, M[RowIndex ]
				MOV     M[ ColumnIndex ], R2
				SHL		R1, ROW_SHIFT
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				CALL 	PrintString

				JMP 	Halt 

				POP		R1
				POP		R2

				RET 	

;------------------------------------------------------------------------------
; TELA PERDEU JOGO (retira o último coração e mostra a tela)
;------------------------------------------------------------------------------
Tela_perdeu:PUSH R1
			PUSH R2

			;retirar o ultimo coração
			MOV		R1, M[ coracao_lin ] ;linha onde está os corações
			MOV		R2, M[ coracao1_colp1 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1

			MOV		R1, M[ coracao_lin ] ;linha onde está os corações
			MOV		R2, M[ coracao1_colp2 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1; Imprimindo o R1

			;imprime a linha de perder
			MOV     R1, L26
			MOV		M[ TextIndex ], R1
			MOV     R2, 0d
			MOV		R1, 22d
			MOV 	M[ RowIndex ], R1
			MOV		R1, M[RowIndex ]
			MOV     M[ ColumnIndex ], R2
			SHL		R1, ROW_SHIFT
			OR 		R1, R2
			MOV		M[ CURSOR ], R1
			CALL 	PrintString

			JMP 	Halt 

			POP		R1
			POP		R2

			RET 	


;------------------------------------------------------------------------------
; PERDER VIDA - Tira as vidas do PACMAN
;------------------------------------------------------------------------------
Per_vida: 	PUSH R1
			PUSH R2

			DEC  		M[vida]
			MOV 		R1, M[vida]

			CMP			R1, 2d
			JMP.Z 		VIDA_2
			;Verifica se perdeu
			CMP			R1, PERDEU
			CALL.Z      Tela_perdeu

			;RETIRA A SEGUNDA VIDA E DEIXA COM 1 VIDA NO TOTAL
		    MOV		R1, M[ coracao_lin ] ;;linha onde está os corações
			MOV		R2, M[ coracao2_colp1 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1

			MOV		R1, M[ coracao_lin ] ;linha onde está a Pontuação
			MOV		R2, M[ coracao2_colp2 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R3
			
            ;RETIRA A PRIMEIRA VIDA E DEIXA COM 2 VIDAS NO TOTAL
VIDA_2:	    MOV		R1, M[ coracao_lin ] ;linha onde está os corações
			MOV		R2, M[ coracao3_colp1 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1

			MOV		R1, M[ coracao_lin ] ;linha onde está os corações
			MOV		R2, M[ coracao3_colp2 ] ;coluna onde está o coração
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV		R1, ESPACO
			MOV		M[ IO_WRITE ], R1; Imprimindo o R1

			CALL    Orig_PC

			POP R2
			POP R1

			RET

;------------------------------------------------------------------------------
; SCORE
;------------------------------------------------------------------------------
SCORE:		PUSH R1
			PUSH R2
			PUSH R3
			PUSH R4

			INC 	M[pontuacao]

		
			;Transformar em asc11
			MOV		R1, M[pontuacao]
			MOV		R2, 100d
			DIV		R1, R2 
			
			;==========Centenas===========
			MOV		R3, M[ pontlin ] ;linha onde está a Pontuação
			MOV		R4, M[ pontcol_c ] ;coluna onde está a CENTENAS
			SHL		R3, ROW_SHIFT
			OR   	R3, R4
			MOV		M[ CURSOR ], R3
			ADD		R1, '0'
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1


            ;==========Dezenas==========
			MOV		R1, R2
			MOV		R2, 10d
			DIV		R1, R2 
			
			;Imprimir na tela	
			MOV		R3, M[ pontlin ] ;linha onde está a Pontuação
			MOV		R4, M[ pontcol_d ] ;coluna onde está a CENTENAS
			SHL		R3, ROW_SHIFT
			OR   	R3, R4
			MOV		M[ CURSOR ], R3
			ADD		R1, '0'
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1
					
			;==========Unidades==========	
			MOV			R1, R2

			;Imprimir na tela	
			MOV		R2, M[ pontlin ] ;linha onde está o PACMAN
			MOV		R3, M[ pontcol_u ] ;coluna onde está o PACMAN
			SHL		R2, ROW_SHIFT
			OR   	R2, R3
			MOV		M[ CURSOR ], R2
			ADD		R1, '0'
			MOV		M[ IO_WRITE ], R1 ;Imprimindo o R1

 			;verificar se venceu e chamar o mapa de venceu
			MOV 	R1, M[pontuacao]
			CMP		R1, GANHOU
			CALL.Z 	Tela_ganhou

			POP			R4
            POP			R3
			POP			R2
		  	POP			R1
		  	RET

;------------------------------------------------------------------------------
; Mover Direita
;------------------------------------------------------------------------------
mov_right:	PUSH R1
			PUSH R2

			;Não comer barreiras
 			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			INC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, FANTASMA ; VERIFICO SE O PROXIMO É FANTASMA
			CALL.Z  Per_vida
			CMP		R2, PAREDE ; Comparo para ver se ele é parede
			JMP.Z 	BARREIRA

			;Pontuação
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			INC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, PONTO ; Comparo para ver se ele é parede
			CALL.Z	SCORE ;Chamando a Função de contar Pontuação

			;Atualizar o endereço do pacman
  			MOV		R1, M[pcend]
			MOV 	R2, ESPACO
			MOV     M[R1], R2
			INC		M[pcend]
			MOV		R1, M[pcend]
			MOV 	R2, PACMAN
			MOV     M[R1], R2

			
			;Atualizar o pacman na tela

			;Coloca o ESPACO na posição original
			MOV		R1, M[ pclin ] ;linha onde está o PACMAN
			MOV		R2, M[ pccol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, ESPACO
			MOV		M[ IO_WRITE ], R1

			;Coloca o PACMAN na proxima posição 
			INC 	M[ pccol ]
			MOV		R1, M[ pclin ]
			MOV		R2, M[ pccol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, PACMAN
			MOV		M[ IO_WRITE ], R1

BARREIRA:	POP	    R2
			POP     R1
			RET

;------------------------------------------------------------------------------
; Mover Esquerda
;------------------------------------------------------------------------------
mov_left:	PUSH R1
			PUSH R2

			;Não comer barreiras
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			DEC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, FANTASMA ; VERIFICO SE O PROXIMO É FANTASMA
			CALL.Z  Per_vida
			CMP		R2, PAREDE ; Comparo para ver se ele é parede
			JMP.Z 	BARREIRA2

			;Pontuação
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			DEC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, PONTO ; Comparo para ver se ele é parede
			CALL.Z	SCORE ;Chamando a Função de contar Pontuação


			;Atualizar o endereço do pacman
			MOV		R1, M[pcend]
			MOV 	R2, ESPACO
			MOV     M[R1], R2
			DEC		M[pcend]
			MOV		R1, M[pcend]
			MOV 	R2, PACMAN
			MOV     M[R1], R2

			; Atualizar o pacman na tela

			;Coloca o ESPACO na posição original
			MOV		R1, M[ pclin ] ;linha onde está o PACMAN
			MOV		R2, M[ pccol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, ESPACO
			MOV		M[ IO_WRITE ], R1
			DEC 	M[ pccol ]

			;Coloca o PACMAN na proxima posição 
			MOV		R1, M[ pclin ]
			MOV		R2, M[ pccol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, PACMAN
			MOV		M[ IO_WRITE ], R1

BARREIRA2:	POP	    R2
			POP     R1
			RET


;------------------------------------------------------------------------------
; Mover Cima
;------------------------------------------------------------------------------
mov_up:    	PUSH R1
			PUSH R2

			;Não comer barreiras
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			SUB     R1, LINHA ; Diminuo em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, FANTASMA ; VERIFICO SE O PROXIMO É FANTASMA
			CALL.Z  Per_vida
			CMP		R2, PAREDE ; Comparo para ver se ele é parede
			JMP.Z 	BARREIRA3

			;Pontuação
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			SUB     R1, LINHA ; Diminuo em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, PONTO ; Comparo para ver se ele é parede
			CALL.Z	SCORE ;Chamando a Função de contar Pontuação

			; Atualizar o endereço do pacman
			MOV	    R1, M[pcend]
			MOV     R2, ESPACO
			MOV     M[R1], R2
			MOV	    R1, M[pcend] 
			SUB     R1, LINHA
			MOV	    M[pcend], R1
			MOV	    R1, M[pcend]
			MOV     R2, PACMAN
			MOV     M[R1], R2

			; Atualizar o pacman na tela

			;Coloca o ESPACO na posição original
			MOV		R1, M[ pclin ] ;linha onde está o PACMAN
			MOV		R2, M[ pccol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, ESPACO
			MOV		M[ IO_WRITE ], R1

			;Coloca o PACMAN na proxima posição 
			DEC 	M[ pclin ]
			MOV		R1, M[ pclin ]
			MOV		R2, M[ pccol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, PACMAN
			MOV		M[ IO_WRITE ], R1

BARREIRA3:	POP	    R2
			POP     R1
			RET


;------------------------------------------------------------------------------
; Mover Baixo
;------------------------------------------------------------------------------
mov_down:  PUSH R1
			PUSH R2

			;Não comer barreiras
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			ADD     R1, LINHA ; Aumento em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, FANTASMA ; VERIFICO SE O PROXIMO É FANTASMA
			CALL.Z  Per_vida
			CMP		R2, PAREDE ; Comparo para ver se ele é parede
			JMP.Z 	BARREIRA4

			;Pontuação
			MOV		R1, M[ pcend ] ; Adiciono o endereço da posição do Pacman
			ADD     R1, LINHA ; Aumento em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do pacman 
			CMP		R2, PONTO ; Comparo para ver se ele é parede
			CALL.Z	SCORE ; Chamando a Função de contar Pontuação

			; Atualizar o endereço do pacman
			MOV	    R1, M[pcend]
			MOV     R2, ESPACO
			MOV     M[R1], R2
			MOV	    R1, M[pcend] 
			ADD     R1, LINHA
			MOV	    M[pcend], R1
			MOV	    R1, M[pcend]
			MOV     R2, PACMAN
			MOV     M[R1], R2

			; Atualizar o pacman na tela

			;Coloca o ESPACO na posição original
			MOV		R1, M[ pclin ] ;linha onde está o PACMAN
			MOV		R2, M[ pccol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, ESPACO
			MOV		M[ IO_WRITE ], R1

			;Coloca o PACMAN na proxima posição 
			INC 	M[ pclin ]
			MOV		R1, M[ pclin ]
			MOV		R2, M[ pccol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, PACMAN
			MOV		M[ IO_WRITE ], R1

BARREIRA4:	POP	    R2
			POP     R1
			RET

;------------------------------------------------------------------------------
; Função: RandomV2 (versão 2)
;
; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: M[Random_Var]
; Saidas:   M[Random_Var]
;------------------------------------------------------------------------------

RandomV2:	PUSH R1
			PUSH R2
			PUSH R3
			PUSH R4

			MOV R1, M[ RandomState ]
			MOV R2, PRIME_NUMBER_1
			MOV R3, PRIME_NUMBER_2
			MOV R4, 5d

			MUL R1, R2 ; Atenção: O resultado da operacao fica em R1 e R2!!!
			ADD R2, R3 ; Vamos usar os 16 bits menos significativos da MUL
			MOV M[ RandomState ], R2

			DIV R2, R4
			MOV M[ Random_Var ], R4

			POP R4
			POP R3
			POP	R2
			POP R1

			RET
;------------------------------------------------------------------------------
; Mudar Direção FANTASMA 
; -- Função que é chamada quando é necesario mudar a direção do PACMAN, quando 
;    quando bate em uma parede. Ele seleciona randomicamente a nova direção.
;------------------------------------------------------------------------------
Change_dir: PUSH 	R1
			PUSH 	R2
			
			CALL 	RandomV2
			MOV 	R1, M[Random_Var]
			MOV		R2, 4d 
			DIV		R1, R2
			MOV		M[ggdir], R2

			POP		R2
			POP		R1
			RET	

;------------------------------------------------------------------------------
; Mover Direita FANTASMA (0)
;------------------------------------------------------------------------------
Mov_right_g:PUSH 	R1
			PUSH 	R2

			;Não comer barreiras, trocar direção, perder vida
		 	MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			INC		R1 ; Aumento em 1 o endereço do FANTASMA
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			CMP		R2, PAREDE ; Comparo para ver se ele é BARREIRA
			CALL.Z	Change_dir
			CMP		R2, PAREDE 
			JMP.Z	barreira5
			CMP		R2, PACMAN
			CALL.z	Per_vida
			CMP		R2, PACMAN
			JMP.Z   barreira5

			;Pega a proxima posição é armazena em uma variável
			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			INC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			MOV		M[prox_posg], R2 


			;Atualizar o endereço do fantasma
  			MOV		R1, M[ggend]
			MOV 	R2, M[prox_posg]
			MOV     M[R1], R2
			INC		M[ggend]
			MOV		R1, M[ggend]
			MOV 	R2, FANTASMA
			MOV     M[R1], R2

			
			; Atualizar o fantasma na tela

			;Atualizar a posição original
			MOV		R1, M[ gglin ] ;linha onde está o FANTASMA
			MOV		R2, M[ ggcol ] ;coluna onde está o FANTASMA
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, M[prox_posg]
			MOV		M[ IO_WRITE ], R1

			;Coloca o fantasma na proxima posição 
			INC 	M[ ggcol ]
			MOV		R1, M[ gglin ]
			MOV		R2, M[ ggcol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, FANTASMA
			MOV		M[ IO_WRITE ], R1

barreira5:	POP	    R2
			POP     R1
			RET

;------------------------------------------------------------------------------
; Mover Esquerda FANTASMA (1)
;------------------------------------------------------------------------------
Mov_left_g: PUSH R1
			PUSH R2

			;Não comer barreiras, trocar direção, perder vida
 			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			DEC		R1 ; Diminui em 1 o endereço do FANTASMA
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			CMP		R2, PAREDE ; Comparo para ver se ele é BARREIRA
			CALL.Z	Change_dir
			CMP		R2, PAREDE 
			JMP.Z	barreira6
			CMP		R2, PACMAN
			CALL.z	Per_vida
			CMP		R2, PACMAN
			JMP.Z   barreira6

			;Pega a proxima posição é armazena em uma variável
			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			DEC		R1 ; Aumento em 1 o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			MOV		M[prox_posg], R2 


			;Atualizar o endereço do fantasma
  			MOV		R1, M[ggend]
			MOV 	R2, M[prox_posg]
			MOV     M[R1], R2
			DEC		M[ggend]
			MOV		R1, M[ggend]
			MOV 	R2, FANTASMA
			MOV     M[R1], R2

			; Atualizar o fantasma na tela

			;Atualizar a posição original
			MOV		R1, M[ gglin ] ;linha onde está o FANTASMA
			MOV		R2, M[ ggcol ] ;coluna onde está o FANTASMA
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, M[prox_posg]
			MOV		M[ IO_WRITE ], R1

			;Coloca o fantasma na proxima posição 
			DEC 	M[ ggcol ]
			MOV		R1, M[ gglin ]
			MOV		R2, M[ ggcol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, FANTASMA
			MOV		M[ IO_WRITE ], R1
			

barreira6:	POP	    R2
			POP     R1
			RET

;------------------------------------------------------------------------------
; Mover UP FANTASMA (2)
;------------------------------------------------------------------------------
Mov_up_g:   PUSH R1
			PUSH R2


			;Não comer barreiras, trocar direção, perder vida
 			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			SUB     R1, LINHA ; Diminuo em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			CMP		R2, PAREDE ; Comparo para ver se ele é BARREIRA	
			CALL.Z	Change_dir
			CMP		R2, PAREDE 
			JMP.Z	barreira7
			CMP		R2, PACMAN
			CALL.z	Per_vida
			CMP		R2, PACMAN
			JMP.Z   barreira7
			

           ;Pega a proxima posição é armazena em uma variável
			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			SUB     R1, LINHA ; Diminuo em 81(linha) o endereço do fantasma
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			MOV		M[prox_posg], R2 


			; Atualizar o endereço do fantasma 
			MOV	    R1, M[ggend]
			MOV 	R2, M[prox_posg]
			MOV     M[R1], R2
			MOV	    R1, M[ggend] 
			SUB     R1, LINHA
			MOV	    M[ggend], R1
			MOV	    R1, M[ggend]
			MOV 	R2, FANTASMA
			MOV     M[R1], R2


			; Atualizar o fantasma na tela

			;Atualizar a posição original
			MOV		R1, M[ gglin ] ;linha onde está o PACMAN
			MOV		R2, M[ ggcol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, M[prox_posg]
			MOV		M[ IO_WRITE ], R1

			;Coloca o fantasma na proxima posição 
			DEC 	M[ gglin ]
			MOV		R1, M[ gglin ]
			MOV		R2, M[ ggcol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, FANTASMA
			MOV		M[ IO_WRITE ], R1

barreira7:	POP	    R2
			POP     R1
			RET

;------------------------------------------------------------------------------
; Mover DOWN FANTASMA (3)
;------------------------------------------------------------------------------
Mov_down_g: PUSH R1
			PUSH R2

			;Não comer barreiras, trocar direção, perder vida
 			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			ADD     R1, LINHA ; Diminuo em 81(linha) o endereço do pacman
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			CMP		R2, PAREDE ; Comparo para ver se ele é BARREIRA	
			CALL.Z	Change_dir
			CMP		R2, PAREDE 
			JMP.Z	barreira8
			CMP		R2, PACMAN
			CALL.z	Per_vida
			CMP		R2, PACMAN
			JMP.Z   barreira8
			

           ;Pega a proxima posição é armazena em uma variável
			MOV		R1, M[ ggend ] ; Adiciono o endereço da posição do FANTASMA
			ADD     R1, LINHA ; Diminuo em 81(linha) o endereço do fantasma
			MOV		R2, M[R1] ; Adiciono em R2 o conteudo do endereço do FANTASMA 
			MOV		M[prox_posg], R2 


			;Atualizar o endereço do fantasma
			MOV	    R1, M[ggend]
			MOV 	R2, M[prox_posg]
			MOV     M[R1], R2
			MOV	    R1, M[ggend] 
			ADD     R1, LINHA
			MOV	    M[ggend], R1
			MOV	    R1, M[ggend]
			MOV 	R2, FANTASMA
			MOV     M[R1], R2


			; Atualizar o fantasma na tela

			;Atualizar a posição original
			MOV		R1, M[ gglin ] ;linha onde está o PACMAN
			MOV		R2, M[ ggcol ] ;coluna onde está o PACMAN
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, M[prox_posg]
			MOV		M[ IO_WRITE ], R1

			;Coloca o fantasma na proxima posição 
			INC 	M[ gglin ]
			MOV		R1, M[ gglin ]
			MOV		R2, M[ ggcol ]
			SHL		R1, ROW_SHIFT
			OR   	R1, R2
			MOV		M[ CURSOR ], R1
			MOV 	R1, FANTASMA
			MOV		M[ IO_WRITE ], R1


barreira8:	POP	    R2
			POP     R1
			RET


;------------------------------------------------------------------------------
; Configurar os edereços dos FANTASMAS E PACMAN
;------------------------------------------------------------------------------
Config_Address: PUSH R1
                
				;Colocar o endereço do PACMAN
				MOV 	R1, M[pcend]
				ADD 	R1, L11 ; Endereço da Linha que ta PACMAN, + o 34 que é a coluna
				MOV 	M[pcend], R1
				MOV 	M[pcend_init], R1

                ;Colocar o endereço dos FANTASMAS
				MOV 	R1, M[g1end]
				ADD 	R1, L4 ; Endereço da Linha que ta PACMAN, + o 34 que é a coluna
				MOV 	M[g1end], R1
				
				MOV 	R1, M[g2end]
				ADD 	R1, L4 ; Endereço da Linha que ta PACMAN, + o 34 que é a coluna
				MOV 	M[g2end], R1

				MOV 	R1, M[g3end]
				ADD 	R1, L18 ; Endereço da Linha que ta PACMAN, + o 34 que é a coluna
				MOV 	M[g3end], R1
			
				MOV 	R1, M[g4end]
				ADD 	R1, L18 ; Endereço da Linha que ta PACMAN, + o 34 que é a coluna
				MOV 	M[g4end], R1

				POP R1
				RET

;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT
				
				MOV     R1, L1
				MOV		M[ TextIndex ], R1

				CALL 	Mapa

				CALL 	Config_Address

				CALL 	Config_timer


Cycle:			BR      Cycle
Halt:	        BR	    Halt