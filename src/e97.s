  .globl func

  .data

mask: .long 0x00000001, 0x00000001, 0x00000001, 0x00000001

  .text

# uint8_t func(uint8_t *a, uint8_t *b, uint8_t *c, uint8_t *d)
# {
#    prepare_args(a, b, c, d);
#    return (*a | *b) & (!*a | *c) & (!*b | !*c) & (!*a | !*c | d);
# }
func:
  enter $0, $0
  sub $8+16, %esp # stack align
  movdqa 8(%ebp), %xmm0
  movdqa %xmm0, (%esp)
  call prepare_args
  add $8+16, %esp

  # (1) = *a | *b
  mov 8(%ebp), %eax # &a
  mov (%eax), %al # *a
  mov 8+4*1(%ebp), %ebx # &b
  mov (%ebx), %bl # *b
  mov %bl, %bh
  or %al, %bh
  mov %bh, %dl
  shl $8, %dx

  # (2) = !*a | *c
  mov 8+4*2(%ebp), %ecx # &c
  mov (%ecx), %cl # *c
  not %al
  mov %cl, %ch
  or %al, %ch
  mov %ch, %dl
  shl $8, %edx

  # (3) = !*b | !*c
  not %cl
  not %bl
  or %cl, %bl
  mov %bl, %dl

  # (4) = !*a | !*c | *d
  mov 8+4*3(%ebp), %ebx # &d
  mov (%ebx), %bl # *d
  or %cl, %al
  or %bl, %al

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
