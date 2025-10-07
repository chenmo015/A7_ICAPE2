//////////////////////////////////////////////////////////////////////////////////
// Company: �人о·��Ƽ����޹�˾
// Engineer: С÷���Ŷ�
// Web: www.corecourse.cn
// 
// Create Date: 2020/07/20 00:00:00
// Design Name: hex8
// Module Name: hex_top
// Project Name: hex8
// Target Devices: XC7A35T-2FGG484I
// Tool Versions: Vivado 2018.3
// Description: hex8��Ŀ�Ķ����ļ���Э��VIO��hex8��hc595�Ĺ����ͽӿ�
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module hex_top(
	clk,
	reset_n,
	sh_cp,
	st_cp,
	ds
);

	input clk;	//50M
	input reset_n;
	
	output sh_cp;
	output st_cp;
	output ds;
	
	wire [31:0]disp_data;
	wire [7:0] sel;//�����λѡ��ѡ��ǰҪ��ʾ������ܣ�
	wire [6:0] seg;//����ܶ�ѡ����ǰҪ��ʾ������)
/*	
	vio_0 vio_0 (
		.clk(clk), 
		.probe_out0(disp_data)  
	);
*/	
	hc595_driver hc595_driver(
		.clk(clk),
		.reset_n(reset_n),
		.data({1'd1,seg,sel}),
		.s_en(1'b1),
		.sh_cp(sh_cp),
		.st_cp(st_cp),
		.ds(ds)
	);
	
	hex8 hex8(
		.clk(clk),
		.reset_n(reset_n),
		.en(1'b1),
//		.disp_data(disp_data),
		.sel(sel),
		.seg(seg)
	);
	
endmodule
