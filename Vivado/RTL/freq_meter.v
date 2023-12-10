`timescale  1ns/1ns
 
module  freq_meter_calc
(
    input   wire            sys_clk     ,   
    input   wire            sys_rst_n   ,   
    input   wire            clk_test    ,   //�����ʱ��
    output  reg     [33:0]  freq            //�����ʱ��Ƶ��
);
parameter   CNT_GATE_S_MAX  =   28'd74_999_999  ,   //���բ�ż������������ֵ  1.5s
            CNT_RISE_MAX    =   28'd12_499_999   ;   //���բ�����߼���ֵ,   1.25s
parameter   CLK_STAND_FREQ  =   28'd100_000_000 ;   //��׼ʱ��ʱ��Ƶ��,    100Mhz
 
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
 
//step1:����ԭ���������բ�š�ʵ��բ��
//cnt_gate_s:���բ�ż�����
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_gate_s  <=  28'd0;
    else    if(cnt_gate_s == CNT_GATE_S_MAX)
        cnt_gate_s  <=  28'd0;
    else
        cnt_gate_s  <=  cnt_gate_s + 1'b1;
		
//gate_s:���բ��
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_s  <=  1'b0;
    else    if((cnt_gate_s>= CNT_RISE_MAX)
                && (cnt_gate_s <= (CNT_GATE_S_MAX - CNT_RISE_MAX)))
        gate_s  <=  1'b1;
    else
        gate_s  <=  1'b0;
		
//gate_a:ʵ��բ��
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a  <=  1'b0;
    else
        gate_a  <=  gate_s;
		
//step2���õ������źŵ������� X
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_test  <=  1'b0;
    else
        gate_a_test  <=  gate_a;		
		
//gate_a_test:ʵ��բ�Ŵ�һ��(�����ʱ����)
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_test_reg <=  1'b0;
    else
        gate_a_test_reg <=  gate_a_test;	
		
//cnt_clk_test:�����ʱ�����ڼ�����,����ʵ��բ���´����ʱ����������  x++
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a_test == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a_test == 1'b1)
        cnt_clk_test    <=  cnt_clk_test + 1'b1;
		
//gate_a_flag_t:ʵ��բ���½���(�����ʱ����)
assign  gate_a_flag_t = ((gate_a_test_reg == 1'b1) && (gate_a_test == 1'b0))
                        ? 1'b1 : 1'b0;
						
//cnt_clk_test_reg:ʵ��բ���´����ʱ��������,  x
always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test_reg   <=  32'd0;
    else    if(gate_a_flag_t == 1'b1)
        cnt_clk_test_reg   <=  cnt_clk_test;	
 
//step3���õ���׼�źŵ������� y		

 
//gate_a_stand:ʵ��բ�Ŵ�һ��(��׼ʱ����)
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
		
//gate_a_flag_s:ʵ��բ���½���(��׼ʱ����)
assign  gate_a_flag_s = ((gate_a_stand_reg == 1'b1) && (gate_a_stand == 1'b0))
                        ? 1'b1 : 1'b0;
						
//cnt_clk_stand:��׼ʱ�����ڼ�����,����ʵ��բ���±�׼ʱ����������  y++
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a_stand == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a_stand == 1'b1)
        cnt_clk_stand   <=  cnt_clk_stand + 1'b1;
		
//cnt_clk_stand_reg:ʵ��բ���±�־ʱ��������
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand_reg   <=  32'd0;
    else    if(gate_a_flag_s == 1'b1)
        cnt_clk_stand_reg   <=  cnt_clk_stand;
		
//step4: ���ù�ʽ����Ƶ�ʼ���		
//calc_flag:�����ʱ��ʱ��Ƶ�ʼ����־�ź�
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag   <=  1'b0;
    else    if(cnt_gate_s == (CNT_GATE_S_MAX - 1'b1))
        calc_flag   <=  1'b1;
    else
        calc_flag   <=  1'b0;
		
//freq:�����ʱ���ź�ʱ��Ƶ��
always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq_reg    <=  64'd0;
    else    if(calc_flag == 1'b1)
        freq_reg    <=  (CLK_STAND_FREQ * cnt_clk_test_reg / cnt_clk_stand_reg );    //   (100MHZ*X)/Y 
 
 //calc_flag_reg:�����ʱ��Ƶ�������־�ź�
 always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag_reg <= 1'b0;
    else
        calc_flag_reg <= calc_flag;
 
 //freq:�����ʱ���ź�ʱ��Ƶ��
 always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq <= 34'd0;
    else if(calc_flag_reg == 1'b1)
        freq <= freq_reg[33:0];	  
 
endmodule