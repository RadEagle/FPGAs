`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:23 01/07/2021 
// Design Name: 
// Module Name:    FPCTV 
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
module FPCTV(D, S, E, F);
	input D;
	output S, E, F;
	
	wire [12:0] D;
	wire S;
	wire [2:0] E;
	wire [4:0] F;
	
	wire [12:0] output_data;
	wire [2:0] exp;
	wire [4:0] sig;
	wire sixth_bit;

	converter part1(.D(D), .S(S), .output_data(output_data));
	extractor part2(.output_data(output_data), .exp(exp), .sig(sig), .sixth_bit(sixth_bit));
	rounder part3(.exp(exp), .sig(sig), .sixth_bit(sixth_bit), .E(E), .F(F));

endmodule
