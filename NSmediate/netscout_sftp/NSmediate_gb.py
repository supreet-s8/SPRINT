#!/usr/bin/env python
 
import time
import datetime
import logging
import os, sys, shutil
 
try:
    import pexpect
except ImportError:
    print "Failed to import pexpect module"
    sys.exit(1)

try:
    from setproctitle import setproctitle
except ImportError:
    setproctitle = None

from daemon import Daemon

__all__ = ['Server']

# Global variables
dirslug = "total 123\r\n-rw-r--r--  1 user  group  12345 Jan  1 00:00 DUMMY.file\r\n"
sftp_timeout = 300
# added to facilitate reporting # ssw
report = "/data/reportNSflow"
file = ""

def get_timestamp(timestamp = False):
    """Return ISO8601 timestamp as string"""
    from time import time, strftime, localtime
    if not timestamp:
        retval = strftime("%Y-%m-%dT%H:%M:%S%z", localtime(time()))
    return retval

    
def preparse(lines):
    """
    Pre-parse lines of output to strip undesired bits:
    ### $ ls -l
    ### total 48
    ### -rw-r--r-- 1 user group 12345 Jan  1 20:03 file1.txt
    ### -rw-r--r-- 1 user group 54321 Jan  1 20:24 file2.txt
    or
    ### sftp> put -p victory444.png
    ### Uploading victory444.png to /root/remote-dest/victory444.png
    ### victory444.png                  100%   21KB  21.2KB/s   00:00
    """
    retval = lines.split('\r\n')	# Split on newlines
    retval.pop(0) 			# Delete the previous "sendline"
    retval.pop() 			# Delete the last empty list item (leftover from last newline)
    # This leaves us with a list that looks like this:
    # ['-rw-r--r-- 1 user group 12345 Jan  1 20:03 file1.txt', '-rw-r--r-- 1 user group 54321 Jan  1 20:24 file2.txt']
    # or
    # ['victory444.png                  100%   21KB  21.2KB/s   00:00']
    return retval


def parse_response(response, ptype):
    """Take output from sftp and parse.  Returns boolean"""
    # Pre-parse
    r = preparse(response)		# Pre-parse the response
    # Copy
    if ptype == "copy":			#
        retval = False			# Set return value to False first
        if len(r) > 0: 			# Don't bother if empty result set
            for line in r:		# Scan each line
                if "100%" in line:	# Look for the string "100%"
                    retval = True	# Return value is true if it is
    # Rename
    if ptype == "rename":		# 
        retval = True			# Return value here is True first
        if len(r) > 0: 			# In this case, it's bad to have any size list
            retval = False		# Fail if we saw anything at all
            logging.error(get_timestamp() + " Error found: %s" " ".join(r)) # and report
    return retval

def lstrim(response):
    """Take ls -l output from sftp and turn it into a dict of {filename,size}"""
    retval = {}
    ls = preparse(response)		# Pre-parse the response
    if len(ls) > 0:                     # Don't bother if empty result set
        for line in ls:			# Iterate over all lines
            if len(line.split()) > 7:   # Only process lines that have 8 columns
                f = line.split()[8]	# Column 9 is the filename (0..8)
                s = line.split()[4]	# Column 5 is the file size (0..4)
                retval[f] = s		# retval is a dictionary of {f:s}
    return retval


def filechk(lfiles, rfiles):
    """
    Check local files against remote files.  Verify that file size matches.
    Check if remote file has tmp_ prepended
    Return list of files not yet copied.
    """
    retval = {}
    for lf in lfiles.iterkeys():			# Iterate over all keys in dictionary
        tmprf = 'tmp_' + lf				# tmprf is temporary remote name of lf (local file)
        if not lf in rfiles and not tmprf in rfiles: 	# If the file isn't on the remote server (either completed or tmp_)
            #retval[lf] = "copy" 			#     then flag file as "to copy"
	    retval["10.11.116.57_if3-1395396000000-HTTPS_CorrelatedXDR.csv.gz"] = "failed"
        elif tmprf in rfiles: 				# If the file is there but prepended with tmp_
            if lfiles[lf] == rfiles[tmprf]: 		#     and if the size of local & remote match:
                retval[lf] = "rename" 			#         then flag the file as "to rename"
            else:					#
                retval[lf] = "failed" 			#     if they don't match, it failed
        else: 						# Otherwise:
            retval[lf] = "completed"			#     Presume the file is already completed
    return retval



