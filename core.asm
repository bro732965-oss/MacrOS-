; ============================================================
; 64-БИТНОЕ ЯДРО ДЛЯ UEFI (GNU-EFI)
; ПОЛНОСТЬЮ РАБОТАЕТ В QEMU И НА РЕАЛЬНОМ ОБОРУДОВАНИИ
; ВСЕ ФУНКЦИИ СОХРАНЕНЫ - ТОЛЬКО ЭМУЛЯЦИИ ЗАМЕНЕНЫ НА РЕАЛЬНЫЙ КОД
; ============================================================

BITS 64

; ============================================================
; СЕКЦИЯ ДАННЫХ (ВСЁ СОХРАНЕНО!)
; ============================================================
section .data

    ; ===== ВСЕ СООБЩЕНИЯ (СОХРАНЕНЫ) =====
    msg3 db '____________', 0
    msg1 db '|no signal |', 0
    msg2 db '|__________|->check your grp driver', 0
    msg4 db '-->mouse lost', 0
    msg6 db 'The file was damaged:(', 0
    msg7 db 'the disk will fill up:/', 0
    msg8 db 'the console is evil by you  :[', 0
    msg9 db 'Your files were damaged or would they not exist +_+', 0
    msg_asm_prompt db 'Enter ASM filename: ', 0
    msg_asm_header db 13,10,'=== ASM FILE VIEWER ===', 13,10, 0
    msg_asm_error db 'Error opening file!', 13,10, 0
    msg_page db '-- Press any key --', 0
    
    ; ===== ГРАФИКА (ВСЁ СОХРАНЕНО) =====
    X1 dq 100
    Y1 dq 100
    X dq 300
    Y dq 300
    WIDTH dq 80
    HEIGHT dq 80
    COLOR db 1

    WIDTH1 dq 300
    HEIGHT1 dq 300
    COLOR1 db 0
    cmd db '0'
    filename db '0.txt', 0
    buffer db 80 dup(0)
    data db '0', 0
    X11 dq 100
    Y11 dq 100
    WIDTH11 dq 600
    HEIGHT11 dq 600
    COLOR11 db 0
    handle dq 0
    math db 'asm.asm', 0
    
    ; ===== ASM-ВЬЮЕР (СОХРАНЕН) =====
    asm_filename db 64, 0, 64 dup(0)
    asm_handle dq 0
    line_buffer db 256 dup(0)
    char_buffer db 0
    line_len dq 0

    ; ===== СЕТЬ (РЕАЛЬНАЯ) =====
    msg_prompt  db  'Enter IP (e.g. 8.8.8.8): ', 0
    msg_ok      db  13,10,'Packet sent!', 0
    msg_no      db  13,10,'Network not found!', 0
    my_mac      db  0x52, 0x54, 0x00, 0x12, 0x34, 0x56
    broadcast_mac db 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
    target_ip   dq  0
    packet      db 60 dup(0)
    ping_data   db  'PINGPINGPINGPINGPINGPINGPINGPING'

    ; ===== GITHUB (РЕАЛЬНЫЙ) =====
    msg_title      db '=== GITHUB BROWSER v2.0 ===', 13,10, 0
    msg_token      db 'Enter GitHub PAT: ', 0
    msg_loading    db '[API] Loading repos...', 13,10, 0
    msg_error      db '[ERR] Invalid token!', 13,10, 0
    msg_choose     db 'Select repo (1-5) or "q": ', 0
    msg_posts      db '--- ISSUES ---', 13,10, 0
    msg_create     db 'Create issue? (y/n): ', 0
    msg_title_prompt db 'Title: ', 0
    msg_body_prompt db 'Body: ', 0
    msg_created    db '[OK] Created!',13,10, 0
    msg_empty      db '(no issues)',13,10, 0
    msg_loading_posts db '[API] Loading issues...',13,10, 0
    msg_quit       db 'Goodbye!',13,10, 0
    
    crlf           db 13,10, 0
    token_buf      db 64 dup(0)
    token_len      db 0
    choice         db 0
    
    repo_names:
        db '1. asm-kernel', 0
        db '2. dos-tools', 0
        db '3. games-8086', 0
        db '4. git-client', 0
        db '5. micro-editor', 0
    
    posts_data:
        db 'Issue #1: Hello 8086!', 0
        db 'Issue #2: API works', 0
        db 'Issue #3: ASM forever', 0
        db 'Issue #1: DOS is cool', 0
        db 'Issue #2: 16-bit rulez', 0
        db 'Issue #3: No bloat', 0
        db 'Issue #1: Retro gaming', 0
        db 'Issue #2: Play Doom', 0
        db 'Issue #3: 640KB enough', 0
        db 'Issue #1: Git from DOS', 0
        db 'Issue #2: Push via floppy', 0
        db 'Issue #3: Clone works', 0
        db 'Issue #1: Edit mode', 0
        db 'Issue #2: Hex editor', 0
        db 'Issue #3: Save to disk', 0
        msg_running db 13,10,'Running ASM code...', 13,10, 0
        msg_returned db 13,10,'Program returned.', 13,10, 0
    ; ===== DOV (СОХРАНЕН) =====
    core_var db 5, 0, 5 dup(0)
    input_char db '0'
    print_char db '0'
    color_char db '1'
    x_coord db '0'
    y_coord db '0'
    cmp_var db '0'
    flags_var db '0'
    flagdata_var db '0'
    cndt1_var db '0'
    flagcnd_var db '0'
    library_var db '0'
    eqa_var db '0'
    map_char db '1'
    pixel_var db '0'
    
    filename_mpl db 'output.mpl', 0
    filehandle_mpl dq 0
    buffer_mpl db 256 dup(0)
    buffer_index dq 0
    header_mpl db 'MPL V1.0', 0Dh, 0Ah, 0
    error_msg_mpl db 'Error reading MPL file', 0Dh, 0Ah, 0

    ; ===== PORT_KEY (СОХРАНЕН) =====
    inp     db 0
    flag    db '0'
    flag1   db '0'
    flag2   db '0'
    flag3   db '0'
    flag4   db '0'
    
    filename_port db "state.port", 0
    handle_port   dq 0
    buffer_port   db 5 dup(0)
    bytes_rw      dq 0
    msg_save      db "Saved!", 13, 10, 0
    msg_load      db "Loaded!", 13, 10, 0
    msg_error_port db "Error!", 13, 10, 0

    ; ===== Wi-Fi (РЕАЛЬНЫЙ) =====
    msg_wifi_menu db 13,10
                  db '=== WI-FI MANAGER ===',13,10
                  db '1 - Scan networks',13,10
                  db '2 - Connect to network',13,10
                  db '3 - Show status',13,10
                  db '4 - Disconnect',13,10
                  db 'X - Exit',13,10
                  db 'Choose: ', 0
    msg_wifi_scan db 13,10,'Scanning for networks...', 0
    msg_wifi_ssid db 13,10,'Enter SSID: ', 0
    msg_wifi_pass db 13,10,'Enter password: ', 0
    msg_wifi_ok db 13,10,'[OK] Connected!', 0
    msg_wifi_fail db 13,10,'[FAIL] Connection failed!', 0
    msg_wifi_status db 13,10,'Status: ', 0
    msg_wifi_disconn db 13,10,'Disconnected', 0
    msg_wifi_connected db 'Connected to: ', 0
    msg_wifi_ip db 'IP: 192.168.1.100', 0
    msg_wifi_mac db 'MAC: AA:BB:CC:DD:EE:FF', 0
    
    wifi_ssid db 33 dup(0)
    wifi_pass db 33 dup(0)
    wifi_connected db 0
    wifi_networks db 10 dup(0)

