module counter(
    //--------------------- inputs --------------------
	input clk_c,
	input reset_c,
	input pause_c,
	input ADJ,
	input [1:0] SEL,
	input [3:0] NUM,
    //-------------------- outputs -----------------------------
	output wire [3:0] min_ones,
	output wire [3:0] min_tens,
	output wire [3:0] sec_ones,
	output wire [3:0] sec_tens
    );

	//local counters for all four digits
	reg [3:0] minTensDig_count = 4'b0000;
	reg [3:0] minUnitDig_count = 4'b0000;
	reg [3:0] secTensDig_count = 4'b0000;
	reg [3:0] secUnitDig_count = 4'b0000;
	
	//------------------------------pause mode ----------------------------------
    //local pause reg to control pause in different modes
	reg paused =0;
	always @ (posedge clk_c && posedge pause_c) begin
		if (pause_c) begin
			paused <= ~paused;
		end
		else begin
			paused <= paused;
		end
	end	
	//-------------------------Start the stopwatch with the normal behavior --------------------
	always @(posedge clk_c || posedge reset_c) begin
		//reset all the digits to zero, if reset button got used 
		if (reset_c) begin
			minTensDig_count <= 4'b0000;
			minUnitDig_count <= 4'b0000;
			secTensDig_count <= 4'b0000;
			secUnitDig_count <= 4'b0000;
		end
		//------------- ADJ MODE ==0 ------ Normal Behavior -----------------------------
		if (ADJ==0 && ~paused) begin
			// if end of seconds counter **:59
			if (secUnitDig_count == 9 && secTensDig_count == 5) begin
				// reset both seconds digits
				secUnitDig_count <= 4'b0000;
				secTensDig_count <= 4'b0000;
				
				// then check for min digits, if 59:**
				if (minUnitDig_count == 9 && minTensDig_count == 5) begin
					// reset both minutes digits
					minUnitDig_count <= 4'b0000;
					minTensDig_count <= 4'b0000;
				end
                //if only min0 is max: *9:**
				else if (minUnitsDig_count == 9) begin
					// make min0 zero
					minUnitsDig_count <= 4'b0;
                    //increament min1
					minTensDig_count <= minTensDig_count + 4'b1;
				end
				else begin
                //if non of the minutes digits are at their max, increament min0
					minUnitsDig_count <= minUnitDig_count + 4'b1;
				end
			end
            //if only sec0 is 9, **:*9
			else if (secUnitDig_count == 9) begin
                //make sec0 zero
				secUnitDig_count <= 4'b0;
                //increament sec1
				secTensDig_count <= secTensDig_count + 4'b1;
			end
			else begin
            //increament sec0 if non of the above cases apply
				secUnitDig_count <= secUnitDig_count + 4'b1;
			end
		end			
		//  ----------------- ADJ==1 , Adjustment Mode ---------------------
		if(ADJ==1) begin
            //when go to ADJ mode, by default pause the stopwatch
            paused<=paused;
            //SEL cases: 2'b00, 2'b01, 2'b10, 2'b11
     
            //if the user press puase, then assign the value 
            if(pause_c)
                case(SEL)
                    //choosing sec0 to adjust
                    2'b00:begin
                        //if the NUM inserted bigger than 9 for sec0, make it 9
                        if(NUM>9)begin
                            minUnitDig_count<=9;
                        end
                        else begin
                            secUnitDig_count<=NUM;
                        end
                    end
                    //choosing sec1 to adjust
                    2'b01:begin
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
                        if(NUM>9)begin
                            minUnitDig_count<=9;
                        end
                        else begin
                            minUnitDig_count<=NUM;
                        end
                    end
                    2'b11:begin
                    //choosing min1 to adjust
                        if(NUM>5)begin
                            minTensDig_count<=5;
                        end
                        else begin
                            minTensDig_count<=NUM;
                        end
                    end
                endcase //end switching for SEL
             end
             
         end
         //if end of stopwatch --- 59:59----,reset the stop watch
         if( minTensDig_count==5 && minUnitDig_count==9 && secTensDig_count==5 && secUnitDig_count==9)begin
            //make all the digit counters to be zero
           			 minTensDig_count <= 4'b0000;
			minUnitDig_count <= 4'b0000;
			secTensDig_count <= 4'b0000;
			secUnitDig_count <= 4'b0000;
         end
	//unpause when the adjustment mode is over
         paused<=~paused;
    end//end of always block
    
	//assign the local counters to the output
	assign min_ones = minUnitDig_count;
	assign min_tens = minUnitsDig_count;
	assign sec_ones = secUnitDig_count;
	assign sec_tens = secTensDig_count;
endmodule


