#!/usr/bin/expect -f

# Ask for the IP address
puts -nonewline "Enter the IP address of the remote device: "
flush stdout
gets stdin DEVICE_IP

# Set SSH password (default is alpine)
set PASSWORD "alpine"

# Spawn SSH session
spawn ssh root@$DEVICE_IP

# Handle password prompt
expect {
    "*password:*" {
        send "$PASSWORD\r"
        expect "# "  ; # Wait for shell prompt
    }
}

# Resize HFS partition
send "hfs_resize /private/var 1505306368\r"
expect "# "  

# Run gptfdisk interactively
send "gptfdisk /dev/rdisk0s1\r"
expect "Command (? for help): "  

# Send gptfdisk commands
send "i\r"
set timeout -1
expect "Partition number (1-4): "  
send "2\r"
expect "Command (? for help): "  
send_user "\nCopy the Partition GUID Code at the command above, we will ask you for it later on (Press Enter to continue)"
expect_user "\n"
send "d\r"
expect "Partition number (1-4): "  
send "2\r"
expect "Command (? for help): "  
send "n\r"
expect "Partition number (2-4, default 2):"
send "\r"
expect "First sector"
send "\r"
expect "Last sector"
send "1364612\r"
expect "Hex code or GUID (L to show codes, Enter = AF00)"
send "AF00\r"
expect "Command (? for help): "
send "c\r"
expect "Partition number (1-4): "
send "2\r"
expect "Enter name: "
send "Data\r"
expect "Command (? for help): "
send "x\r"
send "2\r"
send "48\r"
send "49\r"
send "\r"
send "\r"
send "g\r"

puts -nonewline "Enter the Partition unique GUID you saved earlier: "
gets stdin GUID_UNIQUE
send "$GUID_UNIQUE\r"
expect eof
