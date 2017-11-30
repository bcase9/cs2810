                .global run

                .equ    flags, 577
                .equ    mode, 0644

                .equ    sys_write, 4
                .equ    sys_open, 5
                .equ    sys_close, 6

                .equ    fail_open, 1
                .equ    fail_writeheader, 2
                .equ    fail_writerow, 3
                .equ    fail_close, 4

                .text

@ run() -> exit code
run:
@echo $? veiw echo status code
@ your code goes here
@ open (filename, flags, mode)
	push	{r4,r5,r6,r7,r8,r9,r10,lr}
	ldr 	r0, =filename
	ldr 	r1, =flags
	ldr	r2, =mode
	mov	r8, #0 @length
	mov	r7, #sys_open
	svc	#0
	cmp	r0, #0
	bge	1f
	mov 	r0, #fail_open
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
1:		@if open wroked move here
	mov	r4,r0
	ldr	r0, =buffer
	ldr	r1, =xsize
	ldr	r1,[r1]
	ldr	r2, =ysize
	ldr	r2,[r2]
	bl	writeHeader
	cmp	r0, #0
	bge	2f
	mov	r0, #fail_writeheader
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
2:		@if write header works
	add	r8, r8, r0
	mov	r2, r0
	mov	r5, #0 @row
	ldr	r10, =ysize
	ldr	r10, [r10]
	ldr	r9, =xsize
	ldr	r9, [r9]
	mov	r0, r4
	b	6f
3:		@row loop		
	mov	r6, #0 @column
4:		@col loop
	ldr	r0, =iters
	ldr	r0, [r0]
	mov	r1,r6
	mov	r2,r5
	push	{r3,r4}
	ldr	r3,=xsize
	ldr	r4,=ysize
	ldr	r3,[r3]
	ldr	r4,[r4]
	sub	sp,sp,#8
	str	r4,[sp]	
	bl	calcPixel
	add	sp,sp,#8
	pop	{r3,r4}
	mov	r1,r0
	ldr	r0, =buffer
	add	r0, r0, r8
	bl	writeRGB
	add	r8, r8, r0
	mov	r3, #' '
	ldr	r0, =buffer
	strb	r3, [r0,r8]
	add	r6, r6, #1
	add	r8, r8, #1
5:		@col test
	cmp	r6, r9
	blt 	4b
	mov	r3, #'\n'
	sub	r2, r8, #1
	ldr	r0, =buffer
	strb	r3, [r0,r2]
        mov     r0, r4  
        ldr     r1, =buffer
        mov     r2, r8
        mov     r7, #sys_write
        svc     #0
        cmp     r0, #0
        bge     7f     
        mov     r0, #fail_writerow
        pop     {r4,r5,r6,r7,r8,r9,r10,pc}
7:              @if write works
	mov	r8, #0
	add	r5, r5, #1
6:		@row test
	cmp	r5, r10
	blt	3b
	mov	r0,r4
	mov	r7, #sys_close
	svc	#0
	cmp	r0, #0
	bge	8f
	mov	r0, #fail_close
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
8:		@if close works
	mov	r0, #0
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
                .bss
buffer:         .space 64*1024
