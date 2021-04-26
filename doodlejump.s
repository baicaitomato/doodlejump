#####################################################################
#
# CSC258H5S Winter 2021 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Tianyi Ma, 1006429928
# - Student 2: Yusheng Ding, 1004480643
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Score
# 2. Background Cloud Move
# 3. Dynamic Difficulty: the lvl is increased every 5 scores. It is also indicated in the game.  (E stands for easy, N stands for normal, H stands for hard, EX stands for extreme) .
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - You need a decent pc to run this fluently. :P
#
#####################################################################
.data
	displayAddress:	.word	0x10008000
	white:                	.word  	0xffffff
	brown:			.word	0xf4a460
	red:			.word	0xff0000
	green:			.word	0x00ff00
	blue:			.word	0x0000ff
	yellow:			.word	0xffff00
	skblue:            	.word 	0xC8DDF2
	black:			.word	0x000000
	darkred:		.word	0x8B0000
	darkblue:         	.word 	0x1A237E
	platform_left:		.space 	16
	platform_height:	.space 	16
	whichPlatform:		.space 4
	difficulty:		.space 4
	doodle_position:	.space 4
.text

main:	
	lw $t0, displayAddress	# $t0 stores the base address for display
	jal Background_Draw
	jal CLOUD_DRAW
	
	lw $t1, yellow
	addi $t2, $zero, 1024
	add $t2, $t0, $t2
	addi $t2, $t2, 4
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	lw $t1, black
	addi $t2, $t2, 24
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 132($t2)
	sw $t1, 260($t2)
	sw $t1, 388($t2)
	sw $t1, 516($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 388($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 132($t2)
	sw $t1, 260($t2)
	sw $t1, 388($t2)
	sw $t1, 516($t2)
	
	# ��ʼ��
	move $s2, $zero
	move $s4, $zero
	lw $t1, brown 	# $t1 stores the brown colour code
	add $t2, $t0, 3968 # $t2 �����һ������ߵ�λ�ã����ذ�
	add $s3, $t0, 4092 # $s3 stores endpoint
	Ground_LOOP:
	sw $t1, 0($t2)
	addi $t2, $t2, 4
	ble $t2, $s3, Ground_LOOP
	
	la $t2, doodle_position #�浹���ڶ������м��λ�ã���doodle��ʼλ��
	addi $t3, $zero, 3904
	sw $t3, 0($t2)
	jal Doodle_Draw
	
	addi $t2, $zero, 0
	la $t3, difficulty
	addi $t2, $zero, 15
	sw $t2, 0($t3) # ��ʼ�Ѷȣ��Ѷ�Ϊ���ӳ���(����4)

	addi $t2, $zero, 0	
	la $t3, whichPlatform
	sw $zero, 0($t3) # �����õ�һ������
	la $t3, platform_left
	jal getRandom
	sw $a0, 0($t3)	#��һ�����ӵڼ���
	la $t3, platform_height
	addi $t2, $zero, 2816
	sw $t2, 0($t3) #��һ�����ӵڼ���
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 4 # �ڶ�������
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#�ڶ������ӵڼ���
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, 1664
	sw $t2, 0($t3) #�ڶ������ӵڼ���
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 8 # ����������
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#���������ӵڼ���
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, 512
	sw $t2, 0($t3) #���������ӵڼ���
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 12 # ���ĸ�����
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#���ĸ����ӵڼ���
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, -640
	sw $t2, 0($t3) #���ĸ����ӵڼ���
	jal Platform_Draw
	
	#��ʼ���㶨, ����ʼ����
	
	#����û�а�s
	Wait_for_start:
	lw $t7, 0xffff0000 #��input��ַ�浽t7
	bne $t7, 1, Wait_for_start #���t7��ֵ������1����->NOINPUT
	lw $t2, 0xffff0004 #�еĻ�����load ���ݽ�t2
	bne $t2, 115, Wait_for_start
	
	addi $s0, $zero, 1 # Doodle�Ѿ������
	addi $s1, $zero, 16 # Doodle�ܹ������
	GAME_MAIN:
	jal sleep
	lw $t7, 0xffff0000 	#��input��ַ�浽t7
	bne $t7, 1, GAME_MAIN_AFTERINPUT 	#���t7��ֵ������1����->AFTERINPUT
	lw $t2, 0xffff0004	#�еĻ�����load ���ݽ�t2
	beq $t2, 106, moveLeft
	beq $t2, 107, moveRight
	GAME_MAIN_AFTERINPUT:
	bge $s0, $s1, GAME_MAIN_Down
		addi $s0, $s0, 1
		jal Doodle_Up
		jal Draw_Score
		jal Draw_LVL
		j GAME_MAIN
	GAME_MAIN_Down:
		jal Doodle_Down
		jal Draw_Score
		jal Draw_LVL
		addi $s4, $s4, 1 #�Ѿ������ƶ����ٸ���λ
		
		
		lw $t2, doodle_position
		addi $t2, $t2, 128
		add $t2, $t0, $t2
		lw $t4, 0($t2)
	
		addi $t2, $t2, 4 #�Ұ��doodle
		addi $t5, $zero, 128 #$t5 = 128
		sub $t2, $t2, $t0
		div $t2, $t5 #$t5 ���ͷ�
		add $t2, $t2, $t0
		mfhi $t3 #��$t3�����ǲ��ǵ��߽�
		bnez $t3, Doodle_foot_not_over_edge
		sub $t2, $t2, 128
		Doodle_foot_not_over_edge:
		lw $t5, 0($t2)
		lw $t1, green
		beq $t4, $t1, Can_Jump
		beq $t5, $t1, Can_Jump
		j GAME_MAIN
		Can_Jump:
			bge $s4, 9, Score_not_5
			
			addi $s2, $s2, 1
			addi $t2, $zero, 5
			div $s2, $t2
			mfhi $t2
			bnez $t2, Score_not_5
			lw $t2, difficulty
			ble $t2, 6, Score_not_5 #���ӳ�������������λ
			la $t3, difficulty
			subi $t2, $t2, 3
			sw $t2, 0($t3)	#�Ѷȼ�һ�ΰ��ӳ��ȼ���
		Score_not_5:
		move $s4, $zero
		addi $s0, $zero, 1 #Doodle�Ѿ������
		addi $s1, $zero, 16 #Doodle�ܹ������
		j GAME_MAIN
	
	
	j Exit

moveLeft: 
	la $t3, doodle_position
	lw $t2, doodle_position
	addi $t5, $zero, 128 	#$t5 = 128
	div $t2, $t5
	mflo $t6 	#��$t6�����ƶ�֮ǰ�߶�
	subi $t2, $t2, 4
	
	div $t2, $t5 	#$t5 ���ͷ�
	mflo $t7 	#��$t6�����ƶ�֮��߶�
	beq $t6, $t7, moveLeft_not_over_edge
	addi $t2, $t2, 128
	moveLeft_not_over_edge:
	sw $t2, 0($t3)
	j GAME_MAIN_AFTERINPUT
moveRight: 
	la $t3, doodle_position
	lw $t2, doodle_position
	addi $t5, $zero, 128 	#$t5 = 128
	div $t2, $t5
	mflo $t6 	#��$t6�����ƶ�֮ǰ�߶�
	addi $t2, $t2, 4
	
	div $t2, $t5 	#$t5 ���ͷ�
	mflo $t7 	#��$t6�����ƶ�֮��߶�
	beq $t6, $t7, moveRight_not_over_edge
	sub $t2, $t2, 128
	moveRight_not_over_edge:
	sw $t2, 0($t3)
	j GAME_MAIN_AFTERINPUT

Doodle_Up: #Doodle����16��, ������Ļһ�뿪ʼ��camera
	move $t8, $ra
	jal Background_Draw
	jal CLOUD_DRAW
	lw $t2, doodle_position
	ble $t2, 1792, Doodle_Up_Movecamera 
		la $t4, whichPlatform #û����Ļһ��
		addi $t5, $zero, 0
		sw $t5, 0($t4) 
		jal Platform_Draw # ��һ������
		la $t4, whichPlatform
		addi $t5, $zero, 4 
		sw $t5, 0($t4)
		jal Platform_Draw # �ڶ�������
		la $t4, whichPlatform
		addi $t5, $zero, 8
		sw $t5, 0($t4)
		jal Platform_Draw # ����������
		la $t4, whichPlatform
		addi $t5, $zero, 12
		sw $t5, 0($t4)
		jal Platform_Draw # ���ĸ�����
		lw $t2, doodle_position #��ʼ��Doodle
		la $t3, doodle_position
		subi $t2, $t2, 128 
		sw $t2, 0($t3)
		jal Doodle_Draw
		j Doodle_Up_Exit
	Doodle_Up_Movecamera: #������Ļһ��
		la $t4, platform_height
		lw $t3, 0($t4) # ��һ������
		addi $t3, $t3, 128
		sw $t3, 0($t4)
		lw $t3, 4($t4) # �ڶ�������
		addi $t3, $t3, 128
		sw $t3, 4($t4)
		lw $t3, 8($t4) # ����������
		addi $t3, $t3, 128
		sw $t3, 8($t4)
		lw $t3, 12($t4) # ���ĸ�����
		addi $t3, $t3, 128
		sw $t3, 12($t4)
		la $t4, whichPlatform #��ʼ������
		addi $t5, $zero, 0
		sw $t5, 0($t4) 
		jal Platform_Draw # ��һ������
		la $t4, whichPlatform
		addi $t5, $zero, 4 
		sw $t5, 0($t4)
		jal Platform_Draw # �ڶ�������
		la $t4, whichPlatform
		addi $t5, $zero, 8
		sw $t5, 0($t4)
		jal Platform_Draw # ����������
		la $t4, whichPlatform
		addi $t5, $zero, 12
		sw $t5, 0($t4)
		jal Platform_Draw # ���ĸ�����
		jal Doodle_Draw
	Doodle_Up_Exit:
	move $ra, $t8
	jr $ra

Doodle_Down: 
    	la $t2, doodle_position
    	lw $t3, doodle_position
    	addi $t3, $t3, 128
    	sw $t3, 0($t2)
    	
    	addi $t2, $s3, 256
    	add $t3,$t3, $t0
    	bgt $t3,$t2, Exit 
    	
    	
   	move $t8, $ra
    	jal Background_Draw

    	jal CLOUD_DRAW
    	jal Doodle_Draw
    	add $t4, $zero, $zero
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # ��һ������
    	jal Platform_Draw
    	addi $t4, $zero, 4
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # �ڶ�������
    	jal Platform_Draw
    	addi $t4, $zero, 8
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # ����������
    	jal Platform_Draw
    	addi $t4, $zero, 12
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # ���ĸ�����
    	jal Platform_Draw
    	move $ra, $t8
    	jr $ra

Doodle_Draw:
	lw $t2, doodle_position
	lw $t1, blue   # $t1 stores the blue colour code
	add $t2, $t0, $t2
	sw $t1, 0($t2)
	subi $t2, $t2, 128
	sw $t1, 0($t2)	#����doodle
	
	addi $t2, $t2, 4 #�Ұ��doodle
	addi $t5, $zero, 128 # $t5 = 128
	sub $t2, $t2, $t0
	div $t2, $t5 # $t5 ���ͷ�
	add $t2, $t2, $t0
	mfhi $t3 #��$t3�����ǲ��ǵ��߽�
	bnez $t3, Doodle_not_over_edge
	sub $t2, $t2, 128
	Doodle_not_over_edge:
	sw $t1, 0($t2)
	addi $t2, $t2, 128
	sw $t1, 0($t2)
	jr $ra

Platform_Draw:
	addi $t2, $zero, 0
	lw $t4, whichPlatform
	la $t3, platform_left
	la $t5, platform_height
	lw $t6, difficulty
	add $t3, $t3, $t4 #��platform_left[whichPlatform]
	lw $t2, 0($t3) # $t3 ���ͷ�
	mul $t2, $t2, 4 # ��Ϊ������ڼ��в��ǳ�4, Ҫ��4
	add $t2, $t2, $t0
	add $t5, $t5, $t4 #��platform_height[whichPlatform]
	lw $t5, 0($t5) 
	blt $t5, $zero, Platform_Draw_After
	addi $t3, $zero, 4092
	ble $t5, $t3, Platform_Draw_Next
		lw $t4, whichPlatform
		la $t3, platform_left
		la $t5, platform_height
		
		add $t3, $t3, $t4 #��platform_left[whichPlatform]
		move $t9, $ra
		jal getRandom
		move $ra, $t9
		sw $a0, 0($t3)	#�ڼ���
		add $t5, $t5, $t4 #��platform_height[whichPlatform]
		subi $t2, $zero, 512
		sw $t2, 0($t5) #�ڼ���
		
		j Platform_Draw_After
	Platform_Draw_Next:
	add $t2, $t2, $t5 # $t5 ���ͷ�, �߶Ȳ��ó�
	addi $t4, $zero, 0 # ��$t4��������Ѿ���������
	lw $t1, green
	addi $t5, $zero, 128 # $t5 = 128
	Platform_draw_loop:
		sw $t1, 0($t2)
		addi $t4, $t4, 1
		addi $t2, $t2, 4
		sub $t2, $t2, $t0
		div $t2, $t5 
		add $t2, $t2, $t0
		mfhi $t3 #��$t3�����ǲ��ǵ��߽�
		bnez $t3, Platform_not_over_edge
		sub $t2, $t2, $t5 # $t5 ���ͷ�
		Platform_not_over_edge:
		ble $t4, $t6, Platform_draw_loop
	Platform_Draw_After:
	jr $ra

Background_Draw:
	lw $t1, skblue 	# $t1 stores the white colour code
	add $t2, $zero, $t0 # $t2 stores 0
	add $t3, $t0, 4096 # $t3 stores endpoint
	Background_LOOP:
		sw $t1, 0($t2)
		addi $t2, $t2, 4
		bne $t2, $t3, Background_LOOP
	jr $ra

CLOUD_DRAW: 
    ble $s5, 500, Cloud_Ani
    move $s5, $zero
    Cloud_Ani: 
    addi $s5, $s5, 1
    lw $t1, white
    addi $t2, $t0, 576 #�ڵ������м䲿λ����һ����������ƣ�3����
    mul $t7, $s5, 4 
    add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 700 #�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 832 #�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)

    addi $t2, $t0, 1560 #�ڵ������м䲿λ����һ����������ƣ�3����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 1688#�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 1816 #�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)


    addi $t2, $t0, 2644 #�ڵ������м䲿λ����һ����������ƣ�3����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 2772#�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 2900 #�ڵ������м䲿λ����һ����������ƣ�5����
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    jr $ra

Draw_One: 
	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������

	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 112 #120 Ϊ���ұ߽�
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    add $t2, $t2,384
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
   Draw_Two: 
	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    sw $t1, 256($t2)
    sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 256($t2)
        sw $t1, 384($t2)
        sw $t1, 512($t2)
    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
    sw $t1, 128($t2)
    jr $ra
    
    Draw_Three: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    sw $t1, 256($t2)
    sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 256($t2)

        sw $t1, 512($t2)
    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
        Draw_Four: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 0 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4

    sw $t1, 256($t2)

    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 128($t2)
        sw $t1, 256($t2)


    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
Draw_Five: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)

    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    sw $t1, 256($t2)
        sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 128($t2)
        sw $t1, 256($t2)
        sw $t1, 512($t2)

    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
Draw_Six: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)

    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    sw $t1, 256($t2)
        sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 128($t2)
        sw $t1, 256($t2)
            sw $t1, 384($t2)
        sw $t1, 512($t2)

    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
       Draw_Seven: 
	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    
    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
    sw $t1, 0($t2)
    sw $t1, 128($t2)

    jr $ra
    Draw_Eight: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    sw $t1, 256($t2)
        sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 128($t2)
        sw $t1, 256($t2)
            sw $t1, 384($t2)
        sw $t1, 512($t2)

    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
        Draw_Nine: 
    	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
        sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)

    sw $t1, 256($t2)
        sw $t1, 512($t2)
    subi $t2, $t2, 4
        sw $t1, 0($t2)
        sw $t1, 128($t2)
        sw $t1, 256($t2)

        sw $t1, 512($t2)

    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
         Draw_Zero: 
	#������ϵ��functionʱ��t3Ϊ���������ڼ�λ���ı�����callǰȷ��t3�� 0Ϊ��λ����1Ϊʮλ������������
	#li $t3, 1 #���ӣ�10λ��
	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 120 
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
    
        sw $t1, 512($t2)
    subi $t2, $t2, 4
    sw $t1, 0($t2)
        sw $t1, 128($t2)
            sw $t1, 256($t2)
            sw $t1, 384($t2)
            sw $t1, 512($t2)
    addi $t2, $t2, 8 #reset�����ұ�
    add $t2, $t2, 384
    sw $t1, 0($t2)
    sw $t1, 128($t2)

    jr $ra
