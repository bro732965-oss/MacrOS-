; ============================================================
; БУТ-СЕРВЕР - ЭТАП 2
; Переключение в защищенный режим, затем в Long Mode
; Загрузка ядра
; ============================================================

BITS 16
ORG 0x0000

; ============================================================
; СЕКЦИЯ ДАННЫХ
; ============================================================
section .data
    msg_enter       db 13, 10, 'Entering protected mode...', 13, 10, 0
    msg_long        db 'Entering long mode...', 13, 10, 0
    msg_kernel      db 'Loading kernel...', 13, 10, 0
    msg_done        db 'Kernel loaded!', 13, 10, 0
    msg_error       db 'Kernel load error!', 13, 10, 0
    msg_wait        db 'Press any key to boot...', 13, 10, 0
    
    ; GDT (Global Descriptor Table)
    gdt_start:
        ; Нулевой дескриптор
        dq 0x0000000000000000
        
        ; Код 64-bit (Ring 0)
        dq 0x00209A0000000000
        
        ; Данные 64-bit (Ring 0)  
        dq 0x0000920000000000
        
        ; Код 32-bit (Ring 0)
        dq 0x00CF9A000000FFFF
        
        ; Данные 32-bit (Ring 0)
        dq 0x00CF92000000FFFF
    gdt_end:
    
    gdt_desc:
        dw gdt_end - gdt_start - 1
        dd gdt_start

    ; IDT (Interrupt Descriptor Table) - временная
    idt_desc:
        dw 0
        dd 0

    ; Таблица страниц для Long Mode
    pml4_table  times 512 dq 0
    pdp_table   times 512 dq 0
    pd_table    times 512 dq 0
    
    ; Буфер для ядра
    kernel_buffer times 65536 db 0

; ============================================================
; СЕКЦИЯ КОДА
; ============================================================
section .text
global start

start:
    ; Настройка сегментов
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9000
    
    ; Очистка экрана
    mov ax, 0x0003
    int 0x10
    
    ; Вывод сообщения
    mov si, msg_enter
    call print_string
    
    ; Загрузка ядра в память
    call load_kernel
    
    ; Проверка A20
    call check_a20
    
    ; Настройка GDT
    call setup_gdt
    
    ; Переход в защищенный режим
    call enter_protected
    
    ; Настройка страниц для Long Mode
    call setup_paging
    
    ; Переход в Long Mode
    call enter_long_mode
    
    ; Переход на ядро
    jmp 0x08:kernel_entry

; ============================================================
; ФУНКЦИИ ЗАГРУЗЧИКА
; ============================================================

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

load_kernel:
    mov si, msg_kernel
    call print_string
    
    ; Чтение ядра с диска (секторы 35+)
    mov ax, 0x2000      ; Сегмент для ядра
    mov es, ax
    xor bx, bx
    
    mov ah, 0x02
    mov al, 64          ; Количество секторов
    mov ch, 0
    mov cl, 35          ; Начинаем с сектора 35
    mov dh, 0
    mov dl, 0
    int 0x13
    jc kernel_error
    
    mov si, msg_done
    call print_string
    ret
    
kernel_error:
    mov si, msg_error
    call print_string
    jmp $

check_a20:
    ; Проверка A20
    mov ax, 0x2401
    int 0x15
    ret

setup_gdt:
    ; Загрузка GDT
    lgdt [gdt_desc]
    ret

enter_protected:
    cli
    
    ; Включение A20
    in al, 0x92
    or al, 2
    out 0x92, al
    
    ; Включение защищенного режима
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; Дальний переход на 32-битный код
    jmp 0x18:.protected_mode
    BITS 32

.protected_mode:
    ; Настройка сегментов
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    
    mov si, msg_long
    call print_string_pm
    ret

print_string_pm:
    pusha
    mov edx, 0xB8000
.loop:
    lodsb
    or al, al
    jz .done
    mov [edx], al
    add edx, 2
    jmp .loop
.done:
    popa
    ret

setup_paging:
    ; Очистка таблиц страниц
    mov edi, pml4_table
    mov ecx, 512
    xor eax, eax
    rep stosd
    
    ; Настройка PML4
    mov eax, pdp_table
    or eax, 0x03        ; Present + Read/Write
    mov [pml4_table], eax
    
    ; Настройка PDP
    mov eax, pd_table
    or eax, 0x03
    mov [pdp_table], eax
    
    ; Настройка PD (2MB страницы)
    mov edi, pd_table
    mov eax, 0x83       ; Present + Read/Write + 2MB
    mov ecx, 512
.setup_pd:
    mov [edi], eax
    add eax, 0x00200000
    add edi, 8
    loop .setup_pd
    
    ; Загрузка PML4 в CR3
    mov eax, pml4_table
    mov cr3, eax
    ret

enter_long_mode:
    ; Включение PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    
    ; Включение Long Mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr
    
    ; Включение пейджинга
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    
    ; Переход в 64-битный режим
    jmp 0x08:.long_mode
    BITS 64

.long_mode:
    ; Настройка сегментов
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x90000
    
    ; Очистка экрана
    mov rax, 0x0720072007200720
    mov rdi, 0xB8000
    mov rcx, 2000
    rep stosq
    
    ret

; ============================================================
; ТОЧКА ВХОДА В ЯДРО
; ============================================================
kernel_entry:
    ; Переход к ядру (функция start)
    mov rax, 0x20000
    jmp rax

; ============================================================
; ДОПОЛНИТЕЛЬНЫЕ ДАННЫЕ
; ============================================================
times 32768 - ($ - $$) db 0