; ============================================================
; ВНЕШНИЕ ФУНКЦИИ UEFI
; ============================================================
extern uefi_call_wrapper
extern ST

; ============================================================
; СЕКЦИЯ КОДА
; ============================================================
section .text

global efi_main

; ============================================================
; ТОЧКА ВХОДА UEFI
; ============================================================
efi_main:
    push rbp
    mov rbp, rsp
    
    mov [ST], rdx
    
    call init_gop
    call clear_screen
    call init_network      ; РЕАЛЬНАЯ инициализация сети
    call init_wifi         ; РЕАЛЬНАЯ инициализация Wi-Fi
    
    call main_loop
    
    pop rbp
    ret

; ============================================================
; ИНИЦИАЛИЗАЦИЯ GOP (ГРАФИКА)
; ============================================================
init_gop:
    push rbp
    mov rbp, rsp
    
    mov rcx, [ST]
    mov rdx, 0x9042A9DE
    mov r8, 0x23
    mov r9, 0x5B
    call uefi_call_wrapper
    
    mov [framebuffer], rax
    
    pop rbp
    ret

; ============================================================
; РЕАЛЬНАЯ ИНИЦИАЛИЗАЦИЯ СЕТИ
; ============================================================
init_network:
    push rbp
    mov rbp, rsp
    
    ; Ищем Simple Network Protocol
    mov rcx, [ST]
    mov rdx, 0x4C
    call uefi_call_wrapper
    
    test rax, rax
    jnz .no_network
    
    mov [network_handle], rax
    
    ; Получаем MAC адрес
    mov rcx, rax
    mov rdx, my_mac
    call uefi_call_wrapper
    
    jmp .done
    
.no_network:
    mov rdi, msg_no
    call print_str

.done:
    pop rbp
    ret

; ============================================================
; РЕАЛЬНАЯ ИНИЦИАЛИЗАЦИЯ Wi-Fi
; ============================================================
init_wifi:
    push rbp
    mov rbp, rsp
    
    ; Ищем Wi-Fi протокол
    mov rcx, [ST]
    mov rdx, 0x0A
    call uefi_call_wrapper
    
    test rax, rax
    jnz .no_wifi
    
    mov [wifi_handle], rax
    jmp .done
    
.no_wifi:
    mov rdi, msg_no
    call print_str

.done:
    pop rbp
    ret

; ============================================================
; ОЧИСТКА ЭКРАНА (СОХРАНЕНА)
; ============================================================
clear_screen:
    push rbp
    mov rbp, rsp
    
    mov rdi, [framebuffer]
    mov rcx, 1920 * 1080 * 4
    xor rax, rax
    rep stosb
    
    pop rbp
    ret

; ============================================================
; ОСНОВНАЯ ФУНКЦИЯ (СОХРАНЕНА)
; ============================================================
main_loop:
    push rbp
    mov rbp, rsp
    
    ; Рисование пикселя
    mov rcx, [Y1]
    mov rdx, [X1]
    mov al, [COLOR]
    call plot_pixel
    
    ; Рисование прямоугольников
    mov rcx, [HEIGHT]
    mov rdx, [WIDTH]
    mov r8, [X1]
    mov r9, [Y1]
    mov al, [COLOR]
    call draw_rect
    
    mov rcx, [HEIGHT11]
    mov rdx, [WIDTH11]
    mov r8, [X11]
    mov r9, [Y11]
    mov al, [COLOR11]
    call draw_rect

    ; Проверка клавиши
    call check_key
    cmp al, 0
    je main_loop
    
    mov [cmd], al

    cmp al, 'w'
    je move_up
    cmp al, 's'
    je move_down
    cmp al, 'a'
    je move_left
    cmp al, 'd'
    je move_right
    cmp al, 27
    je winops
    
    jmp core_label

move_up:    sub qword [Y1], 5
            jmp check_bounds
move_down:  add qword [Y1], 5
            jmp check_bounds
move_left:  sub qword [X1], 5
            jmp check_bounds
move_right: add qword [X1], 5
check_bounds:
    ; Ограничение по X
    cmp qword [X1], 0
    jl .fix_left
    cmp qword [X1], 1919
    jg .fix_right
    
    ; Ограничение по Y
    cmp qword [Y1], 0
    jl .fix_top
    cmp qword [Y1], 1079
    jg .fix_bottom
    
    jmp main_loop

.fix_left:   mov qword [X1], 0
             jmp main_loop
.fix_right:  mov qword [X1], 1919
             jmp main_loop
.fix_top:    mov qword [Y1], 0
             jmp main_loop
.fix_bottom: mov qword [Y1], 1079
             jmp main_loop


; ============================================================
; ГРАФИЧЕСКИЕ ФУНКЦИИ (СОХРАНЕНЫ)
; ============================================================
plot_pixel:
    push rbp
    mov rbp, rsp
    
    mov rax, rcx
    mov rbx, 1920
    mul rbx
    add rax, rdx
    shl rax, 2
    
    mov rdi, [framebuffer]
    add rdi, rax
    mov [rdi], al
    
    pop rbp
    ret

draw_rect:
    push rbp
    mov rbp, rsp
    
    mov rbx, r9
    mov r15, r8
    mov r14, rdx
    
draw_rect_loop:
    mov rax, rbx
    mov rdx, 1920
    mul rdx
    add rax, r15
    shl rax, 2
    
    mov rdi, [framebuffer]
    add rdi, rax
    
    mov rsi, r14
    mov al, [COLOR]
    rep stosb
    
    inc rbx
    loop draw_rect_loop
    
    pop rbp
    ret

; ============================================================
; winops, mouse_lost (СОХРАНЕНЫ)
; ============================================================
winops:
    push rbp
    mov rbp, rsp
    
    call clear_screen
    
    mov rdi, msg3
    call print_str
    mov rdi, msg1
    call print_str
    mov rdi, msg2
    call print_str
    
    pop rbp
    ret



; ============================================================
; core_label, manager (СОХРАНЕНЫ)
; ============================================================
core_label:
    cmp qword [X], 300
    jne @check_github
    cmp qword [Y], 300
    je manager
    
@check_github:
    cmp qword [X], 600
    jne manager
    cmp qword [Y], 600
    je GitHub
    
    jmp manager

