//definindo região de dados
.section .data
	a: .word 4 //a recebe 4
	b: .word 3 //b recebe 3
	x: .word 0 //x inicia com 0

.section .text
.global _start
_start:
	LDR r2,=a //r2 é um registrador auxiliar que referencia 'a'
	LDR r0,[r2] //r0 recebe o conteúdo de 'a'
	LDR r2,=b //r2 agora referencia b
	LDR r1,[r2] //r1 agora recebe conteúdo de b
	LDR r2,=x //reutilizando r2 para referenciar 'x'
	MOV r5, #0 //r4 apenas recebe 0 e passa para i
	STR r5,[r2] //atualiza valor de x
	
	//Início de comparações utilizando curto-circuito
	CMP r0, #0 //compara 'a' e '0'
	BLT end //se 'a' < 0, logo a não é maior ou igual a 0
	CMP r1, #50 //compara 'b' e '50'
	BGT end //se 'b' > 50, logo b não é menor ou igual a 50
	
	//se chegou aqui, o  if deu true
	MOV r0, #1 //reutilizando um registrador agora inútil
	STR r0, [r2] //passando 1 para x
end:
	MOV r7, #1 //passando 1 para encerramento através de uma chamada ao sistema
	SWI 0 //interrupção	
