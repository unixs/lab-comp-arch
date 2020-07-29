  .globl func, build_arg

  .data

mask: .byte 0x01, 0x01, 0x01, 0x01

  .text

func:
  enter $0, $0
  nop
  leave
  ret

# uint8_t build_arg(uint8_t a, uint8_t b, uint8_t c, uint8_t d)
# {
#    a = a & 1 << 3;
#    a = a | (b & 1 << 2);
#    a = a | (c & 1 << 1);
#    a = a | (d & 1);
#
#    return a;
# }
build_arg_1:
  enter $0, $0
  xor %eax, %eax
  mov 8(%ebp), %al
  and $1, %al
  shl $3, %al
  mov 12(%ebp), %bl
  and $1, %bl
  shl $2, %bl
  or %bl, %al
  mov 16(%ebp), %bl
  and $1, %bl
  shl %bl
  or %bl, %al
  mov 20(%ebp), %bl
  and $0b0001, %bl
  or %bl, %al
  leave
  ret

build_arg:
  enter $0, $0
  xor %eax, %eax
  xor %ecx, %ecx

  1:
  mov 8(%ebp,%ecx,4), %bl
  and $1, %bl
  or %bl, %al
  shl %al
  inc %cl
  cmp $4, %cl
  jnz 1b

  leave
  ret

# With SSE2
build_arg_3:
  xor %eax, %eax
  mov %eax, %ecx

  jmp 2f
  1:
  shl $8, %eax
  2:
  mov 8(%ebp,%ecx,4), %al
  inc %cl
  cmp $4, %cl
  jl 1b

  movd %eax, %xmm0
  movd mask, %xmm1
  pand %xmm1, %xmm0 # SIMD and

  movd %xmm0, %edx

  xor %ecx, %ecx
  mov %dl, %al

  ret
# edx
#    a    b    c    d
# 0000 0000 0000 0001

# al
#      abcd
# 0000 0001
