package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"
 
pktgen.screen("off");

pktgen.clr();
pktgen.delay(500);
pktgen.set("0", "size", 64);
pktgen.set("0", "rate", 1);
pktgen.latency("all", "enable");
pktgen.set_proto("all", "udp");

pktgen.start("0");

for a = 1,5 do
    pktgen.delay(5000);
    prints("pktStats", pktgen.pktStats("all"));
    prints("portStats", pktgen.portStats("all", "port"));
end
pktgen.stop("0");