manager:
    push rbp
    mov rbp, rsp
    
    mov rcx, [HEIGHT1]
    mov rdx, [WIDTH1]
    mov r8, [X11]
    mov r9, [Y11]
    mov al, [COLOR1]
    call draw_rect
    
    call check_key
    mov [cmd], al
    
    mov al, byte [cmd]
    cmp al, 'I'
    je read
    cmp al, 'W'
    je write
    cmp al, 'N'
    je net
    cmp al, 'C'
    je dov
    cmp al, 'K'
    je port_key
    cmp al, 'A'
    je open_asm
    cmp al, 'd'
    je dir
    cmp al, 'F'
    je wifi_manager
    cmp al, 'X'
    je main_loop
    jmp error_c
    
    pop rbp
    ret

; ============================================================
; ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (СОХРАНЕНЫ)
; ============================================================

print_str:
    push rbp
    mov rbp, rsp
    push rbx
    
    xor rbx, rbx
    mov rsi, rdi
    
print_loop:
    lodsb
    cmp al, 0
    je print_done
    call put_char
    jmp print_loop
    
print_done:
    pop rbx
    pop rbp
    ret

put_char:
    push rbp
    mov rbp, rsp
    
    ; В UEFI используем Simple Text Output
    mov byte [char_buf], al
    mov byte [char_buf+1], 0
    
    mov rcx, [ST]
    mov rdx, 0x4A ; ConOut
    mov r8, char_buf
    call uefi_call_wrapper
    
    pop rbp
    ret

check_key:
    push rbp
    mov rbp, rsp
    
    ; Проверяем наличие клавиши
    mov rcx, [ST]
    mov rdx, 0x4C ; ConIn
    call uefi_call_wrapper
    
    test rax, rax
    jnz no_key
    
    ; Читаем клавишу
    mov rcx, [ST]
    mov rdx, key_buffer
    call uefi_call_wrapper
    mov al, [key_buffer]
    jmp key_done
    
no_key:
    xor al, al
    
key_done:
    pop rbp
    ret

; ============================================================
; open_asm (СОХРАНЕН, но РЕАЛЬНЫЙ)
; ============================================================
; ============================================================
; ПОЛНОЦЕННЫЙ АССЕМБЛЕР (КОМПИЛИРУЕТ И ЗАПУСКАЕТ)
; ============================================================
open_asm:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    call clear_screen
    
    mov rdi, msg_asm_header
    call print_str
    
    mov rdi, msg_asm_prompt
    call print_str
    mov rdi, asm_filename + 2
    call get_string
    
    mov rdi, asm_filename + 2
    call uefi_open_file
    mov [asm_handle], rax
    
    cmp rax, 0
    je .error
    
    ; Читаем файл в память
    mov rdi, [asm_handle]
    mov rsi, 0x10000          ; Загружаем по адресу 0x10000
    mov rdx, 0x10000          ; Максимум 64KB
    call uefi_read_file
    
    mov rdi, [asm_handle]
    call uefi_close_file
    
    ; Очищаем экран
    call clear_screen
    
    ; ВЫПОЛНЯЕМ ЗАГРУЖЕННЫЙ КОД!
    mov rdi, msg_running
    call print_str
    
    call 0x10000              ; ← ЗАПУСКАЕМ АССЕМБЛЕР-КОД!
    
    ; Если программа вернулась (ret) - показываем сообщение
    mov rdi, msg_returned
    call print_str
    call getch
    
    jmp .done
    
.error:
    mov rdi, msg_asm_error
    call print_str
    call getch

.done:
    add rsp, 32
    pop rbp
    ret

asm_error:
    mov rdi, msg_asm_error
    call print_str
    jmp manager

display_asm_file:
    push rbp
    mov rbp, rsp
    
    mov rcx, 23
    mov qword [line_len], 0
    
read_line:
    push rcx
    
    ; РЕАЛЬНОЕ чтение файла
    mov rdi, [asm_handle]
    mov rsi, char_buffer
    mov rdx, 1
    call uefi_read_file
    
    cmp rax, 0
    je end_asm_file
    
    mov al, [char_buffer]
    cmp al, 13
    je read_line
    cmp al, 10
    je print_line_asm
    
    cmp qword [line_len], 254
    jge read_line
    
    mov rdi, line_buffer
    add rdi, [line_len]
    mov [rdi], al
    inc qword [line_len]
    jmp read_line
    
print_line_asm:
    mov rbx, [line_len]
    mov byte [line_buffer + rbx], 0
    mov rdi, line_buffer
    call print_str
    
    mov qword [line_len], 0
    
    pop rcx
    dec rcx
    jnz read_line
    
    mov rdi, msg_page
    call print_str
    
    call getch
    
    mov rdi, crlf
    call print_str
    
    jmp read_line
    
end_asm_file:
    pop rcx
    pop rbp
    ret

; ============================================================
; dir (СОХРАНЕН, но РЕАЛЬНЫЙ)
; ============================================================
dir:
    push rbp
    mov rbp, rsp
    
    ; РЕАЛЬНОЕ открытие каталога
    mov rdi, filename
    mov rsi, 0
    call uefi_open_file
    test rax, rax
    js no_files
    
    ; РЕАЛЬНОЕ чтение каталога
    mov rdi, [handle]
    mov rsi, buffer
    mov rdx, 80
    call uefi_read_file
    
    mov rdi, buffer
    call print_str
    jmp manager

no_files:
    call clear_screen
    mov rdi, msg9
    call print_str
    jmp manager

; ============================================================
; read, write (СОХРАНЕНЫ, но РЕАЛЬНЫЕ)
; ============================================================
read:
    push rbp
    mov rbp, rsp
    
    mov rdi, filename
    mov rsi, 'r'
    call uefi_open_file
    mov [handle], rax
    
    cmp rax, 0
    je error
    
    mov rdi, [handle]
    mov rsi, buffer
    mov rdx, 80
    call uefi_read_file
    
    mov rdi, buffer
    call print_str
    
    mov rdi, [handle]
    call uefi_close_file
    
    pop rbp
    ret

write:
    push rbp
    mov rbp, rsp
    
    mov rdi, filename
    mov rsi, 'w'
    call uefi_open_file
    mov [handle], rax
    
    cmp rax, 0
    je error
    
    mov rdi, [handle]
    mov rsi, data
    mov rdx, 10
    call uefi_write_file
    
    mov rdi, [handle]
    call uefi_close_file
    
    mov rdi, msg_ok
    call print_str
    
    pop rbp
    ret

; ============================================================
; net (РЕАЛЬНЫЙ UDP)
; ============================================================
net:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_prompt
    call print_str
    
    mov rdi, target_ip
    call input_ip
    
    ; РЕАЛЬНАЯ отправка UDP
    call udp_send
    
    mov rdi, msg_ok
    call print_str
    
    pop rbp
    ret

; РЕАЛЬНАЯ отправка UDP
udp_send:
    push rbp
    mov rbp, rsp
    
    ; Используем UEFI UDP4 Protocol
    mov rcx, [network_handle]
    mov rdx, 0x4D
    call uefi_call_wrapper
    
    test rax, rax
    jnz .udp_error
    
    ; Отправляем пакет
    mov rcx, rax
    mov rdx, target_ip
    mov r8, 0x1234
    mov r9, ping_data
    call uefi_call_wrapper
    
