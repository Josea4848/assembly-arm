.section .data
	a: .word 3 //referenciando região da memória como 'a' e armazenando 3
	b: .word 4 //referenciando região da memória como 'b' e armazenando 4
	m: .word 10 //referenciando região da memória como 'm' e armazenando 10
	n: .word 0 //referenciando região da memória como 'n' e armazenando 0
.section .text
.global _start
_start:
	LDR r0,=a //r0 -> a, r0 armazena referencia para a
	LDR r1,=b //r1 -> b, r1 armazena referencia para b
	LDR r2,=m //r2 -> m, r2 armazena referencia para m
	LDR r3,=n //r3 -> n, r3 armazena referencia para n
	
	//registradores auxiliares
	LDR r8, [r1] //recebe valor de b
	LDR r9, [r2] //recebe valor de m

	CMP r8, r9  
	BGE senao //se b >= m, entra no else
	
	//reutilização dos registradores auxiliares
	LDR r8, [r3] //recebe valor de n
	LDR r9, [r0] //recebe valor de a
	
	CMP r8, r9
	BGE senao //se n >= a, entra no else
	
	//reutilizando um registrador temporário, r8 recebe conteúdo de r1
	LDR r8, [r1]
	
	//n = b
	STR r8, [r3]
	B end
//subrotina do else
senao:
	//r8 recebe conteúdo de r2 (m)
	LDR r8, [r2]
	//n = m
	STR r8, [r3]
end:
	MOV r7, #1 //syscal para indicar encerramento do programa
	SWI 0 //interrupção para encerramento do programa
