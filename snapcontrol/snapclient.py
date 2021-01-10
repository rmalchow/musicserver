import socket
import threading
import select
import time
import random
import subprocess
import requests


class SnapClient(threading.Thread):

    def __init__ (self):
        threading.Thread.__init__(self)
        self.current = None
        self.p = None

    def run():
        while True:
            time.sleep(2)

    def connect (self, client=None, server=None, port=1704):
        print("client %s " % client)
        print("server %s " % server)
        if client is not None:
            # request
            url = 'http://%s:5000/client/connect' % (client)
            if server is not None:
                url = 'http://%s:5000/client/connect?server=%s' % (client,server)
            response = requests.get(url)
            return response.content
        elif server is not None:
            try:
                print("terminating old process ... ")
                self.p.terminate()
            except:
                pass

            try:
                print("starting new process ... ")
                sccmd = [
                    "/usr/bin/snapclient"
                ]
                sccmd.append("-h")
                sccmd.append(server)
                #sccmd.append("-s")
                #sccmd.append("pulse")
                self.p = subprocess.Popen(sccmd)
                self.current = server
                print("popen done")
            except Exception as e:
                print(e)
                print("popen failed")
                pass
        if self.current is not None:
            return self.current
        return "None"


snapclient = SnapClient()
