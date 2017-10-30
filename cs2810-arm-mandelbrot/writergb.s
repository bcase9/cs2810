                .global writeRGB

                .text
@ writeRGB(buffer, rgb) -> number of bytes written
writeRGB:
		push	{r4,r5,r6,r7,r8,lr}
		@r4: buffer
		@r5: rgb len once color is extracted
		@r6: red
		@r7: green
		@r8: blue
		mov	r4, r1
		mov	r5, r2
		mov	r6, #0xff
		and	r6, r6, r5, lsr#16
		mov	r7, #0xff
		and	r7, r7, r5, lsr#8
		mov	r8, #0xff
		and	r8, r8, r5
		mov	r5, #0
		add 	r0, r4, r5
		mov	r1, r6
		bl 	itoa
		add	r5, r5, r0
		mov	r6, #' '
		strb	r6, [r4, r5]
		add 	r5, r5, #1
		add	r0, r4, r5
		mov	r1, r7
		bl	itoa
		add	r5, r5, r0
		strb	r6, [r4, r5]
		add 	r5, r5, #1
		add	r0, r4, r5
		mov	r1, r8
		bl	itoa
		add	r5, r5, r0
		mov	r0, r5	


		pop	{r4,r5,r6,r7,r8,pc}
