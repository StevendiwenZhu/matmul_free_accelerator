
module qdiv #(
	//Parameterized values
	parameter Q = FXP_R,
	parameter N = FXP_N
	)
	(
	input 	[N-1:0] i_dividend,
	input 	[N-1:0] i_divisor,
	input 	i_start,
	input 	i_clk,
	input   i_reset_n,
	input 	i_enable,
	output 	[N-1:0] o_quotient_out,
	output 	o_complete,
	output	o_overflow
	);
 
	reg [2*N+Q-3:0]	reg_working_quotient;	//	Our working copy of the quotient
	reg [N-1:0] 		reg_quotient;				//	Final quotient
	reg [N-2+Q:0] 		reg_working_dividend;	//	Working copy of the dividend
	reg [2*N+Q-3:0]	reg_working_divisor;		// Working copy of the divisor
 
	reg [N-1:0] 			reg_count; 		//	This is obviously a lot bigger than it needs to be, as we only need 
													//		count to N-1+Q but, computing that number of bits requires a 
													//		logarithm (base 2), and I don't know how to do that in a 
													//		way that will work for everyone
										 
	reg					reg_done;			//	Computation completed flag
	reg					reg_sign;			//	The quotient's sign bit
	reg					reg_overflow;		//	Overflow flag
 
	assign o_quotient_out[N-2:0] = reg_quotient[N-2:0];	//	The division results
	assign o_quotient_out[N-1] = reg_sign;						//	The sign of the quotient
	assign o_complete = reg_done;
	assign o_overflow = reg_overflow;
 
	always_ff @( posedge i_clk or negedge i_reset_n) begin
		if (!i_reset_n) begin
			reg_done <= 1'b1;				//	Initial state is to not be doing anything
			reg_overflow <= 1'b0;			//		And there should be no woverflow present
			reg_sign <= 1'b0;				//		And the sign should be positive

			reg_working_quotient <= 0;	
			reg_quotient <= 0;				
			reg_working_dividend <= 0;	
			reg_working_divisor <= 0;		
			reg_count <= 0; 		
		end else if (i_enable) begin
			if( reg_done && i_start ) begin										//	This is our startup condition
				//  Need to check for a divide by zero right here, I think....
				reg_done <= 1'b0;												//	We're not done			
				reg_count <= N+Q-1;											//	Set the count
				reg_working_quotient <= 0;									//	Clear out the quotient register
				reg_working_dividend <= 0;									//	Clear out the dividend register 
				reg_working_divisor <= 0;									//	Clear out the divisor register 
				reg_overflow <= 1'b0;										//	Clear the overflow register

				reg_working_dividend[N+Q-2:Q] <= i_dividend[N-2:0];				//	Left-align the dividend in its working register
				reg_working_divisor[2*N+Q-3:N+Q-1] <= i_divisor[N-2:0];		//	Left-align the divisor into its working register

				reg_sign <= i_dividend[N-1] ^ i_divisor[N-1];		//	Set the sign bit
				end 
			else if(!reg_done) begin
				reg_working_divisor <= reg_working_divisor >> 1;	//	Right shift the divisor (that is, divide it by two - aka reduce the divisor)
				reg_count <= reg_count - 1;								//	Decrement the count

				//	If the dividend is greater than the divisor
				if(reg_working_dividend >= reg_working_divisor) begin
					reg_working_quotient[reg_count] <= 1'b1;										//	Set the quotient bit
					reg_working_dividend <= reg_working_dividend - reg_working_divisor;	//		and subtract the divisor from the dividend
					end
	
				//stop condition
				if(reg_count == 0) begin
					reg_done <= 1'b1;										//	If we're done, it's time to tell the calling process
					reg_quotient <= reg_working_quotient;			//	Move in our working copy to the outside world
					if (reg_working_quotient[2*N+Q-3:N]>0)
						reg_overflow <= 1'b1;
						end
				else
					reg_count <= reg_count - 1;	
				end
		end else begin
			// Keep the same values
			reg_done <= reg_done;
			reg_overflow <= reg_overflow;
			reg_sign <= reg_sign;

			reg_working_quotient <= reg_working_quotient;	
			reg_quotient <= reg_quotient;				
			reg_working_dividend <= reg_working_dividend;	
			reg_working_divisor <= reg_working_divisor;		
			reg_count <= reg_count; 		
		end
	end
endmodule