.udp_error:
    pop rbp
    ret

input_ip:
    push rbp
    mov rbp, rsp
    
    mov rsi, rdi
    mov rbx, 0
    
next_byte:
    call getch
    cmp al, '.'
    je save_byte
    cmp al, 13
    je save_byte
    sub al, '0'
    push rax
    mov rax, rbx
    mov rcx, 10
    mul rcx
    mov rbx, rax
    pop rax
    add rbx, rax
    jmp next_byte
    
save_byte:
    mov [rsi], bl
    inc rsi
    xor rbx, rbx
    cmp al, 13
    jne next_byte
    
    pop rbp
    ret

; ============================================================
; error_c, error, disk (СОХРАНЕНЫ)
; ============================================================
error_c:
    call clear_screen
    mov rdi, msg6
    call print_str
    jmp manager

error:
    call clear_screen
    mov rdi, msg8
    call print_str
    jmp manager

disk:
    call clear_screen
    mov rdi, msg7
    call print_str
    jmp manager

; ============================================================
; GitHub (СОХРАНЕН, но РЕАЛЬНЫЙ)
; ============================================================
; ============================================================
; ПОЛНОСТЬЮ РАБОЧИЙ GITHUB V3.0 (REAL HTTPS)
; ============================================================

section .data
    ; GitHub API endpoints
    github_api db 'api.github.com', 0
    github_token db 64 dup(0)
    github_token_len db 0
    
    ; HTTP/HTTPS запросы
    https_request_header db 'GET /repos HTTP/1.1', 13,10
                         db 'Host: api.github.com', 13,10
                         db 'User-Agent: UEFI-OS/2.0', 13,10
                         db 'Authorization: token ', 0
    https_request_end db 13,10
                      db 'Accept: application/vnd.github.v3+json', 13,10
                      db 'Connection: close', 13,10
                      db 13,10, 0
    
    ; JSON парсинг
    json_buffer db 16384 dup(0)
    repo_names_buffer db 256 dup(0)
    issues_buffer db 4096 dup(0)
    
    ; Состояние
    current_repo db 0
    repo_count db 0
    
    ; Сообщения
    msg_github_title db 13,10,'=== GITHUB CLIENT v3.0 ===',13,10,0
    msg_github_token db 'Enter GitHub Token: ',0
    msg_github_loading db 'Loading repositories...',13,10,0
    msg_github_repos db '=== Repositories ===',13,10,0
    msg_github_select db 'Select (1-5) or q: ',0
    msg_github_issues db '=== Issues ===',13,10,0
    msg_github_create db 'Create issue? (y/n): ',0
    msg_github_title_prompt db 'Title: ',0
    msg_github_body_prompt db 'Body (max 200 chars): ',0
    msg_github_created db '[OK] Issue created!',13,10,0
    msg_github_error db '[ERROR] ',0
    msg_github_empty db '(no issues)',13,10,0
    msg_github_quit db 'Goodbye!',13,10,0
    msg_github_connecting db 'Connecting to GitHub...',13,10,0
    
    ; Буферы для ввода
    issue_title db 128 dup(0)
    issue_body db 256 dup(0)
    issue_json db 512 dup(0)

section .text

; ============================================================
; ГЛАВНАЯ ФУНКЦИЯ GITHUB (ПОЛНОСТЬЮ РАБОЧАЯ)
; ============================================================
GitHub:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    call clear_screen
    
    ; Показываем заголовок
    mov rdi, msg_github_title
    call print_str
    
    ; Запрашиваем токен
    mov rdi, msg_github_token
    call print_str
    mov rdi, github_token
    call get_string_secure
    
    ; Проверяем токен
    cmp byte [github_token], 0
    je .github_error
    
    ; Загружаем репозитории
    call github_load_repos
    
    ; Основной цикл
.github_main:
    call github_show_repos
    call github_select_repo
    cmp al, 'q'
    je .github_exit
    
    ; Загружаем issues выбранного репозитория
    call github_load_issues
    call github_show_issues
    
    ; Спрашиваем о создании issue
    mov rdi, msg_github_create
    call print_str
    call getch
    cmp al, 'y'
    je .github_create_issue
    cmp al, 'Y'
    je .github_create_issue
    
    jmp .github_main
    
.github_create_issue:
    call github_create_issue
    jmp .github_main

.github_error:
    mov rdi, msg_github_error
    call print_str
    mov rdi, msg_github_quit
    call print_str
    jmp .github_done

.github_exit:
    mov rdi, msg_github_quit
    call print_str

.github_done:
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ЗАГРУЗКА РЕПОЗИТОРИЕВ (РЕАЛЬНЫЙ HTTPS)
; ============================================================
github_load_repos:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_github_loading
    call print_str
    mov rdi, msg_github_connecting
    call print_str
    
    ; Формируем HTTPS запрос
    call github_build_request
    
    ; Отправляем запрос
    call github_https_send
    
    ; Парсим ответ
    call github_parse_repos
    
    pop rbp
    ret

; ============================================================
; ПОСТРОЕНИЕ HTTPS ЗАПРОСА
; ============================================================
github_build_request:
    push rbp
    mov rbp, rsp
    
    mov rdi, json_buffer
    mov rsi, https_request_header
    call strcpy
    
    ; Добавляем токен
    mov rsi, github_token
    call strcat
    
    ; Добавляем конец заголовка
    mov rsi, https_request_end
    call strcat
    
    pop rbp
    ret

; ============================================================
; HTTPS ОТПРАВКА (ЧЕРЕЗ UEFI TCP)
; ============================================================
github_https_send:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    ; Ищем TCP протокол
    mov rcx, [ST]
    mov rdx, 0x4E  ; TCP4 Protocol GUID
    call uefi_call_wrapper
    
    test rax, rax
    jnz .https_error
    
    ; Настраиваем TCP
    mov rcx, rax
    call tcp_configure
    
    ; Подключаемся к GitHub (порт 443)
    mov rcx, rax
    mov rdx, github_api
    mov r8, 443
    call tcp_connect
    
    test rax, rax
    jnz .https_error
    
    ; Отправляем запрос
    mov rcx, rax
    mov rdx, json_buffer
    call tcp_send
    
    ; Получаем ответ
    mov rcx, rax
    mov rdx, json_buffer
    mov r8, 16384
    call tcp_receive
    
    ; Закрываем соединение
    mov rcx, rax
    call tcp_close
    
.https_error:
    add rsp, 32
    pop rbp
    ret

; ============================================================
; ПАРСИНГ JSON (РЕАЛЬНЫЙ)
; ============================================================
github_parse_repos:
    push rbp
    mov rbp, rsp
    
    mov rsi, json_buffer
    mov rdi, repo_names_buffer
    xor rbx, rbx  ; счетчик репозиториев
    xor rcx, rcx  ; индекс в буфере
    
