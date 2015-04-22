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


# Internal variables to be utilized during Stats.csv writing. 
# -----------------------------------------------------------

displayTextH = ''
displayTextH = 'Date,Time,ServerIP,total_Stat,,,,dropped_Stats,,,\n'
displayTextH += ',,,LTE,WIMAX,CDMA,VOICE,LTE,WIMAX,CDMA,VOICE \n'

#This function shall append Stats.csv.
# --------------------------------------------------------------------------------
def writeFile(param,fileName):
        #path = filePath()
        if os.path.exists("/data/offshore_support/DailyStatNAE/%s"%(fileName)) == False:
        	filePath = "/data/offshore_support/DailyStatNAE/%s"%(fileName)
      		f=open(filePath,"w")
		f.write(param)
        	f.close()
          

# --------------------------------------------------------------------------------
#This function shall get path where script is palce and Stats.csv is generated.
# --------------------------------------------------------------------------------
def filePath():
        path = os.getcwdu()
	#print path 
	#return path


if __name__ == '__main__':


	# ---------------------------------------------------------------------------------------------
	# Function calling to gather stats.
	# ---------------------------------------------------------------------------------------------
	
	localtime   = time.localtime()
	timestring  = time.strftime("%Y-%b-%d", localtime)	
	fileName = 'NAE_hourly_stats_' + timestring + '.csv'
	writeFile(displayTextH,fileName)
