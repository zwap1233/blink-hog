`timescale 1 ns / 1 ps

	//Based on https://zipcpu.com/blog/2019/01/12/demoaxilite.html
	//this function had been verified on 10/02/2026

	module Blink_slave_lite_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY,

		output wire [C_S_AXI_DATA_WIDTH-1:0] reg_0,
		output wire [C_S_AXI_DATA_WIDTH-1:0] reg_1,
		output wire [C_S_AXI_DATA_WIDTH-1:0] reg_2,
		output wire [C_S_AXI_DATA_WIDTH-1:0] reg_3
	);

	reg axi_awready;
	reg axi_arready;
	reg axi_rvalid;
	reg axi_bvalid;

	wire [C_S_AXI_ADDR_WIDTH-3:0] awskd_addr;
	wire [C_S_AXI_ADDR_WIDTH-3:0] arskd_addr;
	wire [C_S_AXI_DATA_WIDTH-1:0] wskd_data;
	wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] wskd_strb;

	reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;

	wire axi_read_ready;
	
	assign reg_0 = r0;
	assign reg_1 = r1;
	assign reg_2 = r2;
	assign reg_3 = r3;

	assign S_AXI_ARREADY = axi_arready;
	assign S_AXI_AWREADY = axi_awready;
	assign S_AXI_WREADY = axi_awready;
	assign S_AXI_RVALID = axi_rvalid;
	assign S_AXI_BVALID = axi_bvalid;

	assign 	awskd_addr = S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH-1:2];
	assign	arskd_addr = S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH-1:2];
	assign	wskd_data  = S_AXI_WDATA;
	assign	wskd_strb  = S_AXI_WSTRB;

	assign	axi_read_ready = (S_AXI_ARVALID && S_AXI_ARREADY);

	assign S_AXI_RDATA = axi_rdata;

	assign	S_AXI_BRESP = 2'b00;
	assign	S_AXI_RRESP = 2'b00;

	reg [C_S_AXI_DATA_WIDTH-1:0] r0, r1, r2, r3;
	initial begin
		r0 = 0;
		r1 = 0;
		r2 = 0;
		r3 = 0;
	end

	wire [C_S_AXI_DATA_WIDTH-1:0] wskd_r0, wskd_r1, wskd_r2, wskd_r3;

	assign	wskd_r0 = apply_wstrb(r0, wskd_data, wskd_strb);
	assign	wskd_r1 = apply_wstrb(r1, wskd_data, wskd_strb);
	assign	wskd_r2 = apply_wstrb(r2, wskd_data, wskd_strb);
	assign	wskd_r3 = apply_wstrb(r3, wskd_data, wskd_strb);

	wire i_reset = !S_AXI_ARESETN;
	wire i_clk = S_AXI_ACLK;
	
	always @(posedge i_clk)
	begin
		if(i_reset)
		begin
			r0 <= 0;
			r1 <= 0;
			r2 <= 0;
			r3 <= 0;
		end
		else if (S_AXI_WREADY)
		begin
			case (awskd_addr)
			2'b00: r0 <= wskd_r0;
			2'b01: r1 <= wskd_r1;
			2'b10: r2 <= wskd_r2;
			2'b11: r3 <= wskd_r3;
			endcase	
		end
	end

	always @(posedge i_clk)
		if (!S_AXI_RVALID || S_AXI_RREADY)
		begin
		case(arskd_addr)
			2'b00:	axi_rdata	<= r0;
			2'b01:	axi_rdata	<= r1;
			2'b10:	axi_rdata	<= r2;
			2'b11:	axi_rdata	<= r3;
			endcase
		end

	initial	axi_bvalid = 0;
	always @(posedge i_clk)
		if (i_reset)
			axi_bvalid <= 0;
		else if (S_AXI_WREADY)
			axi_bvalid <= 1;
		else if (S_AXI_BREADY)
			axi_bvalid <= 0;

	initial	axi_rvalid = 1'b0;
	always @(posedge i_clk)
		if (i_reset)
			axi_rvalid <= 1'b0;
		else if (axi_read_ready)
			axi_rvalid <= 1'b1;
		else if (S_AXI_RREADY)
			axi_rvalid <= 1'b0;
	
	initial	axi_awready = 1'b0;
	always @(posedge S_AXI_ACLK)
		if (i_reset)
			axi_awready <= 1'b0;
		else
			axi_awready <= !axi_awready
				&& (S_AXI_AWVALID && S_AXI_WVALID)
				&& (!S_AXI_BVALID || S_AXI_BREADY);

	always @(*)
		axi_arready = !S_AXI_RVALID;

	function [C_S_AXI_DATA_WIDTH-1:0] apply_wstrb;
		input	[C_S_AXI_DATA_WIDTH-1:0] prior_data;
		input	[C_S_AXI_DATA_WIDTH-1:0] new_data;
		input	[C_S_AXI_DATA_WIDTH/8-1:0] wstrb;

		integer	k;
		for(k=0; k<C_S_AXI_DATA_WIDTH/8; k=k+1)
		begin
			apply_wstrb[k*8 +: 8]
				= wstrb[k] ? new_data[k*8 +: 8] : prior_data[k*8 +: 8];
		end
	endfunction
	
	endmodule
