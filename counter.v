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
    //local pause reg to control pause_c 
	reg paused =1;// true by default
	always @ (posedge clk_c && posedge pause_c) begin
		//if pause button pressed
		if (pause_c) begin
			//make the reg pause true, as in pausing the stopwatch
			paused <= ~paused;
		end
		else begin
			//otherwise 
			paused <= paused;
		end
	end//end of pause mode block
	
	// ---------------always block for ADJ mode, when it is 1 make the stopwatch to pause -------------
	always@(*)begin
		//when the adjustment mode in one, pause the stopwatch
		if(ADJ==1)begin
			paused<=~paused;
		end
		//otherwise go with the default value with is true and contine
		else begin
			paused<=paused;
		end
	end//end always blcok for ADJ mode
	
	//-------------------------Start the stopwatch with the normal behavior --------------------
	
	//always block that checks for reset mode
	always @(posedge clk_c || posedge reset_c) begin
		//reset all the digits to zero, if reset button got used 
		if (reset_c) begin
			minTensDig_count <= 4'b0000;
			minUnitDig_count <= 4'b0000;
			secTensDig_count <= 4'b0000;
			secUnitDig_count <= 4'b0000;
		end//end of reset statement

		//------------- ADJ MODE ==0 ------ Normal Behavior -----------------------------
		if (ADJ==0 && paused==1) begin//beginning of ADJ=0 mode, and not paused then count
			// if end of seconds counter **:59
			if (secUnitDig_count == 4'b1001 && secTensDig_count == 4'b0101) begin
				// reset both seconds digits
				secUnitDig_count <= 4'b0000;
				secTensDig_count <= 4'b0000;
				
				// then check for min digits, if 59:**
				if (minUnitDig_count == 4'b1001 && minTensDig_count == 4'b0101) begin
					// reset both minutes digits
					minUnitDig_count <= 4'b0000;
					minTensDig_count <= 4'b0000;
				end
                //if only min0 is max: *9:**
				else if (minUnitsDig_count == 4'b1001) begin
					// make min0 zero
					minUnitsDig_count <= 4'b0000;
                    //increament min1
					minTensDig_count <= minTensDig_count + 4'b0001;
				end
				else begin
                //if non of the minutes digits are at their max, increament min0
					minUnitsDig_count <= minUnitDig_count + 4'b0001;
				end
			end
            //if only sec0 is 9, **:*9
			else if (secUnitDig_count == 4'b1001) begin
                //make sec0 zero
				secUnitDig_count <= 4'b0000;
                //increament sec1
				secTensDig_count <= secTensDig_count + 4'b0001;
			end
			else begin
            //increament sec0 if non of the above cases apply
				secUnitDig_count <= secUnitDig_count + 4'b0001;
			end
			//if counter is at 59:59, make all the digits zero
			if( minTensDig_count==4'b0101 && minUnitDig_count==4'b1001 && secTensDig_count==4'b0101 && secUnitDig_count==4'b1001)begin
            			//make all the digit counters to be zero
           			 minTensDig_count <= 4'b0000;
				minUnitDig_count <= 4'b0000;
				secTensDig_count <= 4'b0000;
				secUnitDig_count <= 4'b0000;
			end
         	
		end//end of ADJ=0 statement			
		//  ----------------- ADJ==1 , Adjustment Mode ---------------------
		if(ADJ==1 && paused==0) begin//if ADJ is on and paused
            
            
     
            //if the user press puase, then assign the value 
            if(pause_c)
		//SEL cases: 2'b00, 2'b01, 2'b10, 2'b11
                case(SEL)
                    //choosing sec0 to adjust
                    2'b00:begin
                        //if the NUM inserted bigger than 9 for sec0, make it 9
                        if(NUM>9)begin
				//assign 9 to sec0
                            secUnitDig_count<=4'b1001;
                        end
                        else begin
                            secUnitDig_count<=NUM;
                        end
                    end
                    //choosing sec1 to adjust
                    2'b01:begin
                        //if adjusted NUM for sec1 is greater 5, make it 5
                        if(NUM>5)begin
				//assign 5 to sec1
                            secTensDig_count<=4'b0101;
                        end
                        else begin
                            secTensDig_count<=NUM;
                        end
                    end
                    //choosing min0 to adjust
                    2'b10:begin
                        if(NUM>9)begin
				//assign 9 to min0
                            minUnitDig_count<=4'b1001;
                        end
                        else begin
                            minUnitDig_count<=NUM;
                        end
                    end
		//choosing min1 to adjust
                    2'b11:begin
			    //if NUM for min1 is greater than5
                        if(NUM>5)begin
				//assign 5 to min1
                            minTensDig_count<=4'b0101;
                        end
                        else begin
                            minTensDig_count<=NUM;
                        end
                    end
                endcase //end switching for SEL
		end// end if for pause_c mode
             
	end//end for ADJ=1 mode
         //if end of stopwatch --- 59:59----,reset the stop watch
         
    end//end of always block
    
	//assign the local counters to the output
	assign min_ones = minUnitDig_count;
	assign min_tens = minUnitsDig_count;
	assign sec_ones = secUnitDig_count;
	assign sec_tens = secTensDig_count;
endmodule


