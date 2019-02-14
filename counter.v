module counter(
	input clk,
	input reset,
	input state,
	// the following four are the adjusted digit to be used in  //ADJ==1, state==2
  input [3:0]  adj_dig_sec_ones, 
  input [3:0]  adj_dig_sec_tens,
	input [3:0]  adj_dig_min_ones,
	input [3:0]  adj_dig_min_tens,
	output wire [3:0] min_ones,
	output wire [3:0] min_tens,
	output wire [3:0] sec_ones,
	output wire [3:0] sec_tens
    );

	reg [3:0] minTensDig_count = 4'b0000;
	reg [3:0] minUnitDig_count = 4'b0000;
	reg [3:0] secTensDig_count = 4'b0000;
	reg [3:0] secUnitDig_count = 4'b0000;
	
	//implement local pause mode to to control the different state
	reg paused<=1;
			
	//-------------------------Start the stopwatch with the normal behavior --------------------
	always @(posedge reset && posedge clk) begin
		//reset all the digits to zero
		if (reset) begin
			minTensDig_count <= 4'b0000;
			minUnitDig_count <= 4'b0000;
			secTensDig_count <= 4'b0000;
			secUnitDig_count <= 4'b0000;
		//------------- ADJ MODE ==0 ------ Normal Behavior -----------------------------
		else if (state==0  && paused!=0) begin
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
			else If (secUnitDig_count == 9 && minUnitsDig_count == 9 &&
secTensDig_count == 5 && minTensDig_count )begin
		reset<=~reset;
    end

		end



		// ------------------ Pause Mode, State==1 ---------------
		else if (state==1)begin
			//pause the stopwatch
			paused<=0;
			if(state==0)begin
				paused<=1;
        end
			else if(state==2)begin
				paused<=0;
        end
		end
			
		//  ----------------- ADJ==1 or state==2 ---------------------
		else if(state==2 && paused ==0) begin
			//assign the adjusted digits to the local variables to the counting
			secUnitDig_count    = adj_dig_sec_ones;
		 	secTensDig_count   = adj_dig_sec_tens;
			minUnitsDig_count  = adj_dig_min_ones;
			minTensDig_count  = adj_dig_min_tens;

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
			else If (secUnitDig_count == 9 && minUnitsDig_count == 9 &&
secTensDig_count == 5 && minTensDig_count )
		reset<=~reset;

		end

		end
			

	output wire [3:0] min_ones=minUnitDig_count;
	output wire [3:0] min_tens=minUnitsDig_coun;
	output wire [3:0] sec_ones=secUnitDig_count;
	output wire [3:0] sec_tens=secTensDig_count;

	endmodule

