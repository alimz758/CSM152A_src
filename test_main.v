`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:02 02/07/2019 
// Design Name: 
// Module Name:    test_main 
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
module test_main(
	clk,
	seg,
	an
    );
	 
	input clk;
	
	output [7:0] seg;
	output [3:0] an;
	
	wire clk_1hz;
	wire clk_5hz;
	wire clk_500hz;
	
	//sample counts from 0 to 9999
	reg [3:0] samp1;
	reg [3:0] samp2;
	reg [3:0] samp3;
	reg [3:0] samp4;
	
	initial begin
		samp1 = 0;
		samp2 = 0;
		samp3 = 0;
		samp4 = 0;
	end
	
	always @(posedge clk_1hz) begin
		samp1 <= samp1+1;
		if(samp1 == 4'b1010) begin
			samp2 <= samp2 + 1;
			samp1 <= 0;
			if(samp2 == 4'b1010) begin
				samp3 <= samp3 + 1;
				samp2 <= 0;
				if(samp3 == 4'b1010) begin
					samp4 <= samp4 + 1;
					samp3<=0;
					if(samp4 == 4'b1010) begin
						samp4 <=0;
					end
				end
			end
		end
		
	end

clocks ticktock(.clk_i(clk), .clk_m(clk_500hz), .clk_one(clk_1hz), .clk_five(clk_5hz));
display disp(.clk_m(clk_500hz), .min_tens(samp4), .min_ones(samp3), .sec_tens(samp2), .sec_ones(samp1), .an(an), .seg(seg));

endmodule
