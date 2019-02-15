module counter(
	input clk_c,
	input reset_c,
	input puase_c,
	input ADJ,
	input [1:0] SEL,
	input [3:0] NUM,

	output wire [3:0] min_ones,
	output wire [3:0] min_tens,
	output wire [3:0] sec_ones,
	output wire [3:0] sec_tens
    );

	//local counters
	reg [3:0] minTensDig_count = 4'b0000;
	reg [3:0] minUnitDig_count = 4'b0000;
	reg [3:0] secTensDig_count = 4'b0000;
	reg [3:0] secUnitDig_count = 4'b0000;
	
	//pause mode
	reg paused<=0;
	always @ (posedge clk_c) begin
		if (pause_c) begin
			paused <= ~paused;
		end
		else begin
			paused <= paused;
		end
	end
			
	//-------------------------Start the stopwatch with the normal behavior --------------------
	always @(posedge reset && posedge clk) begin
		//reset all the digits to zero, if got reseted 
		if (reset_c) begin
			minTensDig_count <= 4'b0000;
			minUnitDig_count <= 4'b0000;
			secTensDig_count <= 4'b0000;
			secUnitDig_count <= 4'b0000;
		end

		//------------- ADJ MODE ==0 ------ Normal Behavior -----------------------------
		if (ADJ==0 && ~paused) begin
			// increment seconds
			if (secUnitDig_count == 9 && secTensDig_count == 5) begin
				// reset seconds
				secUnitDig_count <= 0;
				secTensDig_count <= 0;
				
				// increment minutes
				if (minUnitDig_count == 9 && minTensDig_count == 5) begin
					// reset minutes
					minUnitDig_count <= 4'b0;
					minTensDig_count <= 4'b0;
				end
				else if (minUnitsDig_count == 9) begin
					// overflow min
					minUnitsDig_count <= 4'b0;
					minTensDig_count <= minTensDig_count + 4'b1;
				end
				else begin
					minUnitsDig_count <= minUnitDig_count + 4'b1;
				end
			end
			else if (secUnitDig_count == 9) begin
				// seconds overflow
				secUnitDig_count <= 4'b0;
				secTensDig_count <= secTensDig_count + 4'b1;
			end
			else begin
				secUnitDig_count <= secUnitDig_count + 4'b1;
			end
		end

			
		//  ----------------- ADJ==1  ---------------------
		if(ADJ==1) begin
		
		//when go to ADJ mode, by default pause the stopwatch
		paused<=~paused;
		//SEL cases: 2'b00, 2'b01, 2'b10, 2'b11
		case(SEL)
			//choosing sec0 to adjust
			2'b00:begin
				an<= 4'b1110;
				//if the user press puase, then assign the value 
				if(pause_c)beign
					//if the NUM inserted bigger than 9 for sec0, make it 9
					if(NUM>9)begin
						minUnitDig_count<=9;
					end
					else begin
						secUnitDig_count<=NUM;
					end
				end
			end
			//choosing sec1 to adjust
			2'b01:begin
				an <= 4'b1101;
				//if the user press puase, then assign the value 
				if(pause)beign
					//if adjusted NUM for sec1 is greater 5, make it 5
					if(NUM>5)begin
						secTensDig_count<=5;
					end
					else begin
						secTensDig_count<=NUM;
					end
				end
			//choosing min0 to adjust
			2'b10:begin
				an<= 4'b1011;
				//if the user press puase, then assign the value 
				if(pause_c)beign
					if(NUM>9)begin
						minUnitDig_count<=9
					end
					else begin
						minUnitDig_count<=NUM;
					end
				end
			end
			2'b11:begin
				//choosing min1 to adjust
				an<= 4'b0111;
				//if the user press puase, then assign the value 
				if(pause_c)beign
					if(NUM>5)begin
						minTensDig_count<=5;
					end
					else begin
						minTensDig_count<=NUM;
					end
				end
			end
			//default case
			default: begin
				//keep the previous values

			end
		endcase //end switching for SEL


		//un-pause ---- not sure
		paused<=paused;

		//----------- start counting for ADJ mode
		
			// increment seconds
			if (secUnitDig_count == 9 && secTensDig_count == 5) begin
				// reset seconds
				secUnitDig_count <= 0;
				secTensDig_count <= 0;
				
				// increment minutes
				if (minUnitDig_count == 9 && minTensDig_count == 5) begin
					// reset minutes
					minUnitDig_count <= 4'b0;
					minTensDig_count <= 4'b0;
				end
				else if (minUnitsDig_count == 9) begin
					// overflow min
					minUnitsDig_count <= 4'b0;
					minTensDig_count <= minTensDig_count + 4'b1;
				end
				else begin
					minUnitsDig_count <= minUnitDig_count + 4'b1;
				end
			end
			else if (secUnitDig_count == 9) begin
				// seconds overflow
				secUnitDig_count <= 4'b0;
				secTensDig_count <= secTensDig_count + 4'b1;
			end
			else begin
				secUnitDig_count <= secUnitDig_count + 4'b1;
			end
		end
			
	//assign the local counters to the output
	assign min_ones = minUnitDig_count;
	assign min_tens = minUnitsDig_coun;
	assign sec_ones = secUnitDig_count;
	assign sec_tens = secTensDig_count;

    endmodule

