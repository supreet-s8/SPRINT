#!/usr/bin/python

'''
Created on 5-Dec-2013

Description: This scripts collects Collectors stats from the poll of servers 
             and generates Stats.csv on the same location from where this script is executed.

@author: samuel.joseph
'''


#----------------------
# Import helper classes
#----------------------
import pexpect
import os.path
import os
import datetime
import time


# ------------------------------------------------------------------
# Variable to be updated in case Server IP, user and pwd is changed.
# ------------------------------------------------------------------

prompt = '[#] '
colServerIP = ['10.23.80.70']
user = 'admin'
pwd = 'Gur9a0n83'


# -----------------------------------------------------------
# Internal variables to be utilized during Stats.csv writing. 
# -----------------------------------------------------------

#displayTextH = ''
#displayTextH = 'Date,Time,ServerIP,dropped_Stat,,,,total_Stats,,,\n'
#displayTextH += ',,,LTE,WIMAX,CDMA,VOICE,LTE,WIMAX,CDMA,VOICE \n'


# --------------------------------------------------------------------------------
# Remote connection.
# --------------------------------------------------------------------------------

def connectRemoteMachines(machineDict):

        rMachineSSHChildDict = {}
        for rMachine in machineDict.keys():
                child = pexpect.spawn ('ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no %s@%s' %(machineDict[rMachine][0].rstrip('\n'),rMachine))
                i = child.expect (['assword: ', '[#\$] ','> ','no\)\? '])
                if i==0:
                        if(len(machineDict[rMachine])>1):
                                child.sendline (machineDict[rMachine][1])
                                j = child.expect (['> ','assword: ','[#\$] '])
                                if j==0:
                                        child.sendline('en')
                                        child.expect ('[#\$] ')
                                        child.sendline('_shell')
                                        child.expect ('[#\$] ')
                                        rMachineSSHChildDict[rMachine] = child
                                elif j==1:
                                        print"Wrong pwd entered for %s. Please specify the correct password" %(rMachine)
                                        child.kill(0)
                                elif j==2:
                                        rMachineSSHChildDict[rMachine] = child

                elif i==1:
                        rMachineSSHChildDict[rMachine] = child

                elif i==2:
                        child.sendline('en')
                        child.expect ('[#\$] ')
                        child.sendline('_shell')
                        child.expect ('[#\$] ')
                        rMachineSSHChildDict[rMachine] = child

                elif i==3:
                        child.sendline('yes')
                        print child.before
                        j = child.expect (['> ','assword: ','[#\$] '])
                        if j==0:
				child.sendline('en')
                                child.expect ('[#\$] ')
                                child.sendline('_shell')
                                child.expect ('[#\$] ')
                                rMachineSSHChildDict[rMachine] = child
                        elif j==1:
                                if(len(machineDict[rMachine])>1):
                                        child.sendline (machineDict[rMachine][1].rstrip('\n'))
                                        k = child.expect (['> ','assword: ','[#\$] '])
                                        if k==0:
                                                child.sendline('en')
                                                child.expect ('[#\$] ')
                                                child.sendline('_shell')
                                                child.expect ('[#\$] ')
                                                rMachineSSHChildDict[rMachine] = child
                                        elif k==1:
                                                print"Wrong pwd entered for %s. Please specify correct password" %(rMachine)
                                                child.kill(0)
                                        elif k==2:
                                                rMachineSSHChildDict[rMachine] = child
                        elif j==2:
                                rMachineSSHChildDict[rMachine] = child
        return (rMachineSSHChildDict)



# --------------------------------------------------------------------------------
#This function shall execute command to collect Collector stats.
# --------------------------------------------------------------------------------
def executeCommand(child, prompt, command):
    
    child.sendline(command)
    child.expect(prompt)
    path = child.before.split('\n')[-2]
    return path
     
       
# --------------------------------------------------------------------------------
#This function shall execute command to collect Collector stats.
# --------------------------------------------------------------------------------
def executeCommandItr(child, prompt, command):
    
    child.sendline(command)
    child.expect(prompt)
    path = child.before.split(',')
    return path
    
    
    
