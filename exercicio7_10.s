.section .data
	//array A
	A: .word -1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101
	//array B
	B: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101
	//constante c
	C: .word 10
	//i
	i: .word 0
.global _start
.section .text
_start:
	LDR r0,=A //referencia A
	LDR r1,=B //referencia B
	LDR r2,=C //referencia C
	LDR r2,[r2] //recebe conteúdo de C
	
	LDR r3,=i //referencia I
	LDR r4,[r3] //armazena conteúdo de i
	LDR r8,[r3] //indíce que anda de 4 em 4 bytes	

	MOV r10, #4 //constante 4
	MUL r8, r4, r10 //inicia com valor inicial
	
	//branch for
	B for
	
//subrotina para loop
for:
	CMP r4, #100 //compara i com 100
	BGT fim_do_loop //se i > 100, i não é mais <= 100
	
	//carregando dados necessários
	LDR r5, [r0, r8] //r5 = A[i]
	LDR r6, [r1, r8] //r6 = B[i]
	
	//if verificar se A[i] < B[i] && A[i] != 0  e utilizando do conceito de curto circuito
	CMP r5, r6 //se A[i] >= B[i] branch pro else
	BGE else //se for, branch pro else
	
	//se chegou aqui, o primeiro operando deu true
	CMP r5, #0 //A[i] != 0, se sim, branch do if true
	BNE if_true
	
	//se chegou aqui o último operando deu false, e branch para else
	B else

//se for verdade
if_true:
	ADD r5, r6, r2 //reutilizando r5, pois seu conteúdo não é mais necessário
	B incrementa_e_muda

//else 
else: 
	SUB r5, r6, r2 //reutilizando r5, pois seu conteúdo não é mais necessário
	B incrementa_e_muda
	
//altera A[i] e incrementa i
incrementa_e_muda:
	STR r5, [r0, r8] 
	ADD r4, r4, #1 //indice normal
	ADD r8, r8, #4 //indice que anda de 4 em 4 bytes
	B for

//fim do loop
fim_do_loop:
	B end
	
//fim
end:
	STR r4, [r3] //atualiza valor de i
	
	//se for em simulador qemu
	//MOV r7, #1 //syscall para fim
	//SVC 0 //interrupção para tal
	B end