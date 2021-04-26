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
	
	# 初始化
	move $s2, $zero
	move $s4, $zero
	lw $t1, brown 	# $t1 stores the brown colour code
	add $t2, $t0, 3968 # $t2 存最后一行最左边的位置，画地板
	add $s3, $t0, 4092 # $s3 stores endpoint
	Ground_LOOP:
	sw $t1, 0($t2)
	addi $t2, $t2, 4
	ble $t2, $s3, Ground_LOOP
	
	la $t2, doodle_position #存倒数第二行最中间的位置，画doodle初始位置
	addi $t3, $zero, 3904
	sw $t3, 0($t2)
	jal Doodle_Draw
	
	addi $t2, $zero, 0
	la $t3, difficulty
	addi $t2, $zero, 15
	sw $t2, 0($t3) # 初始难度，难度为板子长度(不乘4)

	addi $t2, $zero, 0	
	la $t3, whichPlatform
	sw $zero, 0($t3) # 先设置第一个板子
	la $t3, platform_left
	jal getRandom
	sw $a0, 0($t3)	#第一个板子第几列
	la $t3, platform_height
	addi $t2, $zero, 2816
	sw $t2, 0($t3) #第一个板子第几行
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 4 # 第二个板子
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#第二个板子第几列
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, 1664
	sw $t2, 0($t3) #第二个板子第几行
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 8 # 第三个板子
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#第三个板子第几列
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, 512
	sw $t2, 0($t3) #第三个板子第几行
	jal Platform_Draw
	
	la $t3, whichPlatform
	addi $t2, $zero, 12 # 第四个板子
	sw $t2, 0($t3)
	la $t3, platform_left
	jal getRandom
	add $t3, $t3, $t2
	sw $a0, 0($t3)	#第四个板子第几列
	la $t3, platform_height
	add $t3, $t3, $t2
	addi $t2, $zero, -640
	sw $t2, 0($t3) #第四个板子第几行
	jal Platform_Draw
	
	#初始化搞定, 程序开始运行
	
	#看有没有按s
	Wait_for_start:
	lw $t7, 0xffff0000 #把input地址存到t7
	bne $t7, 1, Wait_for_start #如果t7的值不等于1，则->NOINPUT
	lw $t2, 0xffff0004 #有的话，就load 内容进t2
	bne $t2, 115, Wait_for_start
	
	addi $s0, $zero, 1 # Doodle已经跳多高
	addi $s1, $zero, 16 # Doodle能够跳多高
	GAME_MAIN:
	jal sleep
	lw $t7, 0xffff0000 	#把input地址存到t7
	bne $t7, 1, GAME_MAIN_AFTERINPUT 	#如果t7的值不等于1，则->AFTERINPUT
	lw $t2, 0xffff0004	#有的话，就load 内容进t2
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
		addi $s4, $s4, 1 #已经向下移动多少个单位
		
		
		lw $t2, doodle_position
		addi $t2, $t2, 128
		add $t2, $t0, $t2
		lw $t4, 0($t2)
	
		addi $t2, $t2, 4 #右半边doodle
		addi $t5, $zero, 128 #$t5 = 128
		sub $t2, $t2, $t0
		div $t2, $t5 #$t5 已释放
		add $t2, $t2, $t0
		mfhi $t3 #用$t3来看是不是到边界
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
			ble $t2, 6, Score_not_5 #板子长度最少六个单位
			la $t3, difficulty
			subi $t2, $t2, 3
			sw $t2, 0($t3)	#难度加一次板子长度减三
		Score_not_5:
		move $s4, $zero
		addi $s0, $zero, 1 #Doodle已经跳多高
		addi $s1, $zero, 16 #Doodle能够跳多高
		j GAME_MAIN
	
	
	j Exit

moveLeft: 
	la $t3, doodle_position
	lw $t2, doodle_position
	addi $t5, $zero, 128 	#$t5 = 128
	div $t2, $t5
	mflo $t6 	#用$t6来存移动之前高度
	subi $t2, $t2, 4
	
	div $t2, $t5 	#$t5 已释放
	mflo $t7 	#用$t6来存移动之后高度
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
	mflo $t6 	#用$t6来存移动之前高度
	addi $t2, $t2, 4
	
	div $t2, $t5 	#$t5 已释放
	mflo $t7 	#用$t6来存移动之后高度
	beq $t6, $t7, moveRight_not_over_edge
	sub $t2, $t2, 128
	moveRight_not_over_edge:
	sw $t2, 0($t3)
	j GAME_MAIN_AFTERINPUT

