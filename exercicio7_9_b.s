.section .data
	i: .word 0
	A: .word 1,1,1,1,1,1,1,1,1,1
	
.global _start
.section .text
_start:
	LDR r0,=A //r0 referencia A 
	
	LDR r1,=i //r1 referencia i (temporariamente), pois não irei realizar acesso a memória toda vez
	LDR r1, [r1] //r1 recebe conteúdo de i
	
	MOV r5, #0 //index de inteiro (0, 1, 2, 3, ...)
	
	B for //branch para o for

for:
	CMP r5, #10 //verificar se o index é menor que 40 (i < 10*4bytes)
	BGE end //se for maior igual que 10 (i >= 10) fim do loop
	
	//verificando se é par ou ímpar por meio do bit menos significativo
	AND r3, r5, #1  
	
	//carrega valor para r2
	LDR r2, [r0, r1]
	
	//verificando bit menos significativo
	CMP r3, #0
	BEQ if_par //se for igual a 0, é par, entramos no if
	BNE else //se for ímpar vai para o else
	
//se for par	
if_par:
	MOV r3, r1 //registrador auxiliar que irá pegar o índice + 1*4bytes
	ADD r3, r3, #4 

	//carrega A[i+1]
	LDR r3, [r0, r3]
	
	ADD r3, r2, r3 //receberá a operação: A[i] + A[i + 1]
	
	B atribui
	
//se é ímpar
else:
	MOV r3, #2
	MUL r3, r2, r3 //A[i]*2	
	B atribui

//ATRIBUI PARA A[I]
atribui:
	STR r3, [r0, r1] //armazena o valor em A[i]
	ADD r1, r1, #4 //adiciona 1*4bytes
	ADD r5, r5, #1 //adiciona +1 no index de inteiro
	
	B for

//fim
end:
	LDR r1,=i //referencia i
	STR r5, [r1] //armazena conteúdo de r5 em i
	MOV r7, #1
	SVC 0