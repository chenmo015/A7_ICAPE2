`timescale 1ns/100ps

module uart_byte_tx(
	clk,
	rst_n,
  
	data_byte,
	send_en,     
	
	uart_tx,  
	tx_done,   
	uart_state 
);

	input clk ;                     //模块全局时钟输入，50M
	input rst_n;                    //复位信号输入，低有效
	input [7:0]data_byte;           //待传输8bit数据
	input send_en;                  //发送使能
	
	output reg uart_tx;             //串口输出信号
	output reg tx_done;             //1byte数据发送完成标志
	output reg uart_state;          //发送数据状态
	
	localparam START_BIT = 1'b0;    //起始信号0
	localparam STOP_BIT = 1'b1;     //截止信号1
	
	reg bps_clk;	                //波特率时钟	
	reg [15:0]div_cnt;              //分频计数器，0~bps_DR	
	
    parameter bps_DR = 5207;

	reg [3:0]bps_cnt;               //波特率时钟计数器	
	reg [7:0]data_byte_reg;         //data_byte寄存后数据
	
    //标志信号uart_state
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            uart_state <= 1'b0;
        else if(send_en)
            uart_state <= 1'b1;
        else if(bps_cnt == 4'd11)
            uart_state <= 1'b0;
        else
            uart_state <= uart_state;
	end
    
    //发送信号有效后，对输入的数据信号进行备份，存起来
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_byte_reg <= 8'd0;
        else if(send_en)
            data_byte_reg <= data_byte;
        else
            data_byte_reg <= data_byte_reg;
    end

	//div_cnt计数器，0~5207计数，计数满代表发送了1位数据
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            div_cnt <= 16'd0;
        else if(uart_state)begin
            if(div_cnt == bps_DR)
                div_cnt <= 16'd0;
            else
                div_cnt <= div_cnt + 1'b1;
        end
        else
            div_cnt <= 16'd0;
	end
    
	//脉冲信号bps_clk，div_cnt=1时产生1个脉冲，用来对发送的数据进行计数，1个脉冲代表发送了1位数据
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            bps_clk <= 1'b0;
        else if(div_cnt == 16'd1)
            bps_clk <= 1'b1;
        else
            bps_clk <= 1'b0;
	end
    
	//数据位数计数器bps_cnt，0~10计数，代表发送了几位数据
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)	
            bps_cnt <= 4'd0;
        else if(bps_cnt == 4'd11)
            bps_cnt <= 4'd0;
        else if(bps_clk)
            bps_cnt <= bps_cnt + 1'b1;
        else
            bps_cnt <= bps_cnt;
	end
    
    //标志信号，发送完成1帧产生1个脉冲
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            tx_done <= 1'b0;
        else if(bps_cnt == 4'd11)
            tx_done <= 1'b1;
        else
            tx_done <= 1'b0;
	end
    
    //发送数据
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            uart_tx <= 1'b1;
        else begin
            case(bps_cnt)
                0:uart_tx <= 1'b1;
                1:uart_tx <= START_BIT;
                2:uart_tx <= data_byte_reg[0];
                3:uart_tx <= data_byte_reg[1];
                4:uart_tx <= data_byte_reg[2];
                5:uart_tx <= data_byte_reg[3];
                6:uart_tx <= data_byte_reg[4];
                7:uart_tx <= data_byte_reg[5];
                8:uart_tx <= data_byte_reg[6];
                9:uart_tx <= data_byte_reg[7];
                10:uart_tx <= STOP_BIT;
                default:uart_tx <= 1'b1;
            endcase
        end	
    end

endmodule
