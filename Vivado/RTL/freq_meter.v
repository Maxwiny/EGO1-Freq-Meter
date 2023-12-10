`timescale  1ns/1ns
 
module  freq_meter_calc
(
    input   wire            sys_clk     ,   
    input   wire            sys_rst_n   ,   
    input   wire            clk_test    ,   //待检测时钟
    output  reg     [33:0]  freq            //待检测时钟频率
);
parameter   CNT_GATE_S_MAX  =   28'd74_999_999  ,   //软件闸门计数器计数最大值  1.5s
            CNT_RISE_MAX    =   28'd12_499_999   ;   //软件闸门拉高计数值,   1.25s
parameter   CLK_STAND_FREQ  =   28'd100_000_000 ;   //标准时钟时钟频率,    100Mhz
 
wire            gate_a_flag_s       ;   
wire            gate_a_flag_t       ;   
 
reg     [27:0]  cnt_gate_s          ;   
reg             gate_s              ;   
reg             gate_a              ;   
reg             gate_a_test         ;   
reg             gate_a_stand        ;   
reg             gate_a_stand_reg    ;
reg             gate_a_test_reg     ;   
reg     [47:0]  cnt_clk_stand       ;   
reg     [47:0]  cnt_clk_stand_reg   ;   
reg     [47:0]  cnt_clk_test        ;   
reg     [47:0]  cnt_clk_test_reg    ;   
reg             calc_flag           ;   
reg     [63:0]  freq_reg            ;
reg             calc_flag_reg       ;
 
//step1:按照原理生成软件闸门、实际闸门
//cnt_gate_s:软件闸门计数器
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_gate_s  <=  28'd0;
    else    if(cnt_gate_s == CNT_GATE_S_MAX)
        cnt_gate_s  <=  28'd0;
    else
        cnt_gate_s  <=  cnt_gate_s + 1'b1;
		
//gate_s:软件闸门
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_s  <=  1'b0;
    else    if((cnt_gate_s>= CNT_RISE_MAX)
                && (cnt_gate_s <= (CNT_GATE_S_MAX - CNT_RISE_MAX)))
        gate_s  <=  1'b1;
    else
        gate_s  <=  1'b0;
		
//gate_a:实际闸门
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a  <=  1'b0;
    else
        gate_a  <=  gate_s;
		
//step2：得到待测信号的周期数 X
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_test  <=  1'b0;
    else
        gate_a_test  <=  gate_a;		
		
//gate_a_test:实际闸门打一拍(待检测时钟下)
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_test_reg <=  1'b0;
    else
        gate_a_test_reg <=  gate_a_test;	
		
//cnt_clk_test:待检测时钟周期计数器,计数实际闸门下待检测时钟周期数。  x++
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a_test == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a_test == 1'b1)
        cnt_clk_test    <=  cnt_clk_test + 1'b1;
		
//gate_a_flag_t:实际闸门下降沿(待检测时钟下)
assign  gate_a_flag_t = ((gate_a_test_reg == 1'b1) && (gate_a_test == 1'b0))
                        ? 1'b1 : 1'b0;
						
//cnt_clk_test_reg:实际闸门下待检测时钟周期数,  x
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test_reg   <=  32'd0;
    else    if(gate_a_flag_t == 1'b1)
        cnt_clk_test_reg   <=  cnt_clk_test;	
 
//step3：得到标准信号的周期数 y		

 
//gate_a_stand:实际闸门打一拍(标准时钟下)
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_stand    <=  1'b0;
    else
        gate_a_stand    <=  gate_a_test;
		
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_stand_reg    <=  1'b0;
    else
        gate_a_stand_reg    <=  gate_a_stand;
		
//gate_a_flag_s:实际闸门下降沿(标准时钟下)
assign  gate_a_flag_s = ((gate_a_stand_reg == 1'b1) && (gate_a_stand == 1'b0))
                        ? 1'b1 : 1'b0;
						
//cnt_clk_stand:标准时钟周期计数器,计数实际闸门下标准时钟周期数。  y++
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a_stand == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a_stand == 1'b1)
        cnt_clk_stand   <=  cnt_clk_stand + 1'b1;
		
//cnt_clk_stand_reg:实际闸门下标志时钟周期数
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand_reg   <=  32'd0;
    else    if(gate_a_flag_s == 1'b1)
        cnt_clk_stand_reg   <=  cnt_clk_stand;
		
//step4: 利用公式进行频率计算		
//calc_flag:待检测时钟时钟频率计算标志信号
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag   <=  1'b0;
    else    if(cnt_gate_s == (CNT_GATE_S_MAX - 1'b1))
        calc_flag   <=  1'b1;
    else
        calc_flag   <=  1'b0;
		
//freq:待检测时钟信号时钟频率
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq_reg    <=  64'd0;
    else    if(calc_flag == 1'b1)
        freq_reg    <=  (CLK_STAND_FREQ * cnt_clk_test_reg / cnt_clk_stand_reg );    //   (100MHZ*X)/Y 
 
 //calc_flag_reg:待检测时钟频率输出标志信号
 always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag_reg <= 1'b0;
    else
        calc_flag_reg <= calc_flag;
 
 //freq:待检测时钟信号时钟频率
 always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq <= 34'd0;
    else if(calc_flag_reg == 1'b1)
        freq <= freq_reg[33:0];	  
 
endmodule