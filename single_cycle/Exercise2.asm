.macro push %a
    addi sp, sp, -4
    sw   %a, 0(sp) 
.end_macro

.macro pop %a
    lw   %a, 0(sp) 
    addi sp, sp, 4
.end_macro
 
lui  s1, 0xFFFFF
lw   s0, 0x70(s1)           # Read switches

FUNC_SWITCH:
	lui  s1, 0xFFFFF
	lw   s0, 0x78(s1)
	addi t6 zero 7
	and s0 s0 t6
	beq s0 zero no_button
	sw   s0, 0x60(s1)           # Write LEDs
	sw   s0, 0x00(s1)           # Write 7-seg LEDs
	jal DELAY
no_button:	lw   s0, 0x70(s1)           # Read switches ���������ص�����
    	#sw   s0, 0x60(s1)           # Write LEDs
        #sw   s0, 0x00(s1)           # Write 7-seg LEDs
	add a1 zero s0
	srli t0, a1, 21
	li s1, 0x0000ff00
	and  t1, s1, a1
	srli t1, t1, 8
	li s1, 0x000000ff
	and t2, a1, s1
	# op_code in t0, A in t1, B in t2
	beq t0 zero FUNC_SWITCH
	addi s0, zero, 1
	beq t0, s0, ADD
	addi s0, s0, 1
	beq t0, s0, SUB
	addi s0, s0, 1
	beq t0, s0, PLUS
	addi s0, s0, 1
	beq t0, s0, DIV
	addi s0, s0, 1
	beq t0, s0, RAN
	jal FUNC_SWITCH
ADD:	
	push t0
	push t1
	push t2
	push a1
	li s0 0x000000f0
	li s1 0x0000000f
	# A[7: 4] in a0
	and a0 t1 s0
	# A[3: 0] in a1
	and a1 t1 s1
	# B[7: 4} in  a2
	and a2 t2 s0
	# B[3: 0] in a3
	and a3 t2 s1
	add t1 a0 a2
	add t2 a1 a3
	addi s10 zero 10
	bge t2 s10 BIGGERTHAN10
	jal NO_BIGGERTHAN10
BIGGERTHAN10:
	addi t1 t1 16
	sub t2 t2 s10
NO_BIGGERTHAN10:
	add s0 t1 t2
	pop a1
	pop t2
	pop t1
	pop t0
	jal END
SUB:
	push t0
	push t1
	push t2
	push a1
	bge t1 t2 ABIGGER
	jal BBIGGER
ABIGGER:
	add s0 t1 zero
	add t1 t2 zero
	add t2 s0 zero
BBIGGER:
	li s0 0x000000f0
	li s1 0x0000000f
	# A[7: 4] in a0
	and a0 t1 s0
	# A[3: 0] in a1
	and a1 t1 s1
	# B[7: 4} in  a2
	and a2 t2 s0
	# B[3: 0] in a3
	and a3 t2 s1
	blt a3 a1 AFLOATBIGGER
	jal BFLOATBIGGER
AFLOATBIGGER:
	addi s0 zero 16
	sub a2 a2 s0
	addi s0 zero 10
	add a3 a3 s0
BFLOATBIGGER:
	sub a1 a3 a1
	sub a0 a2 a0
	add s0 a1 a0
	pop a1
	pop t2
	pop t1
	pop t0
	jal END
PLUS:
	push t0
	push t1
	push t2
	push a1
	li s0 0x000000f0
	li s1 0x0000000f
	# A[7: 4] in a0
	and a0 t1 s0
	# A[3: 0] in a1
	and a1 t1 s1
	addi s0 zero 1
	addi s1 zero 10
GO:	bge t2 s0 DO
	jal NO_DO
DO:	addi s0 s0 1
	slli a1 a1 1
	slli a0 a0 1
	bge a1 s1 FLOAT_BIGGERTHAN_10
	jal NO_FLOAT_BIGGERTHAN_10
FLOAT_BIGGERTHAN_10:
	sub a1 a1 s1
	addi a0 a0 16
NO_FLOAT_BIGGERTHAN_10:
	jal GO
NO_DO:  add s0 a0 a1
	pop a1
	pop t2
	pop t1
	pop t0
	jal END
