                 .global writeHeader

                .text
@ writeHeader(buffer, x, y) -> number of bytes written
writeHeader:
		@r4: buffer
		@r1: x
		@r5: y
		@r6: len
		push 	{r4, r5, r6, lr}
		mov	r4, r0
		mov	r5, r2
		mov	r6, r3
		mov	r0, #'p'
		mov	r6, #0
		strb	r0, [r4, r6]
		add	r6, r6, #1
		mov	r0, #3
		strb	r0, [r4, r6]
		add	r6, r6, #1
		mov	r0, #'\n'
		strb	r0, [r4, r6]
		add	r6, r6, #1
		add	r0, r4, r6
		bl	itoa
		add	r6, r6, r0
		mov	r0, #' '
		strb	r0, [r4, r6]
		add	r6, r6, #1
		add	r0, r4, r6
		mov	r1, r6
		bl	itoa
		add	r6, r6, r0
		mov	r0, #'\n'
		strb	r0, [r4, r6]
		add	r6, r6, #1
		add	r0, r4, r6
		mov	r1, #255		
		bl	itoa
		add	r6, r6, r0
		mov	r0, #'\n'
		strb	r0, [r4, r6]
		add	r6, r6, #1
		mov	r0, r6
		pop	{r4, r5, r6, pc}

