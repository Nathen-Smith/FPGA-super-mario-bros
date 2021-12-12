# ECE385 Final Project
### Nathen Smith, Pratheek Eravelli

<p align="center">
  <img src="https://media.giphy.com/media/qiowGc3RfRZrx40nwI/giphy.gif" alt="demo gif" max-width="480" max-height="222" />
</p>

## Running Instructions
First, the project must be opened in Quartus Prime, selecting the ```.qpf``` file. 
From there, hit Start Compilation to generate the ```.sof``` file. When complete,
program the FPGA using the programmer. Then, open Nios II and select ```<CURRENT DIRECTORY>/software/```
as the working directory. Nios II Eclipse will start and no files will show up.
Import the ```usb_kb/``` ```usb_kb_bsp/``` both as ```Nios II Software Build Tools Project->Import Custom Makefile for Nios II Software Build Tools Project```.
Name the project name as their respective folders. Go to ```Run->Run Configurations``` and select ```Nios II Hardware->New Configuration``` and select ```usb_kb```
from the dropdown for project name. Refresh the connection and hit run, when the keycode printing show up on the Nios II Console it is run.

Note: If reset timeout prints, stroke the IO Shield until it goes away and proceeds to show keycode prints.

