#!/usr/bin/python

#----------------------
# Import helper classes
#----------------------

import pexpect



# ------------------------------------------------------------------
# Variable to be updated in case Server IP, user and pwd is changed.
# ------------------------------------------------------------------

prompt = '[# ] '
serverIP = ['10.23.80.67']
pwd = '$pr1ntN43'



# --------------------------------------------------------------------------------
def onRemoteServer(prompt,serverIP,cmd1,cmd2,cmd3):
        serList = serverIP
        for item in serList:
	   
	    print "======================="
	    print "SAS Hadoop Health"
	    print "======================="
	    fireCMD1('root',pwd,item,cmd1)
	    print "======================="
	    print "SAS disk space if more than 80%"
	    print "======================="
	    fireCMD2('root',pwd,item,cmd2)
	    print "======================="
	    print "SAS hadoop fsck output"
	    print "======================="
	    fireCMD3('root',pwd,item,cmd3)


def fireCMD1(user,rootPwd,HOST,command):
	password = rootPwd
	cl = "ssh %s@%s  \"%s\"" % (user, HOST, command)
	(output, exitstatus) = pexpect.run(cl, events={'(?i)password':'%s\n' % (password)}, withexitstatus=1 )
	print output.replace("\r", "").partition("\n")[2] 


def fireCMD2(user,rootPwd,HOST,command):
        password = rootPwd
        cl = "ssh %s@%s  \"%s\"" % (user, HOST, command)

        (output, exitstatus) = pexpect.run(cl, events={'(?i)password':'%s\n' % (password)}, withexitstatus=1 )
        print output.replace("\r", "").partition("\n")[2]


def fireCMD3(user,rootPwd,HOST,command):
        password = rootPwd
        cl = "ssh %s@%s  \"%s\"" % (user, HOST, command)

        (output, exitstatus) = pexpect.run(cl, events={'(?i)password':'%s\n' % (password)}, withexitstatus=1 )
        print output.replace("\r", "").partition("\n")[2]


if __name__ == '__main__':

    # ---------------------------------------------------------------------------------------------
    # Function calling to get image.
    # ---------------------------------------------------------------------------------------------
	#cmd1 = '"/opt/sas/hadoop-0.20.204.0/bin/hadoop dfsadmin -report"'
	cmd2 = ("df -kh | awk \'{if (int($5)>=80) print $0}\'")
	cmd3 = '"/opt/sas/hadoop-0.20.204.0/bin/hadoop fsck /|tail -1 |grep -w HEALTHY$"'
	cmd1 = "/opt/sas/hadoop-0.20.204.0/bin/hadoop dfsadmin -report |grep -iE \'Name:|Decommission|Missing|USED%'"
	#cmd5 = '/opt/sas/hadoop-0.20.204.0/bin/hadoop dfs -lsr /data/cubes/SasCDRCube/year=2014/*/day=`date --date='1 day ago' '+%d'/ 
	onRemoteServer(prompt,serverIP,cmd1,cmd2,cmd3)
