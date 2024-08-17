#!/bin/bash

# ANSI color codes for colorizing the output
RED="\033[91m"
GREEN="\033[92m"
YELLOW="\033[93m"
BLUE="\033[94m"
MAGENTA="\033[95m"
CYAN="\033[96m"
WHITE="\033[97m"
RESET="\033[0m"

# Directory in home to save scan results
SAVE_DIR="$HOME/IP_Scanner_Results"

# Function to install figlet if it's not installed
install_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo -e "${YELLOW}Installing figlet...${RESET}"
        pkg install figlet -y || sudo apt-get install figlet -y
    fi
}

# Function to install Python requests if it's not installed
install_requests() {
    if ! python3 -c "import requests" &> /dev/null; then
        echo -e "${YELLOW}Installing Python requests module...${RESET}"
        pip3 install requests || sudo apt-get install python3-requests -y
    fi
}

# Function to print a colorized banner using figlet
print_banner() {
    clear
    figlet -c "IP Scanner Tool"    | lolcat 
    echo -e "${WHITE}Version 1.0.1${RESET}" | tee >(head -n 1) >(tail -n +1)
    echo -e "${WHITE}Lokesh Kumar${RESET}" | tee >(head -n 1) >(tail -n +1)
}

# Function to fetch IP details using Python
fetch_ip_details() {
    local ip_address=$1
    python3 - <<END
import requests
import json
import os  # Import the os module

access_token = "914d41abe9bb39"
ip_address = "$ip_address"
url = f"https://ipinfo.io/{ip_address}/json?token={access_token}"

try:
    response = requests.get(url)
    response.raise_for_status()
    details = response.json()
except requests.RequestException as e:
    print("${RED}Failed to fetch details for ${ip_address}. Error: {e}${RESET}")
    details = None

if details:
    print("${GREEN}--- IP Address Details ---${RESET}")
    print(f"${CYAN}IP Address: {details.get('ip', 'N/A')}${RESET}")
    print(f"${CYAN}Hostname: {details.get('hostname', 'N/A')}${RESET}")
    print(f"${CYAN}City: {details.get('city', 'N/A')}${RESET}")
    print(f"${CYAN}Region: {details.get('region', 'N/A')}${RESET}")
    print(f"${CYAN}Country: {details.get('country', 'N/A')}${RESET}")
    print(f"${CYAN}Location: {details.get('loc', 'N/A')}${RESET}")
    print(f"${CYAN}Organization: {details.get('org', 'N/A')}${RESET}")
    print(f"${CYAN}Postal Code: {details.get('postal', 'N/A')}${RESET}")
    print(f"${CYAN}Timezone: {details.get('timezone', 'N/A')}${RESET}")
    print(f"${CYAN}Anycast: {details.get('anycast', 'N/A')}${RESET}")
    print(f"${CYAN}Carrier: {details.get('carrier', 'N/A')}${RESET}")
    print(f"${CYAN}Internet ID: {details.get('asn', {}).get('asn', 'N/A')}${RESET}")
    print("${GREEN}----------------------------${RESET}")

    # Save details to file
    save_dir = "$SAVE_DIR"
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)

    filename = f"{save_dir}/{details.get('ip', 'N/A')}_Report.txt"
    with open(filename, 'w') as file:
        file.write("--- IP Address Details ---\n")
        file.write(f"IP Address: {details.get('ip', 'N/A')}\n")
        file.write(f"Hostname: {details.get('hostname', 'N/A')}\n")
        file.write(f"City: {details.get('city', 'N/A')}\n")
        file.write(f"Region: {details.get('region', 'N/A')}\n")
        file.write(f"Country: {details.get('country', 'N/A')}\n")
        file.write(f"Location: {details.get('loc', 'N/A')}\n")
        file.write(f"Organization: {details.get('org', 'N/A')}\n")
        file.write(f"Postal Code: {details.get('postal', 'N/A')}\n")
        file.write(f"Timezone: {details.get('timezone', 'N/A')}\n")
        file.write(f"Anycast: {details.get('anycast', 'N/A')}\n")
        file.write(f"Carrier: {details.get('carrier', 'N/A')}\n")
        file.write(f"Internet ID: {details.get('asn', {}).get('asn', 'N/A')}\n")
        file.write("----------------------------\n")
    print("${GREEN}Details saved to ${filename}${RESET}")
END
}

# Function to simulate updating the tool with a loading bar
update_tool() {
    echo -e "${BLUE}Updating tool...${RESET}"
    for i in {0..100}; do
        sleep 0.45
        echo -ne "${YELLOW}Updating ====> $i%${RESET}\r"
    done
    echo -e "\n${GREEN}Tool updated successfully!${RESET}"
    sleep 1
}

# Function to remove the tool
remove_tool() {
    echo -e "${RED}Removing tool...${RESET}"
    rm -f $HOME/bin/ip
    echo -e "${GREEN}Tool removed successfully!${RESET}"
}

# Function to display the main menu
main_menu() {
    while true; do
        echo -e "${MAGENTA}\nMain Menu:${RESET}"
        echo -e "${CYAN}1. Scan IPv4${RESET}"
        echo -e "${CYAN}2. Scan IPv6${RESET}"
        echo -e "${CYAN}3. Update Tool${RESET}"
        echo -e "${CYAN}4. Remove Tool${RESET}"
        echo -e "${CYAN}5. Exit${RESET}"

        read -p "$(echo -e ${YELLOW}Enter your choice: ${RESET})" choice

        case $choice in
            1)
                read -p "$(echo -e ${YELLOW}Enter the IPv4 address: ${RESET})" ip_address
                fetch_ip_details $ip_address
                ;;
            2)
                read -p "$(echo -e ${YELLOW}Enter the IPv6 address: ${RESET})" ip_address
                fetch_ip_details $ip_address
                ;;
            3)
                update_tool
                ;;
            4)
rm -rf IP
                remove_tool
                exit 0
                ;;
            5)
                echo -e "${RED}Exiting...${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice, please try again.${RESET}"
                ;;
        esac
    done
}

# Main function
main() {
    install_figlet
    install_requests
    print_banner
    main_menu
}

# Execute the main function
main
