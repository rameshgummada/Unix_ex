 #-----------------------------------------------------------------#
 #                                                                 #
 # Author:                                                         #
 #                                                                 #
 # Language: Python                                                #
 #                                                                 #
 # Date:                                                           #
 #                                                                 #
 # History: version 1                                              #
 #                                                                 #
 # Environment:                                                    #
 #                                                                 #
 # Purpose: To Solve water puzzle                                  #
 #                                                                 #
 # Tested:                                                         #
 #                                                                 #
 # Data Flow:                                                      #
 #                                                                 #
 #-----------------------------------------------------------------#

#import java
#from java import *
#import os
#import sys
#from sys import *
#import time
#from time import sleep
#from org.python.modules import re

j,T="%dL jug","tank"
A="\n5L: %d, 3L: %d, T: %d"
F,P="Fill "+j+A,"Pour from "+j+" into %s"+A
f,r=divmod(input(),5)
o,t=f*5,[]
for i in range(f):o+=[F%(5,5,0,5*i),P%(5,T,0,0,5*i+5)]
if r>2:o+=[F%(3,0,3,t),P%(3,T,0,0,t+3)];r-=3;t+=3
if r==2:o+=[F%(5,5,0,t),P%(5,j%3,2,3,t),P%(5,T,0,3,t+2)]
if r==1:o+=[F%(3,0,3,t),P%(3,j%5,3,0,t),F%(3,3,3,t),P%(3,j%5,5,1,t),P%(3,T,5,0,t+1)]
print"\n".join(o),'\n',"Volume measured out in %d turns"%len(o)
