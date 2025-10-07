`timescale 1ns/100ps

module write_reg_top(
    clk,
    rst_n,
    key
);
    input clk;
    input rst_n;
    input key;

    wire flag;          //注入完成信号
    wire en;            //注入开始信号
    wire [31:0]frameaddr;   //32位帧地址

    addr_generater addr_generater(
        .clk        (clk),
        .rst_n      (rst_n),
        .key        (key),
        //.start      (key),
        .flag       (flag),
        .en         (en),
        .frameaddr  (frameaddr)
    );

    write_reg write_reg(
        .clk            (clk),
        .rst_n          (rst_n),
        .frameaddr      (frameaddr),                                  //帧地址，由串口发送
        .start          (en),
        .flag_addr_cnt  (flag)
    );

endmodule