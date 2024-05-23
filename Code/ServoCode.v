`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Kaitlyn Franz
// 
// Create Date: 02/01/2016 01:32:45 PM
// Design Name: Servo control with the CON3
// Module Name: sw_to_angle
// Project Name: The Claw
// Target Devices: Basys 3 with PmodCON3
// Tool Versions: 2015.4
// Description: 
//      This module takes the switch values as an input
//      and converts them to a degree value. 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module State_to_Doll(
input [2:0] state,
input clk,
output PWM1,
output PWM2
    );
reg [25:0] count=0;
reg [2:0] helper1;
reg [2:0] helper2;
reg [2:0]helper3;
reg [2:0]helper4;
reg [2:0]operator;
initial 
begin
helper1=1;
helper2=1;
helper3=1;
helper4=0;
operator=0;
end
////These helper function help in the functionality of pattern for each assigned state
always @(posedge clk)
begin
if (count>49999999)
begin
count<=0;
if (helper1==7)
    helper1<=0;
else 
    helper1<=helper1+1;
if (helper2==2)
    helper2<=0;
else
    helper2<=helper2+1;
if (helper3==8)
    helper3<=0;
else
    helper3<=helper3+1;
if (helper4==3)
    helper4<=1;
else
    helper4<=helper4+1;
end
else 
count<=count+1;
end
always @(state)
begin
    case (state)
    // Doll movement pattern for waiting screen
    1:
    begin
    if (helper1==6)
        operator<=4;
    else if (helper1==7)
    begin
    operator<=5;
//    helper1<=0;
    end
    else if (helper1>0)
    operator<=helper1;
    end
    2:
    operator<=1;
    3:
    begin
    if (helper2==2)
    begin
    operator<=5;
//    helper2<=0;
    end
    else if(operator==1)
    operator<=4;
    end
    4:
    begin
    if (helper3==4)
    operator<=2;
    else if (helper3==8)
    begin
    operator<=4;
//    helper3<=0;
    end
    else if (helper3>4)
    operator<=(helper3-4);
    else if (helper3>0)
    operator<=helper3;
    end
    5:
    begin
    if (helper4==0)
    operator<=4;
    else if (helper4==2)
    operator<=2;
    else if (helper4==3)
    begin
    operator<=3;
//    helper4<=1;
    end 
    end
    6:
    operator<=2;
    7:
    operator<=3;
    default:
    begin
    operator=0;
    end
    endcase
end
Servo_Control u1(clk,operator,PWM1,PWM2);
endmodule



module Servo_Control(
    input clk,
    input [2:0] sw,
    output PWM1,
    output PWM2
    );
    reg [2:0] o1;
    reg [2:0] o2;
    always @ (sw)
    begin
        case (sw)
        1:
        begin
        o1 = 3'd1;
        o2 = 3'd1;
        end
        2:
        begin
        o1 = 3'd2;
        o2 = 3'd2;
        end
        3:
        begin
        o1 = 3'd4;
        o2 = 3'd4;
        end
        4:
        begin
        o1 = 3'd1;
        o2 = 3'd4;
        end
        5:
        begin
        o1 = 3'd4;
        o2 = 3'd1;
        end
        default:
        begin
        o1 = 3'd1;
        o2 = 3'd4;
        end
        endcase      
    end
    Servo_interface(o1,clk,PWM1);
    Servo_interface(o2,clk,PWM2);
endmodule

module Servo_interface (
    input [2:0] sw,
    input clk,
    output PWM
    );
    
    wire [19:0] A_net;
    wire [19:0] value_net;
    wire [8:0] angle_net;
    
    // Convert the incoming switch value
    // to an angle.
    sw_to_angle converter(
        .sw(sw),
        .angle(angle_net)
        );
    
    // Convert the angle value to 
    // the constant value needed for the PWM.
    angle_decoder decode(
        .angle(angle_net),
        .value(value_net)
        );
      
    // Counts up to a certain value and then resets.
    // This module creates the refresh rate of 20ms.   
    counter count(
        .clk(clk),
        .count(A_net)
        );    
    // Compare the count value from the
    // counter, with the constant value set by
    // the switches.
    comparator compare(
        .A(A_net),
        .B(value_net),
        .PWM(PWM)
        );

        
endmodule

module Servo_interface (
    input [2:0] sw,
    input clk,
    output PWM
    );
    
    wire [19:0] A_net;
    wire [19:0] value_net;
    wire [8:0] angle_net;
    
    // Convert the incoming switch value
    // to an angle.
    sw_to_angle converter(
        .sw(sw),
        .angle(angle_net)
        );
    
    // Convert the angle value to 
    // the constant value needed for the PWM.
    angle_decoder decode(
        .angle(angle_net),
        .value(value_net)
        );
      
    // Counts up to a certain value and then resets.
    // This module creates the refresh rate of 20ms.   
    counter count(
        .clk(clk),
        .count(A_net)
        );    
    // Compare the count value from the
    // counter, with the constant value set by
    // the switches.
    comparator compare(
        .A(A_net),
        .B(value_net),
        .PWM(PWM)
        );

        
endmodule

module sw_to_angle(
    input [5:0] sw,
    output reg [8:0] angle
    );
    
    // Run when the value of the switches
    // changes
    always @ (sw)
    begin
        case (sw)
        // Switch 0
        1:
        angle = 9'd45;
        // Switch 1
        2:
        angle = 9'd90;
        // Switch 2
        4:
        angle = 9'd135;

        default:
        angle = 9'd0;
        endcase                 
    end
endmodule


module angle_decoder(
    input [8:0] angle,
    output reg [19:0] value
    );
    
    // Run when angle changes
    always @ (angle)
    begin
        // The angle gets converted to the 
        // constant value. This equation
        // depends on the servo motor you are 
        // using. To get this equation I used 
        // trial and error to get the 0
        // and 360 values and created an equation
        // based on those two points. range of variation in duty cycle:
        // 45000 to 105000, ;60,000; 10,000
//        value = 16'd45000 + ((angle/30)*(10'd10000))
//        value = ((12'd1115)*(angle))+ 16'd45000;
        value = ((12'd1130)*(angle))+ 16'd45000;
    end
endmodule


module counter (
	input clk,
	output reg [19:0]count
);
    parameter div_value=999999;
    // Run on the positive edge of the clock
	always @ (posedge clk)
	begin
	    // If the clear button is being pressed or the count
	    // value has been reached, set count to 0.
	    // This constant depends on the refresh rate required by the
	    // servo motor you are using. This creates a refresh rate
	    // of 10ms. 100MHz/(1/10ms) or (system clock)/(1/(Refresh Rate)).
		if (count == div_value)
			begin
			count <= 20'b0;
			end
		// If clear is not being pressed and the 
		// count value is not reached, continue to increment
		// count. 
		else
			begin
			count <= count + 1'b1;
			end
	end
endmodule


module comparator (
	input [19:0] A,
	input [19:0] B,
	output reg PWM
);

    // Run when A or B change
	always @ (A,B)
	begin
	// If A is less than B
	// output is 1.
	if (A < B)
		begin
		PWM <= 1'b1;
		end
	// If A is greater than B
	// output is 0.
	else 
		begin
		PWM <= 1'b0;
		end
	end
endmodule




—--------------------------------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWM1}]
set_property IOSTANDARD LVCMOS33 [get_ports {PWM2}]


set_property PACKAGE_PIN V17 [get_ports {state[0]}]
set_property PACKAGE_PIN V16 [get_ports {state[1]}]
set_property PACKAGE_PIN W16 [get_ports {state[2]}]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN A14 [get_ports PWM1]
set_property PACKAGE_PIN A16 [get_ports PWM2]


