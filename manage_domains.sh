#!/bin/bash

list_file="list"
inactive_file="inactive"

add_domain() {
    local domain=$1
    if ! grep -q "^$domain$" "$list_file"; then
        echo "$domain" >> "$list_file"
        (head -n 12 "$list_file" && tail -n +13 "$list_file" | sort) > "$list_file.tmp" && mv "$list_file.tmp" "$list_file"
        echo "Domain $domain added to $list_file."
    else
        echo "Domain $domain already exists in $list_file."
    fi
}

move_domain() {
    local domain=$1
    if grep -q "^$domain$" "$list_file"; then
        sed -i "/^$domain$/d" "$list_file"
        echo "$domain" >> "$inactive_file"
        (head -n 15 "$inactive_file" && tail -n +16 "$inactive_file" | sort) > "$inactive_file.tmp" && mv "$inactive_file.tmp" "$inactive_file"
        echo "Domain $domain moved to $inactive_file."
    else
        echo "Domain $domain does not exist in $list_file."
    fi
}

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 {add|move} domain"
    exit 1
fi

command=$1
domain=$2

case $command in
    add)
        add_domain "$domain"
        ;;
    move)
        move_domain "$domain"
        ;;
    *)
        echo "Invalid command. Use 'add' to add a domain or 'move' to move a domain."
        exit 1
        ;;
esac
