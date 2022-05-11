// EEET2162 - HDMI Project

module EEET2162-HDMI_Project (
	
	input clock_50;				// System Clock of 50MHz
	
	output HDMI_TX_D;				// Video Data to ADV7513
	output HDMI_TX_CLK;			// Video Clock to ADV7513
	output HDMI_TX_HS;			// Horizontal Sync to ADV7513 
	output HDMI_TX_VS;			// Vertical Sync to ADV7513 
	output HDMI_TX_DE;			// Data Enable Signal to ADV7513 
	
	input HDMI_TX_INT;			// Interrupt signal from ADV7513
	inout I2C_SDA;					// I2C Data, can go between FPGA and ADV7513
	output I2C_SCL;				// I2C Clock to ADV7513
)

addressDecoder 

endmodule
