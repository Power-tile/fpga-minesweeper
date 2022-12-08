`timescale 1ns / 1ps

module CharMap(
        input [7:0] ascii,
        input [2:0] col,
        output wire [7:0] pixels
    );

reg [7:0] pixelsRaw;

assign pixels = ascii[7] ? (~pixelsRaw & 8'd127) : pixelsRaw;

always @(*) begin
    case ({col, 1'b0, ascii[6:0]})
        // 8'h21: !
        11'h021: pixelsRaw <= 8'b00000000;
        11'h121: pixelsRaw <= 8'b00000000;
        11'h221: pixelsRaw <= 8'b00000000;
        11'h321: pixelsRaw <= 8'b00000110;
        11'h421: pixelsRaw <= 8'b01011111;
        11'h521: pixelsRaw <= 8'b01011111;
        11'h621: pixelsRaw <= 8'b00000110;
        11'h721: pixelsRaw <= 8'b00000000;
        // 8'h22: "
        11'h022: pixelsRaw <= 8'b00000000;
        11'h122: pixelsRaw <= 8'b00000000;
        11'h222: pixelsRaw <= 8'b00000011;
        11'h322: pixelsRaw <= 8'b00000011;
        11'h422: pixelsRaw <= 8'b00000000;
        11'h522: pixelsRaw <= 8'b00000011;
        11'h622: pixelsRaw <= 8'b00000011;
        11'h722: pixelsRaw <= 8'b00000000;
        // 8'h23: #
        11'h023: pixelsRaw <= 8'b00010100;
        11'h123: pixelsRaw <= 8'b01111111;
        11'h223: pixelsRaw <= 8'b01111111;
        11'h323: pixelsRaw <= 8'b00010100;
        11'h423: pixelsRaw <= 8'b01111111;
        11'h523: pixelsRaw <= 8'b01111111;
        11'h623: pixelsRaw <= 8'b00010100;
        11'h723: pixelsRaw <= 8'b00000000;
        // 8'h24: $
        11'h024: pixelsRaw <= 8'b00000000;
        11'h124: pixelsRaw <= 8'b00100100;
        11'h224: pixelsRaw <= 8'b00101110;
        11'h324: pixelsRaw <= 8'b01101011;
        11'h424: pixelsRaw <= 8'b01101011;
        11'h524: pixelsRaw <= 8'b00111010;
        11'h624: pixelsRaw <= 8'b00010010;
        11'h724: pixelsRaw <= 8'b00000000;
        // 8'h25: %
        11'h025: pixelsRaw <= 8'b01000110;
        11'h125: pixelsRaw <= 8'b01100110;
        11'h225: pixelsRaw <= 8'b00110000;
        11'h325: pixelsRaw <= 8'b00011000;
        11'h425: pixelsRaw <= 8'b00001100;
        11'h525: pixelsRaw <= 8'b01100110;
        11'h625: pixelsRaw <= 8'b01100010;
        11'h725: pixelsRaw <= 8'b00000000;
        // 8'h26: &
        11'h026: pixelsRaw <= 8'b00110000;
        11'h126: pixelsRaw <= 8'b01111010;
        11'h226: pixelsRaw <= 8'b01001111;
        11'h326: pixelsRaw <= 8'b01011101;
        11'h426: pixelsRaw <= 8'b00110111;
        11'h526: pixelsRaw <= 8'b01111010;
        11'h626: pixelsRaw <= 8'b01001000;
        11'h726: pixelsRaw <= 8'b00000000;
        // 8'h27: '
        11'h027: pixelsRaw <= 8'b00000000;
        11'h127: pixelsRaw <= 8'b00000100;
        11'h227: pixelsRaw <= 8'b00000111;
        11'h327: pixelsRaw <= 8'b00000011;
        11'h427: pixelsRaw <= 8'b00000000;
        11'h527: pixelsRaw <= 8'b00000000;
        11'h627: pixelsRaw <= 8'b00000000;
        11'h727: pixelsRaw <= 8'b00000000;
        // 8'h28: (
        11'h028: pixelsRaw <= 8'b00000000;
        11'h128: pixelsRaw <= 8'b00000000;
        11'h228: pixelsRaw <= 8'b00011100;
        11'h328: pixelsRaw <= 8'b00111110;
        11'h428: pixelsRaw <= 8'b01100011;
        11'h528: pixelsRaw <= 8'b01000001;
        11'h628: pixelsRaw <= 8'b00000000;
        11'h728: pixelsRaw <= 8'b00000000;
        // 8'h29: )
        11'h029: pixelsRaw <= 8'b00000000;
        11'h129: pixelsRaw <= 8'b00000000;
        11'h229: pixelsRaw <= 8'b01000001;
        11'h329: pixelsRaw <= 8'b01100011;
        11'h429: pixelsRaw <= 8'b00111110;
        11'h529: pixelsRaw <= 8'b00011100;
        11'h629: pixelsRaw <= 8'b00000000;
        11'h729: pixelsRaw <= 8'b00000000;
        // 8'h2a: *
        11'h02a: pixelsRaw <= 8'b00001000;
        11'h12a: pixelsRaw <= 8'b00101010;
        11'h22a: pixelsRaw <= 8'b00111110;
        11'h32a: pixelsRaw <= 8'b00011100;
        11'h42a: pixelsRaw <= 8'b00011100;
        11'h52a: pixelsRaw <= 8'b00111110;
        11'h62a: pixelsRaw <= 8'b00101010;
        11'h72a: pixelsRaw <= 8'b00001000;
        // 8'h2b: +
        11'h02b: pixelsRaw <= 8'b00000000;
        11'h12b: pixelsRaw <= 8'b00001000;
        11'h22b: pixelsRaw <= 8'b00001000;
        11'h32b: pixelsRaw <= 8'b00111110;
        11'h42b: pixelsRaw <= 8'b00111110;
        11'h52b: pixelsRaw <= 8'b00001000;
        11'h62b: pixelsRaw <= 8'b00001000;
        11'h72b: pixelsRaw <= 8'b00000000;
        // 8'h2c: ,
        11'h02c: pixelsRaw <= 8'b00000000;
        11'h12c: pixelsRaw <= 8'b00000000;
        11'h22c: pixelsRaw <= 8'b10000000;
        11'h32c: pixelsRaw <= 8'b11100000;
        11'h42c: pixelsRaw <= 8'b01100000;
        11'h52c: pixelsRaw <= 8'b00000000;
        11'h62c: pixelsRaw <= 8'b00000000;
        11'h72c: pixelsRaw <= 8'b00000000;
        // 8'h2d: -
        11'h02d: pixelsRaw <= 8'b00000000;
        11'h12d: pixelsRaw <= 8'b00001000;
        11'h22d: pixelsRaw <= 8'b00001000;
        11'h32d: pixelsRaw <= 8'b00001000;
        11'h42d: pixelsRaw <= 8'b00001000;
        11'h52d: pixelsRaw <= 8'b00001000;
        11'h62d: pixelsRaw <= 8'b00001000;
        11'h72d: pixelsRaw <= 8'b00000000;
        // 8'h2e: .
        11'h02e: pixelsRaw <= 8'b00000000;
        11'h12e: pixelsRaw <= 8'b00000000;
        11'h22e: pixelsRaw <= 8'b00000000;
        11'h32e: pixelsRaw <= 8'b01100000;
        11'h42e: pixelsRaw <= 8'b01100000;
        11'h52e: pixelsRaw <= 8'b00000000;
        11'h62e: pixelsRaw <= 8'b00000000;
        11'h72e: pixelsRaw <= 8'b00000000;
        // 8'h2f: /
        11'h02f: pixelsRaw <= 8'b01100000;
        11'h12f: pixelsRaw <= 8'b00110000;
        11'h22f: pixelsRaw <= 8'b00011000;
        11'h32f: pixelsRaw <= 8'b00001100;
        11'h42f: pixelsRaw <= 8'b00000110;
        11'h52f: pixelsRaw <= 8'b00000011;
        11'h62f: pixelsRaw <= 8'b00000001;
        11'h72f: pixelsRaw <= 8'b00000000;
        // 8'h30: 0
        11'h030: pixelsRaw <= 8'd62;
        11'h130: pixelsRaw <= 8'd127;
        11'h230: pixelsRaw <= 8'd113;
        11'h330: pixelsRaw <= 8'd89;
        11'h430: pixelsRaw <= 8'd77;
        11'h530: pixelsRaw <= 8'd127;
        11'h630: pixelsRaw <= 8'd62;
        11'h730: pixelsRaw <= 8'd0;
        // 8'h31: 1
        11'h031: pixelsRaw <= 8'd0;
        11'h131: pixelsRaw <= 8'd64;
        11'h231: pixelsRaw <= 8'd66;
        11'h331: pixelsRaw <= 8'd127;
        11'h431: pixelsRaw <= 8'd127;
        11'h531: pixelsRaw <= 8'd64;
        11'h631: pixelsRaw <= 8'd64;
        11'h731: pixelsRaw <= 8'd0;
        // 8'h32: 2
        11'h032: pixelsRaw <= 8'd0;
        11'h132: pixelsRaw <= 8'd98;
        11'h232: pixelsRaw <= 8'd115;
        11'h332: pixelsRaw <= 8'd89;
        11'h432: pixelsRaw <= 8'd73;
        11'h532: pixelsRaw <= 8'd111;
        11'h632: pixelsRaw <= 8'd102;
        11'h732: pixelsRaw <= 8'd0;
        // 8'h33: 3
        11'h033: pixelsRaw <= 8'd0;
        11'h133: pixelsRaw <= 8'd34;
        11'h233: pixelsRaw <= 8'd99;
        11'h333: pixelsRaw <= 8'd73;
        11'h433: pixelsRaw <= 8'd73;
        11'h533: pixelsRaw <= 8'd127;
        11'h633: pixelsRaw <= 8'd54;
        11'h733: pixelsRaw <= 8'd0;
        // 8'h34: 4
        11'h034: pixelsRaw <= 8'd24;
        11'h134: pixelsRaw <= 8'd28;
        11'h234: pixelsRaw <= 8'd22;
        11'h334: pixelsRaw <= 8'd83;
        11'h434: pixelsRaw <= 8'd127;
        11'h534: pixelsRaw <= 8'd127;
        11'h634: pixelsRaw <= 8'd80;
        11'h734: pixelsRaw <= 8'd0;
        // 8'h35: 5
        11'h035: pixelsRaw <= 8'd0;
        11'h135: pixelsRaw <= 8'd39;
        11'h235: pixelsRaw <= 8'd103;
        11'h335: pixelsRaw <= 8'd69;
        11'h435: pixelsRaw <= 8'd69;
        11'h535: pixelsRaw <= 8'd125;
        11'h635: pixelsRaw <= 8'd57;
        11'h735: pixelsRaw <= 8'd0;
        // 8'h36: 6
        11'h036: pixelsRaw <= 8'd0;
        11'h136: pixelsRaw <= 8'd60;
        11'h236: pixelsRaw <= 8'd126;
        11'h336: pixelsRaw <= 8'd75;
        11'h436: pixelsRaw <= 8'd73;
        11'h536: pixelsRaw <= 8'd121;
        11'h636: pixelsRaw <= 8'd48;
        11'h736: pixelsRaw <= 8'd0;
        // 8'h37: 7
        11'h037: pixelsRaw <= 8'd0;
        11'h137: pixelsRaw <= 8'd3;
        11'h237: pixelsRaw <= 8'd3;
        11'h337: pixelsRaw <= 8'd113;
        11'h437: pixelsRaw <= 8'd121;
        11'h537: pixelsRaw <= 8'd15;
        11'h637: pixelsRaw <= 8'd7;
        11'h737: pixelsRaw <= 8'd0;
        // 8'h38: 8
        11'h038: pixelsRaw <= 8'd0;
        11'h138: pixelsRaw <= 8'd54;
        11'h238: pixelsRaw <= 8'd127;
        11'h338: pixelsRaw <= 8'd73;
        11'h438: pixelsRaw <= 8'd73;
        11'h538: pixelsRaw <= 8'd127;
        11'h638: pixelsRaw <= 8'd54;
        11'h738: pixelsRaw <= 8'd0;
        // 8'h39: 9
        11'h039: pixelsRaw <= 8'd0;
        11'h139: pixelsRaw <= 8'd6;
        11'h239: pixelsRaw <= 8'd79;
        11'h339: pixelsRaw <= 8'd73;
        11'h439: pixelsRaw <= 8'd105;
        11'h539: pixelsRaw <= 8'd63;
        11'h639: pixelsRaw <= 8'd30;
        11'h739: pixelsRaw <= 8'd0;
        // 8'h3a: :
        11'h03a: pixelsRaw <= 8'b00000000;
        11'h13a: pixelsRaw <= 8'b00000000;
        11'h23a: pixelsRaw <= 8'b00000000;
        11'h33a: pixelsRaw <= 8'b01100110;
        11'h43a: pixelsRaw <= 8'b01100110;
        11'h53a: pixelsRaw <= 8'b00000000;
        11'h63a: pixelsRaw <= 8'b00000000;
        11'h73a: pixelsRaw <= 8'b00000000;
        // 8'h3b: ;
        11'h03b: pixelsRaw <= 8'b00000000;
        11'h13b: pixelsRaw <= 8'b00000000;
        11'h23b: pixelsRaw <= 8'b10000000;
        11'h33b: pixelsRaw <= 8'b11100110;
        11'h43b: pixelsRaw <= 8'b01100110;
        11'h53b: pixelsRaw <= 8'b00000000;
        11'h63b: pixelsRaw <= 8'b00000000;
        11'h73b: pixelsRaw <= 8'b00000000;
        // 8'h3c: <
        11'h03c: pixelsRaw <= 8'b00000000;
        11'h13c: pixelsRaw <= 8'b00001000;
        11'h23c: pixelsRaw <= 8'b00011100;
        11'h33c: pixelsRaw <= 8'b00110110;
        11'h43c: pixelsRaw <= 8'b01100011;
        11'h53c: pixelsRaw <= 8'b01000001;
        11'h63c: pixelsRaw <= 8'b00000000;
        11'h73c: pixelsRaw <= 8'b00000000;
        // 8'h3d: =
        11'h03d: pixelsRaw <= 8'b00000000;
        11'h13d: pixelsRaw <= 8'b00100100;
        11'h23d: pixelsRaw <= 8'b00100100;
        11'h33d: pixelsRaw <= 8'b00100100;
        11'h43d: pixelsRaw <= 8'b00100100;
        11'h53d: pixelsRaw <= 8'b00100100;
        11'h63d: pixelsRaw <= 8'b00100100;
        11'h73d: pixelsRaw <= 8'b00000000;
        // 8'h3e: >
        11'h03e: pixelsRaw <= 8'b00000000;
        11'h13e: pixelsRaw <= 8'b00000000;
        11'h23e: pixelsRaw <= 8'b01000001;
        11'h33e: pixelsRaw <= 8'b01100011;
        11'h43e: pixelsRaw <= 8'b00110110;
        11'h53e: pixelsRaw <= 8'b00011100;
        11'h63e: pixelsRaw <= 8'b00001000;
        11'h73e: pixelsRaw <= 8'b00000000;
        // 8'h3f: ?
        11'h03f: pixelsRaw <= 8'b00000000;
        11'h13f: pixelsRaw <= 8'b00000010;
        11'h23f: pixelsRaw <= 8'b00000011;
        11'h33f: pixelsRaw <= 8'b01010001;
        11'h43f: pixelsRaw <= 8'b01011001;
        11'h53f: pixelsRaw <= 8'b00001111;
        11'h63f: pixelsRaw <= 8'b00000110;
        11'h73f: pixelsRaw <= 8'b00000000;
        // 8'h40: @
        11'h040: pixelsRaw <= 8'b00111110;
        11'h140: pixelsRaw <= 8'b01111111;
        11'h240: pixelsRaw <= 8'b01000001;
        11'h340: pixelsRaw <= 8'b01011101;
        11'h440: pixelsRaw <= 8'b01011101;
        11'h540: pixelsRaw <= 8'b00011111;
        11'h640: pixelsRaw <= 8'b00011110;
        11'h740: pixelsRaw <= 8'b00000000;
        // 8'h41: A
        11'h041: pixelsRaw <= 8'd0;
        11'h141: pixelsRaw <= 8'd124;
        11'h241: pixelsRaw <= 8'd126;
        11'h341: pixelsRaw <= 8'd19;
        11'h441: pixelsRaw <= 8'd19;
        11'h541: pixelsRaw <= 8'd126;
        11'h641: pixelsRaw <= 8'd124;
        11'h741: pixelsRaw <= 8'd0;
        // 8'h42: B
        11'h042: pixelsRaw <= 8'd65;
        11'h142: pixelsRaw <= 8'd127;
        11'h242: pixelsRaw <= 8'd127;
        11'h342: pixelsRaw <= 8'd73;
        11'h442: pixelsRaw <= 8'd73;
        11'h542: pixelsRaw <= 8'd127;
        11'h642: pixelsRaw <= 8'd54;
        11'h742: pixelsRaw <= 8'd0;
        // 8'h43: C
        11'h043: pixelsRaw <= 8'd28;
        11'h143: pixelsRaw <= 8'd62;
        11'h243: pixelsRaw <= 8'd99;
        11'h343: pixelsRaw <= 8'd65;
        11'h443: pixelsRaw <= 8'd65;
        11'h543: pixelsRaw <= 8'd99;
        11'h643: pixelsRaw <= 8'd34;
        11'h743: pixelsRaw <= 8'd0;
        // 8'h44: D
        11'h044: pixelsRaw <= 8'd65;
        11'h144: pixelsRaw <= 8'd127;
        11'h244: pixelsRaw <= 8'd127;
        11'h344: pixelsRaw <= 8'd65;
        11'h444: pixelsRaw <= 8'd99;
        11'h544: pixelsRaw <= 8'd62;
        11'h644: pixelsRaw <= 8'd28;
        11'h744: pixelsRaw <= 8'd0;
        // 8'h45: E
        11'h045: pixelsRaw <= 8'd65;
        11'h145: pixelsRaw <= 8'd127;
        11'h245: pixelsRaw <= 8'd127;
        11'h345: pixelsRaw <= 8'd73;
        11'h445: pixelsRaw <= 8'd93;
        11'h545: pixelsRaw <= 8'd65;
        11'h645: pixelsRaw <= 8'd99;
        11'h745: pixelsRaw <= 8'd0;
        // 8'h46: F
        11'h046: pixelsRaw <= 8'd65;
        11'h146: pixelsRaw <= 8'd127;
        11'h246: pixelsRaw <= 8'd127;
        11'h346: pixelsRaw <= 8'd73;
        11'h446: pixelsRaw <= 8'd29;
        11'h546: pixelsRaw <= 8'd1;
        11'h646: pixelsRaw <= 8'd3;
        11'h746: pixelsRaw <= 8'd0;
        // 8'h47: G
        11'h047: pixelsRaw <= 8'd28;
        11'h147: pixelsRaw <= 8'd62;
        11'h247: pixelsRaw <= 8'd99;
        11'h347: pixelsRaw <= 8'd65;
        11'h447: pixelsRaw <= 8'd81;
        11'h547: pixelsRaw <= 8'd115;
        11'h647: pixelsRaw <= 8'd114;
        11'h747: pixelsRaw <= 8'd0;
        // 8'h48: H
        11'h048: pixelsRaw <= 8'd0;
        11'h148: pixelsRaw <= 8'd127;
        11'h248: pixelsRaw <= 8'd127;
        11'h348: pixelsRaw <= 8'd8;
        11'h448: pixelsRaw <= 8'd8;
        11'h548: pixelsRaw <= 8'd127;
        11'h648: pixelsRaw <= 8'd127;
        11'h748: pixelsRaw <= 8'd0;
        // 8'h49: I
        11'h049: pixelsRaw <= 8'd0;
        11'h149: pixelsRaw <= 8'd65;
        11'h249: pixelsRaw <= 8'd65;
        11'h349: pixelsRaw <= 8'd127;
        11'h449: pixelsRaw <= 8'd127;
        11'h549: pixelsRaw <= 8'd65;
        11'h649: pixelsRaw <= 8'd65;
        11'h749: pixelsRaw <= 8'd0;
        // 8'h4A: J
        11'h04A: pixelsRaw <= 8'd48;
        11'h14A: pixelsRaw <= 8'd112;
        11'h24A: pixelsRaw <= 8'd64;
        11'h34A: pixelsRaw <= 8'd65;
        11'h44A: pixelsRaw <= 8'd127;
        11'h54A: pixelsRaw <= 8'd63;
        11'h64A: pixelsRaw <= 8'd1;
        11'h74A: pixelsRaw <= 8'd0;
        // 8'h4B: K
        11'h04B: pixelsRaw <= 8'd65;
        11'h14B: pixelsRaw <= 8'd127;
        11'h24B: pixelsRaw <= 8'd127;
        11'h34B: pixelsRaw <= 8'd8;
        11'h44B: pixelsRaw <= 8'd28;
        11'h54B: pixelsRaw <= 8'd119;
        11'h64B: pixelsRaw <= 8'd99;
        11'h74B: pixelsRaw <= 8'd0;
        // 8'h4C: L
        11'h04C: pixelsRaw <= 8'd65;
        11'h14C: pixelsRaw <= 8'd127;
        11'h24C: pixelsRaw <= 8'd127;
        11'h34C: pixelsRaw <= 8'd65;
        11'h44C: pixelsRaw <= 8'd64;
        11'h54C: pixelsRaw <= 8'd96;
        11'h64C: pixelsRaw <= 8'd112;
        11'h74C: pixelsRaw <= 8'd0;
        // 8'h4D: M
        11'h04D: pixelsRaw <= 8'd127;
        11'h14D: pixelsRaw <= 8'd127;
        11'h24D: pixelsRaw <= 8'd14;
        11'h34D: pixelsRaw <= 8'd28;
        11'h44D: pixelsRaw <= 8'd14;
        11'h54D: pixelsRaw <= 8'd127;
        11'h64D: pixelsRaw <= 8'd127;
        11'h74D: pixelsRaw <= 8'd0;
        // 8'h4E: N
        11'h04E: pixelsRaw <= 8'd127;
        11'h14E: pixelsRaw <= 8'd127;
        11'h24E: pixelsRaw <= 8'd6;
        11'h34E: pixelsRaw <= 8'd12;
        11'h44E: pixelsRaw <= 8'd24;
        11'h54E: pixelsRaw <= 8'd127;
        11'h64E: pixelsRaw <= 8'd127;
        11'h74E: pixelsRaw <= 8'd0;
        // 8'h4F: O
        11'h04F: pixelsRaw <= 8'd28;
        11'h14F: pixelsRaw <= 8'd62;
        11'h24F: pixelsRaw <= 8'd99;
        11'h34F: pixelsRaw <= 8'd65;
        11'h44F: pixelsRaw <= 8'd99;
        11'h54F: pixelsRaw <= 8'd62;
        11'h64F: pixelsRaw <= 8'd28;
        11'h74F: pixelsRaw <= 8'd0;
        // 8'h50: P
        11'h050: pixelsRaw <= 8'd65;
        11'h150: pixelsRaw <= 8'd127;
        11'h250: pixelsRaw <= 8'd127;
        11'h350: pixelsRaw <= 8'd73;
        11'h450: pixelsRaw <= 8'd9;
        11'h550: pixelsRaw <= 8'd15;
        11'h650: pixelsRaw <= 8'd6;
        11'h750: pixelsRaw <= 8'd0;
        // 8'h51: Q
        11'h051: pixelsRaw <= 8'd30;
        11'h151: pixelsRaw <= 8'd63;
        11'h251: pixelsRaw <= 8'd33;
        11'h351: pixelsRaw <= 8'd33;
        11'h451: pixelsRaw <= 8'd113;
        11'h551: pixelsRaw <= 8'd127;
        11'h651: pixelsRaw <= 8'd94;
        11'h751: pixelsRaw <= 8'd0;
        // 8'h52: R
        11'h052: pixelsRaw <= 8'd65;
        11'h152: pixelsRaw <= 8'd127;
        11'h252: pixelsRaw <= 8'd127;
        11'h352: pixelsRaw <= 8'd9;
        11'h452: pixelsRaw <= 8'd25;
        11'h552: pixelsRaw <= 8'd127;
        11'h652: pixelsRaw <= 8'd102;
        11'h752: pixelsRaw <= 8'd0;
        // 8'h53: S
        11'h053: pixelsRaw <= 8'd0;
        11'h153: pixelsRaw <= 8'd38;
        11'h253: pixelsRaw <= 8'd111;
        11'h353: pixelsRaw <= 8'd77;
        11'h453: pixelsRaw <= 8'd89;
        11'h553: pixelsRaw <= 8'd115;
        11'h653: pixelsRaw <= 8'd50;
        11'h753: pixelsRaw <= 8'd0;
        // 8'h54: T
        11'h054: pixelsRaw <= 8'd0;
        11'h154: pixelsRaw <= 8'd3;
        11'h254: pixelsRaw <= 8'd1;
        11'h354: pixelsRaw <= 8'd127;
        11'h454: pixelsRaw <= 8'd127;
        11'h554: pixelsRaw <= 8'd1;
        11'h654: pixelsRaw <= 8'd3;
        11'h754: pixelsRaw <= 8'd0;
        // 8'h55: U
        11'h055: pixelsRaw <= 8'd0;
        11'h155: pixelsRaw <= 8'd127;
        11'h255: pixelsRaw <= 8'd127;
        11'h355: pixelsRaw <= 8'd64;
        11'h455: pixelsRaw <= 8'd64;
        11'h555: pixelsRaw <= 8'd127;
        11'h655: pixelsRaw <= 8'd127;
        11'h755: pixelsRaw <= 8'd0;
        // 8'h56: V
        11'h056: pixelsRaw <= 8'd0;
        11'h156: pixelsRaw <= 8'd31;
        11'h256: pixelsRaw <= 8'd63;
        11'h356: pixelsRaw <= 8'd96;
        11'h456: pixelsRaw <= 8'd96;
        11'h556: pixelsRaw <= 8'd63;
        11'h656: pixelsRaw <= 8'd31;
        11'h756: pixelsRaw <= 8'd0;
        // 8'h57: W
        11'h057: pixelsRaw <= 8'd127;
        11'h157: pixelsRaw <= 8'd127;
        11'h257: pixelsRaw <= 8'd48;
        11'h357: pixelsRaw <= 8'd24;
        11'h457: pixelsRaw <= 8'd48;
        11'h557: pixelsRaw <= 8'd127;
        11'h657: pixelsRaw <= 8'd127;
        11'h757: pixelsRaw <= 8'd0;
        // 8'h58: X
        11'h058: pixelsRaw <= 8'd67;
        11'h158: pixelsRaw <= 8'd103;
        11'h258: pixelsRaw <= 8'd60;
        11'h358: pixelsRaw <= 8'd24;
        11'h458: pixelsRaw <= 8'd60;
        11'h558: pixelsRaw <= 8'd103;
        11'h658: pixelsRaw <= 8'd67;
        11'h758: pixelsRaw <= 8'd0;
        // 8'h59: Y
        11'h059: pixelsRaw <= 8'd0;
        11'h159: pixelsRaw <= 8'd7;
        11'h259: pixelsRaw <= 8'd15;
        11'h359: pixelsRaw <= 8'd120;
        11'h459: pixelsRaw <= 8'd120;
        11'h559: pixelsRaw <= 8'd15;
        11'h659: pixelsRaw <= 8'd7;
        11'h759: pixelsRaw <= 8'd0;
        // 8'h5A: Z
        11'h05A: pixelsRaw <= 8'd67;
        11'h15A: pixelsRaw <= 8'd99;
        11'h25A: pixelsRaw <= 8'd113;
        11'h35A: pixelsRaw <= 8'd89;
        11'h45A: pixelsRaw <= 8'd77;
        11'h55A: pixelsRaw <= 8'd103;
        11'h65A: pixelsRaw <= 8'd99;
        11'h75A: pixelsRaw <= 8'd0;
        // 8'h5b: [
        11'h05b: pixelsRaw <= 8'b00000000;
        11'h15b: pixelsRaw <= 8'b00000000;
        11'h25b: pixelsRaw <= 8'b01111111;
        11'h35b: pixelsRaw <= 8'b01111111;
        11'h45b: pixelsRaw <= 8'b01000001;
        11'h55b: pixelsRaw <= 8'b01000001;
        11'h65b: pixelsRaw <= 8'b00000000;
        11'h75b: pixelsRaw <= 8'b00000000;
        // 8'h5c: \
        11'h05c: pixelsRaw <= 8'b00000001;
        11'h15c: pixelsRaw <= 8'b00000011;
        11'h25c: pixelsRaw <= 8'b00000110;
        11'h35c: pixelsRaw <= 8'b00001100;
        11'h45c: pixelsRaw <= 8'b00011000;
        11'h55c: pixelsRaw <= 8'b00110000;
        11'h65c: pixelsRaw <= 8'b01100000;
        11'h75c: pixelsRaw <= 8'b00000000;
        // 8'h5d: ]
        11'h05d: pixelsRaw <= 8'b00000000;
        11'h15d: pixelsRaw <= 8'b00000000;
        11'h25d: pixelsRaw <= 8'b01000001;
        11'h35d: pixelsRaw <= 8'b01000001;
        11'h45d: pixelsRaw <= 8'b01111111;
        11'h55d: pixelsRaw <= 8'b01111111;
        11'h65d: pixelsRaw <= 8'b00000000;
        11'h75d: pixelsRaw <= 8'b00000000;
        // 8'h5e: ^
        11'h05e: pixelsRaw <= 8'b00001000;
        11'h15e: pixelsRaw <= 8'b00001100;
        11'h25e: pixelsRaw <= 8'b00000110;
        11'h35e: pixelsRaw <= 8'b00000011;
        11'h45e: pixelsRaw <= 8'b00000110;
        11'h55e: pixelsRaw <= 8'b00001100;
        11'h65e: pixelsRaw <= 8'b00001000;
        11'h75e: pixelsRaw <= 8'b00000000;
        // 8'h5f: _
        11'h05f: pixelsRaw <= 8'b10000000;
        11'h15f: pixelsRaw <= 8'b10000000;
        11'h25f: pixelsRaw <= 8'b10000000;
        11'h35f: pixelsRaw <= 8'b10000000;
        11'h45f: pixelsRaw <= 8'b10000000;
        11'h55f: pixelsRaw <= 8'b10000000;
        11'h65f: pixelsRaw <= 8'b10000000;
        11'h75f: pixelsRaw <= 8'b10000000;
        // 8'h60: `
        11'h060: pixelsRaw <= 8'b00000000;
        11'h160: pixelsRaw <= 8'b00000000;
        11'h260: pixelsRaw <= 8'b00000000;
        11'h360: pixelsRaw <= 8'b00000011;
        11'h460: pixelsRaw <= 8'b00000111;
        11'h560: pixelsRaw <= 8'b00000100;
        11'h660: pixelsRaw <= 8'b00000000;
        11'h760: pixelsRaw <= 8'b00000000;
        // 8'h61: a
        11'h061: pixelsRaw <= 8'b00100000;
        11'h161: pixelsRaw <= 8'b01110100;
        11'h261: pixelsRaw <= 8'b01010100;
        11'h361: pixelsRaw <= 8'b01010100;
        11'h461: pixelsRaw <= 8'b00111100;
        11'h561: pixelsRaw <= 8'b01111000;
        11'h661: pixelsRaw <= 8'b01000000;
        11'h761: pixelsRaw <= 8'b00000000;
        // 8'h62: b
        11'h062: pixelsRaw <= 8'b01000001;
        11'h162: pixelsRaw <= 8'b01111111;
        11'h262: pixelsRaw <= 8'b00111111;
        11'h362: pixelsRaw <= 8'b01001000;
        11'h462: pixelsRaw <= 8'b01001000;
        11'h562: pixelsRaw <= 8'b01111000;
        11'h662: pixelsRaw <= 8'b00110000;
        11'h762: pixelsRaw <= 8'b00000000;
        // 8'h63: c
        11'h063: pixelsRaw <= 8'b00000000;
        11'h163: pixelsRaw <= 8'b00111000;
        11'h263: pixelsRaw <= 8'b01111100;
        11'h363: pixelsRaw <= 8'b01000100;
        11'h463: pixelsRaw <= 8'b01000100;
        11'h563: pixelsRaw <= 8'b01101100;
        11'h663: pixelsRaw <= 8'b00101000;
        11'h763: pixelsRaw <= 8'b00000000;
        // 8'h64: d
        11'h064: pixelsRaw <= 8'b00110000;
        11'h164: pixelsRaw <= 8'b01111000;
        11'h264: pixelsRaw <= 8'b01001000;
        11'h364: pixelsRaw <= 8'b01001001;
        11'h464: pixelsRaw <= 8'b00111111;
        11'h564: pixelsRaw <= 8'b01111111;
        11'h664: pixelsRaw <= 8'b01000000;
        11'h764: pixelsRaw <= 8'b00000000;
        // 8'h65: e
        11'h065: pixelsRaw <= 8'b00000000;
        11'h165: pixelsRaw <= 8'b00111000;
        11'h265: pixelsRaw <= 8'b01111100;
        11'h365: pixelsRaw <= 8'b01010100;
        11'h465: pixelsRaw <= 8'b01010100;
        11'h565: pixelsRaw <= 8'b01011100;
        11'h665: pixelsRaw <= 8'b00011000;
        11'h765: pixelsRaw <= 8'b00000000;
        // 8'h66: f
        11'h066: pixelsRaw <= 8'b00000000;
        11'h166: pixelsRaw <= 8'b01001000;
        11'h266: pixelsRaw <= 8'b01111110;
        11'h366: pixelsRaw <= 8'b01111111;
        11'h466: pixelsRaw <= 8'b01001001;
        11'h566: pixelsRaw <= 8'b00000011;
        11'h666: pixelsRaw <= 8'b00000010;
        11'h766: pixelsRaw <= 8'b00000000;
        // 8'h67: g
        11'h067: pixelsRaw <= 8'b10011000;
        11'h167: pixelsRaw <= 8'b10111100;
        11'h267: pixelsRaw <= 8'b10100100;
        11'h367: pixelsRaw <= 8'b10100100;
        11'h467: pixelsRaw <= 8'b11111000;
        11'h567: pixelsRaw <= 8'b01111100;
        11'h667: pixelsRaw <= 8'b00000100;
        11'h767: pixelsRaw <= 8'b00000000;
        // 8'h68: h
        11'h068: pixelsRaw <= 8'b01000001;
        11'h168: pixelsRaw <= 8'b01111111;
        11'h268: pixelsRaw <= 8'b01111111;
        11'h368: pixelsRaw <= 8'b00001000;
        11'h468: pixelsRaw <= 8'b00000100;
        11'h568: pixelsRaw <= 8'b01111100;
        11'h668: pixelsRaw <= 8'b01111000;
        11'h768: pixelsRaw <= 8'b00000000;
        // 8'h69: i
        11'h069: pixelsRaw <= 8'b00000000;
        11'h169: pixelsRaw <= 8'b00000000;
        11'h269: pixelsRaw <= 8'b01000100;
        11'h369: pixelsRaw <= 8'b01111101;
        11'h469: pixelsRaw <= 8'b01111101;
        11'h569: pixelsRaw <= 8'b01000000;
        11'h669: pixelsRaw <= 8'b00000000;
        11'h769: pixelsRaw <= 8'b00000000;
        // 8'h6a: j
        11'h06a: pixelsRaw <= 8'b00000000;
        11'h16a: pixelsRaw <= 8'b01100000;
        11'h26a: pixelsRaw <= 8'b11100000;
        11'h36a: pixelsRaw <= 8'b10000000;
        11'h46a: pixelsRaw <= 8'b10000000;
        11'h56a: pixelsRaw <= 8'b11111101;
        11'h66a: pixelsRaw <= 8'b01111101;
        11'h76a: pixelsRaw <= 8'b00000000;
        // 8'h6b: k
        11'h06b: pixelsRaw <= 8'b01000001;
        11'h16b: pixelsRaw <= 8'b01111111;
        11'h26b: pixelsRaw <= 8'b01111111;
        11'h36b: pixelsRaw <= 8'b00010000;
        11'h46b: pixelsRaw <= 8'b00111000;
        11'h56b: pixelsRaw <= 8'b01101100;
        11'h66b: pixelsRaw <= 8'b01000100;
        11'h76b: pixelsRaw <= 8'b00000000;
        // 8'h6c: l
        11'h06c: pixelsRaw <= 8'b00000000;
        11'h16c: pixelsRaw <= 8'b00000000;
        11'h26c: pixelsRaw <= 8'b01000001;
        11'h36c: pixelsRaw <= 8'b01111111;
        11'h46c: pixelsRaw <= 8'b01111111;
        11'h56c: pixelsRaw <= 8'b01000000;
        11'h66c: pixelsRaw <= 8'b00000000;
        11'h76c: pixelsRaw <= 8'b00000000;
        // 8'h6d: m
        11'h06d: pixelsRaw <= 8'b01111100;
        11'h16d: pixelsRaw <= 8'b01111100;
        11'h26d: pixelsRaw <= 8'b00011000;
        11'h36d: pixelsRaw <= 8'b00111000;
        11'h46d: pixelsRaw <= 8'b00011100;
        11'h56d: pixelsRaw <= 8'b01111100;
        11'h66d: pixelsRaw <= 8'b01111000;
        11'h76d: pixelsRaw <= 8'b00000000;
        // 8'h6e: n
        11'h06e: pixelsRaw <= 8'b00000000;
        11'h16e: pixelsRaw <= 8'b01111100;
        11'h26e: pixelsRaw <= 8'b01111100;
        11'h36e: pixelsRaw <= 8'b00000100;
        11'h46e: pixelsRaw <= 8'b00000100;
        11'h56e: pixelsRaw <= 8'b01111100;
        11'h66e: pixelsRaw <= 8'b01111000;
        11'h76e: pixelsRaw <= 8'b00000000;
        // 8'h6f: o
        11'h06f: pixelsRaw <= 8'b00000000;
        11'h16f: pixelsRaw <= 8'b00111000;
        11'h26f: pixelsRaw <= 8'b01111100;
        11'h36f: pixelsRaw <= 8'b01000100;
        11'h46f: pixelsRaw <= 8'b01000100;
        11'h56f: pixelsRaw <= 8'b01111100;
        11'h66f: pixelsRaw <= 8'b00111000;
        11'h76f: pixelsRaw <= 8'b00000000;
        // 8'h70: p
        11'h070: pixelsRaw <= 8'b10000100;
        11'h170: pixelsRaw <= 8'b11111100;
        11'h270: pixelsRaw <= 8'b11111000;
        11'h370: pixelsRaw <= 8'b10100100;
        11'h470: pixelsRaw <= 8'b00100100;
        11'h570: pixelsRaw <= 8'b00111100;
        11'h670: pixelsRaw <= 8'b00011000;
        11'h770: pixelsRaw <= 8'b00000000;
        // 8'h71: q
        11'h071: pixelsRaw <= 8'b00011000;
        11'h171: pixelsRaw <= 8'b00111100;
        11'h271: pixelsRaw <= 8'b00100100;
        11'h371: pixelsRaw <= 8'b10100100;
        11'h471: pixelsRaw <= 8'b11111000;
        11'h571: pixelsRaw <= 8'b11111100;
        11'h671: pixelsRaw <= 8'b10000100;
        11'h771: pixelsRaw <= 8'b00000000;
        // 8'h72: r
        11'h072: pixelsRaw <= 8'b01000100;
        11'h172: pixelsRaw <= 8'b01111100;
        11'h272: pixelsRaw <= 8'b01111000;
        11'h372: pixelsRaw <= 8'b01001100;
        11'h472: pixelsRaw <= 8'b00000100;
        11'h572: pixelsRaw <= 8'b00011100;
        11'h672: pixelsRaw <= 8'b00011000;
        11'h772: pixelsRaw <= 8'b00000000;
        // 8'h73: s
        11'h073: pixelsRaw <= 8'b00000000;
        11'h173: pixelsRaw <= 8'b01001000;
        11'h273: pixelsRaw <= 8'b01011100;
        11'h373: pixelsRaw <= 8'b01010100;
        11'h473: pixelsRaw <= 8'b01010100;
        11'h573: pixelsRaw <= 8'b01110100;
        11'h673: pixelsRaw <= 8'b00100100;
        11'h773: pixelsRaw <= 8'b00000000;
        // 8'h74: t
        11'h074: pixelsRaw <= 8'b00000000;
        11'h174: pixelsRaw <= 8'b00000000;
        11'h274: pixelsRaw <= 8'b00000100;
        11'h374: pixelsRaw <= 8'b00111110;
        11'h474: pixelsRaw <= 8'b01111111;
        11'h574: pixelsRaw <= 8'b01000100;
        11'h674: pixelsRaw <= 8'b00100100;
        11'h774: pixelsRaw <= 8'b00000000;
        // 8'h75: u
        11'h075: pixelsRaw <= 8'b00111100;
        11'h175: pixelsRaw <= 8'b01111100;
        11'h275: pixelsRaw <= 8'b01000000;
        11'h375: pixelsRaw <= 8'b01000000;
        11'h475: pixelsRaw <= 8'b00111100;
        11'h575: pixelsRaw <= 8'b01111100;
        11'h675: pixelsRaw <= 8'b01000000;
        11'h775: pixelsRaw <= 8'b00000000;
        // 8'h76: v
        11'h076: pixelsRaw <= 8'b00000000;
        11'h176: pixelsRaw <= 8'b00011100;
        11'h276: pixelsRaw <= 8'b00111100;
        11'h376: pixelsRaw <= 8'b01100000;
        11'h476: pixelsRaw <= 8'b01100000;
        11'h576: pixelsRaw <= 8'b00111100;
        11'h676: pixelsRaw <= 8'b00011100;
        11'h776: pixelsRaw <= 8'b00000000;
        // 8'h77: w
        11'h077: pixelsRaw <= 8'b00111100;
        11'h177: pixelsRaw <= 8'b01111100;
        11'h277: pixelsRaw <= 8'b01110000;
        11'h377: pixelsRaw <= 8'b00111000;
        11'h477: pixelsRaw <= 8'b01110000;
        11'h577: pixelsRaw <= 8'b01111100;
        11'h677: pixelsRaw <= 8'b00111100;
        11'h777: pixelsRaw <= 8'b00000000;
        // 8'h78: x
        11'h078: pixelsRaw <= 8'b01000100;
        11'h178: pixelsRaw <= 8'b01101100;
        11'h278: pixelsRaw <= 8'b00111000;
        11'h378: pixelsRaw <= 8'b00010000;
        11'h478: pixelsRaw <= 8'b00111000;
        11'h578: pixelsRaw <= 8'b01101100;
        11'h678: pixelsRaw <= 8'b01000100;
        11'h778: pixelsRaw <= 8'b00000000;
        // 8'h79: y
        11'h079: pixelsRaw <= 8'b00000000;
        11'h179: pixelsRaw <= 8'b10011100;
        11'h279: pixelsRaw <= 8'b10111100;
        11'h379: pixelsRaw <= 8'b10100000;
        11'h479: pixelsRaw <= 8'b10100000;
        11'h579: pixelsRaw <= 8'b11111100;
        11'h679: pixelsRaw <= 8'b01111100;
        11'h779: pixelsRaw <= 8'b00000000;
        // 8'h7a: z
        11'h07a: pixelsRaw <= 8'b00000000;
        11'h17a: pixelsRaw <= 8'b01001100;
        11'h27a: pixelsRaw <= 8'b01100100;
        11'h37a: pixelsRaw <= 8'b01110100;
        11'h47a: pixelsRaw <= 8'b01011100;
        11'h57a: pixelsRaw <= 8'b01001100;
        11'h67a: pixelsRaw <= 8'b01100100;
        11'h77a: pixelsRaw <= 8'b00000000;
        // 8'h7b: {
        11'h07b: pixelsRaw <= 8'b00000000;
        11'h17b: pixelsRaw <= 8'b00001000;
        11'h27b: pixelsRaw <= 8'b00001000;
        11'h37b: pixelsRaw <= 8'b00111110;
        11'h47b: pixelsRaw <= 8'b01110111;
        11'h57b: pixelsRaw <= 8'b01000001;
        11'h67b: pixelsRaw <= 8'b01000001;
        11'h77b: pixelsRaw <= 8'b00000000;
        // 8'h7c: |
        11'h07c: pixelsRaw <= 8'b00000000;
        11'h17c: pixelsRaw <= 8'b00000000;
        11'h27c: pixelsRaw <= 8'b00000000;
        11'h37c: pixelsRaw <= 8'b00000000;
        11'h47c: pixelsRaw <= 8'b01110111;
        11'h57c: pixelsRaw <= 8'b01110111;
        11'h67c: pixelsRaw <= 8'b00000000;
        11'h77c: pixelsRaw <= 8'b00000000;
        // 8'h7d: }
        11'h07d: pixelsRaw <= 8'b00000000;
        11'h17d: pixelsRaw <= 8'b01000001;
        11'h27d: pixelsRaw <= 8'b01000001;
        11'h37d: pixelsRaw <= 8'b01110111;
        11'h47d: pixelsRaw <= 8'b00111110;
        11'h57d: pixelsRaw <= 8'b00001000;
        11'h67d: pixelsRaw <= 8'b00001000;
        11'h77d: pixelsRaw <= 8'b00000000;
        // 8'h7e: ~
        11'h07e: pixelsRaw <= 8'b00000010;
        11'h17e: pixelsRaw <= 8'b00000011;
        11'h27e: pixelsRaw <= 8'b00000001;
        11'h37e: pixelsRaw <= 8'b00000011;
        11'h47e: pixelsRaw <= 8'b00000010;
        11'h57e: pixelsRaw <= 8'b00000011;
        11'h67e: pixelsRaw <= 8'b00000001;
        11'h77e: pixelsRaw <= 8'b00000000;

        default: pixelsRaw <= 8'b00000000;
    endcase
end

endmodule
