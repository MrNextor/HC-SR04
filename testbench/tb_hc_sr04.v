`timescale 10 ns/ 1 ns
module tb_hc_sr04;
    parameter BCD_DIGITS = 3;                    // number of displayed BCD digits
    parameter SSEG       = 7;                    // widht seven seg      
    parameter MAX_RANGE  = 400;                  // maximum measuring range
    parameter DST_SZ     = $clog2(MAX_RANGE);    // distance width in binary code
    parameter NUM_LEN    = 4;                    // widht number in BCD code
    parameter BCD_LEN    = BCD_DIGITS * NUM_LEN; // widht BCD code)  

//------------------------------------------------------
    reg                   CLK;       // clock 50 MHz       
    reg                   RST_n;     // asynchronous reset_n
    reg                   I_EN;      // enable measurement distance
    wire                  strobe;    // impulse strobe onсe in 58.82 uS
    wire                  O_TRIG;    // trigger signal to start measurement HC-SR04
    reg                   I_ECHO;    // input  lever signal and the range in proportion  
    wire                  conv;      // signal start converting binary to BCD
    wire [DST_SZ-1:0]     dst;       // distance to object in binary code
    wire                  busy;      // realization converting binary to BCD
    wire [BCD_LEN-1:0]    bcd_dst;   // distance to object in BCD code
    wire [BCD_DIGITS-1:0] O_MUX_HEX; // multiplexer for determining the current seven-segment display    
    wire [SSEG-1:0]       O_HEX;     // current value seven-segment display 
    wire                  O_FL;      // measurement flag 

//------------------------------------------------------
    top_hc_sr04 dut 
        (
         .CLK(CLK),
         .RST_n(RST_n),
         .I_EN(I_EN),
         .I_ECHO(I_ECHO),
         .O_TRIG(O_TRIG),
         .O_MUX_HEX(O_MUX_HEX),
         .O_HEX(O_HEX),
         .O_FL(O_FL)
        );

//------------------------------------------------------    
    assign bcd_dst = dut.bcd_dst;
    assign strobe = dut.strobe;
    assign conv = dut.conv;
    assign dst = dut.dst;
    assign busy = dut.busy;
    
//------------------------------------------------------   
    initial begin
      CLK = 1;
      RST_n = 1;
      I_ECHO = 0;
      I_EN = 0;
      #1; RST_n = 0;
      #2; RST_n = 1;
      #1801032; I_ECHO = 1;
      #2200205; I_ECHO = 0;
      #5000000; I_ECHO = 1;
      #1100103; I_ECHO = 0;
    end

    always #1 CLK = ~CLK;

    initial begin
      // $dumpvars;
      #10200000 $finish;
    end 
    
    
endmodule