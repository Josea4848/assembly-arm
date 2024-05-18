//região da memória principal
.section .data
	vetorX: .space 64
	numeroDe1: .word 0

	prompt: .asciz "Digite o valor: "
	len= .-prompt

	saida: .asciz "Quantidade de 1: %d\n"
//global como _start
.global _start
//.extern printf
.section .text
_start:
	//Exibe prompt BEGIN
	MOV r0, #1
	LDR r1,=prompt
	LDR r2,=len

	MOV r7, #4
	SVC 0
	//Exibe prompt END


	//Entrada para o vetor
	MOV r0, #0 //chamada do sistema para entrada
	LDR r1,=vetorX //r1 referencia vetorX
	MOV r2, #64 //tamanho do buffer de entrada
	
	MOV r7, #3 //sycall
	SVC 0
	//Entrada Fim

	LDR r1,=vetorX	
	MOV r2, #0 //r2 será para controle de index
	MOV r3, #0 //r3 será um registrador auxiliar para a contagem, só depois dará STR em numeroDe1
	B loop //branch para loop

//percorrerá o vetorX
loop:
	//verificação de fim de loop (se index for maior que 63 -> branch para o fim)
	CMP r2, #63
	BGT end
	
	LDRB r4, [r1, r2] //carrega exatamente um elemento do vetor de bytes
	
	//compara com 1
	CMP r4, #49
	BEQ incrementa //se for igual de 1, branch para incrementar no contador
	
	//incrementa +1 no index
	ADD r2, r2, #1 
	
	//chama a si novamente
	B loop

//branch que incrementa no registrador auxiliar
incrementa:
	ADD r3, r3, #1
	
	//incrementa +1 no index
	ADD r2, r2, #1 
	//chama a si novamente
	B loop

print:
	push {ip, lr} //adicionando para pilha
	LDR r0,=saida //r0 referencia saída
	MOV r1, r3 //passando valor da quantidade de 1's para r1
		
	bl printf
	pop {ip, pc} //voltando ao valor original

	BX LR

end:
	LDR r1,=numeroDe1 //referenciando a saida numeroDe1 
	STR r3, [r1] //armazenando a quantidade de ocorrencias de 1 na regiao de memoria	
	//BL print //apenas para exibir
	MOV r7, #1
	SVC 0


//instrução para compilar -> diferente do normal
//gcc -o nomeSaida nome.s -nostartfiles