DIV:
	push t0
	push t1
	push t2
	push a1
	li s0 0x000000f0
	li s1 0x0000000f
	li a5 0x00000010
	# A[7: 4] in a0
	and a0 t1 s0
	# A[3: 0] in a1
	and a1 t1 s1
	addi s0 zero 1
	addi s1 zero 10
GO_2:	bge t2 s0 DO_1
	jal NO_DO_2
DO_1:	addi s0 s0 1
	srli a1 a1 1
	and a4 a0 a5
	srli a0 a0 1
	beq a4 zero C
	addi a1 a1 5
	slli a0 a0 1
	addi a0 a0 -16
	srli a0 a0 1
C:	jal GO_2
NO_DO_2:  
	bge a1 s1 A
	jal B
A:	sub a1 a1 s1
	addi a0 a0 16
	jal NO_DO_2
B:	add s0 a0 a1
	pop a1
	pop t2
	pop t1
	pop t0
	jal END
RAN:	push t0
	push t1
	push t2
	push a1
	li s0 0xc0004001
	add a3 zero s0
LOOP:	 # ��t0��ȡ31��21��1��0λ
	     srli t6, a3, 31                
	     andi t6, t6, 0x1               # ��������ȡ��31λ��t6
	     
	     srli t5, a3, 21                
	     andi t5, t5, 0x1               # ��������ȡ��21λ��t5
	     
	     srli t4, a3, 1                
	     andi t4, t4, 0x1               # ��������ȡ��1λ��t4
	           
	     andi t3, a3, 0x1               # �����ȡ��0λ��t3
	     
	     xor t2, t3, t4     
	     xor t2, t2 ,t5
	     xor t2, t2 , t6               # �����佫��31��21��1��0��λ�����������,�õ����t2���λ
	     
	     slli a3, a3, 1                # t0������λ1��
	     or a3, a3, t2                 # ���ƺ��t0��t2����ֵ��t0�� �Ͱ�����������һλ���������λ
     # 32λ�������ֵ�ʹ���t0������д�������
	lui  s1, 0xFFFFF
	sw   a3, 0x60(s1)           # Write LEDs
	sw   a3, 0x00(s1)           # Write 7-seg LEDs
	
	lw   a5, 0x70(s1)           # Read switches ���������ص�����
	srli a5, a5, 21
	addi a6 zero 5
	bne a5 a6 FUNC_SWITCH
	jal DELAY
	jal LOOP
	
	pop a1
	pop t2
	pop t1
	pop t0
	
END:	push t0
	push t1
	push t2
	push a1
	li t3 0xfffffff0
	li t2 0x00000010
	li t4 0x000000a0
	li t5 0x00000a00
	li t6 0x0000a000
	li t1 0x00000010
	and a0 s0 t3
UP_LOOP:
	bge a0 t6 thousand
	bge a0 t5 hundred
	bge a0 t4 ten
	bge a0 t2 one
	jal all_end
thousand:
	sub a0 a0 t6
	slli s6 t1 12
	add s1 s1 s6
	jal UP_LOOP
hundred:
	sub a0 a0 t5
	slli s5 t1 8
	add s1 s1 s5
	jal UP_LOOP
ten: 
	sub a0 a0 t4
	slli s4 t1 4
	add s1 s1 s4
	jal UP_LOOP
one:
	sub a0 a0 t2
	add s1 s1 t2
	jal UP_LOOP
all_end:
	addi t0 zero 15
	srli s1 s1 4
	slli s1 s1 16
	and s0 s0 t0
	add s0 s1 s0
	push t0
	push t1
	push t2
	push a1
final_end:
	lui  s1, 0xFFFFF
	sw   s0, 0x60(s1)           # Write LEDs
	sw   s0, 0x00(s1)           # Write 7-seg LEDs
	jal zero FUNC_SWITCH
	
DELAY:
    li t5, 10000000
    LOOPDELAY:
    blt t5, zero , LOOPDELAYDONE
    addi t5,t5,-1 
    j LOOPDELAY
    LOOPDELAYDONE:
    jr ra

	
	

	
	
	
	
	
	
	
