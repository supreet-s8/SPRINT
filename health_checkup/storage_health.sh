#!/usr/bin/expect -f
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

	match_max 1000000000
# Iterate over the hosts
foreach host $hosts {
      if { $host == "" } {
        continue
      } 
      set output [open "$host.txt" "w"]
	spawn ssh manage@$host
		expect "assword: "
		send "Gur9a0n83\r"
		# Iterate over the commands
		expect "# "
		send "set cli-parameters pager off\n"
		expect "# "
		#send "\n"
		foreach cmd $commands {
		#expect "# "
		send "$cmd\r\n"
		sleep 2
		expect ".*"
		set outcome $expect_out(buffer)
		puts $output $outcome
		} 

       close $output

		# Tidy up
		expect "# "
		send "exit\n"

}


