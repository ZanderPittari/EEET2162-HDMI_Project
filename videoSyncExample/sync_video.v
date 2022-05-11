//example module for the generated video sync adv7511

//questions: 
/*
 - do we need interlaced or noninterlaced video standard?
*/
module sync_video(clk, reset,v_total_0, v_fp_0,v_bp_0,v_sync_0,
v_total_1,v_fp_1,v_bp_1,v_sync_1,h_total, h_fp, h_bp, h_sync, hv_offset_0,hv_offset_1,
vs_out_wire, hs_out_wire, de_out_wire, v_count_out, h_count_out, x_out, y_out, field_out, clk_out);

parameter X_BITS=12;
parameter Y_BITS=12;

input clk;
input reset;
input [Y_BITS-1:0] v_total_0;
input [Y_BITS-1:0] v_fp_0;
input [Y_BITS-1:0] v_bp_0;
input [Y_BITS-1:0] v_sync_0;
input [Y_BITS-1:0] v_total_1;
input [Y_BITS-1:0] v_fp_1;
input [Y_BITS-1:0] v_bp_1;
input [Y_BITS-1:0] v_sync_1;
input [X_BITS-1:0] h_total;
input [X_BITS-1:0] h_fp;
input [X_BITS-1:0] h_bp;
input [X_BITS-1:0] h_sync;
input [X_BITS-1:0] hv_offset_0;
input [X_BITS-1:0] hv_offset_1;
output vs_out_wire;				
output hs_out_wire;
output de_out_wire;
output reg [Y_BITS:0] v_count_out;
output reg [X_BITS-1:0] h_count_out;
output reg [X_BITS-1:0] x_out;
output reg [Y_BITS:0] y_out;
output reg field_out;
output clk_out;
//parameters and inputs/outputs are now defined 

/*
#( parameter X_BITS=12,Y_BITS=12)
*/
reg vs_out;
reg hs_out;
reg de_out;
reg [X_BITS-1:0] h_count;
reg [Y_BITS-1:0] v_count;
reg field;
reg [Y_BITS-1:0] v_total;
reg [Y_BITS-1:0] v_fp;
reg [Y_BITS-1:0] v_bp;
reg [Y_BITS-1:0] v_sync;
reg [X_BITS-1:0] hv_offset;
assign clk_out = !clk;				//inverting clock --> check this

/* horizontal counter =========================*/
always @(posedge(clk))
	begin
	 if (reset)
		h_count <= 0;
	 else
		begin
		if (h_count < h_total - 1)
			h_count <= h_count + 1;
		else
			h_count <= 0;
		end
	end
 
/* vertical counter ===========================*/ 
always @(posedge(clk))
	begin
	 if (reset)
		v_count <= 0;
	 else
		if (h_count == h_total - 1)
		begin
			if (v_count == v_total - 1)
				v_count <= 0;
			else
				v_count <= v_count + 1;
		end
	end
	
/* field ======================================*/
always @(posedge(clk))
	begin
	 if (reset)
		 begin
		 field 	<= 0;
		 v_total <= v_total_0;
		 v_fp 	<= v_fp_0; 		//this is non-interlaced mode
		 v_bp 	<= v_bp_0;
		 v_sync 	<= v_sync_0;
		 hv_offset <= hv_offset_0;
		 end
	else if ((v_count == v_total - 1) && (h_count == h_total - 1))
		 begin
			 field 	<= field;
			 v_total <= v_total_1;
			 v_fp 	<= v_fp_0; 				// This order is not inverted due to non-interlaced mode
			 v_bp 	<= v_bp_1;
			 v_sync 	<= v_sync_1;
			 hv_offset <= hv_offset_1;
		 end
	end
	
always @(posedge clk)
	begin
		if (reset)
			begin
			 vs_out <= 1'b0; 
			 hs_out <= 1'b0; 
			 de_out <= 1'b0; 
			 field_out <= 1'b0;
			end
		else 
			begin
			 hs_out <= ((h_count < h_sync));
			 de_out <= (((v_count >= v_sync + v_bp) && (v_count <= v_total - v_fp - 1)) && ((h_count >= h_sync + h_bp) && (h_count <= h_total - h_fp - 1)));
			 if ((v_count == 0) && (h_count == hv_offset))
				vs_out <= 1'b1;
			 else if ((v_count == v_sync) && (h_count == hv_offset))
				vs_out <= 1'b0;
				
				/* H_COUNT_OUT and V_COUNT_OUT */
				h_count_out <= h_count;
			 if (field)
				v_count_out <= v_count + v_total_0;
			 else
				v_count_out <= v_count;
				/* X and Y coords – for a backend pattern generator */
				x_out <= h_count - (h_sync + h_bp);
				y_out <= { 1'b0, (v_count - (v_sync + v_bp)) }; 	//assigns first bit 0, second bit as the vcount result
				field_out <= field;
			end
	end

	//my addition
	assign vs_out_wire = vs_out;
	assign hs_out_wire = hs_out;
	assign de_out_wire = de_out;
	
endmodule 