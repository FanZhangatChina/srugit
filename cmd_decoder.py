"""
author: Fan Zhang
created on : 2018-11-23
"""

import binascii
import math

def cmd_decoder(CardNo = 0x0, RW = 1, Addr = 0x3, Data = 0x0):

    if 20 <= CardNo <= 40 :
        word0_a = int(math.pow(2,(CardNo-20)))
        word0_s = '%08x'% word0_a
        word1_a = 0
        word1_s = '%08x'% word1_a
    else:
        word0_a = 0
        word0_s = '%08x'% word0_a
        word1_a = int(math.pow(2,CardNo))
        word1_s = '%08x'% word1_a

    if RW == 0 :
        word2_H = '00'
    else :
        word2_H = '80'

    word2_L = '%06x'% Addr

    word3_s = '%08x'% Data

    cmd_sep = ''
    cmd_s = [word0_s,word1_s,word2_H,word2_L,word3_s]
    cmd_packet_s = cmd_sep.join(cmd_s)
    cmd_packet = bytes.fromhex(cmd_packet_s)

    return cmd_packet