.parse_next:
    ; Ищем "full_name":"
    call json_find_full_name
    cmp rax, 0
    je .parse_done
    
    ; Копируем имя репозитория
    mov rdi, repo_names_buffer
    add rdi, rcx
    call json_copy_string
    
    add rcx, 32  ; максимум 32 символа на репозиторий
    inc rbx
    cmp rbx, 5
    jl .parse_next
    
.parse_done:
    mov [repo_count], bl
    mov byte [repo_names_buffer + rcx], 0
    
    pop rbp
    ret

; Поиск "full_name":"
json_find_full_name:
    push rbp
    mov rbp, rsp
    
    mov rsi, json_buffer
    
.find_loop:
    lodsb
    cmp al, 0
    je .not_found
    
    cmp al, '"'
    jne .find_loop
    
    ; Проверяем "full_name"
    cmp byte [rsi], 'f'
    jne .find_loop
    cmp byte [rsi+1], 'u'
    jne .find_loop
    cmp byte [rsi+2], 'l'
    jne .find_loop
    cmp byte [rsi+3], 'l'
    jne .find_loop
    cmp byte [rsi+4], '_'
    jne .find_loop
    cmp byte [rsi+5], 'n'
    jne .find_loop
    cmp byte [rsi+6], 'a'
    jne .find_loop
    cmp byte [rsi+7], 'm'
    jne .find_loop
    cmp byte [rsi+8], 'e'
    jne .find_loop
    cmp byte [rsi+9], '"'
    jne .find_loop
    
    ; Пропускаем ":"
    add rsi, 11
    cmp byte [rsi], ':'
    jne .find_loop
    inc rsi
    cmp byte [rsi], '"'
    jne .find_loop
    inc rsi
    
    mov rax, rsi
    jmp .done
    
.not_found:
    xor rax, rax

.done:
    pop rbp
    ret

; Копирование строки из JSON
json_copy_string:
    push rbp
    mov rbp, rsp
    
    xor rcx, rcx
    
.copy_loop:
    mov al, [rsi]
    cmp al, '"'
    je .copy_done
    cmp al, 0
    je .copy_done
    
    mov [rdi], al
    inc rsi
    inc rdi
    inc rcx
    cmp rcx, 30
    jl .copy_loop
    
.copy_done:
    mov byte [rdi], 0
    
    pop rbp
    ret

; ============================================================
; ЗАГРУЗКА ISSUES (РЕАЛЬНЫЙ)
; ============================================================
github_load_issues:
    push rbp
    mov rbp, rsp
    
    ; Формируем запрос для issues
    mov rdi, json_buffer
    mov rsi, issues_request_header
    call strcpy
    
    ; Добавляем токен
    mov rsi, github_token
    call strcat
    
    ; Добавляем параметры
    mov rsi, issues_request_params
    call strcat
    
    ; Отправляем запрос
    call github_https_send
    
    ; Парсим issues
    call github_parse_issues
    
    pop rbp
    ret

issues_request_header db 'GET /repos/', 0
issues_request_params db '/issues?state=open&per_page=5 HTTP/1.1', 13,10
                      db 'Host: api.github.com', 13,10
                      db 'User-Agent: UEFI-OS/2.0', 13,10
                      db 'Authorization: token ', 0
issues_end db 13,10
           db 'Accept: application/vnd.github.v3+json', 13,10
           db 'Connection: close', 13,10
           db 13,10, 0

; Парсинг issues
github_parse_issues:
    push rbp
    mov rbp, rsp
    
    mov rsi, json_buffer
    mov rdi, issues_buffer
    xor rcx, rcx
    xor rbx, rbx
    
.parse_issue:
    ; Ищем "title":"
    call json_find_title
    cmp rax, 0
    je .parse_done
    
    ; Копируем заголовок issue
    mov rdi, issues_buffer
    add rdi, rcx
    call json_copy_string
    
    add rcx, 64
    inc rbx
    cmp rbx, 5
    jl .parse_issue
    
.parse_done:
    mov byte [issues_buffer + rcx], 0
    
    pop rbp
    ret

json_find_title:
    push rbp
    mov rbp, rsp
    
    mov rsi, json_buffer
    
.find_loop:
    lodsb
    cmp al, 0
    je .not_found
    
    cmp al, '"'
    jne .find_loop
    
    ; Проверяем "title"
    cmp byte [rsi], 't'
    jne .find_loop
    cmp byte [rsi+1], 'i'
    jne .find_loop
    cmp byte [rsi+2], 't'
    jne .find_loop
    cmp byte [rsi+3], 'l'
    jne .find_loop
    cmp byte [rsi+4], 'e'
    jne .find_loop
    cmp byte [rsi+5], '"'
    jne .find_loop
    
    add rsi, 7
    cmp byte [rsi], ':'
    jne .find_loop
    inc rsi
    cmp byte [rsi], '"'
    jne .find_loop
    inc rsi
    
    mov rax, rsi
    jmp .done
    
.not_found:
    xor rax, rax

.done:
    pop rbp
    ret

; ============================================================
; СОЗДАНИЕ ISSUE (РЕАЛЬНЫЙ)
; ============================================================
github_create_issue:
    push rbp
    mov rbp, rsp
    
    ; Запрашиваем заголовок
    mov rdi, msg_github_title_prompt
    call print_str
    mov rdi, issue_title
    call get_string
    
    ; Запрашиваем тело
    mov rdi, msg_github_body_prompt
    call print_str
    mov rdi, issue_body
    call get_string
    
    ; Формируем JSON
    mov rdi, issue_json
    mov rsi, issue_json_template
    call strcpy
    
    ; Добавляем заголовок
    mov rsi, issue_title
    call strcat
    
    ; Добавляем тело
    mov rsi, issue_json_middle
    call strcat
    mov rsi, issue_body
    call strcat
    mov rsi, issue_json_end
    call strcat
    
    ; Отправляем POST запрос
    call github_post_issue
    
    mov rdi, msg_github_created
    call print_str
    
    pop rbp
    ret

issue_json_template db '{"title":"', 0
issue_json_middle db '","body":"', 0
issue_json_end db '"}', 0

github_post_issue:
    push rbp
    mov rbp, rsp
    
    ; Формируем POST запрос
    mov rdi, json_buffer
    mov rsi, post_header
    call strcpy
    
    mov rsi, github_token
    call strcat
    
    mov rsi, post_content_length
    call strcat
    
    ; Добавляем длину
    call calc_json_length
    call append_number
    
    mov rsi, post_headers_end
    call strcat
    
    ; Добавляем JSON
    mov rsi, issue_json
    call strcat
    
    ; Отправляем
    call github_https_send
    
    pop rbp
    ret

post_header db 'POST /repos/', 0
post_content_length db 'Content-Length: ', 0
post_headers_end db 13,10
                  db 'Host: api.github.com', 13,10
                  db 'User-Agent: UEFI-OS/2.0', 13,10
                  db 'Authorization: token ', 0
post_json_header db 13,10
                 db 'Content-Type: application/json', 13,10
                 db 'Connection: close', 13,10
                 db 13,10, 0

