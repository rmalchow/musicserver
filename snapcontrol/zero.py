

from zeroconf import IPVersion, ServiceBrowser, Zeroconf, ServiceInfo
import psutil, socket

class Zero:

    def __init__ (self, service=None):
        self.list = {}
        self.browser = ServiceBrowser(zeroconf, service, self)

    def remove_service(self, zeroconf, type, name):
        del self.list[name]

    def update_service():
        pass

    def add_service(self, zeroconf, type, name):
        info = zeroconf.get_service_info(type, name)
        print("Service %s added, service info: %s" % (name, info))
        print("name: %s " % (info.name))
        print("ip:   %s " % (info.parsed_addresses(IPVersion.V4Only)[0]))
        print("port: %s " % (str(info.port)))
        ip = None
        ips = info.parsed_addresses()
        for i in ips:
            if i.startswith("192"):
                ip = i
                break
            else:
                print(i)

        self.list[name] = {
            "name" : info.name,
            "ip"   : ip,
            "ips"   : ips,
            "port" : info.port,
            "server" : info.server
        }

    def get_list(self):
        out = []
        for s in self.list.keys():
            out.append(self.list[s])
        return out

iface = None


af_map = {
    socket.AF_INET: 'IPv4',
    socket.AF_INET6: 'IPv6',
    psutil.AF_LINK: 'MAC',
}

duplex_map = {
    psutil.NIC_DUPLEX_FULL: "full",
    psutil.NIC_DUPLEX_HALF: "half",
    psutil.NIC_DUPLEX_UNKNOWN: "?",
}

addrs = psutil.net_if_addrs()
for k in addrs.keys():

    if iface is not None:
        break

    if k.startswith("lo"):
        print("loopback ... ")
        continue
    if k.startswith("veth"):
        print("virtual ... ")
        continue
    if k.startswith("docker"):
        print("docker  ... ")
        continue
    if k.startswith("br"):
        print("bridge ... ")
        continue
    for addr in addrs[k]:
        if af_map.get(addr.family, addr.family) != "IPv4":
            continue
        iface = {
            "name" : k,
            "ip"   : addr.address,
            "family" : af_map.get(addr.family, addr.family)
        }
        print(addr)


print("====================================================")
print(iface)
print("====================================================")

zeroconf = Zeroconf()
name = "pi-%s" % iface["ip"].replace(".","-")

info = ServiceInfo(
          type_="_snapserver._tcp.local.",
          name="%s._snapserver._tcp.local." % name,
          port=1704,
          parsed_addresses=[iface["ip"]]
          )

zeroconf.register_service(info)

info = ServiceInfo(
          type_="_mopidy._tcp.local.",
          name="%s._mopidy._tcp.local." % name,
          port=6680,
          parsed_addresses=[iface["ip"]]
          )

zeroconf.register_service(info)

snapserver = Zero("_snapserver._tcp.local.")
mopidy = Zero("_mopidy._tcp.local.")
