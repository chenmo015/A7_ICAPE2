`timescale 1ps/1ps

module top(
    clk,
    rst_n,
    key,
    sh_cp,
    st_cp,
    ds
);
    input clk;
    input rst_n;
    input key;
    output wire sh_cp;
	output wire st_cp;
	output wire ds;

    write_reg_top write_reg_top_inst(
        .clk(clk),
        .rst_n(rst_n),
        .key(key)
    );

    hex_top hex_top_inst(
        .clk(clk),
        .reset_n(rst_n),
        .sh_cp(sh_cp),
        .st_cp(st_cp),
        .ds(ds)
    );

endmodule