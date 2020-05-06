	.file	"builtin.c"
	.text
	.align	2
	.globl	_size
	.type	_size, @function
_size:
	lw	a0,-4(a0)
	ret
	.size	_size, .-_size
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"%s"
	.text
	.align	2
	.globl	print
	.type	print, @function
print:
	mv	a1,a0
	lui	a0,%hi(.LC0)
	addi	a0,a0,%lo(.LC0)
	tail	printf
	.size	print, .-print
	.align	2
	.globl	println
	.type	println, @function
println:
	tail	puts
	.size	println, .-println
	.section	.rodata.str1.4
	.align	2
.LC1:
	.string	"%d"
	.text
	.align	2
	.globl	printInt
	.type	printInt, @function
printInt:
	mv	a1,a0
	lui	a0,%hi(.LC1)
	addi	a0,a0,%lo(.LC1)
	tail	printf
	.size	printInt, .-printInt
	.section	.rodata.str1.4
	.align	2
.LC2:
	.string	"%d\n"
	.text
	.align	2
	.globl	printlnInt
	.type	printlnInt, @function
printlnInt:
	mv	a1,a0
	lui	a0,%hi(.LC2)
	addi	a0,a0,%lo(.LC2)
	tail	printf
	.size	printlnInt, .-printlnInt
	.align	2
	.globl	getString
	.type	getString, @function
getString:
	addi	sp,sp,-288
	lui	a0,%hi(.LC0)
	addi	a1,sp,12
	addi	a0,a0,%lo(.LC0)
	sw	ra,284(sp)
	sw	s0,280(sp)
	sw	s1,276(sp)
	call	scanf
	addi	a0,sp,12
	call	strlen
	addi	s0,a0,1
	mv	a0,s0
	call	malloc
	mv	a2,s0
	addi	a1,sp,12
	mv	s1,a0
	call	memcpy
	lw	ra,284(sp)
	lw	s0,280(sp)
	mv	a0,s1
	lw	s1,276(sp)
	addi	sp,sp,288
	jr	ra
	.size	getString, .-getString
	.align	2
	.globl	getInt
	.type	getInt, @function
getInt:
	addi	sp,sp,-32
	lui	a0,%hi(.LC1)
	addi	a1,sp,12
	addi	a0,a0,%lo(.LC1)
	sw	ra,28(sp)
	call	scanf
	lw	ra,28(sp)
	lw	a0,12(sp)
	addi	sp,sp,32
	jr	ra
	.size	getInt, .-getInt
	.align	2
	.globl	toString
	.type	toString, @function
toString:
	addi	sp,sp,-32
	sw	s1,20(sp)
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	mv	s1,a0
	blt	a0,zero,.L29
	li	s3,0
	beq	a0,zero,.L18
.L13:
	mv	a5,s1
	li	s0,0
	li	a3,10
.L15:
	div	a5,a5,a3
	mv	a4,s0
	addi	s0,s0,1
	bne	a5,zero,.L15
	addi	a5,a4,2
	mv	s2,s0
	mv	a0,a5
	beq	s3,zero,.L14
	mv	s2,a5
	mv	s0,a5
	addi	a0,a4,3
.L14:
	call	malloc
	addi	a5,s0,-1
	sub	a2,s0,s3
	add	a5,a0,a5
	add	s0,a0,s0
	li	a3,10
.L16:
	rem	a4,s1,a3
	addi	a5,a5,-1
	addi	a4,a4,48
	sb	a4,1(a5)
	sub	a4,s0,a5
	div	s1,s1,a3
	bge	a2,a4,.L16
	beq	s3,zero,.L17
	li	a5,45
	sb	a5,0(a0)
.L17:
	add	s2,a0,s2
	sb	zero,0(s2)
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	addi	sp,sp,32
	jr	ra
.L29:
	neg	s1,a0
	li	s3,1
	j	.L13
.L18:
	li	a0,2
	li	s2,1
	li	s0,1
	j	.L14
	.size	toString, .-toString
	.align	2
	.globl	_str_length
	.type	_str_length, @function
