//地址产生模块，受按键控制，按键每按下一次，就启动，地址以此加1，遍历底端的所有位置，然后把数码管模块部署到底端进行测试
//给write_reg模块帧地址frameaddr和使能信号en
//32位帧地址中前6位保留位、3位块类型、1位区域划分、5位行地址、10位列地址、7位次要地址
//000000_000_1_xxxxxx_xxxxxxxxxx_xxxxxxx
module addr_generater(
    clk,
    rst_n,
    key,
    //start,
    flag,
    en,
    frameaddr
);
    parameter IDLE = 0;
    parameter WORKING = 1;

    input clk;
    input rst_n;
    input key;              //按键控制启动
    //input start;
    input flag;             //接收write_reg模块的标志信号，每完成一次写入就给一个脉冲
    output en;              //输出使能，连接到write_reg模块，每生成一个frameaddr就使能一次
    output [31:0]frameaddr;       //帧地址，给到write_reg模块

    reg en;
    wire [31:0]frameaddr;

    reg [31:0]cnt_addr;

    //按键消抖
    wire start;
    key_filter key_filter_inst1(
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .start(start)
    );

    //定义状态机state，分为空闲状态和工作状态
    reg state;

    //状态转换，按键按下后进入工作状态，地址遍历完成后进入空闲状态
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state <=  IDLE;
        else begin
            case(state)
                IDLE    :begin
                    if(start)
                        state <= #1 WORKING;
                end
                WORKING :begin
                    if(cnt_addr == 32'b000000_000_1_111111_1111111111_1111111)
                        state <= #1 IDLE;
                end
            endcase
        end
    end 

    //不同状态下对cnt_addr和en赋值
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt_addr <= 0;
            en <= 0;
        end
        else begin
            case(state)
                IDLE    :begin          //IDLE状态下，按键按下后才会启动，同时进入WORKING状态
                    if(start) begin
                        cnt_addr <= #1 cnt_addr + 1;
                        en <= #1 1;
                    end
                    else begin
                        cnt_addr <= #1 32'b000000_000_1_000000_0000000000_0000000;
                        en <= #1 0;
                    end
                end
                WORKING :begin         //WORKING状态下，每接收到一个flag，就给出使能和地址
                    if(flag) begin
                        cnt_addr <= #1 cnt_addr + 1;
                        en <= #1 1;
                    end
                    else begin
                        cnt_addr <= #1 cnt_addr;
                        en <= #1 0;
                    end
                end
            endcase
        end
    end

    assign frameaddr = cnt_addr;



/*
    //定义一个计数器，用来给frameaddr赋值
    reg [31:0]cnt_addr;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_addr <= #1 32'b000000_000_1_000000_0000000000_0000000;
        else if(cnt_addr == 32'b000000_000_1_111111_1111111111_1111111)
            cnt_addr <= #1 32'b000000_000_1_000000_0000000000_0000000;
        else if(start)
            cnt_addr <= #1 cnt_addr + 1;
        else if(cnt_addr == 32'b000000_000_1_000000_0000000000_0000000)
            cnt_addr <= #1 32'b000000_000_1_000000_0000000000_0000000;
        else if(flag)
            cnt_addr <= #1 cnt_addr + 1;
    end

    assign frameaddr = cnt_addr;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            en <= #1 0;
        else if(cnt_addr == 32'b000000_000_1_111111_1111111111_1111111)
            en <= #1 0;
        else if(start)
            en <= #1 1;
        else if(flag == 1)
            en <= #1 1;
        else
            en <= #1 0;
    end
*/
endmodule