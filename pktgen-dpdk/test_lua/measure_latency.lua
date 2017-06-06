package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"
 
--pktgen.screen("on");
pktgen.screen("off");
pktgen.clr();
pktgen.delay(500);
pktgen.latency("all", "enable");
pktgen.set_proto("all", "udp");

sizes = {64, 576, 1500};
rates = {1, 10, 50, 100};
interval = 5000;
avg_mbtx = 0;
avg_mbrx = 0;

printf("\n");

--for r = 1, 4 do
for r = 4, 4 do
    printf("RATE:%d\n", rates[r]);
    printf("SIZE,PPS,AVG_MBITS_RX,AVG_LATENCY,MAX_LATENCY,MIN_LATENCY\n");
    for s = 1, 3 do
        avg_mbrx = 0;
        printf("%d", sizes[s]);
        pktgen.clr();
        pktgen.set("0", "size", sizes[s]);
        pktgen.set("0", "rate", rates[r]);
        pktgen.delay(500);
        pktgen.start("0");
        for count = 1, 4 do
            pktgen.delay(interval);
            stats = pktgen.portStats("all", "port");
            portRates = pktgen.portStats("all", "rate");
            avg_mbtx = avg_mbtx + portRates[0]["mbits_tx"];
            avg_mbrx = avg_mbrx + portRates[1]["mbits_rx"];
        end
        pktgen.stop("0");
        pktgen.delay(interval);
        stats = pktgen.portStats("all", "port");
        pktstats = pktgen.pktStats("all");
        printf(",%.2f,%.2f,%d,%d,%d", stats[1]["ipackets"]/20, avg_mbrx/4, pktstats[1]["avg_latency"], pktstats[1]["max_latency"], pktstats[1]["min_latency"]);
        if stats[0]["opackets"] ~= stats[1]["ipackets"] then
            printf(" PACKET LOSSES\n");
        else
            printf("\n");
        end
    end
end

os.exit();

