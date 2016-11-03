# PC based Function Generator (PCFG)

Group Project making PC based FunctionGenerator using FPGA ( Xilinx Spartan3 , VHDL )
2015 Fall semester ( 2015.11 ) 

Designer : JaeSeung Won , JaeSeung Choi   ( Undergraduate at Sogang Univ )




#1 Overall block diagram
https://github.com/cowboy409/PC-based-Function-Generator-VHDL-/blob/master/overall.png

#2 Design Detail Description ( Korean Language )
https://github.com/cowboy409/PC-based-Function-Generator-VHDL-/blob/master/2015%20Fall.%20PCFG%20Design%20Project%20Description.pdf

#3 Design Project Report ( Korean Language)
https://github.com/cowboy409/PC-based-Function-Generator-VHDL-/blob/master/PCFG%20Project%20Report.pdf

#4 Click (code) menu above to see the vhdl files.

#5 Brief description about PCFG

PCFG is PC based Function Generator. Based on PC, it need USB communication with PC.
Used USB Controller in Xilinx Spartan3 Board.
Used RAM in Xilinx IP library.
Used 8254 in Xilinx library.
Others, designed by ourselves.

1. System Clock Setting mode ( 8254 setting mode)
 Consider the 8254 Data sheet. It will start to work after receive total 3 times of data.
 The output signal will be used to System clock.

2. Software Reset.  
 Reset except 8254.

3. PC Mode. 
Communicate with PC with the USB controller. ( Hand shake mode)
In this mode, with the wen ( write enable ) signal it will start to record data to RAM0 receiving from PC. With the ren ( read enable ) signal it will start to transfer data from RAM to PC. We can select RAM0 or RAM1.

4. Data Transfer Mode
Move data from Ram0 to Ram1

5. DA Mode
Digital to Analog mode using the RAM1 data. 
It will continue converting Digital to Analog until stop signal comes in. Because this system is function generator.

6. AD Mode
Analog to Digital mode. Data recorded to RAM0.

7. Interpolation Mode.
Do the interpolation with RAM0 data and store to RAM1.
