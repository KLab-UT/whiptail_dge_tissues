#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Fetch interactions for use in a pandas dataframe
"""

import requests
import json
import pandas as pd
from core import config as cfg

request_url = cfg.BASE_URL + "/interactions"

# List of genes to search for
geneList = ["AADAT","KAT2","KATII","KYAT2","AASS","LKR/SDH","LKRSDH","LORSDH","ABCB6","ABC","LAN","MTABC3","PRP","umat","ABCB7","ABC7","ASAT","Atm1p","EST140535","ABCD1","ABC42","ALD","ALDP","AMN","ABCD3","ABC43","CBAS5","PMP70","PXMP1","ZWS2","ACACB","ACACbeta","ACC-beta","ACC2","ACCB","ACCbeta","HACC275","ACAD8","ACAD-8","ARC42","IBDH","ACAD9","MC1DN20","NPD002","ACADM","ACAD1","MCAD","MCADH","ACADS","ACAD3","SCAD","CPN2","ACBP","ACLY","ACL","ATPCL","CLATP","ACOT2","CTE-IA","CTE1A","MTE1","PTE2","PTE2A","ZAP128","ACSF2","ACSMW","AVYV493","ACSF3","ACSL1","ACS1","FACL1","FACL2","LACS","LACS1","LACS2","ACSM3","SA","SAH","FDX1","ADX","FDX","LOH11CR1D","AGK","CATC5","CTRCT38","MTDPS10","MULK","AGXT2","AGT2","BAIBA","DAIBAT","AIFM1","AIF","AUNX1","CMT2D","CMTX4","COWCK","COXPD6","DFNX5","NADMR","NAMSD","PDCD8","SEMDHL","AIP","ARA9","FKBP16","FKBP37","PITA1","SMTPHN","XAP-2","XAP2","AURKAIP1","AKIP","MRP-S38","mS38","ALDH2","ALDH-E2","ALDHI","ALDM","IGFALS","ACLSD","ALS","AMACR","AMACRD","CBAS4","P504S","RACE","RM","SLC25A6","AAC3","ANT","ANT 2","ANT 3","ANT3","ANT3Y","ANAPC4","APC4","APEX1","APE","APE1","APEN","APEX","APX","HAP1","REF1","ARL1","ARFL1","ARL2","ARFL2","MRCS1","ATAD1","AFDC1","FNP001","HKPX4","Msp1","THORASE","hATAD1","ATP23","KUB3","XRCC6BP1","ATP5PD","APT5H","ATP5H","ATPQ","ATP5ME","ATP5I","ATP5K","ATP5PF","ATP5","ATP5A","ATP5J","ATPM","CF6","F6","DMAC2L","ATP5S","ATPW","FB","HSU79253","ATP5PO","ATP5O","ATPO","HMC08D05","MC5DN7","OSCP","ACOT7","ACH1","ACT","BACH","CTE-II","LACH","LACH1","hBACH","BAK1","BAK","BAK-LIKE","BCL2L7","CDN1","BAX","BCL2L4","BCAT2","BCAM","BCATM","BCT2","HVLI","PP18","BCO2","B-DIOX-II","BCDO2","BCS1L","BCS","BCS1","BJS","FLNMS","GRACILE","Hs.6719","MC3DN1","PTD","h-BCS","h-BCS1","BDH1","BDH","SDR9C1","BNIP3","HABON","NIP3","BOLA1","CGI-143","BOLA3","MMDS2","BPHL","BPH-RP","MCNAA","VACVASE","C1QBP","COXPD33","GC1QBP","HABP1","SF2AP32","SF2p32","gC1Q-R","gC1qR","p32","CASP3","CPP32","CPP32B","SCA-1","CASP9","APAF-3","APAF3","ICE-LAP6","MCH6","PPP1R56","CPT1C","CATL1","CPT I-C","CPT1-B","CPT1P","CPTI-B","CPTIC","SPG73","CBR3","HEL-S-25","SDR21C2","hCBR3","HCCS","CCHL","LSDMCA1","MCOPS7","MLS","CHDH","CHPT1","CPT","CPT1","NDUFAF1","CGI-65","CGI65","CIA30","MC1DN11","CLK1","CLK","CLK/STY","STY","CLPB","ANKCLB","ANKCLP","HSP78","MEGCANN","MGCA7","MGCA7A","SCN9","SKD3","CLPP","DFNB81","PRLTS3","CLPX","EPP2","CLYBL","CLB","GNAQ","CMAL","CMC1","G-ALPHA-q","GAQ","SWS","CMC2","2310061C15Rik","C16orf61","DC13","CMC4","C6.1B","MTCP1","MTCP1B","MTCP1NB","p8","p8MTCP1","CMPK2","NDK","TMPK2","TYKi","UMP-CMPK2","COA1","C7orf44","MITRAC15","COA4","CHCHD8","CMC3","E2IG2","COA5","6330578E17Rik","C2orf64","CEMCOX3","MC4DN9","Pet191","COA6","C1orf31","CEMCOX4","MC4DN13","COA7","C1orf163","RESA1","SCAN3","SELRC1","COA8","APOP","APOP1","APOPT1","C14orf153","MC4DN17","COQ3","DHHBMT","DHHBMTASE","UG0215E05","bA9819.1","COQ4","CGI-92","COQ10D7","SPAX10","COQ5","COQ10D9","COQ6","CGI-10","CGI10","COQ10D6","COQ7","CAT5","CLK-1","COQ10D8","HMNR9","COQ8A","ADCK3","ARCA2","CABC1","COQ10D4","COQ8","SCAR9","COQ9","C16orf49","COQ10D5","COX10","MC4DN3","COX11","COX11P","MC4DN23","COX14","C12orf62","MC4DN10","PCAG1","COX15","CEMCOX2","HAS","MC4DN6","COX16","C14orf112","HSPC203","MC4DN22","hCOX16","COX17","COX18","COX18HS","OXA1L2","COX20","FAM36A","MC4DN11","COX5A","COX","COX-VA","MC4DN20","VA","COX5B","COXVB","COX8A","COX8","COX8-2","COX8L","MC4DN15","VIII","VIII-L","CPT1A","CPT1-L","L-CPT1","CPT2","CPTASE","IIAE4","CRY1","DSPD","PHLL1","CYB5B","CYB5-M","CYPB5M","OMB5","CYCS","CYC","HCS","THC4","DCXR","DCR","HCR2","HCRII","KIDCR","P34H","PNTSU","SDR20C1","XR","DDX28","MDDX28","DECR1","DECR","NADPH","SDR18C1","DELE1","DELE","DELE1(L)","KIAA0141","DGUOK","MTDPS3","NCPH","NCPH1","PEOB4","dGK","QDPR","DHPR","HDHPR","PKU2","SDR33C1","DHRS4","CR","NRDR","PHCR","PSCD","SCAD-SRL","SDR-SRL","SDR25C1","SDR25C2","DHX30","DDX30","NEDMIAL","RETCOR","SLC25A10","DIC","MTDPS19","DLD","DLDD","DLDH","E3","GCSL","LAD","OGDC-E3","PHE3","DNM1L","DLP1","DRP1","DVLP","DYMPLE","EMPF","EMPF1","HDYNIV","OPA5","DMAC1","C9orf123","TMEM261","DUS2","DUS2L","SMM1","URLC8","ECH1","HPXEL","HADHA","ECHA","GBP","HADH","LCEH","LCHAD","MTPA","TP-ALPHA","HADHB","ECHB","MSTP029","MTPB","MTPD","MTPD2","TP-BETA","ECI1","DCI","ECI2","ACBD2","DRS-1","DRS1","HCA88","PECI","dJ1013A10.3","ECSIT","SITPEC","GFM1","COXPD1","EFG","EFG1","EFGM","EGF1","GFM","hEFG1","mtEF-G1","EFHD1","MST133","MSTP133","PP3051","SWS2","TUFM","COXPD4","EF-TuMT","EFTU","P43","SMDT1","C22orf32","DDDD","EMRE","ERAL1","CEGA","ERA","ERA-W","ERAL1A","ERAL1B","H-ERA","HERA-A","HERA-B","PRLTS6","ETFA","EMA","GA2","MADD","ETFB","FP585","ETHE1","HSCO","YF13H12","EXOG","ENDOGL1","ENDOGL2","ENGL","ENGL-a","ENGL-b","ENGLA","ENGLB","BRCA2","BRCC2","BROVCA2","FACD","FAD","FAD1","FANCD","FANCD1","GLM3","PNCA2","XRCC11","FAHD1","C16orf36","ODx","YISKL","FAS","ALPS1A","APO-1","APT1","CD95","FAS1","FASTM","TNFRSF6","FASTK","FAST","FDX2","FDX1L","MEOAL","FHIT","AP3Aase","FRA3B","FIS1","CGI-135","TTC11","FKBP8","FKBP38","FKBPr38","FDPS","FPPS","FPS","POROK9","FXN","CyaY","FA","FARR","FRDA","X25","S100A4","18A2","42A","CAPL","FSP1","MTS1","P9KA","PEL98","GARS1","DSMAV","GARS","GlyRS","HMN5","HMN5A","HMND5","SMAD1","SMAJI","GATB","COXPD41","HSPC199","PET112","PET112L","GATC","15E1.2","COXPD42","GBF1","ARF1GEF","CMT2GG","CMTDI2","CMTDIA","GCDH","ACAD5","GCD","GCSH","GCE","MMDS7","NKH","GLDC","GCE1","GCSP","HYGN1","AMT","GCE2","GCST","GCVT","Gene","GHITM","DERP2","HSPC282","MICS1","My021","PTD010","TMBIM5","HAGH","GLO2","GLO2D","GLX2","GLXII","HAGH1","GLOD4","C17orf25","CGI-150","HC6","HC71","GLRX2","CGI-133","GRX2","GLRX5","C14orf87","FLB4739","GRX5","PR01238","PRO1238","PRSA","SIDBA3","SPAHGC","GPAM","GPAT","GPAT1","GPD2","GDH2","GPDM","mGDH","mGPDH","GPX1","GPXD","GSHPX1","GPX4","GPx-4","GSHPx-4","MCSP","PHGPx","SMDS","snGPx","snPHGPx","GRHPR","GLXR","GLYD","PH2","HSPA9","CRP40","CSA","EVPLS","GRP-75","GRP75","HEL-S-124m","HSPA9B","MOT","MOT2","MTHSP75","PBP74","SAAN","SIDBA4","GRSF1","GSTK1","GST","GST 13-13","GST13","GST13-13","GSTK1-1","hGSTK1","GUF1","DEE40","EF-4","EF4","EIEE40","HSD17B10","17b-HSD10","ABAD","CAMR","DUPXp11.22","ERAB","HADH2","HCD2","HSD10MD","MHBD","MRPP2","MRX17","MRX31","MRXS10","SCHAD","SDR5C1","HAD","HADH1","HADHSC","HCDH","HHF4","MSCHAD","HDHD5","CECR5","NFE2L2","HEBP1","IMDDHH","NRF2","Nrf-2","HEMK1","HEMK","MPRMC","MTQ1","HES1","HES-1","HHL","HRY","bHLHb39","HIBCH","HIBYLCOAH","HINT1","HINT","NMAN","PKCI-1","PRKCNH1","HINT2","HIT-17","HINT3","HINT4","HMGCL","HL","HMGCL1","HOGA1","C10orf65","DHDPS2","DHDPSL","HP3","NPL2","ADHFE1","ADH8","HMFT2263","HOT","HSCB","DNAJC20","HSC20","JAC1","SIDBA5","HSDL1","SDR12C3","HSDL2","C9orf99","SDR13C1","HTRA2","MGCA8","OMI","PARK13","PRSS25","MGARP","C4orf49","CESP-1","HUMMR","OSAP","MRPL58","DS-1","DS1","ATP8","MT-ATP8","ATPase8","MTATP8","ATP6","MT-ATP6","ATPase6","MTATP6","COX1","MT-CO1","COI","MTCO1","COX2","MT-CO2","COII","MTCO2","COX3","MT-CO3","COIII","MTCO3","CYTB","MT-CYB","MTCYB","ND1","MT-ND1","MTND1","ND2","MT-ND2","MTND2","ND3","MT-ND3","MTND3","ND4L","MT-ND4L","MTND4L","ND4","MT-ND4","MTND4","ND5","MT-ND5","MTND5","ND6","MT-ND6","MTND6","RNR2","MT-RNR2","MTRNR2","TRNA","MT-TA","MTTA","TRNR","MT-TR","MTTR","TRNN","MT-TN","MTTN","TRND","MT-TD","MTTD","TRNC","MT-TC","MTTC","TRNE","MT-TE","MTTE","TRNQ","MT-TQ","MTTQ","TRNG","MT-TG","MTTG","TRNH","MT-TH","MTTH","TRNI","MT-TI","MTTI","TRNL1","MT-TL1","MTTL1","TRNL2","MT-TL2","MTTL2","TRNK","MT-TK","MTTK","TRNM","MT-TM","MTTM","TRNF","MT-TF","TRNP","MT-TP","MTTP","TRNS1","MT-TS1","MTTS1","TRNS2","MT-TS2","MTTS2","TRNT","MT-TT","MTTT","TRNW","MT-TW","MTTW","TRNY","MT-TY","MTTY","TRNV","MT-TV","MTTV","RNR1","MT-RNR1","MTRNR1"]  # Yeast Genes STE11 and NMD4
evidenceList = ["POSITIVE GENETIC", "PHENOTYPIC ENHANCEMENT"]

# These parameters can be modified to match any search criteria following
# the rules outlined in the Wiki: https://wiki.thebiogrid.org/doku.php/biogridrest
params = {
    "accesskey": cfg.ACCESS_KEY,
    "format": "json",  # Return results in TAB2 format
    "geneList": "|".join(geneList),  # Must be | separated
    "searchNames": "true",  # Search against official names
    "includeInteractors": "true",  # Set to true to get any interaction involving EITHER gene, set to false to get interactions between genes
    "includeInteractorInteractions": "true",  # Set to true to get interactions between the geneList’s first order interactors
    "includeEvidence": "true",  # If false "evidenceList" is evidence to exclude, if true "evidenceList" is evidence to show
    "taxID": 9606,
    "includeHeader": "true",
    "searchSynonyms": "true"
    "interSpeciesExcluded": "true",
    "includeEvidence": "false",
    "evidenceList": "|".join(evidenceList),  # Exclude these two evidence types
}

# Additional options to try, you can uncomment them as necessary
# See "get_interactions_by_gene.py" or https://wiki.thebiogrid.org/doku.php/biogridrest for a list of additional parameter options

r = requests.get(request_url, params=params)
interactions = r.json()

# Create a hash of results by interaction identifier
data = {}
for interaction_id, interaction in interactions.items():
    data[interaction_id] = interaction
    # Add the interaction ID to the interaction record, so we can reference it easier
    data[interaction_id]["INTERACTION_ID"] = interaction_id

# Load the data into a pandas dataframe
dataset = pd.DataFrame.from_dict(data, orient="index")

# Re-order the columns and select only the columns we want to see

columns = [
    "INTERACTION_ID",
    "ENTREZ_GENE_A",
    "ENTREZ_GENE_B",
    "OFFICIAL_SYMBOL_A",
    "OFFICIAL_SYMBOL_B",
    "EXPERIMENTAL_SYSTEM",
    "PUBMED_ID",
    "PUBMED_AUTHOR",
    "THROUGHPUT",
    "QUALIFICATIONS",
]
dataset = dataset[columns]
dataset.to_csv("complete_interaction_list.csv", index=False)
# Pretty print out the results
print(dataset)
