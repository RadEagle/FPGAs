`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:05 01/07/2021 
// Design Name: 
// Module Name:    converter
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
module converter(D, S, output_data);
	input [12:0] D;
	output S;
	output [12:0] output_data;
	
	reg [11:0] c;
    
   // assign D = -4094;
   assign S = D >> 12;
   
   always @* begin
       if (S == 1)
           c = ~D + 1;
       else
           c = D;
            
       if (D == 'b1_0000_0000_0000)
           c = c - 1;
   end
    
   assign output_data = c;
	
endmodule