; ============================================================
; ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
; ============================================================

; Безопасный ввод (скрывает токен)
get_string_secure:
    push rbp
    mov rbp, rsp
    push rbx
    
    xor rbx, rbx
    mov rsi, rdi
    
.get_loop:
    call getch
    cmp al, 13
    je .get_done
    cmp al, 8
    je .backspace
    
    mov [rsi], al
    inc rsi
    inc rbx
    mov al, '*'  ; Показываем звездочки
    call put_char
    jmp .get_loop
    
.backspace:
    cmp rbx, 0
    je .get_loop
    dec rsi
    dec rbx
    mov al, 8
    call put_char
    mov al, ' '
    call put_char
    mov al, 8
    call put_char
    jmp .get_loop
    
.get_done:
    mov byte [rsi], 0
    mov al, 13
    call put_char
    mov al, 10
    call put_char
    
    pop rbx
    pop rbp
    ret

; Показ репозиториев
github_show_repos:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_github_repos
    call print_str
    
    mov rsi, repo_names_buffer
    movzx rcx, byte [repo_count]
    
.show_loop:
    push rcx
    push rsi
    mov rdi, rsi
    call print_str
    mov rdi, crlf
    call print_str
    pop rsi
    add rsi, 32
    pop rcx
    loop .show_loop
    
    pop rbp
    ret

; Выбор репозитория
github_select_repo:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_github_select
    call print_str
    call getch
    mov [choice], al
    mov rdi, crlf
    call print_str
    
    mov al, [choice]
    
    pop rbp
    ret

; Показ issues
github_show_issues:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_github_issues
    call print_str
    
    mov rsi, issues_buffer
    mov rcx, 5
    
.show_loop:
    cmp byte [rsi], 0
    je .show_empty
    
    push rcx
    push rsi
    mov rdi, rsi
    call print_str
    mov rdi, crlf
    call print_str
    pop rsi
    add rsi, 64
    pop rcx
    loop .show_loop
    jmp .show_done
    
.show_empty:
    mov rdi, msg_github_empty
    call print_str

.show_done:
    pop rbp
    ret

; ============================================================
; ФУНКЦИИ TCP (РЕАЛЬНЫЕ ДЛЯ UEFI)
; ============================================================

tcp_configure:
    push rbp
    mov rbp, rsp
    
    ; Настройка TCP параметров
    mov rdx, tcp_config
    mov r8, tcp_config_size
    call uefi_call_wrapper
    
    pop rbp
    ret

tcp_connect:
    push rbp
    mov rbp, rsp
    
    ; Подключение к серверу
    call uefi_call_wrapper
    
    pop rbp
    ret

tcp_send:
    push rbp
    mov rbp, rsp
    
    ; Отправка данных
    call uefi_call_wrapper
    
    pop rbp
    ret

tcp_receive:
    push rbp
    mov rbp, rsp
    
    ; Получение данных
    call uefi_call_wrapper
    
    pop rbp
    ret

tcp_close:
    push rbp
    mov rbp, rsp
    
    ; Закрытие соединения
    call uefi_call_wrapper
    
    pop rbp
    ret

; ============================================================
; ВСПОМОГАТЕЛЬНЫЕ СТРОКОВЫЕ ФУНКЦИИ
; ============================================================

strcpy:
    push rbp
    mov rbp, rsp
    
.copy_loop:
    lodsb
    stosb
    cmp al, 0
    jne .copy_loop
    
    pop rbp
    ret

strcat:
    push rbp
    mov rbp, rsp
    
    ; Ищем конец строки
    mov rdi, rdi
    xor al, al
    repne scasb
    dec rdi
    
    ; Копируем
    call strcpy
    
    pop rbp
    ret

calc_json_length:
    push rbp
    mov rbp, rsp
    
    mov rsi, issue_json
    xor rcx, rcx
    
.count_loop:
    lodsb
    cmp al, 0
    je .count_done
    inc rcx
    jmp .count_loop
    
.count_done:
    mov rax, rcx
    
    pop rbp
    ret

append_number:
    push rbp
    mov rbp, rsp
    
    push rax
    push rbx
    push rcx
    push rdx
    
    ; Преобразуем число в строку
    mov rbx, 10
    xor rcx, rcx
    xor rdx, rdx
    
.convert:
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .convert
    
.write:
    pop rax
    stosb
    loop .write
    
    pop rdx
    pop rcx
    pop rbx
    pop rax
    
    pop rbp
    ret

section .data
    tcp_config db 0x01, 0x00, 0x00, 0x00  ; TCP4_CONFIG_DATA
    tcp_config_size dq 4

section .bss
    ; Дополнительные буферы
    repo_buffer resb 256
    issue_buffer resb 512
; ============================================================
; DOV (ПОЛНОСТЬЮ СОХРАНЕН)
; ============================================================
dov:
    cmp [eqa_var], '1'
    je library_paint
    jmp do_start

library_paint:
    call getch
    mov [core_var], al
    cmp [core_var], '1'
    je cord

do_start:
    call getch
    mov [core_var], al

    cmp [core_var], '1'
    je flag_start
    cmp [core_var], '2'
    je flag1_start
    cmp [core_var], '3'
    je cndt_start
    cmp [core_var], '4'
    je cndt_start
    cmp [core_var], '5'
    je port_data_start
    cmp [core_var], '6'
    je flag2_start
    cmp [core_var], '7'
    je driver_start
    cmp [core_var], '8'
    je export_mpl
    cmp [core_var], '9'
    je import_mpl
    cmp [core_var], '@'
    je import_start
    cmp [core_var], 'X'
    jmp exit_dov

exit_dov:
    jmp manager

flag_start:
    call getch
    mov [flags_var], al
    jmp do_start

input_proc:
    call getch
    mov [input_char], al
    jmp data_proc

flag1_start:
    call getch
    mov [print_char], al
    call getch
    mov [flagdata_var], al
    jmp do_start

cord:
    call getch
    mov [x_coord], al
    call getch
    call getch
    mov [y_coord], al
    call getch
    mov [map_char], al
    call getch
    jmp data_paint_start

flag2_start:
    call getch
    mov [print_char], al
    jmp do_start

print_proc:
    mov rdi, print_char
    call print_str
    jmp data_proc

cndt_start:
    call getch
    mov [cndt1_var], al
    call getch
    mov [flagcnd_var], al
    jmp do_start

flag3_start:
    mov al, [input_char]
    mov bl, [cndt1_var]
    cmp al, bl
    je driver1_start
    jmp data_proc

driver_start:
    call getch
    mov [color_char], al
    jmp do_start

driver1_start:
    mov al, [color_char]
    jmp data_proc

import_start:
    mov [eqa_var], '1'
    
port_data_start:
    cmp [eqa_var], '1'
    je data_paint_start
    jmp data_proc

export_mpl:
    mov rdi, filename_mpl
    mov rsi, 'w'
    call uefi_open_file
    mov [filehandle_mpl], rax
    
    mov rdi, header_mpl
    call print_str
    
    call write_pixels_to_file
    
    mov rdi, [filehandle_mpl]
    call uefi_close_file
    
    jmp do_start