# --------------------------------------------------------------------------------
#This function shall execute command to collect Collector stats.
# --------------------------------------------------------------------------------
def executeCommandFull(child, prompt, command):

    child.sendline(command)
    child.expect(prompt)
    path = child.before
    return path


# --------------------------------------------------------------------------------
#This function shall append Stats.csv.
# --------------------------------------------------------------------------------
def writeFile(param,fileName):
        path = filePath()
        if os.path.exists("%s/%s"%(path,fileName)) == False:
		f=open(fileName,"w")
        	f.write(param)
        	f.close()
          

# --------------------------------------------------------------------------------
#This function shall get path where script is palce and Stats.csv is generated.
# --------------------------------------------------------------------------------
def filePath():
        path = os.getcwdu()
	return path



	
# ------------------------------------------------------------------------------------------------------
#This function shall collect log by time and call other funtionas internally to log tranfer completion.

# ------------------------------------------------------------------------------------------------------        
def StatsCollectionByTime(prompt,user,pwd,colServerIP,intervalType):
    
	serList = colServerIP
	displayTextN = ''
    	#displayTextN += displayTextH	
	for item in serList:
    		
		#remote server object creation
		sshChild =  connectRemoteMachines({item:[user,pwd]})
                child = sshChild[item]		
                #print "Connection to server %s established"%(item)
		#print "Stats collection started....pl wait"		
		cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr dropped-flow interval-type %s"'%(str(intervalType))
     		cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_droppedLte = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_droppedLte.append(value)

        	cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax dropped-flow interval-type %s"'%(str(intervalType))
        	cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_droppedWimax = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_droppedWimax.append(value)
		
		
		cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr dropped-flow interval-type %s"'%(str(intervalType))
     		cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_droppedCdma = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_droppedCdma.append(value)

        	cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice dropped-flow interval-type %s"'%(str(intervalType))
        	cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_droppedVoice = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_droppedVoice.append(value)
		
		
		cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats lteIpdr total-flow interval-type %s"'%(str(intervalType))
     		cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_totalLte = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_totalLte.append(value)

        	cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats wimax total-flow interval-type %s"'%(str(intervalType))
        	cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_totalWimax = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_totalWimax.append(value)
                    
                    
        	cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaIpdr total-flow interval-type %s"'%(str(intervalType))
        	cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_totalCdma = list()
                for c in cmd:
                    value = c.split()[3].strip()
                    list_totalCdma.append(value)
                
		cmd = 'cli -t "en" "conf t" "collector stats instance-id 1 adaptor-stats cdmaVoice total-flow interval-type %s"'%(str(intervalType))
        	cmd = executeCommandFull(child, prompt, cmd).split('\n')[3:-1]
                list_totalVoice = list()
		list_getDate = list()
		for c in cmd:
                    value = c.split()[3].strip()
                    value1 = c.split()[1:3]
		    list_totalVoice.append(value)
		    list_getDate.append(value1)
		    
		    #value1 = c.split()[1:3]
		# to test headder writing
        	#writeFile(displayTextH,fileName)          

		
                for i in xrange(len(list_totalVoice)):
			displayTextN    += str(list_getDate[i]).strip('[]') + ',' + item + ',' +\
                        	          list_totalLte[i] + ',' + list_totalWimax[i] + ',' + \
                                	  list_totalCdma[i] + ',' + list_totalVoice[i] + ',' + \
                                    	  list_droppedLte[i] + ',' + list_droppedWimax[i] + ',' + \
                                      	  list_droppedCdma[i] + ',' + list_droppedVoice[i]
                  

	print displayTextN
	# commented to test headed writing
    	#writeFile(displayTextN,fileName)	
 
if __name__ == '__main__':

	# ---------------------------------------------------------------------------------------------
	# Function calling to gather stats.
	# ---------------------------------------------------------------------------------------------
	
	'''
	import time

	localtime   = time.localtime()
	timestring  = time.strftime("%Y-%b-%d", localtime)	
	fileName2 = 'NAE_hourly_stats_' + timestring + '.csv'
	'''
	StatsCollectionByTime(prompt,user,pwd,colServerIP,"1-hour")