class Server(object):
    """This is where the daemon dwells, with all his underlings"""
    def __init__(self, options):
        """Initialize variables and constants"""
        # Variables
        self.sleep_interval = options.sleep_interval
        self.user = options.user
        self.host = options.host
        self.daemonize = options.daemonize
        self.debug = options.debug
        self.localdir = options.localdir
        self.remotedir = options.remotedir
        self.retrydir = options.retrydir
        self.includeips = options.includeips
        self.excludeips = options.excludeips
        self.includestr = options.includestr
        self.excludestr = options.excludestr
        # Constants
        self.SFTP_PROMPT = 'sftp> ' ### This is way too simple for industrial use -- we will change is ASAP.
        self.TERMINAL_PROMPT = '(?i)terminal type\?'
        # This is the prompt we get if SSH does not have the remote host's public key stored in the cache.
        self.SSH_NEWKEY = '(?i)are you sure you want to continue connecting'
        if not os.path.exists(self.retrydir):
            try:
                os.mkdir(self.retrydir)
                logging.debug(get_timestamp() + " Creating retry file directory: " + self.retrydir)
            except:
                logging.error(get_timestamp() + " Unable to create retry file directory: " + self.retrydir)

    def sftp_login(self):
        """Create and return a child instance"""
        # Login via SSH
        protochild = pexpect.spawn('sftp %s@%s'%(self.user, self.host))
        i = protochild.expect([pexpect.TIMEOUT, self.SSH_NEWKEY, self.SFTP_PROMPT, '(?i)password'])
        if i == 0: # Timeout
            logging.error(get_timestamp() + ' Could not login with SSH. Here is what SSH said: %s %s' % (protochild.before, protochild.after))
            logging.error(str(protochild))
            # sys.exit (1) # We are daemonized here and built to repeat.  Just log and hope it reconnects
        if i == 1: # In this case SSH does not have the public key cached.
            protochild.sendline ('yes')
            protochild.expect ('(?i)password')
            logging.info(get_timestamp() + ' Adding SSH public key to cache...')
        if i == 2:
            # This may happen if a public key was setup to automatically login.
            # But beware, the SFTP_PROMPT at this point is very trivial and
            # could be fooled by some output in the MOTD or login message.
            logging.debug(get_timestamp() + ' Login successful')
            pass
        if i == 3:
            protochild.sendline(password)
            # Now we are either at the command prompt or
            # the login process is asking for our terminal type.
            i = protochild.expect ([self.SFTP_PROMPT, self.TERMINAL_PROMPT])
            if i == 1:
                protochild.expect (self.SFTP_PROMPT)
            logging.debug(get_timestamp() + ' Password accepted')
        return protochild
        
    def sftp_fixpaths(self):
        """Make sure we're at the correct paths"""
        if self.remotedir:
            self.child.sendline ('cd ' + self.remotedir) # On remote side, switch to target dir
            self.child.expect (self.SFTP_PROMPT)
        if self.localdir:
            self.child.sendline ('lcd ' + self.localdir)
            self.child.expect (self.SFTP_PROMPT)

    def sftp_conn_check(self):
        """Send a simple CR/LF to test if the connection is up"""
        self.child.sendline ('')		# Send a CR/LF
        self.child.expect (self.SFTP_PROMPT)	# Hopefully get the SFTP_PROMPT
        response = self.child.after		# Check here
        if response != self.SFTP_PROMPT:	# If we do NOT get it
            self.sftp_logout()			# Just in case, we log out first. May be moot.
            self.child = sftp_login()		# Refresh self.child
            logging.warn(get_timestamp() + " Connection reset.")
        else:
            #logging.debug(get_timestamp() + " Connection okay.")
            pass
        self.sftp_fixpaths()			# Make sure we're in the right place every time

    def sftp_logout(self):
        """Logout"""
        self.child.sendline ('bye')
        logging.debug(get_timestamp() + " SFTP logout")


    def cluded(self, iplist, stringlist, filedict, operation='include'):
        """
            Return only files INcluded or EXcluded (based on value of operation)
            by ips in iplist, and and by string(s) in stringlist
        """
        # IPs
        matching_files = {}					# Zero out first dictionary
        if len(iplist) > 0:					# Only run if there are entries in iplist
            for k,v in filedict.iteritems():			#  Loop through all files
                match = False					#   Initialize match to false
                for ip in iplist:				#   Loop through all ips
                    if k.startswith(ip):			#     If key (filename) "starts with" the ip
                        match = True				#       set match to True
                if match and operation == 'include':		#   If we find a match and we're set to include
                    matching_files[k] = v			#      add the matching entry to "matching_files" (include)
                elif not match and operation == 'exclude':	#   If we find NO match and we're set to exclude
                    matching_files[k] = v			#      add the matching entry to "matching_files" (not excluded)
        else:							# No IPs provided for filter
            matching_files = filedict				#  Pass all through

        # Strings
        resultdict = {}						# Zero out the "final result" dictionary
        if len(stringlist) > 0:					# Only run if there are entries in stringlist
            for k in matching_files:				#  Loop through the files in our matches from the first set
                match = False					#   Initialize match to false
                for string in stringlist:			#   Loop through all strings in our include_strings
                    if string in k:				#     if the string is in the key (filename)
                        match = True				#       set match to True
                if match and operation == 'include':		#    If we find a match and we're set to include
                    resultdict[k] = matching_files[k]		#      add the matching entry to final result (include)
                elif not match and operation == 'exclude':	#    If we find NO match and we're set to exclude
                    resultdict[k] = matching_files[k]		#      add the matching entry to final result (not excluded)
        else:							# No Strings provided for filter
            resultdict = matching_files				#  Pass all through
        return resultdict					# return the final result

    def get_localfiles(self):
        """Get listing of local files"""
        llsraw = pexpect.run('ls -l ' + self.localdir)   # Capture local ls -l
        if not llsraw:
            llsraw = dirslug
        prefilter = lstrim(llsraw)               	 # trim output to dict of {file, size} entries
        filtered = self.cluded(self.includeips, self.includestr, prefilter, operation='include')	# Filter out non-matching filenames
        self.lfiles = self.cluded(self.excludeips, self.excludestr, filtered, operation='exclude')	# Filter out matching filenames


    def get_retryfiles(self):
        """Get listing of files needing another attempt at upload"""
        rtlsraw = pexpect.run('ls -l ' + self.retrydir)  # Capture local ls -l
        if not rtlsraw:
            rtlsraw = dirslug
        prefilter = lstrim(rtlsraw)               	 # trim output to dict of {file, size} entries
        filtered = self.cluded(self.includeips, self.includestr, prefilter, operation='include')	# Filter out non-matching filenames
        self.retryfiles = self.cluded(self.excludeips, self.excludestr, filtered, operation='exclude')	# Filter out matching filenames


    def get_remotefiles(self):
        """Get listing of remote files"""
        self.sftp_conn_check()			# Guarantee connectivity
        self.child.sendline ('ls -l')           # Run remote ls -l
        self.child.timeout = sftp_timeout
        self.child.expect (self.SFTP_PROMPT)	#
        rlsraw = self.child.before              # capture raw output
        self.rfiles = lstrim(rlsraw)            # trim output to dict of {file, size} entries

    def check_duptmpfile(self, f):
        """Get listing of remote files"""
        dup = False
        self.sftp_conn_check()			        # Guarantee connectivity
        self.child.sendline ('ls -l')           # Run remote ls -l
        self.child.timeout = sftp_timeout
        self.child.expect (self.SFTP_PROMPT)	#
        rlsraw = self.child.before              # capture raw output
        rfiles = lstrim(rlsraw)                 # trim output to dict of {file, size} entries
        if ("tmp_" + f) and f in rfiles.iterkeys():
            if rfiles[f] == rfiles["tmp_" + f]:
                logging.warn(get_timestamp() + " Files tmp_" + f + " and " + f + " have same file size")
                self.sftp_rm(f)
                dup = True
        return dup

    def sftp_rename(self, f):
        """Rename the file from tmp_f to just f"""
        self.sftp_conn_check()			# Guarantee connectivity
        self.child.sendline ('rename tmp_' + f + ' ' + f) # Put the file to a tmp_ file
        self.child.expect (self.SFTP_PROMPT)	#
        rename_resp_raw = self.child.before 	# Get the response
        rename_success = parse_response(rename_resp_raw, "rename") # Parse for boolean result
        if rename_success:			# If True
            now = datetime.datetime.now()	# Get a timestamp
            logging.info(get_timestamp() + " COMPLETED: " + f + " at " + str(now)) # Log completion
        elif self.check_duptmpfile(f):
            logging.warn(get_timestamp() + " Removed duplicate file " + f)
        else:
            logging.error(get_timestamp() + " Unknown error in rename of file " + f)

    def sftp_copy(self, f, ldir):
        """Copy, and if successful call the rename"""
        self.sftp_conn_check()				     # Guarantee connectivity
        lfile = ldir + "/" + f
        print lfile
        self.child.sendline ('put -p ' + lfile + ' tmp_' + f)    # Put the file to a tmp_ file
        self.child.timeout = sftp_timeout
        self.child.expect (self.SFTP_PROMPT)		     #
        copy_resp_raw = self.child.before 		     # Get the response
        copy_success = parse_response(copy_resp_raw, "copy") # Parse for boolean result
        if copy_success:				     # If True
            logging.debug(get_timestamp() + " File " + lfile + " successfully copied to tmp_" + f) # Log success

	    # ssw
	    file = lfile
	    RE = open(report, "a")
	    size = str(os.stat(file).st_size)
	    t = str(int(time.time()))
	    RE.write(self.host + ":" + t + ":" + size + "\n")
	    RE.close()
	    #####

            self.sftp_rename(f)				     # Attempt to rename
        else:						     # Otherwise:
            now = datetime.datetime.now()		     # Get a timestamp
            logging.error(get_timestamp() + " Unsuccessful file transfer: " + lfile + " at " + str(now)) # Log failure
            try:
                if not ldir == self.retrydir:
                    shutil.copy2(lfile, self.retrydir)
                    logging.debug(get_timestamp() + " Copied: " + f + " to " + self.retrydir) # Log copy action
                else:
                    logging.error(get_timestamp() + " File " + f + " failed repeat upload attempt from " + self.retrydir)
                    logging.warn(get_timestamp() + " File " + f + " will remain in " + self.retrydir)
            except IOError as e:
                logging.error(get_timestamp() + " Unable to copy " + f + " to " + self.retrydir)
	        print e
            
            
    def sftp_rm(self, f):
        """Remove file f"""
        self.sftp_conn_check()			# Guarantee connectivity
        logging.debug(get_timestamp() + ' Removing file: ' + f)	# Log removal
        self.child.sendline ('rm ' + f)		# Remove file
        self.child.expect (self.SFTP_PROMPT)	#

    def do_sftp(self, dutydict, localdir, delete=False):
        """Run the commands against the current pexpect child"""
        for f in dutydict.iterkeys():			# Run against each file in the dict
            if dutydict[f] == "copy":			# For files marked "copy"
                logging.debug(get_timestamp() + " Copying file " + f)	# 
                self.sftp_copy(f, localdir)		# Copy file
            elif dutydict[f] == "failed":		# For files marked "failed"
                logging.warn(get_timestamp() + " Retrying failed download for " + f) # Log warning
                self.sftp_rm(f)				# Remove old copy first
                self.sftp_copy(f, localdir)		# Re-copy file
            elif dutydict[f] == "rename":		# For files marked "rename"
                logging.debug(get_timestamp() + " Renaming file tmp_" + f + " to " + f) # Log rename
                self.sftp_rename(f)			# Rename file
            elif delete: 					# Otherwise:
                if dutydict[f] == "completed":
                    try:
                        os.remove(localdir + "/" + f)
                        logging.debug(get_timestamp() + " Deleting successfully copied file: " + f)
                    except:
                        logging.error(get_timestamp() + " Unable to delete successfully copied file " + f)


    def process(self):
        """The meat of the operation"""
        self.child = self.sftp_login()	# Initial login
        self.get_localfiles()		# Get list of local files
        self.get_remotefiles()		# Get list of remote files
        self.get_retryfiles()		# Get list of files to retry
        retrydict = filechk(self.retryfiles, self.rfiles)   # Obtain duty roster for each file (copy, rename, failed, completed)
        self.do_sftp(retrydict, self.retrydir, delete=True) # Try to copy files that failed last time, delete on success.
        dutydict = filechk(self.lfiles, self.rfiles)        # Obtain duty roster for each file (copy, rename, failed, completed)
        self.do_sftp(dutydict, self.localdir, delete=True)  # Do the actual sftp stuff, delete on success.

    def serve(self):
        """The actual daemon process lives here"""
        import signal
        import sys
        def signal_handler(signal, frame):
            """Need this for the signal caller, even though we don't really use it"""
            self.stop()
        signal.signal(signal.SIGINT, signal_handler)
        if self.daemonize:
            while 1:
                start = datetime.datetime.now()			# Start time
                logging.debug(get_timestamp() + ' Cycle started at ' + str(start))	#
                self.process()					# Run the full process
                finish = datetime.datetime.now()			# End time
                logging.debug(get_timestamp() + ' Cycle complete at ' + str(finish))	# 
                time.sleep(self.sleep_interval)			# Pause for the sleep interval
        else:
            start = datetime.datetime.now()                 # Start time
            logging.debug(get_timestamp() + ' Cycle started at ' + str(start)) #
            self.process()                                  # Run the full process
            finish = datetime.datetime.now()                        # End time
            logging.debug(get_timestamp() + ' Cycle complete at ' + str(finish))       #
            

    def stop(self):
        """Dummy process here for when signal_handler calls it"""
        pass