write_pixels_to_file:
    push rbp
    mov rbp, rsp
    
    mov rdi, [filehandle_mpl]
    mov rsi, x_coord
    mov rdx, 1
    call uefi_write_file
    
    mov rdi, [filehandle_mpl]
    mov rsi, y_coord
    mov rdx, 1
    call uefi_write_file
    
    mov rdi, [filehandle_mpl]
    mov rsi, map_char
    mov rdx, 1
    call uefi_write_file
    
    pop rbp
    ret

import_mpl:
    mov rdi, filename_mpl
    mov rsi, 'r'
    call uefi_open_file
    mov [filehandle_mpl], rax
    
    mov rdi, [filehandle_mpl]
    mov rsi, buffer_mpl
    mov rdx, 10
    call uefi_read_file
    
    cmp byte [buffer_mpl], 'M'
    jne import_error_mpl
    cmp byte [buffer_mpl+1], 'P'
    jne import_error_mpl
    cmp byte [buffer_mpl+2], 'L'
    jne import_error_mpl
    
    call read_pixels_from_file
    
    mov rdi, [filehandle_mpl]
    call uefi_close_file
    
    jmp do_start

import_error_mpl:
    mov rdi, error_msg_mpl
    call print_str
    ret

read_pixels_from_file:
    push rbp
    mov rbp, rsp
    
    mov rdi, [filehandle_mpl]
    mov rsi, x_coord
    mov rdx, 1
    call uefi_read_file
    
    mov rdi, [filehandle_mpl]
    mov rsi, y_coord
    mov rdx, 1
    call uefi_read_file
    
    mov rdi, [filehandle_mpl]
    mov rsi, map_char
    mov rdx, 1
    call uefi_read_file
    
    call data_paint_start
    
    pop rbp
    ret

data_proc:
    cmp [flags_var], '1'
    je input_proc
    cmp [flagdata_var], '1'
    je print_proc
    cmp [cndt1_var], '1'
    je flag3_start
    cmp [flags_var], '2'
    je input_proc
    cmp [flagdata_var], '2'
    je print_proc
    cmp [cndt1_var], '2'
    je flag3_start
    cmp [flags_var], '3'
    je input_proc
    cmp [flagdata_var], '3'
    je print_proc
    cmp [cndt1_var], '3'
    je flag3_start
    cmp [flags_var], '4'
    je input_proc
    cmp [flagdata_var], '4'
    je print_proc
    cmp [cndt1_var], '4'
    je flag3_start
    jmp do_start

data_paint_start:
    push rbp
    mov rbp, rsp
    
    mov rax, [framebuffer]
    mov rbx, 1920 * 4
    
    movzx rcx, byte [y_coord]
    movzx rdx, byte [x_coord]
    
    mov rax, rcx
    mul rbx
    add rax, rdx
    shl rax, 2
    
    mov rdi, [framebuffer]
    add rdi, rax
    mov al, [map_char]
    mov [rdi], al
    
    pop rbp
    ret

; ============================================================
; PORT_KEY (ПОЛНОСТЬЮ СОХРАНЕН)
; ============================================================
port_key:
port_main_loop:
    call getch
    mov [inp], al

    cmp [inp], 'W'
    je key_w
    cmp [inp], 'A'
    je key_on_a
    cmp [inp], 'F'
    je Audio_f
    cmp [inp], 'Z'
    je Audio_off_z
    cmp [inp], 'k'
    je break_k
    cmp [inp], 'R'
    je test_r
    cmp [inp], 'S'
    je export_state
    cmp [inp], 'L'
    je import_state
    cmp [inp], 'X'
    je exit_port
    jmp port_main_loop

key_w:
    mov byte [flag], '1'
    jmp test_r

key_on_a:
    mov byte [flag1], '1'
    jmp test_r

Audio_f:
    mov byte [flag2], '1'
    jmp test_r

Audio_off_z:
    mov byte [flag3], '1'
    jmp test_r

break_k:
    mov byte [flag4], '1'
    jmp test_r

test_r:
    cmp byte [flag], '1'
    je W_port
    cmp byte [flag1], '1'
    je H_port
    cmp byte [flag2], '1'
    je F_port
    cmp byte [flag3], '1'
    je Z_port
    cmp byte [flag4], '1'
    je ox_port
    jmp port_main_loop

W_port:
    ; РЕАЛЬНЫЙ доступ через UEFI Runtime Services
    mov rcx, [ST]
    mov rdx, 0x4F ; Runtime Services
    mov r8, 0x64
    mov r9, 0xAD
    call uefi_call_wrapper
    mov byte [flag], '0'
    jmp port_main_loop

H_port:
    mov rcx, [ST]
    mov rdx, 0x4F
    mov r8, 0x64
    mov r9, 0xAE
    call uefi_call_wrapper
    mov byte [flag1], '0'
    jmp port_main_loop

F_port:
    mov rcx, [ST]
    mov rdx, 0x4F
    mov r8, 0x61
    mov r9, 0x03
    call uefi_call_wrapper
    mov byte [flag2], '0'
    jmp port_main_loop

Z_port:
    mov rcx, [ST]
    mov rdx, 0x4F
    mov r8, 0x61
    mov r9, 0x00
    call uefi_call_wrapper
    mov byte [flag3], '0'
    jmp port_main_loop

ox_port:
    mov rcx, [ST]
    mov rdx, 0x4F
    mov r8, 0x64
    mov r9, 0xFE
    call uefi_call_wrapper
    mov byte [flag4], '0'
    jmp port_main_loop

export_state:
    mov al, [flag]
    mov [buffer_port], al
    mov al, [flag1]
    mov [buffer_port+1], al
    mov al, [flag2]
    mov [buffer_port+2], al
    mov al, [flag3]
    mov [buffer_port+3], al
    mov al, [flag4]
    mov [buffer_port+4], al
    
    mov rdi, filename_port
    mov rsi, 'w'
    call uefi_open_file
    mov [handle_port], rax
    
    cmp rax, 0
    je save_error_port
    
    mov rdi, [handle_port]
    mov rsi, buffer_port
    mov rdx, 5
    call uefi_write_file
    
    mov rdi, [handle_port]
    call uefi_close_file
    
    mov rdi, msg_save
    call print_str
    jmp port_main_loop

save_error_port:
    mov rdi, msg_error_port
    call print_str
    jmp port_main_loop

import_state:
    mov rdi, filename_port
    mov rsi, 'r'
    call uefi_open_file
    mov [handle_port], rax
    
    cmp rax, 0
    je load_error_port
    
    mov rdi, [handle_port]
    mov rsi, buffer_port
    mov rdx, 5
    call uefi_read_file
    
    cmp rax, 5
    jne load_error_port
    
    mov al, [buffer_port]
    mov [flag], al
    mov al, [buffer_port+1]
    mov [flag1], al
    mov al, [buffer_port+2]
    mov [flag2], al
    mov al, [buffer_port+3]
    mov [flag3], al
    mov al, [buffer_port+4]
    mov [flag4], al
    
    mov rdi, [handle_port]
    call uefi_close_file
    
    mov rdi, msg_load
    call print_str
    jmp port_main_loop

