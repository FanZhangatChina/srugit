// Simple routine to plot error rate vs phase from SRU DTC link phase scan based on David's txt2tree code
// TCA October 2012
//
void SRU_phase_scan(const int minPhase=0, const int maxPhase=79,
		    const char *filename="SruDtcScanLogSMA5.txt")
{
  
  gROOT->Reset();
  
  gStyle->SetOptDate(0);
  gStyle->SetOptTitle(0);
  gStyle->SetOptStat(0);
  
  TCanvas *MyC1 = new TCanvas("MyC1","PhaseScan",1);
  
  TH2F *h1 = new TH2F("DTC Link","Phase (ns)",40,0.0,40.0,
		      maxPhase-minPhase+1,minPhase,maxPhase);
  MyC1->SetFillColor(10);
  MyC1->SetHighLightColor(10);
  
  ifstream fin;
  fin.open(filename);
  
  Int_t nlines = 0;
  Int_t nlines2 = 0;
  const int kNHEADERLINES = 6;
  const int kMAXLEN = 100; // max length of a single line
  
  const Int_t kNLinks = 40;
  Int_t firstReg = 0x800010a0;
  
  const int kMaxPhases = 1000;
  Int_t nPhases = 0;
  Int_t phaseShift = 0;
  Int_t nVal = 0;
  Int_t reg[kNLinks];
  Int_t val[kNLinks];

  Int_t nPhases2 = 0;
  Int_t phaseShift2 = 0;
  Int_t nVal2 = 0;
  Int_t reg2[kNLinks];
  Int_t val2[kNLinks];
	
  char line[kMAXLEN];
  char line2[kMAXLEN];

  while (fin.good() && nlines<kNHEADERLINES) {
    fin.getline(line, kMAXLEN);
    cout << " line " << line << endl;
    if (!fin.good()) break;
    nlines++;
  }
	
  while (nPhases < kMaxPhases) {

    fin.getline(line, kMAXLEN);
    if (!fin.good()) break;
    else {
      // this should be the line with the phase info.. decode it
      int p = 0;
      sscanf(line,"Set Phaseshift to %x", &p);
      phaseShift = p;
      cout << " phaseShift " << phaseShift << endl;
      nlines++;
      nPhases++;
      
      nVal = 0;    
      // and then we have a block of links with register and value info
      for (int j=0; j<kNLinks; j++) {
	fin.getline(line, kMAXLEN); // line info
	if (!fin.good()) break;
	fin.getline(line, kMAXLEN); // line info
	if (!fin.good()) break;
	int r = 0; int v = 0;
	sscanf(line,"%x : %x",&r,&v);
	reg[j] = r - firstReg;
	val[j] = v;
	if (j<40 && p>=minPhase && p<=maxPhase) h1->Fill(reg[j],p,val[j]);
	cout << " j " << j
	     << " reg " << reg[j]
	     << " val " << val[j] << endl;
	nVal++;
	nlines++;
      }
      fin.getline(line, kMAXLEN); // empty trailer line
    }


  } // phases


  printf(" found %d lines\n",nlines);
  printf(" found %d phases\n",nPhases);
  printf(" found %d lines\n",nlines2);
  printf(" found %d phases\n",nPhases2);
	
  fin.close();

  //MyC1->SetGrayscale();
	
  gStyle->SetTitleOffset(1.3,"Y");
  gStyle->SetOptStat();
  gStyle->SetOptFit(0111);
  gStyle->SetStatH(0.1);
  gStyle->SetStatW(0.1);
  gStyle->SetPalette(1,0);
  //  gPad->SetLogz(1);
  
  h1->GetXaxis()->SetTitle("DTC Link");
  h1->GetYaxis()->SetTitle("Phase step (0.6 ns/step)");
 // h1->GetZaxis()->SetTitle("Error counter value");
  h1->SetStats(kFALSE);
  h1->GetZaxis()->SetLabelSize(0.025);
  h1->SetContour(10);
  h1->Draw("colz");
  //h1->Draw("BOX");
  //h1->Draw("CONT3");
  MyC1->Print("DTCPlateauLin.eps");
  //MyC1->Print("DTCPlateauLog.eps");
  
  //leg = new TLegend(0.1,0.75,0.65,0.89);
  //	leg->AddEntry(gr1,"All Clusters","p");
  //	leg->AddEntry(gr2,"Clusters with 80% in single tower","p");
  //	leg->AddEntry(f2,"Old Fit","l");
  //	leg->AddEntry(f1,"[0]*(1./(1.+[1]*exp(-x/[2]))*1./(1.+[3]*exp((x-[4])/[5])))","l");
  //leg->Draw();
}


















