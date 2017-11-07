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
	mov	r6, #0 @column
	ldr	r5, =buffer
	ldr	r9, =xsize
	ldr	r9, [r9]
	mov	r0, r4
	b	4f
3:		@loop
	add	r0, r5, r8
	mov	r1, r6, lsl #8
	bl	writeRGB
	add	r8, r8, r0
	mov	r3, #' '
	strb	r3, [r5,r8]
	add	r6, r6, #1
	add	r8, r8, #1
4:		@test
	cmp	r6, r9
	blt 	3b
	mov	r3, #'\n'
	sub	r2, r8, #1
	strb	r3, [r5,r2]
	mov	r0, r4
	ldr	r1, =buffer
	mov	r2, r8
	mov	r7, #sys_write
	svc	#0
	cmp	r0, #0
	bge	5f	
	mov	r0, #fail_writerow
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
5:		@if write works
	mov	r0,r4
	mov	r7, #sys_close
	svc	#0
	cmp	r0, #0
	bge	6f
	mov	r0, #fail_close
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
6:		@if close works
	mov	r0, #0
	pop	{r4,r5,r6,r7,r8,r9,r10,pc}
                .bss
buffer:         .space 64*1024
