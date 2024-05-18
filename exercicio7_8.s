.section .data
	palavra: 
		.asciz "ola mundo" //string da palavra	
		tamanho= .-palavra //tamanho da string com \0
	x: .asciz "i" //caracter a procurar
	y: .asciz "u" //caracter que irá substituir
	
.global _start
.section .text
_start:
	LDR r0,=palavra	//r0 referencia 'palavra'
	LDR r1,=tamanho //será temporário para verificar o tamanho da palavra
	
	//se for igual a 1, temos apenas \0, ou seja, uma string vazia
	CMP r1, #1
	BEQ end
	
	LDR r1,=x //r1 referencia x
	LDRB r1, [r1, #0] //r1 recebe conteúdo de x
	
	LDR r2,=y //r2 referencia y
	LDRB r2, [r2, #0] //r3 recebe conteúdo de y
	
substitui:
	MOV r3, #0 //será o index de controle para o loop
	B loop

loop:
	LDRB r4, [r0, r3] //carrega primeiro caracter 
	
	CMP r4, #0 //compara com o caracter nulo (\0)
	BEQ end //se for igual, fim de loop
	
	CMP r4, r1 //compara com o caracter que queremos substituir 
	BEQ muda_de_x_para_y //se for igual, iniciamos procedimento de substituição
	
	//senão, incrementamos o index e chamamos o loop de volta
	B incrementa_index
	
//realiza a troca do char com valor x para valor y
muda_de_x_para_y:	
	STRB r2, [r0, r3] //substituimos o caracter com o valor de x para o valor de y
	B incrementa_index

incrementa_index:
	ADD r3, r3, #1 //i++
	B loop


end:
	MOV r7, #1 //syscall para encerramento
	SVC 0 //interrupção para tal 

