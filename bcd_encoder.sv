`timescale 1ns/100ps
/*
 * Convert binary to BCD with "Double dabble" algorithm
 * 2019 - np@rnd.stcnet.ru
 */
module bcd_encoder 
    #(parameter BINARY_LEN = 9,            // binary code widht
      parameter BCD_DIGITS = 3,            // number of displayed BCD digits
      parameter BCD_LEN  = BCD_DIGITS * 4) // BCD code widht
    (CLK, RST_n, I_CONV, I_BIN,
     O_BUSY, O_BCD);
    
    
//-------------------------------------------------------
    localparam SCRATCH_LEN = BINARY_LEN + BCD_LEN; // BCD + BINARY
//  input signals    
    input wire                  CLK;    // clock 50 MHz
    input wire                  RST_n;  // asynchronous reset_n
    input wire                  I_CONV; // signal start converting binary to BCD
    input wire [BINARY_LEN-1:0] I_BIN;  // distance to object in binary code
//  output signals
    output wire               O_BUSY; // busy converting binary to BCD 
    output wire [BCD_LEN-1:0] O_BCD;  // distance to object in BCD code
//  internal signals
    logic [$clog2(BINARY_LEN)-1:0] scnt;    // binary conversion counter width
    logic [SCRATCH_LEN-1:0]        scratch; // widht BCD + BINARY
    logic [BCD_LEN-1:0]            bcd;
    logic [BCD_LEN-1:0]            bcd_carry; 
    logic                          running;
    logic                          cr_i_conv;
    logic                          pr_i_conv;
    logic                          rs_i_conv;


//-------------------------------------------------------
    assign bcd = scratch[SCRATCH_LEN-1:SCRATCH_LEN-BCD_LEN];
    assign rs_i_conv = cr_i_conv & !pr_i_conv;

//-------------------------------------------------------
    genvar i;
    generate
        for (i = 0; i < BCD_DIGITS; i ++)
          begin : bcd_carry_adders
              assign bcd_carry[i*4+3:i*4] = bcd[i*4+3:i*4] + ((bcd[i*4+3:i*4] < 5) ? 0 : 3);
          end
    endgenerate

//-------------------------------------------------------
    always_ff @(posedge CLK or negedge RST_n)
      if (!RST_n) begin
        scratch <= '0;
        scnt <= '0;
        running <= '0;
        cr_i_conv <= '0;
        pr_i_conv <= '0;
      end
      else begin
//-------------------------------------------------------
        cr_i_conv <= I_CONV;
        pr_i_conv <= cr_i_conv;
//-------------------------------------------------------        
        if (running) begin
            if (scnt == '0) begin
                running <= '0;
            end
            else begin
                scratch <= {bcd_carry[BCD_LEN-2:0], scratch[BINARY_LEN-1:0], 1'b0};
                scnt <= scnt - 1'b1;
            end
        end
        else begin
            if (rs_i_conv) begin
                scratch[BINARY_LEN-1:0] <= I_BIN;
                scratch[SCRATCH_LEN-1:SCRATCH_LEN-BCD_LEN] <= '0;
                scnt <= BINARY_LEN;
                running <= '1;
            end
        end             
      end
        
//-------------------------------------------------------
    assign O_BUSY = running;
    assign O_BCD = bcd;


endmodule