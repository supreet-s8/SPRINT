#!/usr/bin/expect -f

#  
#
#  Created by Jatinder Singh on 2/19/15.
#
# Set up various other variables here ($user, $password)

# Get the list of hosts, one per line #####
set f [open "host.txt"]
set hosts [split [read $f] "\n"]
close $f

# Get the commands to run, one per line
set f2 [open "commands.txt"]
set commands [split [read $f2] "\n"]
close $f2


# Iterate over the hosts
foreach host $hosts {
      if { $host == "" } {
        continue
      } 
	spawn ssh manage@$host
		expect "assword: "
		send "Gur9a0n83\r"
		# Iterate over the commands
		foreach cmd $commands {
		expect "# "
		send "$cmd\r"
		}

		# Tidy up
		expect "# "
		send "exit\r"

}


