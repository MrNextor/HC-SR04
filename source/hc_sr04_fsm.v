module hc_sr04_fsm
    #(parameter MAX_RANGE  = 400,           // maximum measuring range
      parameter DST_SZ = $clog2(MAX_RANGE)) // distance width
    (CLK, RST_n, I_EN, I_ST, I_ECHO, 
     O_DST, O_CONV, O_TRIG, O_FL);
    
    
//-------------------------------------------------------    
    localparam CCL_TIME    = 1020;              // 60 mS measurement cycle (T = 58.82 uS * 1020)
    localparam CNT_CCL_TIME = $clog2(CCL_TIME); // cycle time counter width
//  description states FSM      
    localparam ST_SZ      = 6;         // number of states FSM
    localparam IDLE       = 6'b000001; // waiting I_EN 
    localparam TRIG       = 6'b000010; // trigger to HC-SR04
    localparam WT_ECHO    = 6'b000100; // waiting echo from HC-SR04  
    localparam CNT_ECHO   = 6'b001000; // time count when echo is high level
    localparam CONV       = 6'b010000; // convert binary code to bsd
    localparam WT_END_CCL = 6'b100000; // waiting for the end of the measurement cycle
//  input signals
    input wire CLK;    // clock 50 MHz
    input wire RST_n;  // asynchronous reset_n
    input wire I_EN;   // enable measurement distance
    input wire I_ST;   // impulse strobe onсe in 58.82 uS
    input wire I_ECHO; // input lever signal and the range in proportion
//  output signals
    output reg [DST_SZ-1:0] O_DST;  // distance to object in binary code
    output reg              O_CONV; // signal start converting binary to BCD
    output reg              O_TRIG; // trigger signal to start measurement HC-SR04
    output reg              O_FL;   // measurement flag 
//  internal signals    
    reg [ST_SZ-1:0]        st;          // current state FSM
    reg [ST_SZ-1:0]        nx_st;       // next state of FSM   
    reg [CNT_CCL_TIME-1:0] cnt_i_st;    // counter pulse strobe 
    reg [CNT_CCL_TIME-1:0] nx_cnt_i_st; // next counter pulse strobe
    reg                    echo_d0;     // signal0 I_ECHO from HC-SR04
    reg                    echo_sync;   // synchronized signal I_ECHO
    reg [DST_SZ-1:0]       cnt_echo;    // counter signal echo_sync
    reg [DST_SZ-1:0]       nx_cnt_echo; // next counter signal echo_sync
    reg                    nx_o_trig;   // next trigger signal to start measurement HC-SR04 
    reg [DST_SZ-1:0]       nx_o_dst;    // next distance to object in binary code
    reg                    nx_o_conv;   // next signal start converting binary to BCD
    reg                    nx_o_fl;     // next measurement flag 


//  determining the next state of FSM and singals   
    always @(*) begin
      nx_st = st;
      nx_cnt_i_st = cnt_i_st;
      nx_o_trig = O_TRIG;
      nx_cnt_echo = cnt_echo;
      nx_o_conv = O_CONV;
      nx_o_dst = O_DST;
      nx_o_fl = O_FL;
      if (I_ST)
        begin
          case (st)
             IDLE       : begin
                            if (I_EN)
                              begin
                                nx_o_trig = 1'b1;
                                nx_o_fl = 1'b1;
                                nx_st = TRIG;
                              end
                          end
             TRIG       : begin
                            nx_cnt_i_st = cnt_i_st + 1'b1;
                            nx_o_trig = 1'b0;
                            nx_st = WT_ECHO;    
                          end
             WT_ECHO    : begin
                            nx_cnt_i_st = cnt_i_st + 1'b1;
                            if (echo_sync) 
                              nx_st = CNT_ECHO;
                          end
             CNT_ECHO   : begin 
                            nx_cnt_i_st = cnt_i_st + 1'b1;
                            nx_cnt_echo = cnt_echo + 1'b1;
                            if (!echo_sync)
                              begin
                                nx_cnt_echo = {DST_SZ{1'b0}};
                                nx_o_conv = 1'b1;
                                nx_o_dst = cnt_echo + 1'b1;
                                nx_st = CONV;
                              end
                          end
             CONV       : begin
                            nx_cnt_i_st = cnt_i_st + 1'b1;
                            nx_o_conv = 1'b0;
                            nx_st = WT_END_CCL;
                          end
             WT_END_CCL : begin
                            nx_cnt_i_st = cnt_i_st + 1'b1;
                            if (cnt_i_st == CCL_TIME - 1'b1) 
                              begin 
                                nx_cnt_i_st = {CNT_CCL_TIME{1'b0}};
                                nx_o_fl = 1'b0;
                                nx_st = IDLE; 
                              end
                          end
             default    : begin
                            nx_st = IDLE; 
                            nx_cnt_i_st = {CNT_CCL_TIME{1'b0}};
                            nx_o_trig = 1'b0;
                            nx_cnt_echo = {DST_SZ{1'b0}};
                            nx_o_conv = 1'b0;
                            nx_o_dst = {DST_SZ{1'b0}};
                            nx_o_fl = 1'b0;
                          end       
          endcase
        end
    end
    
//  latching the next state of FSM and signals, every clock   
    always @(posedge CLK or negedge RST_n) begin
      if (!RST_n)
        begin
          st        <= IDLE;
          cnt_i_st  <= {CNT_CCL_TIME{1'b0}};
          O_TRIG    <= 1'b0;
          cnt_echo  <= {DST_SZ{1'b0}};
          O_CONV    <= 1'b0;
          O_DST     <= {DST_SZ{1'b0}};
          echo_d0   <= 1'b0;
          echo_sync <= 1'b0;
          O_FL      <= 1'b0;
        end
      else
        begin
          st        <= nx_st;
          cnt_i_st  <= nx_cnt_i_st;
          O_TRIG    <= nx_o_trig;
          cnt_echo  <= nx_cnt_echo;
          O_CONV    <= nx_o_conv;
          O_DST     <= nx_o_dst;
          O_FL      <= nx_o_fl;
//-------------------------------------------------------  
          if (I_ST)
            begin
              echo_d0   <= I_ECHO;
              echo_sync <= echo_d0;
            end
        end
    end


endmodule