BITS 16
ORG 32768
%include 'os1dev.inc'
%include 'mouse.lib'

call os_clear_screen
call mouselib_setup
mov si, terminal
call os_print_string

main:
	call mouselib_freemove
	jc keypress
	jnc terminal_cmp
	jmp main

keypress:
	cmp al, 27
	je exit
	
	jmp main

terminal_cmp:
	cmp DX, 0
	jnz main
	cmp CX, 1
	jnz main
	
	call mouselib_remove_driver
	call os_clear_screen
	ret
exit:
	call mouselib_remove_driver
	ret

terminal db 'RET', 0