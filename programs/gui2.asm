BITS 16
ORG 32768
%include 'os1dev.inc'
%include 'mouse.lib'

call os_clear_screen
call mouselib_setup
mov ax, 0
mov bx, 0
mov cx, 0
mov dx, 24
call mouselib_range
mov si, terminal
call os_print_string
call os_print_newline
mov si, selector
call os_print_string

main:
	call mouselib_freemove
	jc keypress
	jnc function_cmp
	jmp main

keypress:
	cmp al, 27
	je exit
	
	jmp main

function_cmp:
	call mouselib_locate
	cmp DX, 0
	jz open_terminal
	cmp DX, 1
	jz open_selector
	jnz main
	
open_terminal:	
	call mouselib_remove_driver
	call os_clear_screen
	ret

open_selector:
	call mouselib_remove_driver
	call os_clear_screen
	jmp os_file_selector

	exit:
	call mouselib_remove_driver
	ret

terminal db '*RET', 0
selector db '*APP', 0