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
			a=9; b=3;
			repeat(15) @(negedge clk);
			$stop;
		end
endmodule








 