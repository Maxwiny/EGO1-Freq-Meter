`timescale 1ns / 1ns

module seg_drive_8bit#(
	parameter	p_system_clk = 'd100_000_000
)(
	input	wire	clk,
	input	wire	rstn,
	input	wire	[31:0]	i_data,
	input	wire	[2:0]	i_sw_state,
	output	wire	[7:0]	o_seg_pos,
	output	wire	[7:0]	o_seg
);

localparam	p_seg_max = p_system_clk / 1000; 

reg	[19:0]	r_seg_pos_cnt;
reg	[7:0]	r_seg_pos;
reg	[3:0]	r_data;
reg	r_clear;
reg	[7:0]	r_seg;

assign	o_seg_pos = r_seg_pos;
assign	o_seg = o_seg_pos[i_sw_state] == 'b1 ? (r_seg | 'h80) : r_seg;

/* counter */
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		r_seg_pos_cnt <= #1 0;
	else if(r_seg_pos_cnt == p_seg_max)
		r_seg_pos_cnt <= #1 0;
	else
		r_seg_pos_cnt <= #1 r_seg_pos_cnt + 1;
	
/* pos control */	
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		r_seg_pos <= #1 'b00000001;
	else if(r_seg_pos_cnt == p_seg_max - 'd1)
		r_seg_pos <= #1 {r_seg_pos[6:0], r_seg_pos[7]};
	else
		r_seg_pos <= #1 r_seg_pos;
				
/* seg control*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_data <= #1 10;
		r_clear <= #1 0;
	end
	else if(r_seg_pos_cnt == p_seg_max - 3'd4)begin
		r_clear <= #1 1;
		r_data <= #1 10;
	end
	else if(r_seg_pos_cnt == p_seg_max)
		r_clear <= #1 0;
	else if(r_clear == 0)
		case(r_seg_pos)
			'b00000001: r_data <= #1 i_data[3:0];
			'b00000010: r_data <= #1 i_data[7:4];
			'b00000100: r_data <= #1 i_data[11:8];
			'b00001000: r_data <= #1 i_data[15:12];
			'b00010000: r_data <= #1 i_data[19:16];
			'b00100000: r_data <= #1 i_data[23:20];
			'b01000000: r_data <= #1 i_data[27:24];
			'b10000000: r_data <= #1 i_data[31:28];
			default: r_data <= #1 r_data; 
		endcase
	else
		r_data <= #1 r_data; 

always@(posedge clk or negedge rstn)
	if(rstn == 0)
		r_seg <= 'h00;
	else	case(r_data)
			10: r_seg <= #1 'h00;
			0: r_seg <= #1 'h3f;
			1: r_seg <= #1 'h06;
			2: r_seg <= #1 'h5b;
			3: r_seg <= #1 'h4f;
			4: r_seg <= #1 'h66;
			5: r_seg <= #1 'h6d;
			6: r_seg <= #1 'h7d;
			7: r_seg <= #1 'h07;
			8: r_seg <= #1 'h7f;
			9: r_seg <= #1 'h6f;
		endcase
endmodule
