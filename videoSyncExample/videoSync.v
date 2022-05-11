//TLE for the example generated video sync, but no pattern generator 

module videoSync(clk_in,globalReset_n,adv7511_hs,adv7511_vs,adv7511_clk,adv7511_d,adv7511_de,pb);

//MODE_720p /* FORMAT 4 */
//parameter INTERLACED = 1'b0;
parameter V_TOTAL_0 = 12'd750;
parameter V_FP_0 = 12'd5;
parameter V_BP_0 = 12'd20;
parameter V_SYNC_0 = 12'd5;
parameter V_TOTAL_1 = 12'd0;
parameter V_FP_1 = 12'd0;
parameter V_BP_1 = 12'd0;
parameter V_SYNC_1 = 12'd0;
parameter H_TOTAL = 12'd1650;
parameter H_FP = 12'd110;
parameter H_BP = 12'd220;
parameter H_SYNC = 12'd40;
parameter HV_OFFSET_0 = 12'd0;
parameter HV_OFFSET_1 = 12'd0;
parameter PATTERN_RAMP_STEP = 20'h0333; // 20'hFFFFF / 1280 act_pixels per line = 20'h0333
//parameter PATTERN_TYPE = 8'd1; // BORDER.
parameter PATTERN_TYPE = 8'd4; // RAMP

input clk_in;
input globalReset_n;
input [5:0] pb;

output adv7511_clk;	 	// ADV7511: CLK
output reg adv7511_hs; 			// HS output to ADV7511
output reg adv7511_vs; 			// VS output to ADV7511
output reg [35:0] adv7511_d; 	// data
output reg adv7511_de; 			// ADV7511: DE

wire reset;
assign reset = !globalReset_n;

wire [11:0] x_out;
wire [12:0] y_out;
wire [7:0] r_out;
wire [7:0] g_out;
wire [7:0] b_out;
/* ********************* */
//now call the video sync module 

sync_video #(.X_BITS(12), .Y_BITS(12)) video1(

 .clk(clk_in),
 .reset(reset),
 .clk_out(), // inverted output clock - unconnected
 .v_total_0(V_TOTAL_0),
 .v_fp_0(V_FP_0),
 .v_bp_0(V_BP_0),
 .v_sync_0(V_SYNC_0),
 .v_total_1(V_TOTAL_1),
 .v_fp_1(V_FP_1),
 .v_bp_1(V_BP_1),
 .v_sync_1(V_SYNC_1),
 .h_total(H_TOTAL),
 .h_fp(H_FP),
 .h_bp(H_BP),
 .h_sync(H_SYNC),
 .hv_offset_0(HV_OFFSET_0),
 .hv_offset_1(HV_OFFSET_1),
 .vs_out_wire(vs), 
 .hs_out_wire(hs), 
 .de_out_wire(de),
 .v_count_out(),
 .h_count_out(),
 .x_out(x_out),
 .y_out(y_out),
 .field_out(field)
);

/* ********************* */
// B - Bits per channel
pattern_vg #(.B(8), .X_BITS(12), .Y_BITS(12), .FRACTIONAL_BITS(12)) pattern1(
 .reset(reset),
 .clk_in(clk_in),
 .x(x_out),
 .y(y_out[11:0]),
 .vn_in(vs),
 .hn_in(hs),
 .dn_in(de),
 .r_in(8'h0), // default red channel value
 .g_in(8'h0), // default green channel value
 .b_in(8'h0), // default blue channel value
 .vn_out(vs_out),
 .hn_out(hs_out),
 .den_out(de_out),
 .r_out(r_out),
 .g_out(g_out),
 .b_out(b_out),
 .total_active_pix(H_TOTAL - (H_FP + H_BP + H_SYNC)), // (1920) // h_total - (h_fp+h_bp+h_sync)
 .total_active_lines((V_TOTAL_0 - (V_FP_0 + V_BP_0 + V_SYNC_0))), // originally: 13'd480
 .pattern(PATTERN_TYPE),
 .ramp_step(PATTERN_RAMP_STEP)
 );

 assign adv7511_clk = ~clk_in;

/* ********************* */


always @(posedge clk_in)
begin
 adv7511_d[35:24] <= { r_out, 4'b0 };
 adv7511_d[23:12] <= { g_out, 4'b0 };
 adv7511_d[11:0] <= { b_out, 4'b0 };
 adv7511_hs <= hs_out;
 adv7511_vs <= vs_out;
 adv7511_de <= de_out;
end

endmodule 
