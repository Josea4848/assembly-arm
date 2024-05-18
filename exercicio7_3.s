//alocando na memória principaç
.section .data
	entrada: 
		.asciz "Vasco" //conteúdo de entrada
		size = .-entrada //tamanho de entrada (com \0)
	saida:
		.space size //definindo região para string de saída
		
.global _start
.section .text
_start:
	LDR r0,=entrada //referencia entrada
	LDR r5,=size //recebe tamanho da string de entrada
	LDR r1,=saida //referencia saída
	
	SUB r5, r5, #1 //pega o index do último elemento (\0)
	LDRB r3, [r0, r5] //pega o \0 em código ascii e guarda r3 
	STRB r3, [r1, r5] //armazena \0 na última posição
	
	SUB r5, r5, #1 //pega index do último elemento antes do '\0', descrescente
	MOV r6, r5 //registrador auxiliar para ajudar na escrita da string de saída (será constante)
	
//passa de caractere em caractere
loop:
	CMP r5, #0 //se r5 for menor que 0, percorremos toda a string
	BLT end //fim do loop
	
	LDRB r3, [r0, r5] //pega caractere com índice r5, começamos pelo último caractere
	
	//primeira veficação para vê se é uma letra = if(r3 < 65 || r3 > 122) -> não é letra!
	CMP r3, #65 //se r3 < 65
	BLT end_erro
	CMP r3, #90 //se r3 <= 90, então temos uma uma letra maiúscula
	BLE mai_to_min
	
	//se chegamos aq é pq r3 > 90, podendo ser uma letra minúscula ou não
	CMP r3, #97
	BLT end_erro //se for menor que 97, então não é letra
	CMP r3, #122
	BGT end_erro //se for maior que 122, então não é letra
	
	//se chegamos aqui, então temos uma letra minúscula, basta apenas converter em maiúscula	
	SUB r3, r3, #32 //subtrai 32 para chegar na maiúscula
	B insere
	
//transforma maiúsculo em minúsculo	
mai_to_min:
	ADD r3, r3, #32 //soma 32 para chegar na minúscula
	B insere
	
//insere char em saida
insere:
	SUB r4, r6, r5 //r4 será um registrador auxiliar para index da string de saída
	STRB r3, [r1, r4] //insere na string de saída o caracter
	SUB r5, r5, #1 //diminui em 1 o index da string de entrada
	B loop
//encerramento do programa por erro
end_erro:
	MOV r1, #1

end: //encerramento geral
	MOV r7, #1
	SVC 0