Draw_Score: 
	add $t5, $zero, 10
	move $t2, $s2	#s2 ��score, move the s2 ���� �� t2. 
	div $t2, $t5 
	mfhi $t5 #t3 ����--��λ��
	mflo $t7 #t2 �� --10λ��
	move $t8, $ra
	li $t3, 0 #��λ��
	add $t4, $zero, $zero #counter
	bne $t5, $t4, One
	jal Draw_Zero	
	One:
	addi $t4, $t4, 1 #when 1 happens 
	bne $t5, $t4, Two
	jal Draw_One
	Two:
	addi $t4, $t4, 1 #when 2 happens 
	bne $t5, $t4, Three
	jal Draw_Two
	Three:
	addi $t4, $t4, 1 #when 3 happens 
	bne $t5, $t4, Four
	jal Draw_Three
	Four: 
	addi $t4, $t4, 1 #when 4 happens 
	bne $t5, $t4, Five
	jal Draw_Four
	Five:
	addi $t4, $t4, 1 #when 5 happens 
	bne $t5, $t4, Six
	jal Draw_Five
	Six: 
	addi $t4, $t4, 1 #when 6 happens 
	bne $t5, $t4, Seven
	jal Draw_Six
	Seven:
	addi $t4, $t4, 1 #when 7 happens 
	bne $t5, $t4, Eight
	jal Draw_Seven
	Eight:
	addi $t4, $t4, 1 #when 8 happens 
	bne $t5, $t4, Nine
	jal Draw_Eight
	Nine:
	addi $t4, $t4, 1 #when 9 happens 
	bne $t5, $t4, Shiweishu
	jal Draw_Nine
	Shiweishu:
	#��10λ���� �����1 Ϊʮλ����variable
	li $t3, 1
	add $t4, $zero, $zero #counter
	bne $t7, $t4, yishi
	jal Draw_Zero
	yishi:
	addi $t4, $t4, 1 #when 1 happens 
	bne $t7, $t4, ershi
	jal Draw_One
	ershi:
	addi $t4, $t4, 1 #when 2 happens 
	bne $t7, $t4, sanshi
	jal Draw_Two
	sanshi:
	addi $t4, $t4, 1 #when 3 happens 
	bne $t7, $t4, sishi
	jal Draw_Three
	sishi:
	addi $t4, $t4, 1 #when 4 happens 
	bne $t7, $t4, wushi
	jal Draw_Four
	wushi:
	addi $t4, $t4, 1 #when 5 happens 
	bne $t7, $t4, liushi
	jal Draw_Five
	liushi:
	addi $t4, $t4, 1 #when 6 happens 
	bne $t7, $t4, qishi
	jal Draw_Six
	qishi:
	addi $t4, $t4, 1 #when 7 happens 
	bne $t7, $t4, bashi
	jal Draw_Seven
	bashi:
	addi $t4, $t4, 1 #when 8 happens 
	bne $t7, $t4, jiushi
	jal Draw_Eight
	jiushi:
	addi $t4, $t4, 1 #when 9 happens 
	bne $t7, $t4, outofdrawdigit
	jal Draw_Nine
	outofdrawdigit: 
	move $ra, $t8
	jr $ra

