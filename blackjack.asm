# Jozias Martini
# 2211101004

.data
# Mensagens para interação com o jogador
MSG_WELCOME:        .string "\nBem-vindo ao Blackjack!\n"           # Mensagem de boas-vindas
MSG_TOTAL_CARDS:    .string "\nTotal de Cartas: "                    # Exibe o total de cartas restantes no baralho
MSG_PLAYER_SCORE:   .string "  Vitórias do Jogador: "                # Exibe o total de vitórias do jogador
MSG_DEALER_SCORE:   .string "  Vitórias do Dealer: "                 # Exibe o total de vitórias do dealer
MSG_SCORE_LABEL:    .string "\nPlacar Atual:\n"                      # Label para mostrar o placar
MSG_PLAYER_CARDS:   .string "\nO jogador recebe: "                   # Exibe as cartas iniciais do jogador
MSG_DEALER_CARD:    .string "\nO dealer revela: "                    # Exibe a carta revelada do dealer
MSG_OCCULT_CARD:    .string " e uma carta oculta\n"                   # Indica a carta oculta do dealer
MSG_YOUR_HAND:      .string "Sua mão: "                              # Label para mostrar o valor total da mão do jogador
MSG_CHOICE:         .string "\nO que você deseja fazer? (1 - Hit, 2 - Stand): "  # Pergunta ao jogador ação a tomar
MSG_WIN:            .string "\nVocê ganhou!\n"                       # Mensagem para vitória do jogador
MSG_LOSE:           .string "\nDealer ganhou!\n"                     # Mensagem para vitória do dealer
MSG_DRAW:           .string "\nEmpate!\n"                            # Mensagem para empate
MSG_AGAIN:          .string "\nDeseja jogar novamente? (1 - Sim, 2 - Não): "     # Pergunta se quer jogar outra vez
MSG_DEALER_FINAL:   .string "\nMão final do dealer: "                # Exibe a mão final do dealer
AND:                .string " e "                                    # Conector para listar cartas
PLUS:               .string " + "                                    # Símbolo de soma para exibir somas de cartas
EQUAL:              .string " = "                                    # Símbolo de igual para exibir resultado da soma
NEWLINE:            .string "\n"                                     # Quebra de linha para formatação

.align 2
# Variáveis globais para controle do jogo
total_cards:        .word 52                 # Total de cartas restantes no baralho (52 inicialmente)
card_counters:      .word 0,0,0,0,0,0,0,0,0,0,0,0,0   # Contador para cada tipo de carta (13 tipos, 4 cartas cada)
player_score:       .word 0                  # Contador de vitórias do jogador
dealer_score:       .word 0                  # Contador de vitórias do dealer
player_hand:        .space 208                # Espaço reservado para cartas do jogador (não utilizado detalhadamente aqui)
dealer_hand:        .space 208                # Espaço reservado para cartas do dealer (idem)
player_hand_count:  .word 0                   # Quantidade de cartas na mão do jogador
dealer_hand_count:  .word 0                   # Quantidade de cartas na mão do dealer

.text
.globl main

main:
    # Exibe mensagem de boas-vindas
    li a7, 4                # syscall para imprimir string
    la a0, MSG_WELCOME      # endereço da mensagem
    ecall
    j play_game             # inicia o jogo

exit:
    li a7, 10               # syscall para sair do programa
    ecall

play_game:
    # Mostra total de cartas e placar atual
    call show_cards_and_score

    # Executa uma rodada do jogo
    call play_round

    # Volta para o início para nova partida
    j main

show_cards_and_score:
    # Imprime total de cartas restantes
    li a7, 4
    la a0, MSG_TOTAL_CARDS
    ecall

    la t0, total_cards
    lw t1, 0(t0)            # carrega total_cards
    mv a0, t1
    li a7, 1                # syscall print inteiro
    ecall

    # Quebra de linha
    li a7, 4
    la a0, NEWLINE
    ecall

    # Imprime label "Placar Atual:"
    li a7, 4
    la a0, MSG_SCORE_LABEL
    ecall

    # Exibe vitórias do dealer
    li a7, 4
    la a0, MSG_DEALER_SCORE
    ecall
    la t0, dealer_score
    lw a0, 0(t0)
    li a7, 1
    ecall

    # Quebra de linha
    li a7, 4
    la a0, NEWLINE
    ecall

    # Exibe vitórias do jogador
    li a7, 4
    la a0, MSG_PLAYER_SCORE
    ecall
    la t0, player_score
    lw a0, 0(t0)
    li a7, 1
    ecall

    # Quebra de linha
    li a7, 4
    la a0, NEWLINE
    ecall

    ret                     # retorna para o chamador

