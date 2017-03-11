`timescale 1ns / 1ps

module vga(
	input clk,            // 50MHzʱ��
	input rst,            // ��λ
	output vgaclk,        // VGA�ź�ʱ��
	output [8:0]row,      // ��ǰ����
	output [9:0]column,   // ��ǰ����
	input [7:0]color,     // ��ǰ��ɫ��BBGGGRR��
	output [2:0]vgaRed,   // VGA��ɫͨ��
	output [2:0]vgaGreen, // VGA��ɫͨ��
	output [1:0]vgaBlue,  // VGA��ɫͨ��
	output vgaHsync,      // VGAˮƽͬ��
	output vgaVsync       // VGA��ֱͬ��
);

	// ʱ��
	// ��껬B�� 640x480@50Hz
	parameter CLKF = 25;      // ʱ��Ƶ�ʣ�25��50��
	parameter H_SYNC = 96;    // ��ͬ���źţ�vgaclk��������
	parameter H_BEGIN = 144;  // ��������ʼ��
	parameter H_END = 784;    // �����ݽ�����+1
	parameter H_PERIOD = 800; // �г���
	parameter V_SYNC = 2;     // ��ͬ���źţ�������
	parameter V_BEGIN = 31;   // ��������ʼ��
	parameter V_END = 511;    // �����ݽ�����+1
	parameter V_PERIOD = 521; // ������

	wire clk25;
	counter16 clk25c(clk, rst, 2, clk25);
	assign vgaclk = (CLKF == 50) ? clk : clk25;

	wire [9:0]hcount;
	counter16 hc(vgaclk, rst, H_PERIOD, hcount);
	assign vgaHsync = (hcount < H_SYNC) ? 0 : 1;
	assign column = hcount - H_BEGIN;

	wire [9:0]vcount;
	counter16 vc(~(hcount[9]), rst, V_PERIOD, vcount);
	assign vgaVsync = (vcount < V_SYNC) ? 0 : 1;
	assign row = vcount - V_BEGIN;

	wire de;
	assign de = (vcount >= V_BEGIN) && (vcount < V_END) && (hcount >= H_BEGIN) && (hcount < H_END);
	assign vgaRed = de ? color[2:0] : 0;
	assign vgaGreen = de ? color[5:3] : 0;
	assign vgaBlue = de ? color[7:6] : 0;

endmodule
