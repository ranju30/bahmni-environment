#!/usr/bin/python
from optparse import OptionParser

usage = "usage: %prog [options] JOBNAME"
parser = OptionParser(usage=usage, version="1.0")
parser.add_option("-H", "--host", dest="host", help="host", metavar="HOST")
parser.add_option("-p", "--port", dest="port", help="port", metavar="PORT")
parser.add_option("-u", "--url", dest="url", help="url", metavar="URL")
parser.add_option("-a", "--authorization", dest="authorization", help="Username:password on sites with basic authentication", metavar="AUTH_PAIR")

(options, args) = parser.parse_args()
if len(args) != 1:
	parser.error("please supply the jobName")

import urllib2
from base64 import b64encode
import json
import sys
import socket

jobName = args[0]
if options.port: 
	serverUrl = "http://%(host)s:%(port)s%(url)s" % vars(options)
else:
	serverUrl = "http://%(host)s%(url)s" % vars(options)


socket.setdefaulttimeout(5)
request = urllib2.Request(serverUrl)
request.add_header('Authorization', 'Basic ' + b64encode(options.authorization))
try:
	response = urllib2.urlopen(request)
except urllib2.HTTPError as e:
	print "HTTP Error: {0} : \n {1}".format(e.code, e.read())
	sys.exit(2)
except urllib2.URLError as e:
	print "URL Error: {0} ".format(e.reason)
	sys.exit(2)

jobs = json.load(response)   
job = next((j for j in jobs if jobName in j['taskClass']), None)
if(job is None):
	print "Job : %s not defined" % jobName
	sys.exit(2)

if(not job['started']):
	print "Job : %s not started" % jobName
	sys.exit(2)
else:
	print "Job : %s has been scheduled and started" % jobName