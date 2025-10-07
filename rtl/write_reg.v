`timescale 1ps/1ps




`define WORDS_NUM 202
module write_reg(
    clk,
    rst_n,
    frameaddr,                                  //帧地址，由串口发送
    start,
    flag_addr_cnt
);
    input clk;
    input rst_n;
    input [31:0]frameaddr;
    input start;
    output reg flag_addr_cnt;               //标志信号，每运行完一次指令就给一个脉冲，后续连到帧地址产生模块，每写入一次地址加1，然后给下一个地址注入

    wire read_or_write;
    assign read_or_write = 0;           //始终为写入


 //定义状态机
    reg [6:0]state;
    parameter [6:0] STATE00 = 7'd0;
    parameter [6:0] STATE01 = 7'd1;
    parameter [6:0] STATE02 = 7'd2;
    parameter [6:0] STATE03 = 7'd3;
    parameter [6:0] STATE04 = 7'd4;
    parameter [6:0] STATE05 = 7'd5;
    parameter [6:0] STATE06 = 7'd6;
    parameter [6:0] STATE07 = 7'd7;
    parameter [6:0] STATE08 = 7'd8;
    parameter [6:0] STATE09 = 7'd9;
    parameter [6:0] STATE10 = 7'd10;
    parameter [6:0] STATE11 = 7'd11;
    parameter [6:0] STATE12 = 7'd12;
    parameter [6:0] STATE13 = 7'd13;
    parameter [6:0] STATE14 = 7'd14;
    parameter [6:0] STATE15 = 7'd15;
    parameter [6:0] STATE16 = 7'd16;
    parameter [6:0] STATE17 = 7'd17;
    parameter [6:0] STATE18 = 7'd18;
    parameter [6:0] STATE19 = 7'd19;
    parameter [6:0] STATE20 = 7'd20;
    parameter [6:0] STATE21 = 7'd21;
    parameter [6:0] STATE22 = 7'd22;
    parameter [6:0] STATE23 = 7'd23;
    parameter [6:0] STATE24 = 7'd24;
    parameter [6:0] STATE25 = 7'd25;
    parameter [6:0] STATE26 = 7'd26;
    parameter [6:0] STATE27 = 7'd27;
    parameter [6:0] STATE28 = 7'd28;
    parameter [6:0] STATE29 = 7'd29;
    parameter [6:0] STATE30 = 7'd30;
    parameter [6:0] STATE31 = 7'd31;
    parameter [6:0] STATE32 = 7'd32;
    parameter [6:0] STATE33 = 7'd33;
    parameter [6:0] STATE34 = 7'd34;
    parameter [6:0] STATE35 = 7'd35;
    parameter [6:0] STATE36 = 7'd36;
    parameter [6:0] STATE37 = 7'd37;
    parameter [6:0] STATE38 = 7'd38;
    parameter [6:0] STATE39 = 7'd39;
    parameter [6:0] STATE40 = 7'd40;
    parameter [6:0] STATE41 = 7'd41;
    parameter [6:0] STATE42 = 7'd42;
    parameter [6:0] STATE43 = 7'd43;


    //计数器
    reg [5:0]noop_cnt;                                      //有些地方要多个空操作，记录空操作的次数
    reg [8:0]read_FDRO_cnt;                                 //读出字个数0~202
    reg [8:0]write_FDRI_cnt;                                //写入字个数0~202
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            read_FDRO_cnt = 0;
        else if(state == STATE21)
            read_FDRO_cnt = read_FDRO_cnt + 1;
        else
            read_FDRO_cnt = 0;
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            write_FDRI_cnt = 0;
        else if(state == STATE37)
            write_FDRI_cnt = write_FDRI_cnt + 1;
        else
            write_FDRI_cnt = 0;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            noop_cnt = 0;
        else if(state == STATE38)
            noop_cnt = noop_cnt + 1;
        else
            noop_cnt = 0;
    end

    //读取帧地址
    wire [31:0]frameaddr1;                                  
    assign frameaddr1 = frameaddr;

    //状态转换，有些状态转换没有按顺序来，有点乱，因为期间在中间插入或删减过一些状态，可以去看指令序列部分
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state = STATE00;
        else begin
            case(state)
                STATE00:    if(start) state = STATE01;
                STATE01:    state = STATE02;
                STATE02:    state = STATE03;

                STATE03:    state = STATE04;
                STATE04:    state = STATE05;
                STATE05:    state = STATE06;

                STATE06:    state = STATE07;
                STATE07:    begin
                                if(read_or_write)           //read_or_write=1时读出
                                    state = STATE08;
                                else                        //read_or_write=0时写入
                                    state = STATE29;
                            end
                //读出
                STATE08:    state = STATE09;
                STATE09:    state = STATE10;
                STATE10:    state = STATE11;
                STATE11:    state = STATE12;
                STATE12:    state = STATE13;
                STATE13:    state = STATE14;
                STATE14:    state = STATE15;
                STATE15:    state = STATE16;
                STATE16:    state = STATE17;
                STATE17:    state = STATE18;
                STATE18:    state = STATE19;
                STATE19:    state = STATE20;
                STATE20:    state = STATE21;
                STATE21:    begin
                                if(read_FDRO_cnt == `WORDS_NUM+1)     //循环202次
                                    state = STATE22;
                                else
                                    state = STATE21;
                            end
                STATE22:    state = STATE23;
                STATE23:    state = STATE24;
                STATE24:    state = STATE25;

                STATE25:    state = STATE26;
                STATE26:    state = STATE27;
                STATE27:    state = STATE28;
                STATE28:    state = STATE00;
                
                //写入

                STATE29:    state = STATE30;
                STATE30:    state = STATE31;
                STATE31:    state = STATE32;
                STATE32:    state = STATE33;
                STATE33:    state = STATE34;
                STATE34:    state = STATE35;
                STATE35:    state = STATE36;
                STATE36:    state = STATE37;
                STATE37:    begin
                                if(write_FDRI_cnt == `WORDS_NUM + 1)        //循环202次
                                    state = STATE38;
                                else
                                    state = STATE37;
                            end

                STATE38:    state = STATE39;
                STATE39:    state = STATE40;

                STATE40:    state = STATE41;
                STATE41:    state = STATE42;
                STATE42:    state = STATE43;
                STATE43:    state = STATE00;
            endcase
        end
    end

    //指令序列,从上往下按顺序来的
    reg csib;
    reg rdwrb;
    reg [31:0]icap_i;
    wire [31:0]icap_o;
    always@(*) begin
        if(!rst_n) begin
            csib    = 1;
            rdwrb   = 1;
            icap_i  = 8'b0000_0000;
        end
        else case(state)
                STATE00:begin
                            csib    = 1;
                            rdwrb   = 1;
                            icap_i  = swap(0);
                        end
                STATE01:begin
                            csib    = 1;
                            rdwrb   = 0;
                            icap_i  = swap(0);
                        end
                STATE02:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(0);
                        end

                STATE03:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'hFFFF_FFFF);          //虚拟字
                        end
                STATE04:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'HAA99_5566);          //同步字
                        end
                STATE05:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end

                STATE06:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE07:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
        //读出
                STATE08:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE09:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE10:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE11:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H3000_8001);          //写入一个字
                        end
                STATE12:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h0000_0004);          //激活RCFG
                        end
                STATE13:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE14:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h3000_2001);          //写入FAR地址
                        end
                STATE15:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(frameaddr);              //串口接收帧地址frameaddr
                        end
                STATE16:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2800_60ca);          //读出来101个字
                        end
                STATE17:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE18:begin
                            csib    = 1;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);
                        end
                STATE19:begin
                            csib    = 1;
                            rdwrb   = 1;
                            icap_i  = swap(32'h2000_0000);                              //切换到读出
                        end
                STATE20:begin
                            csib    = 0;
                            rdwrb   = 1;
                            icap_i  = swap(32'h2000_0000);       
                        end
                STATE21:begin
                            csib    = 0;
                            rdwrb   = 1;
                            icap_i  = swap(32'h00000000);           //此状态下读出FDRO
                        end
                STATE22:begin
                            csib    = 1;
                            rdwrb   = 1;
                            icap_i  = swap(32'h2000_0000);                              //切换到写入
                        end
                STATE23:begin
                            csib    = 1;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
                STATE24:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
                //28-33在论文里没有，ug470里有

                STATE25:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H3000_8001);          //写入CMD1个字
                        end
                STATE26:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h0000_000D);          //去同步字
                        end
                STATE27:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
                STATE28:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
        //写入

                STATE29:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H3001_8001);          //写入IDCODE1个字
                        end
                STATE30:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H0362d093);           //IDCODE
                        end
                STATE31:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h3000_8001);          //写入CMD1个字
                        end
                STATE32:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h0000_0001);          //激活WCFG
                        end
                STATE33:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);          
                        end
                STATE34:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h3000_2001);          //写入FAR
                        end
                STATE35:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(frameaddr);              //帧地址frameaddr
                        end
                STATE36:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h3000_40CA);          //向FDRI寄存器写入101个字
                        end
                STATE37:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h0000_0000);          //写入全1111_0011
                            //icap_i  = swap(write_FDRI_cnt);
                        end
                STATE38:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
                STATE39:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end

                STATE40:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H3000_8001);          //写入CMD1个字
                        end
                STATE41:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'H0000_000D);          //去同步字
                        end
                STATE42:begin
                            csib    = 0;
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
                STATE43:begin
                            csib    = 0; 
                            rdwrb   = 0;
                            icap_i  = swap(32'h2000_0000);       
                        end
        endcase
    end

    wire [31:0]icap_i_real;
    wire [31:0]icap_o_real;
    assign icap_i_real = swap(icap_i);
    assign icap_o_real = swap(icap_o);


    //定义1个函数swap,将32位数据的位进行调换
    function    [31:0]swap;
        input [31:0]data;
        begin
            swap[0] = data[7];
            swap[1] = data[6];
            swap[2] = data[5];
            swap[3] = data[4];
            swap[4] = data[3];
            swap[5] = data[2];
            swap[6] = data[1];
            swap[7] = data[0];
            swap[8] = data[15];
            swap[9] = data[14];
            swap[10] = data[13];
            swap[11] = data[12];
            swap[12] = data[11];
            swap[13] = data[10];
            swap[14] = data[9];
            swap[15] = data[8];
            swap[16] = data[23];
            swap[17] = data[22];
            swap[18] = data[21];
            swap[19] = data[20];
            swap[20] = data[19];
            swap[21] = data[18];
            swap[22] = data[17];
            swap[23] = data[16];
            swap[24] = data[31];
            swap[25] = data[30];
            swap[26] = data[29];
            swap[27] = data[28];
            swap[28] = data[27];
            swap[29] = data[26];
            swap[30] = data[25];
            swap[31] = data[24];
        end
         
    endfunction
/*
    //定义1个存储器，将读出的101个32位数据都存在里面
    reg [31:0]data_ram[100:0];
    integer i;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            for(i=0;i<101;i=i+1)    data_ram[i] = 0;
        else if(read_FDRO_cnt > 103)
            data_ram[read_FDRO_cnt - 104] = icap_o_real;
    end

    //将存储器里面存储的数据全部发送给串口
    reg [7:0]data_out_cnt;                              //记录从data_out输出的数据个数，每输出1个加1
    reg data_out_state;    //状态变量，state=37时开始变为1，代表存储器准备完成，可以发送数据，data_out_cnt=100时变为0，等待下1个存储器准备
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_out_state = 0;
        else if(data_out_cnt == 101)
            data_out_state = 0;
        else if(state == STATE28)
            data_out_state = 1;
    end

    //
    reg [31:0]data_out;
    reg done;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_out = 0;
            done = 0;
            data_out_cnt = 0;
        end
        else if(data_out_state) begin
            if(data_out_cnt == 0) begin
                data_out = data_ram[data_out_cnt];
                done = 1;
                data_out_cnt = data_out_cnt + 1;
            end
            else if(flag) begin
                data_out = data_ram[data_out_cnt];
                done = 1;
                data_out_cnt = data_out_cnt + 1;
            end
            else
                done = 0;
        end
        else begin
            data_out = 0;
            done = 0;
            data_out_cnt = 0;
        end 
    end
*/
    //标志信号flag_addr_cnt，每运行完1次指令就给一个脉冲
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            flag_addr_cnt <= 0;
        else if((state == STATE43) || (state == STATE28))
            flag_addr_cnt <= 1;
        else 
            flag_addr_cnt <= 0;
    end
/*
///////////////////////////////////////////////////////////////////////////
    //测试，看看数据是不是真的写入到了data存储器中
    reg [7:0]cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt = 0;
        else if(cnt == 100)
            cnt = 0;
        else if(state == STATE28)
            cnt = cnt + 1;
        else if(cnt == 0)
            cnt = 0;
        else
            cnt = cnt + 1;
    end


    reg [31:0]data_test;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_test = 0;
        else 
            data_test = data_ram[cnt];
    end
////////////////////////////////////////////////////////////////////////////
*/
    //调用ICAP
    ICAPE2 #(
        .DEVICE_ID(32'h0362d093),       // Specifies the pre-programmed Device ID value to be used for simulation
                                        // purposes.
        .ICAP_WIDTH("X32"),             // Specifies the input and output data width.
        .SIM_CFG_FILE_NAME("NONE")      // Specifies the Raw Bitstream (RBT) file to be parsed by the simulation
                                        // model.
    )
    ICAPE2_inst (
        .O(icap_o),             // 32-bit output: Configuration data output bus
        .CLK(clk),              // 1-bit input: Clock Input
        .CSIB(csib),            // 1-bit input: Active-Low ICAP Enable
        .I(icap_i),             // 32-bit input: Configuration data input bus
        .RDWRB(rdwrb)           // 1-bit input: Read/Write Select input
    );

    ila_0 ila_0_inst (
    	.clk    (clk), // input wire clk


    	.probe0(start), // input wire [0:0]  probe0  
    	.probe1(frameaddr), // input wire [31:0]  probe1 
    	.probe2(flag_addr_cnt), // input wire [0:0]  probe2 
    	.probe3(state), // input wire [6:0]  probe3 
    	.probe4(icap_i_real) // input wire [31:0]  probe4
    );


/*
    //用ila观察波形，需要观察的数据；read_or_write1/start/state/noop_cnt/read_FDRO_cnt/write_FDRI_cnt/frameaddr1/csib/rdwrb/icap_i/icap_o/icap_i_real/icap_o_real/flag_addr_cnt
    ila_0 ila_0_inst (
    	.clk(clk), // input wire clk


    	.probe0(read_or_write1),        // input wire [0:0]  probe0  
    	.probe1(start),                 // input wire [0:0]  probe1 
    	.probe2(state),                 // input wire [6:0]  probe2 
    	.probe3(noop_cnt),              // input wire [5:0]  probe3 
    	.probe4(read_FDRO_cnt),         // input wire [8:0]  probe4 
    	.probe5(write_FDRI_cnt),        // input wire [8:0]  probe5 
    	.probe6(frameaddr1),            // input wire [31:0]  probe6 
    	.probe7(csib),                  // input wire [0:0]  probe7 
    	.probe8(rdwrb),                 // input wire [0:0]  probe8 
    	.probe9(icap_i),                // input wire [31:0]  probe9 
    	.probe10(icap_o),               // input wire [31:0]  probe10 
    	.probe11(icap_i_real),          // input wire [31:0]  probe11 
    	.probe12(icap_o_real),           // input wire [31:0]  probe12
        .probe13(data_out_cnt),
        .probe14(data_out),
        .probe15(flag_addr_cnt),
        .probe16(flag),
        .probe17(done),
        .probe18(cnt),
        .probe19(data_test)
    );
*/
endmodule