Draw_LVL:
	lw $t1, darkred
	add $t2, $zero, $t0	
	
	addi $t2, $t2, 4
	sw $t1, 0($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 516($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	lw $t1, black
	lw $t3, difficulty
	bgt $t3, 12, Draw_LVL_E
	bgt $t3, 9, Draw_LVL_N
	bgt $t3, 6, Draw_LVL_H
	j Draw_LVL_EX
	Draw_LVL_E:
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	jr $ra
	Draw_LVL_N:
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	jr $ra
	Draw_LVL_H:
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	jr $ra
	Draw_LVL_EX:
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 260($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	jr $ra
	
	

getRandom:	# ���������¸����ӵڼ���
			li $v0, 42
			li $a1, 32
			syscall # ��������� $a0
			jr $ra

sleep:      li $v0, 32
            li $a0, 50
            syscall
            jr $ra
            
Exit:
	lw $t1, yellow
	addi $t2, $zero, 1024
	add $t2, $t0, $t2
	addi $t2, $t2, 4
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 768
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	
	lw $t1, black
	subi $t2, $t2, 744
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 388($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 260($t2)
	sw $t1, 388($t2)
	sw $t1, 516($t2)
	
	
	addi $t2, $t2, 688
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 256($t2)
	sw $t1, 260($t2)
	sw $t1, 264($t2)
	sw $t1, 384($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 8($t2)
	sw $t1, 128($t2)
	sw $t1, 136($t2)
	sw $t1, 260($t2)
	sw $t1, 384($t2)
	sw $t1, 392($t2)
	sw $t1, 512($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 132($t2)
	sw $t1, 260($t2)
	sw $t1, 388($t2)
	sw $t1, 512($t2)
	sw $t1, 516($t2)
	sw $t1, 520($t2)
	
	addi $t2, $t2, 16
	sw $t1, 0($t2)
	sw $t1, 4($t2)
	sw $t1, 8($t2)
	sw $t1, 132($t2)
	sw $t1, 260($t2)
	sw $t1, 388($t2)
	sw $t1, 516($t2)
	
	

	#����û�а�s
	Wait_for_Exit:
	lw $t7, 0xffff0000 #��input��ַ�浽t7
	bne $t7, 1, Wait_for_Exit #���t7��ֵ������1����->NOINPUT
	lw $t2, 0xffff0004 #�еĻ�����load ���ݽ�t2
	beq $t2, 115, main
	beq $t2, 100, Exit_Syscall
	j Wait_for_Exit
	
	Exit_Syscall:
	li $v0, 10 # terminate the program gracefully
	syscall