Doodle_Up: #Doodle能跳16格, 超过屏幕一半开始动camera
	move $t8, $ra
	jal Background_Draw
	jal CLOUD_DRAW
	lw $t2, doodle_position
	ble $t2, 1792, Doodle_Up_Movecamera 
		la $t4, whichPlatform #没有屏幕一半
		addi $t5, $zero, 0
		sw $t5, 0($t4) 
		jal Platform_Draw # 第一个板子
		la $t4, whichPlatform
		addi $t5, $zero, 4 
		sw $t5, 0($t4)
		jal Platform_Draw # 第二个板子
		la $t4, whichPlatform
		addi $t5, $zero, 8
		sw $t5, 0($t4)
		jal Platform_Draw # 第三个板子
		la $t4, whichPlatform
		addi $t5, $zero, 12
		sw $t5, 0($t4)
		jal Platform_Draw # 第四个板子
		lw $t2, doodle_position #开始画Doodle
		la $t3, doodle_position
		subi $t2, $t2, 128 
		sw $t2, 0($t3)
		jal Doodle_Draw
		j Doodle_Up_Exit
	Doodle_Up_Movecamera: #超过屏幕一半
		la $t4, platform_height
		lw $t3, 0($t4) # 第一个板子
		addi $t3, $t3, 128
		sw $t3, 0($t4)
		lw $t3, 4($t4) # 第二个板子
		addi $t3, $t3, 128
		sw $t3, 4($t4)
		lw $t3, 8($t4) # 第三个板子
		addi $t3, $t3, 128
		sw $t3, 8($t4)
		lw $t3, 12($t4) # 第四个板子
		addi $t3, $t3, 128
		sw $t3, 12($t4)
		la $t4, whichPlatform #开始画板子
		addi $t5, $zero, 0
		sw $t5, 0($t4) 
		jal Platform_Draw # 第一个板子
		la $t4, whichPlatform
		addi $t5, $zero, 4 
		sw $t5, 0($t4)
		jal Platform_Draw # 第二个板子
		la $t4, whichPlatform
		addi $t5, $zero, 8
		sw $t5, 0($t4)
		jal Platform_Draw # 第三个板子
		la $t4, whichPlatform
		addi $t5, $zero, 12
		sw $t5, 0($t4)
		jal Platform_Draw # 第四个板子
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
    	sw $t4, 0($t6) # 第一个板子
    	jal Platform_Draw
    	addi $t4, $zero, 4
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # 第二个板子
    	jal Platform_Draw
    	addi $t4, $zero, 8
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # 第三个板子
    	jal Platform_Draw
    	addi $t4, $zero, 12
    	la $t6, whichPlatform
    	sw $t4, 0($t6) # 第四个板子
    	jal Platform_Draw
    	move $ra, $t8
    	jr $ra

