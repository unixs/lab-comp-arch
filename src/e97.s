  .globl func

  .data
  .align 16

mask: .long 0x00000001, 0x00000001, 0x00000001, 0x00000001

  .text

# uint8_t func(uint8_t *a, uint8_t *b, uint8_t *c, uint8_t *d)
# {
#    prepare_args(a, b, c, d);
#    return (*a | *b) & (!*a | *c) & (!*b | !*c) & (!*a | !*c | *d);
# }
func:
  enter $0, $0
  sub $8+16, %esp # stack align
  movdqa 8(%ebp), %xmm0
  movdqa %xmm0, (%esp)
  call prepare_args
  add $8+16, %esp

  mov 8(%ebp), %ebx # &[abcd]
  mov (%ebx), %ebx
  mov %bx, %ax # al = *a; ah = *b
  shr $16, %ebx # bl = *c; bh = *d

  # (1) = *a | *b
  mov %ah, %dl
  or %al, %dl
  shl $8, %dx

  # (2) = !*a | *c
  not %al
  mov %bl, %dl
  or %al, %dl
  shl $8, %edx

  # (3) = !*b | !*c
  not %ah
  not %bl
  mov %ah, %dl
  or %bl, %dl

  # (4) = !*a | !*c | *d
  or %bl, %al
  or %bh, %al

  # (5) = (3) & (4)
  and %dl, %al

  # (6) = (2) & (5)
  shr $8, %edx
  and %dl, %al

  # (7) = (1) & (6)
  shr $8, %dx
  and %dl, %al

  leave
  ret

# void prepare_args(uint8_t *a, uint8_t *b, uint8_t *c, uint8_t *d)
# {
#    *a = *a & 1;
#    *b = *b & 1;
#    *c = *c & 1;
#    *d = *d & 1;
# }
prepare_args:
  enter $0, $0
  xor %eax, %eax
  mov %eax, %ecx

  sub $8, %esp # stack align

  1:
  mov 8(%ebp,%ecx,4), %ebx
  mov (%ebx), %al
  push %eax
  inc %cl
  cmp $4, %cl
  jl 1b

  movdqa (%esp), %xmm0
  movdqa mask, %xmm1
  pand %xmm1, %xmm0 # SSE AND
  movdqa %xmm0, (%esp)

  1:
  dec %ecx
  js 1f
  mov 8(%ebp,%ecx,4), %ebx
  pop %eax
  mov %al, (%ebx)
  jmp 1b
  1:

  add $8, %esp # stack restore

  leave
  ret
