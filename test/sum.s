//
//  sum.s
//  test
//
//  Created by paprika on 2018/3/15.
//  Copyright © 2018年 paprika. All rights reserved.
//  .data数据段  .text代码段 .global全局访问 _sum函数实现 movq64位 movl32位 %rdi %rsi寄存器
.text
.global _sum

_sum:
movq %rdi, %rax
addq %rsi, %rax
retq

