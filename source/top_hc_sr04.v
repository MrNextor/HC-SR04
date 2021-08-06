module top_hc_sr04
    #(parameter BCD_DIGITS = 3, // number of displayed BCD digits
      parameter SSEG       = 7) // width seven seg
    (CLK, RST_n, I_EN, I_ECHO,
     O_TRIG, O_MUX_HEX, O_HEX, O_FL);
     
     
//------------------------------------------------------      
    localparam MAX_RANGE = 400;                  // maximum measuring range
    localparam CCL_SZ    = 2941;                 // T = 58.82 uS
    localparam DST_SZ    = $clog2(MAX_RANGE);    // distance width in binary code
    localparam NUM_LEN   = 4;                    // number in BCD code (width)
    localparam BCD_LEN   = BCD_DIGITS * NUM_LEN; // BCD code width      
//  input signals
    input wire CLK;    // clock 50 MHz
    input wire RST_n;  // asynchronous reset_n
    input wire I_EN;   // enable measurement distance
    input wire I_ECHO; // input  lever signal and the range in proportion  
//  output signals    
    output wire                  O_TRIG;    // trigger signal to start measurement HC-SR04
    output wire [BCD_DIGITS-1:0] O_MUX_HEX; // multiplexer for determining the current seven-segment display
    output wire [SSEG-1:0]       O_HEX;     // current value seven-segment display 
    output wire                  O_FL;      // measurement flag 
//  internal signals 
    wire               en;      // enable (avtive low signal)
    wire               strobe;  // impulse strobe onсe in 58.82 uS
    wire               conv;    // signal start converting binary to BCD
    wire [DST_SZ-1:0]  dst;     // distance to object in binary code
    wire               busy;    // busy converting binary to BCD
    wire [BCD_LEN-1:0] bcd_dst; // distance to object in BCD code


//------------------------------------------------------
    assign en = ~I_EN;

//------------------------------------------------------
    clk_div 
        #(
         .CCL_SZ(CCL_SZ)
        )
    clk_div 
        (
         .CLK(CLK),
         .RST_n(RST_n),
         .O_ST(strobe)
        );
    
//------------------------------------------------------    
    hc_sr04_fsm 
        #(
         .MAX_RANGE(MAX_RANGE),
         .DST_SZ(DST_SZ)
        )
    hc_sr04_fsm
        (
         .CLK(CLK),
         .RST_n(RST_n),
         .I_EN(en),
         .I_ST(strobe),
         .I_ECHO(I_ECHO),
         .O_DST(dst),
         .O_CONV(conv),
         .O_TRIG(O_TRIG),
         .O_FL(O_FL)
        );

//------------------------------------------------------     
    bcd_encoder 
        #(
         .BINARY_LEN(DST_SZ),
         .BCD_DIGITS(BCD_DIGITS),
         .BCD_LEN(BCD_LEN)
        )
    bcd_encoder 
        (   
         .CLK(CLK),
         .RST_n(RST_n),
         .I_CONV(conv),
         .I_BIN(dst),
         .O_BUSY(busy),
         .O_BCD(bcd_dst)
        );  

//------------------------------------------------------     
    dynamic_indication 
        #(
         .BCD_DIGITS(BCD_DIGITS),
         .BCD_LEN(BCD_LEN),
         .SSEG(SSEG),
         .NUM_LEN(NUM_LEN)
        )
    dynamic_indication
        (
         .CLK(CLK),
         .RST_n(RST_n),
         .I_ST(strobe),
         .I_BCD(bcd_dst),
         .I_BUSY(busy),
         .O_MUX_HEX(O_MUX_HEX),
         .O_HEX(O_HEX)    
        );
    
    
endmodule 