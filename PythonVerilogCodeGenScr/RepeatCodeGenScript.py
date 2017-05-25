#print >>f, "16'h"+hex(i+4256)+" : begin rcmd_reply_data <= {26'h0,errcnt["+str(16*(i+1)-1)+":"+str(16*i)+"]}; rcmd_reply_dv <= 1'b1; end";
#print >>f, "16'h"+hex(i+4256)+" : begin rcmd_reply_data <= SampSel["+str(32*i+31)+":"+str(32*i)+"]; rcmd_reply_dv <= 1'b1; end";

f = open('CodeOut.txt','w')

for i in range(40):
    print >>f, "NET \"usru_40dtc_top/dtcgroup["+ str(i) + "].u_dtc_master_top/u_dtc_master_rx/Udtcdatapair/bitcnt<2>\" TNM_NET = dtc_wclk;";
#NET "usru_40dtc_top/dtcgroup[0].u_dtc_master_top/u_dtc_master_rx/Udtcdatapair/bitcnt<2>" TNM_NET = dtc_wclk;
	
	
