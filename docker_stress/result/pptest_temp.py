import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pylab
import sys


def goto_help():
    print ("Invalid input. To know the exact usage, try \"python pptest.py --help\"")

def plot_graph(data_type, figureStartNo, file_nt, file_ct, file_vm):
    if data_type == 'pps':
        data_no = 1
        topic = 'Packets Per Second'
        av_topic = 'PPS'
    elif data_type == 'mbits':
        data_no = 2
        topic = 'Average MBITS_RX'
        av_topic = "AVG_MBITS_RX"
    if figureStartNo == 0:
        data_nt = file_nt.readlines()
        data_ct = file_ct.readlines()
        data_vm = file_vm.readlines()
    elif figureStartNo == 4:
        file_nt.close()
        file_ct.close()
        file_vm.close()
        file_nt = open(sys.argv[3], 'r')
        file_ct = open(sys.argv[5], 'r')
        file_vm = open(sys.argv[7], 'r')
        data_nt = file_nt.readlines()
        data_ct = file_ct.readlines()
        data_vm = file_vm.readlines()

    rate = [1,10,50,100]
    specific_lines = [204,209,214,219]
    for i in range(4):
        ylimit = 0
        N= 3
        ind = np.arange(N)
        blank = 0.15
        width = 0.20
        smallblank = 0.05

        fig = pylab.figure(figureStartNo+i+1)
        ax = fig.add_subplot(111)

        xlabels = ('64', '576', '1500')

        mbps_nt = range(3)
        mbps_ct = range(3)
        mbps_vm = range(3)
        for j in range(3):
            print data_nt[specific_lines[i]+j].strip().split(',')
            print specific_lines[i]
            print j
            mbps_nt[j] = float(data_nt[specific_lines[i]+j].strip().split(',')[data_no].strip('PACKET LOSSES'))
            mbps_ct[j] = float(data_ct[specific_lines[i]+j].strip().split(',')[data_no].strip('PACKET LOSSES'))
            #mbps_vm[j] = float(data_vm[specific_lines[i]+j].strip().split(',')[data_no].strip('PACKET LOSSES'))
            maxvalue = max(mbps_nt[j], mbps_ct[j])
            if maxvalue > ylimit:
                ylimit = maxvalue


        rects_nt = ax.bar(ind+0.275, mbps_nt, width, color='r')
        rects_ct = ax.bar(ind+0.525, mbps_ct, width, color='g')
        #rects_vm = ax.bar(ind+blank+width*2+smallblank*2, mbps_vm, width, color='b')

        plt.title('%s at Rate=%d'%(topic,rate[i]))
        ax.set_xlabel('Packet Size')
        ax.set_ylabel(topic)
        ax.set_xticks(ind+0.5)
        ax.set_xticklabels(xlabels)
        ax.legend((rects_nt[0], rects_ct[0]), ('NATIVE', 'CONTAINER'))

        axes = fig.gca()
        axes.set_ylim([0,ylimit * 1.3])
        fig.savefig('graphs/%s_RATE%d.png'%(av_topic, rate[i]))

    return [file_nt, file_ct, file_vm]

if len(sys.argv)<2:
    goto_help()

elif (sys.argv[1] == '--help' and len(sys.argv) == 2):
    print ("\nUSAGE: python pptest.py -[p|m|b] -n [filename] -c [filename] -v [filename]")
    print ("ex) python pptest.py -p -n test_native.csv -c test_container.csv -v test_vm.csv\n\n")
    print ("OPTIONS:")
    print ("-p: print graph of PPS(packets per second)")
    print ("-m: print graph of AVG_MBITS_RX")
    print ("-b: print graph of PPS and AVG_MBITS_RX")
    print ("-n [filename]: input name of .csv file which contains data from native, bare metal")
    print ("-c [filename]: input name of .csv file which contains data from container")
    print ("-v [filename]: input name of .csv file which contains data from vm\n")

elif len(sys.argv) != 8:
    goto_help()

elif (sys.argv[1] not in ['-p', '-m', '-b']) or sys.argv[2] != '-n' or sys.argv[4] != '-c' or sys.argv[6] != '-v':
    goto_help()

else:
    try:
        file_nt = open(sys.argv[3], 'r')
        file_ct = open(sys.argv[5], 'r')
        file_vm = open(sys.argv[7], 'r')
    except IOError as e:
        print(str(e))
        goto_help()
    else:
        if sys.argv[1] == '-b':
            k = plot_graph('pps', 0, file_nt, file_ct, file_vm)
            [file_nt, file_ct, file_vm] = k
            plot_graph('mbits', 4, file_nt, file_ct, file_vm)
            #pylab.show()
        else:
            if sys.argv[1] == '-p':
                plot_graph('pps', 0, file_nt, file_ct, file_vm)
            elif sys.argv[1] == '-m':
                plot_graph('mbits', 0, file_nt, file_ct, file_vm)
            #pylab.show()
    finally:
        file_nt.close()
        file_ct.close()
        file_vm.close()
