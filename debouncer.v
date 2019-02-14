`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:12:27 02/07/2019 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
	clk_in,
	button_in,
	button_out
    );

input button_in;
input clk_in;
output button_out;

reg [15:0] contact_ct;
reg button_out_reg;

always @(posedge clk_in) begin
	if(button_in == 0) begin
		contact_ct<= 0;
		button_out_reg <= 0;
	end
	else begin
		contact_ct <= contact_ct + 1'b1;
		if(contact_ct == 16'hffff) begin
			button_out_reg <= 1;
			contact_ct <= 0;
		end
	end
end

assign button_out = button_out_reg;

endmodule
