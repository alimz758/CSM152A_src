`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:15 02/07/2019 
// Design Name: 
// Module Name:    display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module display(
	clk_m,
	min_tens,
	min_ones,
	sec_tens,
	sec_ones,
	an,
	seg
    );
	input clk_m;
	
	input [3:0] min_tens;
	input [3:0] min_ones;
	input [3:0] sec_tens;
	input [3:0] sec_ones;
	
	output [3:0] an;
	output [7:0] seg;
	
	//iterator iterates through the first~fourth digits:
	reg [2:0] iterator;
	//the value is the number on the digit iterator points to
	reg [3:0] value;
	
	reg [3:0] an_reg;
	reg [7:0] seg_reg;
	
	wire [3:0] an;
	wire [7:0] seg;
	
	initial begin
		iterator = 3'b001;
	end
	
	always @(posedge clk_m) begin
		
		if(iterator == 3'b101) begin
			iterator = 3'b001;
		end
		
		case(iterator)
			3'b001: an_reg = 4'b0111;	//iterator points to tens min
			3'b010: an_reg = 4'b1011;	//" to the ones min
			3'b011: an_reg = 4'b1101;	// tens sec
			3'b100: an_reg = 4'b1110;	// ones sec
			default: an_reg = 4'b1110;
		endcase
		
		case(iterator)
			3'b001: value = min_tens;
			3'b010: value = min_ones;
			3'b011: value = sec_tens;
			3'b100: value = sec_ones;	//value equals to the numbers from according digits
			default: value = 4'b0000;
		endcase
			
		case(value)
			4'b0000 : seg_reg = 8'b11000000;	//seg is assigned accordingly
			4'b0001 : seg_reg = 8'b11111001;
			4'b0010 : seg_reg = 8'b10100100;
			4'b0011 : seg_reg = 8'b10110000;
			4'b0100 : seg_reg = 8'b10011001;
			4'b0101 : seg_reg = 8'b10010010;
			4'b0110 : seg_reg = 8'b10000010;
			4'b0111 : seg_reg = 8'b11111000;
			4'b1000 : seg_reg = 8'b10000000;
			4'b1001 : seg_reg = 8'b10010000;
			//default to 0
			default : seg_reg = 8'b11000000;
		endcase    
		
		iterator = iterator + 1;

	end
	
	assign an = an_reg;
	assign seg = seg_reg;
	
endmodule
