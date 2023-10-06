/* ACM Class System (I) Fall Assignment 1 
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder_8bit (
	input [7:0] a, 
	input [7:0] b, 
	input cin, 
	output [7:0] s, 
	output cout
);
	wire [7:0] g;
	wire [7:0] p;
	wire [7:0] c;
	wire [7:0] t;

	assign g = a & b;
	assign p = a | b;
	assign t = ~g&p;
	assign cout = c[7];
	
	assign c[0] = g[0] | p[0] & cin;
	assign c[1] = g[1] | p[1] & g[0] | p[1] & p[0] & cin;
	assign c[2] = g[2] | g[1]&p[2] | g[0]&p[2]&p[1] | p[2]&p[1]&p[0]&cin;
	assign c[3] = g[3] | p[3]&g[2] | p[3]*p[2]*g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&cin;
	assign c[4] = g[4] | p[4]&g[3] | p[4]*p[3]*g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&g[0] | p[4]&p[3]&p[2]&p[1]&p[0]&cin;
	assign c[5] = g[5] | p[5]&g[4] | p[5]*p[4]*g[3] | p[5]&p[4]&p[3]&g[2] | p[5]&p[4]&p[3]&p[2]&g[1] | p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;
	assign c[6] = g[6] | p[6]&g[5] | p[6]*p[5]*g[4] | p[6]&p[5]&p[4]&g[3] | p[6]&p[5]&p[4]&p[3]&g[2] | p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;
	assign c[7] = g[7] | p[7]&g[6] | p[7]*p[6]*g[5] | p[7]&p[6]&p[5]&g[4] | p[7]&p[6]&p[5]&p[4]&g[3] | p[7]&p[6]&p[5]&p[4]&p[3]&g[2] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;

	assign s[0] = t[0]^cin;
	assign s[1] = t[1]^c[0];
	assign s[2] = t[2]^c[1];
	assign s[3] = t[3]^c[2];
	assign s[4] = t[4]^c[3];
	assign s[5] = t[5]^c[4];
	assign s[6] = t[6]^c[5];
	assign s[7] = t[7]^c[6];

endmodule

module adder_32bit (input [31:0] a, input [31:0] b, input cin, output [31:0] s, output c);
	wire [3:0] carry;

	adder_8bit Adder0 (a[7:0], b[7:0], cin, s[7:0], carry[0]);
	adder_8bit Adder1 (a[15:8], b[15:8], carry[0], s[15:8], carry[1]);
	adder_8bit Adder2 (a[23:16], b[23:16], carry[1], s[23:16], carry[2]);
	adder_8bit Adder3 (a[31:24], b[31:24], carry[2], s[31:24], carry[3]);

	assign c = carry[3];
endmodule

module Add(
	input [31:0] a,
	input [31:0] b,
	output reg [31:0] sum,
	output reg carry
);
	wire zero = 0;
	wire [31:0] s;
	wire c;
	adder_32bit Adder (a, b, zero, s, c);
	always @(*) begin
		sum <= s;
		carry <= c;
	end
	
endmodule