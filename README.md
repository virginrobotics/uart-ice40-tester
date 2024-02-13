# uart-ice40-tester
Small configurable IP to test UART interfaces using the ice40 FPGA

Update as on 11 Feb 24

- new branch shift_uart
- basic UART tx with shift register approach
- spent way too long on debugging SHIFT_AMOUNT
- right val for reseting count was 9
- 0th count has stop bit + loads data frame to shift register
- UART frame 8n1 : 1MSB---LSB0

To Do

- ~~put baud clock and shift logic in sperate modules~~
- add data_frame load capability with a load_enable
- use increment logic to print "Hello World"
- 11 ASCII characters
- probably add new line + return to carraige as well
- add logic to trigger shift register with a enable signal 
