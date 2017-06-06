package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"
 
--pktgen.screen("on");
pktgen.screen("off");
pktgen.clr();
pktgen.delay(500);
pktgen.set_proto("all", "udp");

sizes = {64, 576, 1500};
interval = 5000;
avg_mbtx = 0;
avg_mbrx = 0;

printf("\n");

pktgen.set("0", "rate", 100)

printf("RATE:%d\n", 100);
printf("SIZE,PPS,AVG_MBITS_RX\n");
for s = 1, 3 do
    avg_mbrx = 0;
    printf("%d", sizes[s]);
    pktgen.clr();
    pktgen.set("0", "size", sizes[s]);
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
    printf(",%.2f,%.2f", stats[1]["ipackets"]/20, avg_mbrx/4);
    if stats[0]["opackets"] ~= stats[1]["ipackets"] then
        printf(" PACKET LOSSES\n");
    else
        printf("\n");
    end
end

os.exit();

