module clk_div                 // clk div 50 MHz to 17.001 KHz
    #(parameter CCL_SZ = 2941) // T = 58.82 uS
    (CLK, RST_n, 
     O_ST);
     
     
//-------------------------------------------------------
    localparam CNT_CCL_SZ = $clog2(CCL_SZ); // cycle counter width
//  input signals
    input wire CLK;   // clock 50 MHz
    input wire RST_n; // asynchronous reset_n
//  output signals
    output reg O_ST;  // impulse strobe onсe in 58.82 uS
//  internal signals
    reg [CNT_CCL_SZ-1:0] cnt_clk; // counter clk
    
    
//-------------------------------------------------------
    always @(posedge CLK or negedge RST_n) begin
      if (!RST_n)
        begin
          cnt_clk <= {CNT_CCL_SZ{1'b0}};
          O_ST    <= 1'b0;
        end
      else 
        begin
          if (cnt_clk == CCL_SZ - 1'b1)
            begin
              cnt_clk <= {CNT_CCL_SZ{1'b0}};
              O_ST    <= 1'b1;
            end
          else 
            begin
              cnt_clk <= cnt_clk + 1'b1;
              O_ST    <= 1'b0;
            end
        end
    end
    
    
endmodule