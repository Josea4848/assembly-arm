.section .data
	i: .word 0//int i;
	A: .word 0,0,0,0,0,0,0,0,0,0 //inicializei para não ter problema de valores aleatórios

.global _start
.section .text
_start:
	MOV r0, #0 //r0 será o i, não irei ficar atualizando I na memória toda vez para não aumentar o custo de tempo
	//no fim passarei o valor atualizado para i
	MOV r3, #0 //registrador auxiliar para passar de 4 em 4 bytes
	
	
	LDR r2,=A //r1 referencia A 
	B for
	
for:
	//se r0 (i) for maior ou igual que 10, o loop está encerrado
	CMP r0, #10
	BGE end
	
	//senão
	LDR r1, [r2, r3] //carregará o valor de índice r0 no vetor A -> A[i] no registrador r1
	ADD r1, r1, #1 //Essa operação equivale a soma -> A[i] + 1 e volta pra r1 (reutilizando registrador)
	STR r1, [r2, r3] //Passamos o valor da operação para o elemento de índice r0 no vetor -> A[i] = A[i] + 1

	ADD r0, r0, #1 //índice de controle (0, 1, 2, 3, ...)
	ADD r3, r3, #4 //índice para acesso e manipulação da memória (0, 4, 8, 12, ...)
	
	B for
//finaliza o programa
end:
	//por fim, agora atualizarei o valor de i na memória
	LDR r1,=i //r1 agora referencia i
	STR r0, [r1] //atualizando região de memória
	
	MOV r7, #1 //syscall para finalizar
	SVC 0 //interrupção