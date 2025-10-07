`timescale 1ns/1ps

`define PERIOD 20
module write_reg_top_tb;

    reg clk_tb;
    reg rst_n_tb;
    reg key_tb;

    initial clk_tb = 0;
    always  # (`PERIOD/2) clk_tb = ~clk_tb;

    initial begin
        rst_n_tb = 0;
        #(`PERIOD*5) rst_n_tb = 1;
    end

    initial begin
        key_tb = 0;
        #(`PERIOD*6) key_tb = 1;
    end

    write_reg_top write_reg_top_inst(
        .clk    (clk_tb),
        .rst_n  (rst_n_tb),
        .key    (key_tb)
    );

endmodule