class ServerDaemon(Daemon):
    """ServerDaemon object class"""
    def run(self, options):
        """Set the process to run"""
        if setproctitle:
            setproctitle('NSmediator')
        server = Server(options)
        server.serve()


def main():
    """Do I have to describe what main does?"""
    import os, sys
    import argparse
     
    localuser = os.getlogin()
    localpath = os.getcwd()
    # Get and parse command-line args
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--host', dest='host', help='sftp target host', default='')
    group.add_argument('--restart', dest='restart', action='store_true', help='restart a running daemon', default=False)
    group.add_argument('--stop', dest='stop', action='store_true', help='stop a running daemon', default=False)

    parser.add_argument('-d', '--debug', dest='debug', action='store_true', help='debug mode', default=False)
    parser.add_argument('--user', dest='user', help='sftp target user (DEFAULT: current user (' + localuser + '))', default=localuser)
    parser.add_argument('--localdir', dest='localdir', help='local file directory (DEFAULT: ' + localpath + ')', default=localpath)
    parser.add_argument('--remotedir', dest='remotedir', help='remote file directory', default='')
    parser.add_argument('--retrydir', dest='retrydir', help='Temp storage directory for files to be retried', default='/tmp/NSretry')    
    parser.add_argument('--includeip', dest='includeips', metavar='IP', action='append', help='Full or partial IP address expected at beginning of filenames to include, e.g. --includeip 10.26.56 would match and include files like 10.26.56.64_filename.csv.gz (Can invoke multiple instances of this arg)', default=[])
    parser.add_argument('--excludeip', dest='excludeips', metavar='IP', action='append', help='Full or partial IP address expected at beginning of filenames to exclude, e.g. --excludeip 10.26.56 would match and exclude files like 10.26.56.64_filename.csv.gz (Can invoke multiple instances of this arg)', default=[])
    parser.add_argument('--includestr', dest='includestr', metavar='STRING', action='append', help='Include files with matching string in filename. Can invoke multiple instances of this arg. (If not specified, defaults to this list: ["HTTP", "GENERIC", "EMAIL", "FTP_DATA"])', default=['HTTP','GENERIC','EMAIL','FTP_DATA'])
    parser.add_argument('--excludestr', dest='excludestr', metavar='STRING', action='append', help='Exclude files with matching string in filename. Can invoke multiple instances of this arg.', default=[])
    parser.add_argument('-s', '--sleep-interval', dest='sleep_interval', help='interval between attempts to upload', type=int, default=10)
    parser.add_argument('-l', dest='log_file', help='log file', type=str, default=None)
    parser.add_argument('-D', '--daemon', dest='daemonize', action='store_true', help='daemonize', default=False)
    parser.add_argument('--pidfile', dest='pidfile', action='store', help='pid file', default='/tmp/NSmediate.pid')
    parser.add_argument('--lockfile', dest='lockfile', action='store', help='lock file', default='/tmp/NSmediate.lck')
    
    options = parser.parse_args(sys.argv[1:])

    print options 
    #exit

    logging.basicConfig(level=logging.DEBUG if options.debug else logging.INFO,
                        stream=open(options.log_file, 'a') if options.log_file else sys.stderr)

    if os.path.exists(options.lockfile):
        now = int(time.time())
        if now - os.path.getmtime(options.lockfile) > 1800:
            os.remove(options.lockfile)
            logging.warn(get_timestamp() + " Deleted lock file.  Exiting.")
        else:
            logging.warn(get_timestamp() + " Lockfile exists.  Please delete or verify no other instance running.")
        sys.exit(1)

    with open(options.lockfile, 'w') as lockfile:
        lockfile.write("locked")
    logging.debug(get_timestamp() + " Created lock file " + options.lockfile)

    daemon = ServerDaemon(options.pidfile)
    if options.daemonize:
        daemon.start(options)
    elif options.restart:
        daemon.restart(options)
    elif options.stop:
        daemon.stop()
    else:
        daemon.run(options)

    if os.path.exists(options.lockfile):
        os.remove(options.lockfile)
        logging.debug(get_timestamp() + " Removed lock file " + options.lockfile)
    if os.path.exists(options.pidfile):
        os.remove(options.pidfile)
        logging.debug(get_timestamp() + " Removed pidfile " + options.pidfile)
        
if __name__ == '__main__':
    main()
