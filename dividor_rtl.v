module dividor_rtl #(parameter SIZE=4) 
		(
			input clk, rst, start,
			input [SIZE-1:0] a, b,
			output reg [SIZE-1:0] m,
			output reg [9:0] f);

		localparam IDLE=3'b000;
		localparam READY=3'b001;
		localparam INVALID=3'b010;
		localparam ZERO=3'b011;
		localparam REAL=3'b100;
		localparam FRACTION=3'b101;
		localparam RESULT=3'b111;

		reg [SIZE-1:0] a_reg, a_next;
		reg [2*SIZE-1:0] a_f_reg, a_f_next;
		reg [1:0] precision_reg, precision_next; 
		reg [31:0] counter_real_reg, counter_real_next;
		reg [31:0] counter_fraction_reg, counter_fraction_next; 
		reg [31:0] memory [3:1];

		reg [2:0] current_state, next_state;

		always @(posedge clk or posedge rst)
			if (rst) begin
				current_state<= IDLE;
				a_reg<=0;
				a_f_reg<=0;
				counter_real_reg<=0;
				counter_fraction_reg<=0;
				precision_reg<=0;
			end	
			else begin
				current_state<= next_state;
				a_reg<=a_next;
				a_f_reg<=a_f_next;
				counter_real_reg<=counter_real_next;
				counter_fraction_reg<=counter_fraction_next;
				precision_reg<=precision_next;
			end

		always@(*)
			case(current_state)
				IDLE: 	begin
							if(start) 
								next_state=READY;
					  		else 
								next_state=IDLE;
						end		

				READY: 	begin
							a_next=a;
							counter_real_next=0;
							memory[3]=0;
							memory[2]=0;
							memory[1]=0;
							if(b==0)
								next_state=INVALID;
					   		else if (a==0)
					   			next_state=ZERO;
					   		else if (a<b) begin
					    		next_state=FRACTION;
					    		a_f_next=a_next*10;
					    		counter_fraction_next=0;
					    		precision_next=3;
					   		end
					   		else 
					    		next_state=REAL;
					    end		

				INVALID:	begin
						  		next_state=IDLE;
						 	end	    

				ZERO: 	begin
						  	next_state=IDLE;
					  	end

				REAL:	begin
							a_next=a_reg-b;
							counter_real_next=counter_real_reg+1;
							if(a_next>=b)
								next_state=REAL;
							else if (a_next==0)
								next_state=RESULT;
							else begin	
								next_state=FRACTION;
								a_f_next=a_next*10;
								counter_fraction_next=0;
								precision_next=3;	
					  	end	end

				FRACTION:	begin
								if(precision_reg>0) begin
									a_f_next=a_f_reg-b;
									counter_fraction_next=counter_fraction_reg+1;
									if(a_f_next>=b)
										next_state=FRACTION;
									else if(a_f_next==0) begin		
										next_state=RESULT;
										memory[precision_reg]=counter_fraction_next;
									end
									else begin
										next_state=FRACTION;
										a_f_next=a_f_next*10;
										memory[precision_reg]=counter_fraction_next;
										precision_next=precision_reg-1;
										counter_fraction_next=0;
									end
								end		
								else
										next_state=RESULT;	

							end	  	    

				RESULT: next_state=IDLE;
			endcase
			
			always@(*) 
				case(current_state)
					RESULT: begin m=counter_real_reg; f=memory[3]*100+memory[2]*10+memory[1]; end
					ZERO: begin m=0; f=0; end
					INVALID: begin m='bx; f='bx; end
					default: begin m='bz; f='bz; end
			endcase			
endmodule

module dividor_tb #(parameter SIZE=4) ();
		reg clk, rst, start;
		reg [SIZE-1:0] a, b;
		wire [SIZE-1:0] m;
		wire [9:0] f;
		dividor_rtl #(.SIZE(SIZE)) dut (clk, rst, start, a, b, m, f);

		initial begin
			clk=0;
			forever 
				#10 clk=~clk;
		end

		initial begin
			rst=1;
			@(negedge clk);
			rst=0;
			start=1;
			@(negedge clk);
			start=0;
			a=1; b=3;
			repeat(15) @(negedge clk);
			start=1;
			@(negedge clk);
			start=0;
			a=10; b=3;
			repeat(15) @(negedge clk);
			start=1;
			@(negedge clk);
			start=0;
			a=0; b=3;
			repeat(15) @(negedge clk);
			start=1;
			@(negedge clk);
			start=0;
			a=15; b=0;
			repeat(15) @(negedge clk);
			start=1;
			@(negedge clk);
			start=0;
			a=1; b=3;
			repeat(15) @(negedge clk);
			$stop;
		end
endmodule








 