module dram(CLK, RESET, ADDR, DATA, MW, Q, IOA, IOB, IOC, IOD, IOE, IOF, IOG, IOH, dispMsg, ack, action);
  input        CLK;
  input        RESET;
  input  [7:0] ADDR;  // 8-bit addresses
  input  [7:0] DATA;  // 8-bit data words
  input        MW;
  
  input  [7:0] action;
  output [7:0] ack;
  output [7:0] Q;
  input  [7:0] IOA;
  input  [7:0] IOB;
  output [7:0] IOC;
  output [7:0] IOD;
  output [7:0] IOE;
  output [7:0] IOF;
  output [7:0] IOG;
  output [7:0] IOH;
  output [0:511] dispMsg;
  
  reg    [7:0] Q;
  

  reg    [7:0] IOreg [2:7]; 
  reg    [7:0] mem   [0:247];
  reg    [7:0] Q_IO;
  reg    [7:0] Q_mem;
  reg    [7:0] ADDR_IO;
  reg          MW_IO;
  reg          MW_mem;
  
  always @(*) begin
    Q_mem <= mem[ADDR];
  end

  always @(posedge CLK) begin
    // Minesweeper map
    // 1X1000001X10012X
    // 22200011211001X3
    // 2X10001X3210012X
    // X2100012XX100011
    if(RESET) begin
      mem[0] <= 8'b00110001; // 1
      mem[1] <= 8'b01011000; // X
      mem[2] <= 8'b00110001; // 1
      mem[3] <= 8'b00110000; // 0
      mem[4] <= 8'b00110000; // 0
      mem[5] <= 8'b00110000; // 0
      mem[6] <= 8'b00110000; // 0
      mem[7] <= 8'b00110000; // 0
      mem[8] <= 8'b00110001; // 1
      mem[9] <= 8'b01011000; // X
      mem[10] <= 8'b00110001; // 1
      mem[11] <= 8'b00110000; // 0
      mem[12] <= 8'b00110000; // 0
      mem[13] <= 8'b00110001; // 1
      mem[14] <= 8'b00110010; // 2
      mem[15] <= 8'b01011000; // X
      mem[16] <= 8'b00110010; // 2
      mem[17] <= 8'b00110010; // 2
      mem[18] <= 8'b00110010; // 2
      mem[19] <= 8'b00110000; // 0
      mem[20] <= 8'b00110000; // 0
      mem[21] <= 8'b00110000; // 0
      mem[22] <= 8'b00110001; // 1
      mem[23] <= 8'b00110001; // 1
      mem[24] <= 8'b00110010; // 2
      mem[25] <= 8'b00110001; // 1
      mem[26] <= 8'b00110001; // 1
      mem[27] <= 8'b00110000; // 0
      mem[28] <= 8'b00110000; // 0
      mem[29] <= 8'b00110001; // 1
      mem[30] <= 8'b01011000; // X
      mem[31] <= 8'b00110011; // 3
      mem[32] <= 8'b00110010; // 2
      mem[33] <= 8'b01011000; // X
      mem[34] <= 8'b00110001; // 1
      mem[35] <= 8'b00110000; // 0
      mem[36] <= 8'b00110000; // 0
      mem[37] <= 8'b00110000; // 0
      mem[38] <= 8'b00110001; // 1
      mem[39] <= 8'b01011000; // X
      mem[40] <= 8'b00110011; // 3
      mem[41] <= 8'b00110010; // 2
      mem[42] <= 8'b00110001; // 1
      mem[43] <= 8'b00110000; // 0
      mem[44] <= 8'b00110000; // 0
      mem[45] <= 8'b00110001; // 1
      mem[46] <= 8'b00110010; // 2
      mem[47] <= 8'b01011000; // X
      mem[48] <= 8'b01011000; // X
      mem[49] <= 8'b00110010; // 2
      mem[50] <= 8'b00110001; // 1
      mem[51] <= 8'b00110000; // 0
      mem[52] <= 8'b00110000; // 0
      mem[53] <= 8'b00110000; // 0
      mem[54] <= 8'b00110001; // 1
      mem[55] <= 8'b00110010; // 2
      mem[56] <= 8'b01011000; // X
      mem[57] <= 8'b01011000; // X
      mem[58] <= 8'b00110001; // 1
      mem[59] <= 8'b00110000; // 0
      mem[60] <= 8'b00110000; // 0
      mem[61] <= 8'b00110000; // 0
      mem[62] <= 8'b00110001; // 1
      mem[63] <= 8'b00110001; // 1

      mem[64] <= 8'b10100000; //  
      mem[65] <= 8'b00100000; //  
      mem[66] <= 8'b00100000; //  
      mem[67] <= 8'b00100000; //  
      mem[68] <= 8'b00100000; //  
      mem[69] <= 8'b00100000; //  
      mem[70] <= 8'b00100000; //  
      mem[71] <= 8'b00100000; //  
      mem[72] <= 8'b00100000; //  
      mem[73] <= 8'b00100000; //  
      mem[74] <= 8'b00100000; //  
      mem[75] <= 8'b00100000; //  
      mem[76] <= 8'b00100000; //  
      mem[77] <= 8'b00100000; //  
      mem[78] <= 8'b00100000; //  
      mem[79] <= 8'b00100000; //  
      mem[80] <= 8'b00100000; //  
      mem[81] <= 8'b00100000; //  
      mem[82] <= 8'b00100000; //  
      mem[83] <= 8'b00100000; //  
      mem[84] <= 8'b00100000; //  
      mem[85] <= 8'b00100000; //  
      mem[86] <= 8'b00100000; //  
      mem[87] <= 8'b00100000; //  
      mem[88] <= 8'b00100000; //  
      mem[89] <= 8'b00100000; //  
      mem[90] <= 8'b00100000; //  
      mem[91] <= 8'b00100000; //  
      mem[92] <= 8'b00100000; //  
      mem[93] <= 8'b00100000; //  
      mem[94] <= 8'b00100000; //  
      mem[95] <= 8'b00100000; //  
      mem[96] <= 8'b00100000; //  
      mem[97] <= 8'b00100000; //  
      mem[98] <= 8'b00100000; //  
      mem[99] <= 8'b00100000; //  
      mem[100] <= 8'b00100000; //  
      mem[101] <= 8'b00100000; //  
      mem[102] <= 8'b00100000; //  
      mem[103] <= 8'b00100000; //  
      mem[104] <= 8'b00100000; //  
      mem[105] <= 8'b00100000; //  
      mem[106] <= 8'b00100000; //  
      mem[107] <= 8'b00100000; //  
      mem[108] <= 8'b00100000; //  
      mem[109] <= 8'b00100000; //  
      mem[110] <= 8'b00100000; //  
      mem[111] <= 8'b00100000; //  
      mem[112] <= 8'b00100000; //  
      mem[113] <= 8'b00100000; //  
      mem[114] <= 8'b00100000; //  
      mem[115] <= 8'b00100000; //  
      mem[116] <= 8'b00100000; //  
      mem[117] <= 8'b00100000; //  
      mem[118] <= 8'b00100000; //  
      mem[119] <= 8'b00100000; //  
      mem[120] <= 8'b00100000; //  
      mem[121] <= 8'b00100000; //  
      mem[122] <= 8'b00100000; //  
      mem[123] <= 8'b00100000; //  
      mem[124] <= 8'b00100000; //  
      mem[125] <= 8'b00100000; //  
      mem[126] <= 8'b00100000; //  
      mem[127] <= 8'b00100000; //  

    end
    else if(MW_IO == 1'b1) begin
      IOreg[ADDR_IO] <= DATA;
    end
    else if(MW_mem == 1'b1) begin
      mem[ADDR] <= DATA;
    end
  end

  assign IOC = IOreg[2];
  assign IOD = IOreg[3];
  assign IOE = IOreg[4];
  assign IOF = IOreg[5];
  assign IOG = IOreg[6];
  assign IOH = IOreg[7];
  assign ack = IOreg[8][0];
  
  // Did not figure out good way to initialize this lol
  // dispMsg[511:0] = mem[127:64] did not work
  assign dispMsg[0:7] = mem[64];
  assign dispMsg[8:15] = mem[65];
  assign dispMsg[16:23] = mem[66];
  assign dispMsg[24:31] = mem[67];
  assign dispMsg[32:39] = mem[68];
  assign dispMsg[40:47] = mem[69];
  assign dispMsg[48:55] = mem[70];
  assign dispMsg[56:63] = mem[71];
  assign dispMsg[64:71] = mem[72];
  assign dispMsg[72:79] = mem[73];
  assign dispMsg[80:87] = mem[74];
  assign dispMsg[88:95] = mem[75];
  assign dispMsg[96:103] = mem[76];
  assign dispMsg[104:111] = mem[77];
  assign dispMsg[112:119] = mem[78];
  assign dispMsg[120:127] = mem[79];
  assign dispMsg[128:135] = mem[80];
  assign dispMsg[136:143] = mem[81];
  assign dispMsg[144:151] = mem[82];
  assign dispMsg[152:159] = mem[83];
  assign dispMsg[160:167] = mem[84];
  assign dispMsg[168:175] = mem[85];
  assign dispMsg[176:183] = mem[86];
  assign dispMsg[184:191] = mem[87];
  assign dispMsg[192:199] = mem[88];
  assign dispMsg[200:207] = mem[89];
  assign dispMsg[208:215] = mem[90];
  assign dispMsg[216:223] = mem[91];
  assign dispMsg[224:231] = mem[92];
  assign dispMsg[232:239] = mem[93];
  assign dispMsg[240:247] = mem[94];
  assign dispMsg[248:255] = mem[95];
  assign dispMsg[256:263] = mem[96];
  assign dispMsg[264:271] = mem[97];
  assign dispMsg[272:279] = mem[98];
  assign dispMsg[280:287] = mem[99];
  assign dispMsg[288:295] = mem[100];
  assign dispMsg[296:303] = mem[101];
  assign dispMsg[304:311] = mem[102];
  assign dispMsg[312:319] = mem[103];
  assign dispMsg[320:327] = mem[104];
  assign dispMsg[328:335] = mem[105];
  assign dispMsg[336:343] = mem[106];
  assign dispMsg[344:351] = mem[107];
  assign dispMsg[352:359] = mem[108];
  assign dispMsg[360:367] = mem[109];
  assign dispMsg[368:375] = mem[110];
  assign dispMsg[376:383] = mem[111];
  assign dispMsg[384:391] = mem[112];
  assign dispMsg[392:399] = mem[113];
  assign dispMsg[400:407] = mem[114];
  assign dispMsg[408:415] = mem[115];
  assign dispMsg[416:423] = mem[116];
  assign dispMsg[424:431] = mem[117];
  assign dispMsg[432:439] = mem[118];
  assign dispMsg[440:447] = mem[119];
  assign dispMsg[448:455] = mem[120];
  assign dispMsg[456:463] = mem[121];
  assign dispMsg[464:471] = mem[122];
  assign dispMsg[472:479] = mem[123];
  assign dispMsg[480:487] = mem[124];
  assign dispMsg[488:495] = mem[125];
  assign dispMsg[496:503] = mem[126];
  assign dispMsg[504:511] = mem[127];
  
  always @(*) begin
    MW_mem  = 0;
    MW_IO   = 0;
    ADDR_IO = 0;
    Q       = 8'd0;

    case(ADDR)
      8'd246: begin // action -10
        ADDR_IO = 9;
        Q = action;
      end
      8'd247: begin // ack -9
        ADDR_IO = 8;
        MW_IO = MW;
      end
      8'd248: begin // -8
        ADDR_IO = 0;
        Q = IOA;
      end
      8'd249: begin
        ADDR_IO = 1;
        Q = IOB;
      end
      8'd250: begin
        ADDR_IO = 2;
        MW_IO = MW;
      end
      8'd251: begin
        ADDR_IO = 3;
        MW_IO = MW;
      end
      8'd252: begin
        ADDR_IO = 4;
        MW_IO = MW;
      end
      8'd253: begin
        ADDR_IO = 5;
        MW_IO = MW;
      end
      8'd254: begin
        ADDR_IO = 6;
        MW_IO = MW;
      end
      8'd255: begin // -1
        ADDR_IO = 7;
        MW_IO = MW;
      end
      default: begin // regular memory
        if(MW) begin
          MW_mem = 1;
        end
        else begin
          Q = Q_mem;
        end
      end
    endcase
  end

endmodule