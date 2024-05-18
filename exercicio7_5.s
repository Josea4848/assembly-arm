.section .data
	s: .word 9 //s
	n: .word 10 //n
	COMB: .word 34 //COMB

.global _start
.section .text
_start:
	LDR r0,=n //r0 referencia n
	LDR r0,[r0] //r0 recebe conteúdo de n
	
	LDR r1,=s //r1 referencia s
	LDR r1,[r1] //r1 recebe conteúdo de s
	
	//Se n ou s forem negativos
	CMP r0, #0
	BLT s_ou_n_negativo //n < 0
	BEQ s_ou_n_igual_0 //n == 0	
	
	CMP r1, #0
	BLT s_ou_n_negativo //s < 0
	BEQ s_ou_n_igual_0 //s == 0 
	
	//comparar se s é maior que n
	CMP r1, r0
	BGT s_maior_que_n //se s for maior
	
continua:
	//cálculo de n! e armazenamento em r4
	BL fatorial //calcula n!

	MOV r4, r1 //armazena n! em r4 (que representará COMB)
	//================================================
	
	//cálculo de s! e armazenamento em r0
	LDR r0,=s
	LDR r0,[r0] //carrega conteúdo de s
	BL fatorial //calcula s!
	
	MOV r5, r1 //armazenando n! em r5
	//===============================================
	
	//cálculo de (n - s)!
	LDR r0,=n 
	LDR r0,[r0] //carrega n
	
	LDR r1,=s 
	LDR r1,[r1] //carrega s
	
	SUB r0, r0, r1 //r0 agora recebe (n - s)
	BL fatorial //calcula (n - s)!
	
	MOV r6, r1 //r6 recebe (n - s)!
	
	//n!/s!
	MOV r0, r4 //dividendo
	MOV r1, r5 //divisor
	MOV r2, #0 //quociente (inicialmente com 0)
	BL div

	//n!/s!/(n-s)!
	MOV r0, r2 //dividendo = n!/s!
	MOV r1, r6 //divisor
	MOV r2, #0 //quociente
	BL div
	
	//armazenando resultado em COMB
	LDR r0,=COMB
	STR r2,[r0]
	
	B end


//s maior que n
s_maior_que_n:
	MOV r9, #1 
	B erro
	
//se e/ou n negativos
s_ou_n_negativo:
	MOV r9, #2
	B erro

//s igual a n
s_igual_n:
	MOV r9, #3
	B continua

//n e\ou s igual a 0
s_ou_n_igual_0:
	MOV r9, #4
	
	//verifica se n é menor que s -> se for, erro
	CMP r0, r1
	BLT erro
		
	//se chegou aqui, tudo certo
	B continua

//não podemos calcular o fatorial se chegamos aqui
erro:
	B end

//cálculo de fatorial
fatorial:
	PUSH {fp, lr} //push na pilha 
	ADD fp, sp, #4 //atualizando ponteiro do bottom da pilha
	
	//caso básico
	CMP r0, #0
	BEQ return_1
	CMP r0, #1
	BEQ return_1
	
	//caso recursivo	
	PUSH {r0}
	SUB r0, r0, #1
	BL fatorial
	POP {r0}
	
	MUL r1, r0, r1
	
	POP {fp, pc}

//retorna 1 para r1
return_1:
	MOV r1, #1
	POP {fp, pc}


/*
	para div:
		r0 - dividendo
		r1 - divisor
		r2 - quociente (inicialmente é 0)
*/
div:
	CMP r0, r1 //comparando dividendo com divisor
	BLT return_quociente //se o dividendo for menor que o divisor -> fim de operação
	
	SUB r0, r0, r1 //subtrai do dividendo 
	ADD r2, r2, #1 //incrementa coeciente
	B div
	
return_quociente:
	BX LR//fim da divisão -> retorna resultado em r2
	
end:
	//por fim copiamos o valor de r9 para v1
	MOV v1, r9 
	
	//syscall para encerramento
	MOV r7, #1 
	SVC 0
	
