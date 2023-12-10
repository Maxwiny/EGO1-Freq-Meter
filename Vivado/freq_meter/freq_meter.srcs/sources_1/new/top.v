`timescale 1ns / 1ps

module top(
	input	wire	clk,
	input	wire	rstn,
	input	wire	[4:0]	i_key,
	input	wire	i_sw,
	
	output	wire	[7:0]	o_seg_pos,
	output	wire	[7:0]	o_seg1,
	output	wire	[7:0]	o_seg2,
	output	wire	o_led
);

reg	[27:0]	r_freq_num;	//set freq
reg	r_num_add_flag;
reg	r_num_sub_flag;
reg	[2:0]	r_step_mode;
reg	r_mode;
reg	[23:0]	r_step_value;
reg	r_bin2bcd_en;
wire	o_div_clk;	//squ out
wire	w_key_val;
wire	[4:0]	w_key;

/* bin2bcd */
reg	[31:0]	r_bcd;

wire	w_bcd_tran_fin;
wire	[3:0]	bcd0;
wire	[3:0]	bcd1;
wire	[3:0]	bcd2;
wire	[3:0]	bcd3;
wire	[3:0]	bcd4;
wire	[3:0]	bcd5;
wire	[3:0]	bcd6;
wire	[3:0]	bcd7;

/*seg*/
wire	[7:0]	w_seg;
assign o_seg1 = w_seg;
assign o_seg2 = w_seg;

/*bcd_sw*/
reg	[27:0]	r_bcd_in;
wire	[33:0]	w_freq;	//now freq

assign o_led = r_mode;
/*bcd_sw*/
always@(posedge clk or negedge rstn)
	if(rstn == 0) r_bcd_in <= #1 0;
	else if(r_mode == 0) r_bcd_in <= #1 r_freq_num;
	else if(r_mode == 1) r_bcd_in <= #1 w_freq[27:0];
	
reg	[27:0]	r_sec_cnt;
always@(posedge clk or negedge rstn)
	if(rstn == 0) r_sec_cnt <= #1 0;
	else if(r_sec_cnt == 'd100_000_000 - 1) r_sec_cnt <= #1 0;
	else  r_sec_cnt <= #1 r_sec_cnt + 'd1;
	
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		 r_freq_num <= #1 'd500_0000;
		 r_bin2bcd_en <= #1 0;
	end
	else if(r_num_add_flag == 1)begin
		r_freq_num <= #1 r_freq_num + r_step_value;
		r_bin2bcd_en <= #1 1;
	end
	else if(r_num_sub_flag == 1)begin
		r_freq_num <= #1 r_freq_num - r_step_value;
		r_bin2bcd_en <= #1 1;
	end
	else if(r_sec_cnt == 'd100_000_000 - 1)begin
		r_bin2bcd_en <= #1 1;
	end
	else	r_bin2bcd_en <= #1 0;



always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_num_add_flag <= #1 0;
		r_num_sub_flag <= #1 0;
		r_step_mode<= #1 0;
		r_mode <= #1 0;
	end
	else if(w_key_val)
		case(w_key)
			'b00001: r_num_sub_flag <= #1 1;	//s0
			'b00010: r_step_mode <= #1 r_step_mode - 'd1;	//s1
			'b00100: r_mode <= !r_mode;	//s2
			'b01000: r_num_add_flag <= #1 1;	//s3
			'b10000: r_step_mode <= #1 r_step_mode + 'd1;	//s4
		endcase	
	else begin
		r_num_add_flag <= #1 0;
		r_num_sub_flag <= #1 0;
	end

always@(*)
	case(r_step_mode)
		'd0: r_step_value = 'd1;
		'd1: r_step_value = 'd10;
		'd2: r_step_value = 'd100;
		'd3: r_step_value = 'd1000;
		'd4: r_step_value = 'd10000;
		'd5: r_step_value = 'd100000;
		'd6: r_step_value = 'd1000000;
		'd7: r_step_value = 'd10000000;
		default: r_step_value = 'd1;
	endcase

always@(posedge	clk or negedge rstn)
	if(rstn == 0) r_bcd <= #1 0;
	else if(w_bcd_tran_fin == 1) r_bcd <= #1 {bcd7,bcd6,bcd5,bcd4,bcd3,bcd2,bcd1,bcd0};
	
div_clk u_div_clk(
	.clk(clk),
	.rstn(i_sw),
	.i_freq_num(r_freq_num),
	.i_sw(1),
	.o_div_clk(o_div_clk)
);

key u_key(
	.clk(clk),
	.rstn(rstn),
	.i_key(i_key),
	.o_key_val(w_key_val),
	.o_key(w_key)
);

bin2bcd32 u_bin2bcd32(
	.CLK(clk),
	.RST(rstn),
	.en(r_bin2bcd_en),
	.bin(r_bcd_in),
	.bcd0(bcd0),
	.bcd1(bcd1),
	.bcd2(bcd2),
	.bcd3(bcd3),
	.bcd4(bcd4),
	.bcd5(bcd5),
	.bcd6(bcd6),
	.bcd7(bcd7),
	.bcd8(),
	.bcd9(),
 	.busy(),
 	.fin(w_bcd_tran_fin)
);

seg_drive_8bit seg_isnt(
	.clk		(clk),
	.rstn		(rstn),
	.i_data		(r_bcd),
	.o_seg_pos	(o_seg_pos),
	.o_seg		(w_seg),
	.i_sw_state(r_step_mode)
);   
freq_meter_calc u_freq_meter_calc
(
    .sys_clk(clk),   
    .sys_rst_n(rstn),   
    .clk_test(o_div_clk),   //´ý¼ì²âÊ±ÖÓ
    .freq(w_freq)            //´ý¼ì²âÊ±ÖÓÆµÂÊ
);

ila_0 u_ila (
	.clk(clk), // input wire clk

	.probe0(r_freq_num), // input wire [27:0]  probe0  
	.probe1(w_freq[27:0]), // input wire [27:0]  probe1 
	.probe2(o_div_clk) // input wire [0:0]  probe2
);
endmodule
