
module addressDecoder (
	input en;
	input [3:0] addIn;
	output reg [7:0] addOut;
);

always @(en, addIn)
	begin
		if (en)
			begin
				case (addIn)
				3'b000: addOut = 8'b00000000;
				3'b001: addOut = 8'b00000000;
				3'b010: addOut = 8'b00000000;
				3'b011: addOut = 8'b00000000;
				3'b100: addOut = 8'b00000000;
				3'b101: addOut = 8'b00000000;
				3'b110: addOut = 8'b00000000;
				3'b111: addOut = 8'b00000000;
				default: addOut = 8'b00000000;
			end
	end

endmodule
