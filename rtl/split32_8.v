module split32_8(
    clk,
    rst_n,
    data_in,
    data_in_ready,
    data_out,
    data_out_ready,
    tx_done,
    flag    
);
    input clk;
    input rst_n;
    input [31:0]data_in;
    input data_in_ready;
    output reg [7:0]data_out;
    output reg data_out_ready;
    input tx_done;
    output reg flag;                        //给到write_reg，脉冲信号，1代表发送完成1个数据，可以发送下一个，共101个

    //定义寄存器data，对输入的32位数据进行寄存，打1拍
    reg [31:0]data;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data = 0;
        else if(data_in_ready)
            data = data_in;
    end

    //定义1个计数器cnt，每拆出来1个8位数据加1，0~4
    reg [2:0]cnt;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt = 0;
        else if(tx_done && cnt == 4)
            cnt = 0;
        else if(data_in_ready)
            cnt = cnt + 1;
        else if(tx_done)
            cnt = cnt + 1;
    end

    //flag脉冲输出，每发送完成1个32位数据脉冲1次
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            flag = 0;
        else if(tx_done && cnt == 4)
            flag = 1;
        else 
            flag = 0;
    end

    //data_out和data_out_ready
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_out = 0;
            data_out_ready = 0;
        end
        else if(data_in_ready) begin
            data_out = data_in[31:24];
            data_out_ready = 1;
        end
        else if(tx_done) begin
            case(cnt)
                0:  begin data_out = data[31:24]; data_out_ready = 1; end
                1:  begin data_out = data[23:16]; data_out_ready = 1; end
                2:  begin data_out = data[15:8]; data_out_ready = 1; end
                3:  begin data_out = data[7:0]; data_out_ready = 1; end
                default:    data_out_ready = 0;
            endcase
        end
        else 
            data_out_ready = 0;
    end
/*
    //用ila观察data_in/data_in_ready/data_out/data_out_ready/data/tx_done
    ila_1 ila_1_inst (
    	.clk(clk), // input wire clk


    	.probe0(data_in), // input wire [31:0]  probe0  
    	.probe1(data_in_ready), // input wire [0:0]  probe1 
    	.probe2(data_out), // input wire [7:0]  probe2 
    	.probe3(data_out_ready), // input wire [0:0]  probe3 
    	.probe4(data), // input wire [31:0]  probe4 
    	.probe5(tx_done) // input wire [0:0]  probe5
    );
*/
endmodule