`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:46:04 02/07/2019
// Design Name:   test_main
// Module Name:   /home/ise/Documents/verilog_labs/Project_4/test_main_tb.v
// Project Name:  Project_4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_main_tb;

	// Inputs
	reg clk;

	// Outputs
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	test_main uut (
		.clk(clk), 
		.seg(seg), 
		.an(an)
	);

	//400hz clock
	always begin
		#1
		clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
        
		// Add stimulus here

	end
      
endmodule

