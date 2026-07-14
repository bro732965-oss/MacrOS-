# MacrOS-
# 🖥️ 64-bit UEFI Kernel - Как пользоваться

## 💻 Требования к железу

### Минимальные:
- **Процессор**: x86-64 (64-bit)
- **ОЗУ**: 128 MB
- **Видео**: UEFI GOP совместимая
- **Загрузка**: UEFI

### Рекомендуемые:
- **Процессор**: Intel Core i3+ / AMD Ryzen
- **ОЗУ**: 512 MB+
- **Видео**: Любая UEFI-совместимая
- **Сеть**: Ethernet / Wi-Fi (UEFI)

---

## 🚀 Как запустить

### На эмуляторе (QEMU)
```bash
# 1. Установите
sudo apt install nasm qemu-system-x86 ovmf

# 2. Соберите (скопируйте все файлы в папку)
./build.sh  # или вручную

# 3. Запустите
qemu-system-x86_64 -bios OVMF.fd -drive format=raw,file=disk.img
##энциклопедия 
github 
консоль 
Commander
consel:
 C-dov_editor
 K-port_key
 I-read file
 W-write
 N-отправка upd пакета
 F-wifi
 A-запуска ASM проектов
 D-dir
 X-close
github:
 водите пользовательский ключ от аккаунта и получаете полный github 
commander:
 работа с файлами 
