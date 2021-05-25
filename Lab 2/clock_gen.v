`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:28:45 02/07/2021 
// Design Name: 
// Module Name:    clock_gen 
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
module clock_gen(input clk_in, 
	input rst,
	output clk_div_2,
	output clk_div_4,
	output clk_div_8,
	output clk_div_16,
	output clk_div_28,
	output clk_div_5,
	output [7:0] toggle_counter
   );
	
	clock_div_two task_one(
	 .clk_in (clk_in),
	 .rst (rst),
	 .clk_div_2(clk_div_2),
	 .clk_div_4(clk_div_4),
	 .clk_div_8(clk_div_8),
	 .clk_div_16(clk_div_16)
	);
	
	clock_div_twenty_eight task_two(
	 .clk_in (clk_in),
	 .rst (rst),
	 .clk_div_28(clk_div_28)
	);
	
	clock_div_five task_three(
	 .clk_in (clk_in),
	 .rst (rst),
	 .clk_div_5(clk_div_5)
	);
	
	clock_strobe task_four(
	 .clk_in (clk_in),
	 .rst (rst),
	 .toggle_counter (toggle_counter)
	); 
	
endmodule

module clock_div_two(clk_in, rst, clk_div_2, clk_div_4, clk_div_8, clk_div_16);
	input clk_in;
	input rst;
	output clk_div_2;
	output clk_div_4;
	output clk_div_8;
	output clk_div_16;
	
	reg [3:0] a;
	
	always @ (posedge clk_in)
		if (rst)
			a <= 4'b0000;
		else
			a <= a + 1'b1;
			
	assign clk_div_2 = a[0];
	assign clk_div_4 = a[1];
	assign clk_div_8 = a[2];
	assign clk_div_16 = a[3];

endmodule

module clock_div_twenty_eight(clk_in, rst, clk_div_28);
	input clk_in;
	input rst;
	output clk_div_28;
	
	reg [3:0] a;
	reg b;
	
	always @ (posedge clk_in)
		if (rst) begin
			a <= 4'b0000;
			b <= 1'b0;
		end
		else if (a == 4'b1101) begin
			a <= 4'b0000;
			b <= ~b;
		end
		else
			a <= a + 1'b1;
			
	assign clk_div_28 = b;

endmodule

module clock_div_five(clk_in, rst, clk_div_5);

	input clk_in;
	input rst;
	output clk_div_5;
	
	reg a;
	reg [2:0] b;
	reg c;
	
	always @ (posedge clk_in) begin
		if (rst) begin
			a <= 1'b0;
			b <= 4'b0000;
		end
		else if (a == 0 && b == 0) begin
			a <= ~a;
			b <= b + 1'b1;
		end
		else if (b == 2) begin
			a <= ~a;
			b <= b + 1'b1;
		end
		else if (b == 4) begin
			b <= 0;
		end
		else
			b <= b + 1'b1;
	end
			
	always @ (negedge clk_in)
		if (rst)
			c <= 1'b0;
		else
			c <= a;
	
	assign clk_div_5 = a | c;
	
endmodule

module clock_strobe(clk_in, rst, toggle_counter);
	input clk_in;
	input rst;
	output [7:0] toggle_counter;
	
	reg [1:0] a;
	reg [7:0] sum;
	
	always @ (posedge clk_in) begin
		if (rst) begin
			a <= 0;
			sum <= 0;
		end
		else if (a == 3) begin
			a <= a + 1'b1;
			sum <= sum - 3'b101;
		end
		else begin
			a <= a + 1'b1;
			sum <= sum + 2'b10;
		end
	end
	
	assign toggle_counter = sum;

endmodule
