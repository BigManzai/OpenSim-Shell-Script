import struct
import os

def getch():
     os.system("python -V \"read -n 1\"")
                 
     if struct.calcsize("P") * 8 == 64: print("Running in 64-bit mode.")
     else: print("Running in 32-bit mode.")

getch()