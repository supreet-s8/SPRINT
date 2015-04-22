#!/usr/bin/env python

import time, os

def cluded(stringlist, filelist, operation='exclude'):
    """
        Return only files INcluded or EXcluded (based on value of operation)
        by string(s) in stringlist
    """
    result = []                                             # Zero out the "final result" list
    if len(stringlist) > 0:                                 # Only run if there are entries in stringlist
        for f in filelist:                                  #  Loop through the files in our list
            match = False                                   #   Initialize match to false
            for string in stringlist:                       #   Loop through all strings in our include_strings
                if string in f:                             #     if the string is in the key (filename)
                    match = True                            #       set match to True
            if match and operation == 'include':            #    If we find a match and we're set to include
                result.append(f)                            #      add the matching entry to final result (include)
            elif not match and operation == 'exclude':      #    If we find NO match and we're set to exclude
                result.append(f)                            #      add the matching entry to final result (not excluded)
    else:                                                   # No Strings provided for filter
        result = filelist                                   #  Pass all through
    return result                                           # return the final result


# Main
excludelist = ['HTTP','GENERIC','EMAIL','FTP_DATA']
now = int(time.time())

path = "/data/feeds/NETSCOUT"
cutoff = 60

listing = os.listdir(path)
filtered_list = cluded(excludelist, listing)

for e in filtered_list:
    f = path + "/" + e
    if os.path.isfile(f):
        if now - os.path.getmtime(f) > cutoff:
            os.remove(f)
            #print "Deleted file " + f