Doodle_Draw:
	lw $t2, doodle_position
	lw $t1, blue   # $t1 stores the blue colour code
	add $t2, $t0, $t2
	sw $t1, 0($t2)
	subi $t2, $t2, 128
	sw $t1, 0($t2)	#左半边doodle
	
	addi $t2, $t2, 4 #右半边doodle
	addi $t5, $zero, 128 # $t5 = 128
	sub $t2, $t2, $t0
	div $t2, $t5 # $t5 已释放
	add $t2, $t2, $t0
	mfhi $t3 #用$t3来看是不是到边界
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
	add $t3, $t3, $t4 #找platform_left[whichPlatform]
	lw $t2, 0($t3) # $t3 已释放
	mul $t2, $t2, 4 # 因为随机数第几列不是乘4, 要乘4
	add $t2, $t2, $t0
	add $t5, $t5, $t4 #找platform_height[whichPlatform]
	lw $t5, 0($t5) 
	blt $t5, $zero, Platform_Draw_After
	addi $t3, $zero, 4092
	ble $t5, $t3, Platform_Draw_Next
		lw $t4, whichPlatform
		la $t3, platform_left
		la $t5, platform_height
		
		add $t3, $t3, $t4 #找platform_left[whichPlatform]
		move $t9, $ra
		jal getRandom
		move $ra, $t9
		sw $a0, 0($t3)	#第几列
		add $t5, $t5, $t4 #找platform_height[whichPlatform]
		subi $t2, $zero, 512
		sw $t2, 0($t5) #第几行
		
		j Platform_Draw_After
	Platform_Draw_Next:
	add $t2, $t2, $t5 # $t5 已释放, 高度不用乘
	addi $t4, $zero, 0 # 用$t4来存板子已经画过几格
	lw $t1, green
	addi $t5, $zero, 128 # $t5 = 128
	Platform_draw_loop:
		sw $t1, 0($t2)
		addi $t4, $t4, 1
		addi $t2, $t2, 4
		sub $t2, $t2, $t0
		div $t2, $t5 
		add $t2, $t2, $t0
		mfhi $t3 #用$t3来看是不是到边界
		bnez $t3, Platform_not_over_edge
		sub $t2, $t2, $t5 # $t5 已释放
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
    addi $t2, $t0, 576 #在第五行中间部位，画一个天空蓝的云，3像素
    mul $t7, $s5, 4 
    add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 700 #在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 832 #在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)

    addi $t2, $t0, 1560 #在第五行中间部位，画一个天空蓝的云，3像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 1688#在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 1816 #在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)


    addi $t2, $t0, 2644 #在第五行中间部位，画一个天空蓝的云，3像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 8($t2)
    addi $t2, $t0, 2772#在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    sw $t1, 8($t2)
    sw $t1, 12($t2)
    addi $t2, $t0, 2900 #在第五行中间部位，画一个天空蓝的云，5像素
        add $t2, $t2, $t7
    sw $t1, 0($t2)
    sw $t1, 4($t2)
    jr $ra

Draw_One: 
	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推

	mul $t3, $t3, -16
    lw $t1, darkblue
    addi $t2, $t0, 112 #120 为最右边界
    add $t2, $t2, $t3
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    sw $t1, 256($t2)
    add $t2, $t2,384
    sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
   Draw_Two: 
	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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
    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
    sw $t1, 128($t2)
    jr $ra
    
    Draw_Three: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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
    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
        Draw_Four: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 0 #例子：10位数
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


    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
Draw_Five: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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

    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
Draw_Six: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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

    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
       Draw_Seven: 
	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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
    
    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
    sw $t1, 0($t2)
    sw $t1, 128($t2)

    jr $ra
    Draw_Eight: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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

    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
    
        Draw_Nine: 
    	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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

    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
     sw $t1, 0($t2)
    sw $t1, 128($t2)
    jr $ra
         Draw_Zero: 
	#用数字系列function时，t3为决定数字在几位数的变量，call前确定t3， 0为个位数，1为十位数，依此类推
	#li $t3, 1 #例子：10位数
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
    addi $t2, $t2, 8 #reset到最右边
    add $t2, $t2, 384
    sw $t1, 0($t2)
    sw $t1, 128($t2)

    jr $ra
Draw_Score: 
	add $t5, $zero, 10
	move $t2, $s2	#s2 存score, move the s2 分数 到 t2. 
	div $t2, $t5 
	mfhi $t5 #t3 余数--个位数
	mflo $t7 #t2 商 --10位数
	move $t8, $ra
	li $t3, 0 #个位数
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
	#画10位数， 下面的1 为十位数的variable
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
	
	

getRandom:	# 随机数随机下个板子第几列
			li $v0, 42
			li $a1, 32
			syscall # 随机数存在 $a0
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
	
	

	#看有没有按s
	Wait_for_Exit:
	lw $t7, 0xffff0000 #把input地址存到t7
	bne $t7, 1, Wait_for_Exit #如果t7的值不等于1，则->NOINPUT
	lw $t2, 0xffff0004 #有的话，就load 内容进t2
	beq $t2, 115, main
	beq $t2, 100, Exit_Syscall
	j Wait_for_Exit
	
	Exit_Syscall:
	li $v0, 10 # terminate the program gracefully
	syscall