play_round:
    # Inicializa somatórios das mãos do jogador (s0) e dealer (s1)
    li s0, 0
    li s1, 0

    # Jogador recebe duas cartas
    call draw_card          # primeira carta jogador
    mv s2, a0               # guarda carta na s2
    add s0, s0, a0          # soma ao total jogador

    call draw_card          # segunda carta jogador
    mv s3, a0               # guarda carta na s3
    add s0, s0, a0          # soma ao total jogador

    # Dealer recebe duas cartas
    call draw_card          # primeira carta dealer
    mv s4, a0               # guarda carta na s4
    add s1, s1, a0          # soma ao total dealer

    call draw_card          # segunda carta dealer
    mv s5, a0               # guarda carta na s5
    add s1, s1, a0          # soma ao total dealer

    # Exibe as cartas do jogador
    li a7, 4
    la a0, MSG_PLAYER_CARDS
    ecall
    li a7, 1
    mv a0, s2               # imprime primeira carta jogador
    ecall
    li a7, 4
    la a0, AND              # imprime " e "
    ecall
    li a7, 1
    mv a0, s3               # imprime segunda carta jogador
    ecall

    # Exibe a carta revelada do dealer e uma oculta
    li a7, 4
    la a0, MSG_DEALER_CARD
    ecall
    li a7, 1
    mv a0, s4               # imprime carta visível dealer
    ecall
    li a7, 4
    la a0, MSG_OCCULT_CARD  # indica carta oculta
    ecall

    # Quebra de linha
    li a7, 4
    la a0, NEWLINE
    ecall

    # Exibe a soma da mão do jogador
    li a7, 4
    la a0, MSG_YOUR_HAND
    ecall
    li a7, 1
    mv a0, s2
    ecall
    li a7, 4
    la a0, PLUS
    ecall
    li a7, 1
    mv a0, s3
    ecall
    li a7, 4
    la a0, EQUAL
    ecall
    add t0, s2, s3          # soma cartas do jogador
    li a7, 1
    mv a0, t0
    ecall

    j player_turn           # passa para turno do jogador

player_turn:
    # Limite máximo de pontos antes de bust (estourar)
    li t1, 21
    bgt s0, t1, check_result  # se jogador estourou, verifica resultado

ask_input:
    # Pergunta ao jogador o que deseja fazer (Hit ou Stand)
    li a7, 4
    la a0, MSG_CHOICE
    ecall
    li a7, 5                # syscall para ler inteiro do usuário
    ecall

    # Se opção for Hit (1), continua jogador pedindo carta
    li t2, 1
    beq a0, t2, player_hit_loop

    # Se opção for Stand (2), verifica resultado
    li t2, 2
    beq a0, t2, check_result

    # Se opção inválida, pergunta novamente
    j ask_input

player_hit_loop:
    call draw_card           # jogador recebe carta
    add s0, s0, a0          # soma ao total jogador

    # Exibe nova soma da mão do jogador
    li a7, 4
    la a0, MSG_YOUR_HAND
    ecall
    li a7, 1
    mv a0, s0
    ecall
    li a7, 4
    la a0, NEWLINE
    ecall

    j player_turn            # volta para decisão do jogador

check_result:
dealer_loop:
    # Dealer deve continuar comprando cartas até atingir pelo menos 17
    li t1, 17
    bge s1, t1, analyze_result  # se dealer >= 17, verifica resultado

    call draw_card           # dealer compra carta
    add s1, s1, a0          # soma ao total dealer
    j dealer_loop            # repete enquanto dealer < 17

analyze_result:
    # Exibe mão final do dealer
    li a7, 4
    la a0, MSG_DEALER_FINAL
    ecall
    li a7, 1
    mv a0, s4               # primeira carta dealer
    ecall
    li a7, 4
    la a0, PLUS
    ecall
    li a7, 1
    mv a0, s5               # segunda carta dealer
    ecall
    li a7, 4
    la a0, EQUAL
    ecall
    add t0, s4, s5          # soma cartas iniciais dealer
    li a7, 1
    mv a0, t0
    ecall
    li a7, 4
    la a0, NEWLINE
    ecall

    # Verifica resultado do jogo
    beq s0, s1, is_draw          # empate se pontuações iguais

    li t2, 21
    bgt s0, t2, dealer_wins      # jogador estourou -> dealer vence
    bgt s1, t2, player_wins      # dealer estourou -> jogador vence
    bgt s0, s1, player_wins      # jogador maior que dealer -> jogador vence
    bgt s1, s0, dealer_wins      # dealer maior que jogador -> dealer vence

is_draw:
    # Mensagem de empate
    li a7, 4
    la a0, MSG_DRAW
    ecall
    call ask_play_again          # pergunta se quer jogar novamente

dealer_wins:
    # Incrementa placar do dealer e exibe mensagem
    la t0, dealer_score
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li a7, 4
    la a0, MSG_LOSE
    ecall
    call ask_play_again

player_wins:
    # Incrementa placar do jogador e exibe mensagem
    la t0, player_score
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    li a7, 4
    la a0, MSG_WIN
    ecall
    call ask_play_again

ask_play_again:
    # Pergunta se o jogador quer jogar novamente
    li a7, 4
    la a0, MSG_AGAIN
    ecall
    li a7, 5
    ecall
    li t0, 1
    beq a0, t0, play_game    # Se sim, começa novo jogo
    j exit                   # Se não, sai do programa

draw_card:
draw_loop:
    # Gera um número aleatório entre 1 e 12 (valor da carta)
    li a0, 0
    li a1, 12
    li a7, 42                # syscall 42 para random (assumindo ambiente que suporta)
    ecall
    addi a0, a0, 1          # ajusta para valor de 1 a 12

    # Verifica se ainda há cartas disponíveis deste tipo
    la t0, card_counters
    addi t1, a0, -1
    slli t1, t1, 2          # desloca para índice no array (4 bytes por palavra)
    add t2, t0, t1          # endereço do contador da carta sorteada
    lw t3, 0(t2)            # lê contador atual

    li t4, 4                # limite máximo de 4 cartas por tipo
    bge t3, t4, draw_loop   # se já esgotou, sorteia outra carta

    # Incrementa contador de cartas do tipo sorteado
    addi t3, t3, 1
    sw t3, 0(t2)

    # Atualiza total de cartas restantes
    la t5, total_cards
    lw t6, 0(t5)
    addi t6, t6, -1
    sw t6, 0(t5)

    ret                     # retorna valor da carta no registrador a0
