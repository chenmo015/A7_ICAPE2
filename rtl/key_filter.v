`timescale 1ns/100ps

//按键消抖，当按键key按下超过20ms后，才会产生1个脉冲信�?
module key_filter(
    clk,
    rst_n,
    key,
    start
);
    input clk;
    input rst_n;
    input key;
    output wire start;
    
    reg [19:0]cnt;      //计数器，0~999_999计数
    reg r_key;          //打1拍
    reg r_key2;         //打2拍
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= #1 0;
        else if(!key) begin
            if(cnt == 999_999)
                cnt <= #1 cnt;
            else 
                cnt <= #1 cnt + 1;
        end
        else    
            cnt <= #1 0;
    end
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            r_key <= #1 1;
            r_key2 <= #1 1;
        end
        else if(cnt == 999_999) begin
            r_key <= #1 key;
            r_key2 <= #1 r_key;
        end
    end
    
    assign start = ((!r_key) && r_key2);

endmodule