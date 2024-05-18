//utilizando memória principal para criar duas regiões de tamanho word
.data
	numero1: .word 0 //primeiro número
	numero2: .word -3 //segundo número
	result: .word //variável result, receberá o resultado
.global _start
.section .text
_start:
	LDR r1,=numero1 //r1 referencia numero1
	LDR r1,[r1] //r1 recebe uma cópia do valor/conteúdo de numero1
	
	LDR r2,=numero2 //r2 referencia numero2
	LDR r2,[r2] //r2 recebe uma cópia do valor/conteúdo de numero2
	
	LDR r3,=result
	MOV r0, #0 //registrador auxiliar para fazer soma ou subtração dependendo do sinal dos operandos
	
	CMP r1, #0
	BNE op1_dif_0 //se o 1º operando for igual a zero, iremos pular os loops
	B end

//1º operando é diferente de 0
op1_dif_0:	
	//dependendo do sinal do segundo operando, vai ser um loop positivo ou negativo
	CMP r2, #0
	BGT loop_positivo //segundo operando maior que 0, loop positivo (decrescente)
	BLT loop_negativo //segundo operando menor que 0, loop negativo (crescente)
	B end
	
//loop crescente, segundo operando < 0
loop_negativo:
	SUB r0, r0, r1 //decremento com o valor do primeiro operando ao registrador auxiliar (que inicialmente é 0)
	ADD r2, r2, #1 //incrementa 1
	
	CMP r2, #0 //verifica se o r2 (que representa o segundo operando) chegou em 0
	BNE loop_negativo //se for diferente chama o loop novamente
	
	B end //se chegou aqui é porque r2 chegou a zero, a operação está concluída

//loop decrescente, segundo operando > 0
loop_positivo:	
	ADD r0, r0, r1 //incrementa o valor do primeiro operando ao registrador auxiliar
	SUB r2, r2, #1 //decrementa 1
	
	CMP r2, #0 //verifica se o r2 (que representa o segundo operando) chegou em 0
	BNE loop_positivo //se for diferente chama o loop novamente
	
//branch de fim
end:
	//passando valor de r0 (auxiliar) a result
	STR r0, [r3]
	
	//encerra programa
	MOV r7, #1
	SWI 0
