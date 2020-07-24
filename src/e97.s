  .globl func, build_arg

  .data

  .text

func:
  enter $0, $0
  nop
  leave
  ret

# uint8_t build_arg(uint8_t a, uint8_t b, uint8_t c, uint8_t d)
# {
#    a = a & 8;
#    a = a | (b & 4);
#    a = a | (c & 2);
#    a = a | (d & 1);
#
#    return a;
# }
build_arg_1:
  enter $0, $0
  xor %eax, %eax
  mov 8(%ebp), %al
  and $0b1000, %al
  mov 12(%ebp), %ah
  and $0b0100, %ah
  or %ah, %al
  mov 16(%ebp), %ah
  and $0b0010, %ah
  or %ah, %al
  mov 20(%ebp), %ah
  and $0b0001, %ah
  or %ah, %al
  leave
  ret

build_arg:
  enter $0, $0
  xor %eax, %eax
  mov %eax, %ecx

  mov $0b1000, %bl

  loop:
  mov 8(%ebp,%ecx,4), %ah
  and %bl, %ah
  or %ah, %al
  inc %cl
  shr %bl
  jnz loop

  leave
  ret
