.section .data
	entrada: 
		.ascii "00000000000000000000000001001111\n\0" //string
		size= .-entrada //obtem tamanho da string de entrada com \0 
	saida: //saída será o retorno
		.space 1
		
.global _start
.section .text
_start:
	//BL print, só utilizar em simulador raspberry no qemu

	LDR r0,=entrada //r0 referencia entrada
	LDR r1,=size //r1 recebe o tamanho da string

	SUB r1, r1, #3 //r1 agora recebe o último index disponível antes do \0
	
	LDRB r2, [r0, #0] //carrega primeiro caracter da string (bit mais significativo)
	
	//compara com 1
	CMP r2, #49
	BEQ numero_negativo //se o primeiro bit for 1, temos um número negativo

	B continuacao
	
//irá transformar o número negativo (c2) em binário, começará do menos significativo
numero_negativo:
	CMP r1, #0 //quando o índice for menor que 0, será o fim da iteração
	BLT continuacao
	
	LDRB r2, [r0, r1] //carrega caractere
	
	//iremos verificar a primeira ocorrência de um bit, após ele iremos inverter os demais
	CMP r2, #49 
	BEQ inverte //se for 1, os próximos bits serão invertidos
	
	//se chegou aqui é pq não é 1
	CMP r2, #48
	BNE erro //se for diferente de 0 -> erro
	
	SUB r1, r1, #1 //subtrai o index
	
	B numero_negativo //próxima iteração
	
//inverte bits	
inverte:
	//subtrai o index
	SUB r1, r1, #1
	
	CMP r1, #0 //se for menor que 0 -> fim
	BLT continuacao
	
	LDRB r2, [r0, r1] //carrega caractere
	
	CMP r2, #48 //compara com zero 
	BEQ inverte_0 //se igual
	
	CMP r2, #49//compara com um
	BEQ inverte_1 //se igual
	
	//se chegou aqui, não é 0 nem 1 -> informação inválido
	B erro
	
inverte_0:
	MOV r5, #49 //registrador temporário para receber 1 
	STRB r5, [r0, r1] 
	B inverte //próxima iteração
	
inverte_1:
	MOV r5, #48 //registrador temporário para receber 0
	STRB r5, [r0, r1]
	B inverte //próxima iteração

//erro
erro:
	B end

//função que exibi entrada
print:
	MOV r0,#1
	LDR r1,=entrada
	LDR r2,=size
	
	MOV r7, #4
	SVC 0
	
	BX LR	
	
	
/*
	r1 -> índice (31, ..., 0)
	r2 -> bit[r1]
	r4 -> índice (0, ..., 31)
	r8 -> valor em decimal (ficará somando)
*/

binario_to_decimal:
	CMP r1, #0
	BLT verifica_valor_valido //chegou ao fim, bastando apenas verificar se é um valor válido ou não

	LDRB r2, [r0, r1] //carrega bit, do menos significativo para o mais	
	
	//pegando número associado ao caracter -> 0 ou 1 (48 - 48 ou 49 - 48)
	SUB r2, r2, #48
	
	MOV r4, #31 //recebe 31 temporariamente
	SUB r4, r4, r1 //passa a ser um índice começando do 0...31
	
	MOV r5, #1 //registrador auxiliar apenas para receber 1
	
	//se for 0, não precisamos multiplicar 2^n*0
	CMP r2, #1
	BEQ dois_elevado
	
	SUB r1, r1, #1 //diminui o r1, (decresce)
	B binario_to_decimal

dois_elevado:	//2^n
	CMP r4, #0
	BEQ soma_decimal
	
	MOV r10, r5 //r10 é um registrador auxiliar, pois algumas arquiteturas não suportam MUL Rd, Rd, Rn
	MOV r9, #2 //r9 apenas recebe 2, é constante
	MUL r5, r10, r9 //2*n
	
	SUB r4, r4, #1 //diminui índice
	B dois_elevado
	
	
soma_decimal:
	MOV r10, r5 //r10 é um registrador auxiliar, pois algumas arquiteturas não suportam MUL Rd, Rd, Rn
	MUL r5, r10, r2 //produto: 2^n*bit
	ADD r8, r8, r5 //soma 
	SUB r1, r1, #1 //diminui o r1, (decresce)
	B binario_to_decimal

continuacao:
	//BL print
	
	LDR r1,=size //novamente pegando o tamanho
	SUB r1, r1, #3 //pegando último index disponível
	MOV r8, #0 //receberá valor decimal
	
	B binario_to_decimal
	
valor_invalido:
	MOV r1, #1 //em caso de valor inválido, coloco o valor 1 no r1
	B end
	
verifica_valor_valido:
	//com o valor calculado (r8), basta verificar se está na tabela ascii
	CMP r8, #256
	BGE valor_invalido //se for maior ou igual a 256, valor inválido

	//se chegou aqui é pq o valor é válido
	LDR r1,=saida //referencia saída
	STRB r8, [r1, #0] //armazena caractere ascii na saída
	B end //fim

end:
	//BL print, só utilizar em simulador raspberry no qemu
	
	MOV r7, #1
	SVC 0