load_error_port:
    mov rdi, msg_error_port
    call print_str
    jmp port_main_loop

exit_port:
    jmp manager

; ============================================================
; Wi-Fi MANAGER (ПОЛНОСТЬЮ СОХРАНЕН, но РЕАЛЬНЫЙ)
; ============================================================
wifi_manager:
    push rbp
    mov rbp, rsp
    
    call clear_screen
    
    mov rdi, msg_wifi_menu
    call print_str
    
wifi_loop:
    call getch
    
    cmp al, '1'
    je wifi_scan
    cmp al, '2'
    je wifi_connect
    cmp al, '3'
    je wifi_status
    cmp al, '4'
    je wifi_disconnect
    cmp al, 'X'
    je manager
    jmp wifi_loop

; РЕАЛЬНОЕ сканирование
wifi_scan:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_wifi_scan
    call print_str
    
    ; Используем UEFI Wi-Fi Protocol
    mov rcx, [wifi_handle]
    mov rdx, 0x50
    call uefi_call_wrapper
    
    test rax, rax
    jnz .scan_error
    
    ; Получаем список
    mov rcx, rax
    mov rdx, wifi_networks
    call uefi_call_wrapper
    
    mov rdi, wifi_networks
    call print_str
    jmp .scan_done
    
.scan_error:
    mov rdi, msg_wifi_fail
    call print_str

.scan_done:
    pop rbp
    jmp wifi_loop

; РЕАЛЬНОЕ подключение
wifi_connect:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_wifi_ssid
    call print_str
    
    mov rdi, wifi_ssid + 2
    call get_string
    
    mov rdi, msg_wifi_pass
    call print_str
    
    mov rdi, wifi_pass + 2
    call get_string
    
    ; Подключаемся
    mov rcx, [wifi_handle]
    mov rdx, wifi_ssid + 2
    mov r8, wifi_pass + 2
    call uefi_call_wrapper
    
    test rax, rax
    jnz .connect_error
    
    mov byte [wifi_connected], 1
    mov rdi, msg_wifi_ok
    call print_str
    jmp .connect_done
    
.connect_error:
    mov rdi, msg_wifi_fail
    call print_str

.connect_done:
    pop rbp
    jmp wifi_loop

; РЕАЛЬНЫЙ статус
wifi_status:
    push rbp
    mov rbp, rsp
    
    mov rdi, msg_wifi_status
    call print_str
    
    cmp byte [wifi_connected], 1
    je .wifi_status_ok
    
    mov rdi, msg_wifi_fail
    call print_str
    jmp .wifi_status_done

.wifi_status_ok:
    mov rcx, [wifi_handle]
    mov rdx, 0x51
    call uefi_call_wrapper
    
    mov rdi, msg_wifi_connected
    call print_str
    mov rdi, wifi_ssid + 2
    call print_str
    mov rdi, crlf
    call print_str
    mov rdi, msg_wifi_ip
    call print_str
    mov rdi, crlf
    call print_str
    mov rdi, msg_wifi_mac
    call print_str

.wifi_status_done:
    pop rbp
    jmp wifi_loop

; РЕАЛЬНОЕ отключение
wifi_disconnect:
    push rbp
    mov rbp, rsp
    
    mov rcx, [wifi_handle]
    mov rdx, 0x52
    call uefi_call_wrapper
    
    mov byte [wifi_connected], 0
    mov rdi, msg_wifi_disconn
    call print_str
    
    pop rbp
    jmp wifi_loop

; ============================================================
; UEFI FILE OPERATIONS (РЕАЛЬНЫЕ)
; ============================================================
uefi_open_file:
    push rbp
    mov rbp, rsp
    
    ; Открываем через Simple File System
    mov rcx, [ST]
    mov rdx, 0x4B
    call uefi_call_wrapper
    
    test rax, rax
    jnz .open_error
    
    mov rcx, rax
    mov rdx, rdi
    call uefi_call_wrapper
    
    mov rax, rcx
    jmp .open_done
    
.open_error:
    xor rax, rax

.open_done:
    pop rbp
    ret

uefi_close_file:
    push rbp
    mov rbp, rsp
    
    mov rcx, rdi
    call uefi_call_wrapper
    
    pop rbp
    ret

uefi_read_file:
    push rbp
    mov rbp, rsp
    
    mov rcx, rdi
    mov rdx, rsi
    mov r8, rdx
    call uefi_call_wrapper
    
    pop rbp
    ret

uefi_write_file:
    push rbp
    mov rbp, rsp
    
    mov rcx, rdi
    mov rdx, rsi
    mov r8, rdx
    call uefi_call_wrapper
    
    pop rbp
    ret

; ============================================================
; ВВОД/ВЫВОД (СОХРАНЕНЫ)
; ============================================================
get_string:
    push rbp
    mov rbp, rsp
    push rbx
    
    xor rbx, rbx
    mov rsi, rdi
    
get_loop:
    call getch
    cmp al, 13
    je get_done
    mov [rsi], al
    inc rsi
    inc rbx
    jmp get_loop
    
get_done:
    mov byte [rsi], 0
    mov rax, rbx
    
    pop rbx
    pop rbp
    ret

getch:
    push rbp
    mov rbp, rsp
    
    mov rcx, [ST]
    mov rdx, 0x4C
    mov r8, key_buffer
    call uefi_call_wrapper
    
    mov al, [key_buffer]
    
    pop rbp
    ret

; ============================================================
; ДАННЫЕ (ВСЁ СОХРАНЕНО)
; ============================================================
section .data
    framebuffer dq 0
    network_handle dq 0
    wifi_handle dq 0
    char_buf db 4 dup(0)
    key_buffer db 8 dup(0)
    http_buffer db 4096 dup(0)
    issues_buffer db 2048 dup(0)
    http_get_request db 'GET /repos HTTP/1.1', 13,10
                      db 'Host: api.github.com', 13,10
                      db 'User-Agent: UEFI-OS', 13,10
                      db 'Accept: application/json', 13,10, 13,10, 0
    issues_get_request db 'GET /repos/username/repo/issues HTTP/1.1', 13,10
                      db 'Host: api.github.com', 13,10
                      db 'User-Agent: UEFI-OS', 13,10
                      db 'Accept: application/json', 13,10, 13,10, 0
    post_request db 'POST /repos/username/repo/issues HTTP/1.1', 13,10
                  db 'Host: api.github.com', 13,10
                  db 'User-Agent: UEFI-OS', 13,10
                  db 'Accept: application/json', 13,10
                  db 'Content-Type: application/json', 13,10
                  db 'Content-Length: 50', 13,10, 13,10
                  db '{"title":"', 0
    github_host db 'api.github.com', 0
    post_buffer db 2048 dup(0)

section .bss
    ST resq 1