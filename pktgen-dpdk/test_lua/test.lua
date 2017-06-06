package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"
 
--pktgen.screen("on");
pktgen.screen("off");

sizes = {64, 256, 576, 1500};
rates = {1, 5, 10, 20, 40, 50, 100};
interval = 5000;

for s = 1, 1 do
    for r = 1, 1 do
        printf("SIZE, RATE = (%d, %d)\n", sizes[s], rates[r]);
        pktgen.clr();
        pktgen.set("0", "size", sizes[s]);
        pktgen.set("0", "rate", rates[r]);
        pktgen.delay(500);
        pktgen.start("0");
        for count = 1, 4 do
            pktgen.delay(interval);
            stats = pktgen.portStats("all", "port");
            portRates = pktgen.portStats("all", "rate");
            printf("size : %d, rate : %d, time : %d\n", sizes[s], rates[r], count * interval);
            printf("[0] opackets : %d, obytes : %d, oerrors : %d, mbits_tx : %d\n", stats[0]["opackets"], stats[0]["obytes"], stats[0]["oerrors"], portRates[0]["mbits_tx"]);
            printf("[1] ipackets : %d, ibytes : %d, ierrors : %d, mbits_rx : %d\n", stats[1]["ipackets"], stats[1]["ibytes"], stats[1]["ierrors"], portRates[1]["mbits_rx"]);
        end
        pktgen.stop("0");
        pktgen.delay(interval);
        stats = pktgen.portStats("all", "port");
        printf("RESULT\n");
        printf("[0] opackets : %d, obytes : %d, oerrors : %d\n", stats[0]["opackets"],stats[0]["obytes"], stats[0]["oerrors"]);
        printf("[1] ipackets : %d, ibytes : %d, ierrors : %d\n", stats[1]["ipackets"],stats[1]["ibytes"], stats[1]["ierrors"]);
        if stats[0]["opackets"] ~= stats[1]["ipackets"] then
            printf("PACKET LOSSES\n");
        end
        printf("\n");
    end
end


