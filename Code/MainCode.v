`timescale 1ns / 1ps
module Project(
    input I_1,
    input I_2,
    input I_3,
    input Reset,
    input clk
    //VGA RED
    //VGA BLUE
    //VGA GREEN
    //SERVO ONE OUTPUT
    //SERVO TWO OUTPUT
    );
wire A;
wire B;
wire C;
wire D;
wire E;
wire R;
 
assign D = I_1 || I_2; //User Input 1
assign E = I_1 || I_3; //User Input 2
assign R = Reset;

wire clk2Hz;
clk_div_2Hz CLK2(clk, clk2Hz);

wire [2:0] X;
wire [2:0] O;
//Excitation Equations and putting them into D-Flipflops
D_FF D1 (.D(O[2]), .clk(clk2Hz), .Q(A), .reset(Reset)); //A
D_FF D2 (.D(O[1]), .clk(clk2Hz), .Q(B), .reset(Reset)); //B
D_FF D3 (.D(O[0]), .clk(clk2Hz), .Q(C), .reset(Reset)); //C  

assign O[2] = B && ~C && D; //D(A+1) = BC'
assign O[1] = ((B && ~C  && ~D) || (~A && ~B && C && E ) || (~A && ~B && C && E) || (~A && ~B && C && D)); //D(B+1) = BC'D' + A'B'CE + A'B'CD
assign O[0] = ((~C && E) || (B && E) ||( A&&E ) || ( A&&D ) || (~B && ~C && D) || (B && C && D ));//D(C+1) = C'E + BE + AE + AD + B'C'D + BCD
assign A = O[2];
assign B = O[1];
assign C = O[0];

//Output depending on our current State

//assign X[2] = ( (A) || (B && ~C && D) );
//assign X[1] = B; 
//assign X[0] = ( (C) || (B & D & E) ); 

assign X[2] = A;
assign X[1] = B;
assign X[0] = C;
//define counter bahir
//module Lab10TaskA(
//    input clk,
//    output [9:0] h_count,
//    output trig_v
//    );
//reg [9:0] h_count;
//reg trig_v;

//initial trig_v = 0;
//initial h_count = 0;
//always @ (posedge clk)
//    begin 
//      if (h_count < 799)
//        begin
//            h_count <= h_count + 1;
//            trig_v <= 0;
//        end
//      else
//        begin
//            trig_v <= 1;
//            h_count  <= 0;
//        end
//    end
//endmodule
reg [2:0] counter;
wire [1:0] Doll = 0;
//reg [3:0] LED = 0;
initial counter =  0;
reg clear1 = 0;
reg clear2 = 0;

wire Decision [1:0];
lfsr4 K ( .clk(clk2Hz), .reset(Reset), .clear(clear1), .Doll_Answer(Doll), .lfsr(LED) );
Decision_Maker (.A(D), .B(E), .C(Doll[1]), .D(Doll[0]), .D1(Decision[1]), .D2(Decision[0]));

reg ReqOut [2:0];
//Servos(.input(ReqOut), Output);
//VGA(.input(Reqout), Red, Blue, Green);

always @ (O) //checks for every instance of state
        begin
    
        case(O)
        1: //Waiting Screen
        begin
        clear1 <= 1;
        ReqOut[2] <= 0;
        ReqOut[1] <= 0;
        ReqOut[0] <= 1;
        end
        2: //Decision 
        begin
        clear1 <= 0;
        if(Doll[1] == 0 && Doll[0] == 1)
            begin
                ReqOut[2] <= 0;
                ReqOut[1] <= 1;
                ReqOut[0] <= 0;
            end
        else if (Doll[1] == 1 && Doll [0] == 0)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 1;
                ReqOut[0] <= 0;
            end
        else if (Doll[1] == 1 && Doll [0] == 1)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 1;
                ReqOut[0] <= 1;
            end
        end
        3: //Won (Result) 
        begin
        clear1 <= 0;
        if(Decision[1] == 0 && Decision[0] == 1)
            begin
                ReqOut[2] <= 0;
                ReqOut[1] <= 1;
                ReqOut[0] <= 1;
            end
        else if (Decision[1] == 1 && Decision[0] == 0)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 0;
            end
        else if (Decision[1] == 1 && Doll[1] == 1)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 1;
            end
        else
            begin
            ReqOut[2] <= 1;
            ReqOut[1] <= 0;
            ReqOut[0] <= 1;
            end
        end
        4: //Lost (Result)
        begin
        clear1 <= 0;
        if(Decision[1] == 0 && Decision[0] == 1)
            begin
                ReqOut[2] <= 0;
                ReqOut[1] <= 1;
                ReqOut[0] <= 1;
            end
        else if (Decision[1] == 1 && Decision[0] == 0)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 0;
            end
        else if (Decision[1] == 1 && Doll[1] == 1)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 1;
            end
        else
            begin
            ReqOut[2] <= 1;
            ReqOut[1] <= 0;
            ReqOut[0] <= 1;
            end
        end
        5: //Tie (Result)
        begin
        clear1 <= 0;
        if(Decision[1] == 0 && Decision[0] == 1)
            begin
                ReqOut[2] <= 0;
                ReqOut[1] <= 1;
                ReqOut[0] <= 1;
            end
        else if (Decision[1] == 1 && Decision[0] == 0)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 0;
            end
        else if (Decision[1] == 1 && Doll[1] == 1)
            begin
                ReqOut[2] <= 1;
                ReqOut[1] <= 0;
                ReqOut[0] <= 1;
            end
        else
            begin
            ReqOut[2] <= 1;
            ReqOut[1] <= 0;
            ReqOut[0] <= 1;
            end
        end
        6: //Decision (Unused)
        begin
        end
        7: //Decision (Unused)
        begin
        end
    
        default: //Title Screen
        begin
        clear1 <= 0;
        ReqOut[2] <= 0;
        ReqOut[1] <= 0;
        ReqOut[0] <= 0;
        end
        endcase
    end
    
    
endmodule


module D_FF(
    input D, // Data input 
    input clk, // clock input 
    output reg Q, // output Q 
    input reset
    );
always @(posedge clk) 
    begin
    Q = D; 
    if (reset)
        begin
            Q=0;
        end
     end 
endmodule

module clk_div_2Hz(
    input clk,
    output reg clk_d
    );
    //parameter div_value =32'd10000;
    parameter div_value = 24999999; //2HZ
    reg [26:0]count;
    initial
        begin
            clk_d = 0;
            count = 0;    
        end
    always @ (posedge clk)
    begin
        if (count == div_value)
            begin
                clk_d <= ~clk_d;
                count <= 0;
            end
        else
            count <= count + 1;
    end
endmodule

module Decision_Maker(
    
    input A, //user input bit 1
    input B, //user input bit 2
    input C, //computer randomly generated bit 1
    input D, //computer randomly generated bit 2
//    input clear,
    output D1,
    output D2
    );
//A = I1, B = I2, C = O1, D = O2.

//always @ (clear)
//begin
//    if (clear)
//    begin 
    //D1 = A'D' + B'D' + BC' + ACD
    assign D1 = ( (~A && ~D) || ( ~B && ~D ) || (B && ~C) || (A && C && D)  );
    //D2 = A'C' + B'C' + AD' + BCD
    assign D2 = ( (~A && ~C) || ( ~B && ~C) || (A && ~D) || (B && C && D)  );
//    end
    
//end
endmodule

module lfsr_top(
    input clk_100MHz,
    input reset,
    output [3:0] LED
    );
    
wire w_1Hz;
lfsr4 r4(.clk(w_1Hz),.reset(reset),.lfsr(LED));
oneHz_gen uno(.clk_100MHz(clk_100MHz),.reset(reset),.clk_1Hz(w_1Hz));
endmodule

module lfsr4(
    input clk,
    input reset,
    input clear,
    output [1:0] Doll_Answer,
    output reg [3:0] lfsr = 4'b0001
    );
    always @(posedge clk or posedge reset)
        if(reset)
            lfsr <= 4'b0001;
        else if(clear == 0)
            lfsr <= lfsr;
        else begin
            lfsr[3:1] <= lfsr[2:0];
            lfsr[0] <= lfsr[3] ~^ lfsr[2];
        end
        
    //D' + A'B'C + AB'C' + ABC
    assign Doll_Answer[1] = (~lfsr[0] || (~lfsr[3] && ~lfsr[2] && lfsr[1]) || (lfsr[3] && ~lfsr[2] && ~lfsr [1]) || (lfsr[3] && lfsr[2] && lfsr [1]) );
    
    //D + A'BC + ABC';
    assign Doll_Answer[0] = ( (lfsr[0]) || (~lfsr[3] && lfsr[2] && lfsr[1]) || (lfsr[3] && lfsr[2] && ~lfsr[1]) );
    
       
endmodule


