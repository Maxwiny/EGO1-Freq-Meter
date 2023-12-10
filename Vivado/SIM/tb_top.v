`timescale 1ns / 1ps

module tb_top();

reg	clk;
reg	rstn;

top u_top(
	.clk(clk),
	.rstn(rstn),
	.i_key(),
	.o_seg_pos(),
	.o_seg1(),
	.o_seg2()
);
//重定义软件闸门计数时间,缩短仿真时间
defparam u_top.u_freq_meter_calc.CNT_GATE_S_MAX    = 240   ;    //计时最长时间  240X20ns
defparam u_top.u_freq_meter_calc.CNT_RISE_MAX      = 40    ;    

initial clk = 1;
always#5 clk = ~clk;
initial begin
	rstn = 0;
	#201
	rstn = 1;
end
endmodule
