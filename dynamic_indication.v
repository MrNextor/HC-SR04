module dynamic_indication
    #(parameter BCD_DIGITS = 3,  // number of displayed BCD digits
      parameter BCD_LEN    = 12, // BCD code width
      parameter SSEG       = 7,  // seven seg width
      parameter NUM_LEN    = 4)  // number in BCD code (width)
    (CLK, RST_n, I_ST, I_BCD, I_BUSY,
     O_MUX_HEX, O_HEX);
   
   
//------------------------------------------------------- 
    localparam CNT_I_ST_SZ = $clog2(BCD_DIGITS); // counter cnt_i_st width
//  input signals   
    input wire               CLK;    // clock 50 MHz
    input wire               RST_n;  // asynchronous reset_n
    input wire               I_ST;   // impulse strobe onсe in 58.82 uS
    input wire [BCD_LEN-1:0] I_BCD;  // distance to object in BCD code
    input wire               I_BUSY; // busy converting binary to BCD
//  output signals    
     output reg [BCD_DIGITS-1:0] O_MUX_HEX; // multiplexer for determining the current seven-segment display
     output reg [SSEG-1:0]       O_HEX;     // current value seven-segment display   
//  internal signals 
    reg [CNT_I_ST_SZ-1:0]  cnt_i_st;    // counter pulse strobe
    wire [CNT_I_ST_SZ-1:0] nx_cnt_i_st; // next counter pulse strobe
    reg [BCD_DIGITS-1:0]   nx_mux_hex;  // next value multiplexer for determining the next seven-segment display
    reg [NUM_LEN-1:0]      nx_to_hex;   // next value for decoder
    wire [SSEG-1:0]        nx_o_hex;    // next value seven-segment display 
    reg [BCD_LEN-1:0]      bcd;         // distance to object in BCD code
    reg                    cr_i_busy;   // current I_BUSY
    reg                    pr_i_busy;   // previous I_BUSY
    wire                   ld_bcd;      // enable latching I_BCD
    wire                   en_di;       // enable dynamic indication
    wire [NUM_LEN-1:0]     no_signal;   // no dynamic indication


//------------------------------------------------------- 
    assign no_signal = {NUM_LEN{1'b1}};             // set the absence of a signal for the common cathode    
    assign ld_bcd = ~cr_i_busy & pr_i_busy;         // load I_BCD
    assign en_di = I_ST & (bcd != {BCD_LEN{1'b0}}); // enable dynamic indication
    assign nx_cnt_i_st = (cnt_i_st != BCD_DIGITS - 1'b1) ? cnt_i_st + 1'b1 : {CNT_I_ST_SZ{1'b0}};
    assign nx_o_hex = sseg(nx_to_hex);
    
//  determining next MUX and HEX signals     
    always @(*) begin
      begin
        case (cnt_i_st)
           2'b00   : begin 
                       nx_mux_hex = 3'b011;               
                       nx_to_hex = bcd[11:8]; 
                     end
           2'b01   : begin 
                       nx_mux_hex = 3'b101;
                       nx_to_hex = bcd[7:4];  
                     end
           2'b10   : begin 
                       nx_mux_hex = 3'b110;
                       nx_to_hex = bcd[3:0];  
                     end
           default : begin 
                       nx_mux_hex = {BCD_DIGITS{1'b1}}; 
                       nx_to_hex = no_signal; 
                     end
        endcase         
      end
    end    

//  latching the next state of signals, every clock       
    always @(posedge CLK or negedge RST_n) begin
      if (!RST_n)
        begin
          cr_i_busy <= 1'b0;
          pr_i_busy <= 1'b0;            
          cnt_i_st  <= {CNT_I_ST_SZ{1'b0}};
          O_MUX_HEX <= {BCD_DIGITS{1'b0}};
          O_HEX     <= {SSEG{1'b0}};
          bcd       <= {BCD_LEN{1'b0}};          
        end
      else 
        begin
//-------------------------------------------------------        
          cr_i_busy <= I_BUSY;
          pr_i_busy <= cr_i_busy;  
//-------------------------------------------------------          
          if (en_di)
            begin
              cnt_i_st  <= nx_cnt_i_st;
              O_MUX_HEX <= nx_mux_hex;
              O_HEX     <= nx_o_hex;
            end
//-------------------------------------------------------            
          if (ld_bcd)
            bcd <= I_BCD;  
        end
    end

//  seven segment indicator  decoder  
    function [SSEG-1:0] sseg (input [NUM_LEN-1:0] num);
      case (num)
         4'd0    : sseg = 7'b0111111;
         4'd1    : sseg = 7'b0000110;
         4'd2    : sseg = 7'b1011011;
         4'd3    : sseg = 7'b1001111;
         4'd4    : sseg = 7'b1100110;
         4'd5    : sseg = 7'b1101101;
         4'd6    : sseg = 7'b1111101;
         4'd7    : sseg = 7'b0000111;
         4'd8    : sseg = 7'b1111111;
         4'd9    : sseg = 7'b1101111;
         4'hF    : sseg = 7'b0000000;  // no signal for the common cathode
         default : sseg = 7'b0000000;
      endcase
    endfunction


endmodule