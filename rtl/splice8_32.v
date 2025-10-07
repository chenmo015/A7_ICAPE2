`timescale 1ns/100ps

module splice8_32(
    clk,
    rst_n,
    data_in,
    rx_done,
    data_out
);
    input clk;
    input rst_n;
    input [7:0]data_in;
    input rx_done;
    output reg [31:0]data_out;

    //定义计数器cnt，计数收到的4个8位数
    reg [2:0]cnt;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 0;
        else if(cnt == 4)
            cnt <= 0;
        else if(rx_done)
            cnt <= cnt + 1;
    end

    //data_out
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_out <= 0;
        else if(rx_done)
            case(cnt)
                3:  data_out[7:0] <= data_in;
                2:  data_out[15:8] <= data_in;
                1:  data_out[23:16] <= data_in;
                0:  data_out[31:24] <= data_in;
                default:data_out <= data_out;
            endcase
    end

endmodule