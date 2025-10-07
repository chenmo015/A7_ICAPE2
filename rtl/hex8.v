//////////////////////////////////////////////////////////////////////////////////
// Company: �人о·��Ƽ����޹�˾
// Engineer: С÷���Ŷ�
// Web: www.corecourse.cn
// 
// Create Date: 2020/07/20 00:00:00
// Design Name: hex8
// Module Name: hex8
// Project Name: hex8
// Target Devices: XC7A35T-2FGG484I
// Tool Versions: Vivado 2018.3
// Description: ��Ƶ�źţ���ѡ��λѡ�ź����ɣ������Ҫ��ʾ�����ݡ���ѡ��λѡֵ
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module hex8(
	clk,
	reset_n,
	en,
	//disp_data,
	sel,
	seg
);
	wire reset=~reset_n;
	input clk;	//50M
	input reset_n;
	input en;	//�������ʾʹ�ܣ�1ʹ�ܣ�0�ر�
	
	reg [31:0]disp_data;
	
	always@(posedge clk or negedge reset_n) begin
	   if(!reset_n)
	       disp_data <= 32'h01234567;
	   else
	       disp_data <= 32'h01234567;
	end
	
	output [7:0] sel;//�����λѡ��ѡ��ǰҪ��ʾ������ܣ�
	output reg [6:0] seg;//����ܶ�ѡ����ǰҪ��ʾ�����ݣ�
	
	reg [14:0]divider_cnt;//25000-1
	
	reg clk_1K;
	reg [7:0]sel_r;
	
	reg [3:0]data_tmp;//���ݻ���

//	��Ƶ����������ģ��
	always@(posedge clk or posedge reset)
	if(reset)
		divider_cnt <= 15'd0;
	else if(!en)
		divider_cnt <= 15'd0;
	else if(divider_cnt == 24999)
		divider_cnt <= 15'd0;
	else
		divider_cnt <= divider_cnt + 1'b1;

//1Kɨ��ʱ������ģ��		
	always@(posedge clk or posedge reset)
	if(reset)
		clk_1K <= 1'b0;
	else if(divider_cnt == 24999)
		clk_1K <= ~clk_1K;
	else
		clk_1K <= clk_1K;
		
//8λѭ����λ�Ĵ���
	always@(posedge clk_1K or posedge reset)
	if(reset)
		sel_r <= 8'b0000_0001;
	else if(sel_r == 8'b1000_0000)
		sel_r <= 8'b0000_0001;
	else
		sel_r <=  sel_r << 1;
		
	always@(*)
		case(sel_r)
			8'b0000_0001:data_tmp = disp_data[3:0];
			8'b0000_0010:data_tmp = disp_data[7:4];
			8'b0000_0100:data_tmp = disp_data[11:8];
			8'b0000_1000:data_tmp = disp_data[15:12];
			8'b0001_0000:data_tmp = disp_data[19:16];
			8'b0010_0000:data_tmp = disp_data[23:20];
			8'b0100_0000:data_tmp = disp_data[27:24];
			8'b1000_0000:data_tmp = disp_data[31:28];
			default:data_tmp = 4'b0000;
		endcase
		
	always@(*)
		case(data_tmp)
			4'h0:seg = 7'b1000111;
			4'h1:seg = 7'b1000000;
			4'h2:seg = 7'b1000001;
			4'h3:seg = 7'b0000110;
			4'h4:seg = 7'b1111111;
			4'h5:seg = 7'b0010001;
			4'h6:seg = 7'b1000000;
			4'h7:seg = 7'b1000001;
			4'h8:seg = 7'b0000000;
			4'h9:seg = 7'b0010000;
			4'ha:seg = 7'b0001000;
			4'hb:seg = 7'b0000011;
			4'hc:seg = 7'b1000110;
			4'hd:seg = 7'b0100001;
			4'he:seg = 7'b0000110;
			4'hf:seg = 7'b0001110;
		endcase
		
	assign sel = (en)?sel_r:8'b0000_0000;

endmodule
