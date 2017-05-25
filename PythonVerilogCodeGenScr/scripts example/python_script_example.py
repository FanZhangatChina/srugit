f = open('srucode.txt','w')

for i in range(0,40):
		print >> f,"assign dtc_clk["+str(i)+"] = dtc_clk_en["+str(i)+"] ? dtc_clk_i["+str(i)+"] : 1'b1;"

		#loop
		for i in range(0,40):
		k=1;
		print >> f,"parameter ebfifo_wr_s"+str(i)+" = 36'h"+str(hex(k<<i))+";"
		