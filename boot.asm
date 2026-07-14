; ============================================================
; БУТ-СЕРВЕР - ЭТАП 1 (BOOT SECTOR)
; Загружает второй этап с дискеты/диска
; ============================================================

BITS 16
ORG 0x7C00

start:
    ; Настройка сегментов
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Очистка экрана
    mov ax, 0x0003
    int 0x10

    ; Вывод сообщения
    mov si, msg_boot
    call print_string

    ; Загрузка второго этапа (секторы 2-34)
    mov ax, 0x1000      ; Сегмент для загрузки
    mov es, ax
    xor bx, bx          ; Смещение 0x0000

    mov ah, 0x02        ; Функция чтения
    mov al, 33          ; Количество секторов (2-34)
    mov ch, 0           ; Цилиндр 0
    mov cl, 2           ; Начинаем с сектора 2
    mov dh, 0           ; Головка 0
    mov dl, 0           ; Диск A:
    int 0x13
    jc disk_error

    ; Переход на второй этап
    jmp 0x1000:0x0000

disk_error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg_boot   db 'Boot loader v2.0...', 13, 10, 0
msg_error  db 'Error loading kernel!', 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xAA55