_str_length:
	tail	strlen
	.size	_str_length, .-_str_length
	.align	2
	.globl	_str_substring
	.type	_str_substring, @function
_str_substring:
	addi	sp,sp,-32
	sw	s0,24(sp)
	sub	s0,a2,a1
	sw	s4,8(sp)
	mv	s4,a0
	addi	a0,s0,1
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	ra,28(sp)
	mv	s1,a1
	mv	s3,a2
	call	malloc
	mv	s2,a0
	ble	s3,s1,.L32
	mv	a2,s0
	add	a1,s4,s1
	call	memcpy
.L32:
	add	s0,s2,s0
	sb	zero,0(s0)
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s3,12(sp)
	lw	s4,8(sp)
	mv	a0,s2
	lw	s2,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	_str_substring, .-_str_substring
	.align	2
	.globl	_str_parseInt
	.type	_str_parseInt, @function
_str_parseInt:
	addi	sp,sp,-32
	lui	a1,%hi(.LC1)
	addi	a2,sp,12
	addi	a1,a1,%lo(.LC1)
	sw	ra,28(sp)
	sw	zero,12(sp)
	call	sscanf
	lw	ra,28(sp)
	lw	a0,12(sp)
	addi	sp,sp,32
	jr	ra
	.size	_str_parseInt, .-_str_parseInt
	.align	2
	.globl	_str_ord
	.type	_str_ord, @function
_str_ord:
	add	a0,a0,a1
	lbu	a0,0(a0)
	ret
	.size	_str_ord, .-_str_ord
	.align	2
	.globl	_str_add
	.type	_str_add, @function
_str_add:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	s4,8(sp)
	mv	s2,a1
	mv	s4,a0
	call	strlen
	mv	s0,a0
	mv	a0,s2
	call	strlen
	mv	s3,a0
	add	a0,s0,a0
	addi	a0,a0,1
	call	malloc
	mv	a2,s0
	mv	a1,s4
	mv	s1,a0
	call	memcpy
	add	a0,s1,s0
	addi	a2,s3,1
	mv	a1,s2
	call	memcpy
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	lw	s4,8(sp)
	mv	a0,s1
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	_str_add, .-_str_add
	.align	2
	.globl	_str_eq
	.type	_str_eq, @function
_str_eq:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	seqz	a0,a0
	addi	sp,sp,16
	jr	ra
	.size	_str_eq, .-_str_eq
	.align	2
	.globl	_str_ne
	.type	_str_ne, @function
_str_ne:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	snez	a0,a0
	addi	sp,sp,16
	jr	ra
	.size	_str_ne, .-_str_ne
	.align	2
	.globl	_str_slt
	.type	_str_slt, @function
_str_slt:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	srli	a0,a0,31
	addi	sp,sp,16
	jr	ra
	.size	_str_slt, .-_str_slt
	.align	2
	.globl	_str_sgt
	.type	_str_sgt, @function
_str_sgt:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	sgt	a0,a0,zero
	addi	sp,sp,16
	jr	ra
	.size	_str_sgt, .-_str_sgt
	.align	2
	.globl	_str_sge
	.type	_str_sge, @function
_str_sge:
	mv	a5,a0
	addi	sp,sp,-16
	mv	a0,a1
	mv	a1,a5
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	srli	a0,a0,31
	addi	sp,sp,16
	jr	ra
	.size	_str_sge, .-_str_sge
	.align	2
	.globl	_str_sle
	.type	_str_sle, @function
_str_sle:
	mv	a5,a0
	addi	sp,sp,-16
	mv	a0,a1
	mv	a1,a5
	sw	ra,12(sp)
	call	strcmp
	lw	ra,12(sp)
	sgt	a0,a0,zero
	addi	sp,sp,16
	jr	ra
	.size	_str_sle, .-_str_sle
	.ident	"GCC: (GNU) 9.2.0"
