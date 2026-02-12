/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : W-2024.09
// Date      : Mon Jun  2 13:51:16 2025
/////////////////////////////////////////////////////////////


module comparator_8bit_clk ( clk, a, b, equal, greater, less );
  input [7:0] a;
  input [7:0] b;
  input clk;
  output equal, greater, less;
  wire   eq_wire, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92,
         n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n155, n156, n157, n158, n159, n164,
         n165;

  DFFSSRX1_RVT equal_reg ( .D(1'b0), .SETB(eq_wire), .RSTB(1'b1), .CLK(clk), 
        .QN(equal) );
  DFFSSRX1_RVT greater_reg ( .D(1'b0), .SETB(1'b0), .RSTB(n164), .CLK(clk), 
        .QN(greater) );
  DFFSSRX1_RVT less_reg ( .D(1'b0), .SETB(1'b0), .RSTB(n165), .CLK(clk), .QN(
        less) );
  INVX1_RVT U72 ( .A(n77), .Y(n78) );
  INVX1_RVT U73 ( .A(b[4]), .Y(n77) );
  INVX1_RVT U74 ( .A(b[5]), .Y(n79) );
  INVX0_RVT U75 ( .A(a[4]), .Y(n67) );
  INVX0_RVT U76 ( .A(n67), .Y(n68) );
  INVX0_RVT U77 ( .A(b[0]), .Y(n69) );
  INVX0_RVT U78 ( .A(n69), .Y(n70) );
  INVX0_RVT U79 ( .A(b[1]), .Y(n71) );
  INVX0_RVT U80 ( .A(n71), .Y(n72) );
  INVX0_RVT U81 ( .A(b[2]), .Y(n73) );
  INVX0_RVT U82 ( .A(n73), .Y(n74) );
  INVX0_RVT U83 ( .A(b[3]), .Y(n75) );
  INVX0_RVT U84 ( .A(n75), .Y(n76) );
  INVX0_RVT U85 ( .A(n79), .Y(n80) );
  INVX0_RVT U86 ( .A(b[6]), .Y(n81) );
  INVX0_RVT U87 ( .A(n81), .Y(n82) );
  INVX0_RVT U88 ( .A(b[7]), .Y(n83) );
  INVX0_RVT U89 ( .A(n83), .Y(n84) );
  INVX0_RVT U90 ( .A(a[0]), .Y(n85) );
  INVX0_RVT U91 ( .A(n85), .Y(n86) );
  INVX0_RVT U92 ( .A(a[1]), .Y(n87) );
  INVX0_RVT U93 ( .A(n87), .Y(n88) );
  INVX0_RVT U94 ( .A(a[2]), .Y(n89) );
  INVX0_RVT U95 ( .A(n89), .Y(n90) );
  INVX0_RVT U96 ( .A(a[3]), .Y(n91) );
  INVX0_RVT U97 ( .A(n91), .Y(n92) );
  INVX0_RVT U98 ( .A(a[5]), .Y(n93) );
  INVX0_RVT U99 ( .A(n93), .Y(n94) );
  INVX0_RVT U100 ( .A(a[6]), .Y(n95) );
  INVX0_RVT U101 ( .A(n95), .Y(n96) );
  INVX0_RVT U102 ( .A(a[7]), .Y(n97) );
  INVX0_RVT U103 ( .A(n97), .Y(n98) );
  INVX0_RVT U104 ( .A(n88), .Y(n109) );
  INVX0_RVT U105 ( .A(n120), .Y(n142) );
  INVX0_RVT U106 ( .A(n96), .Y(n113) );
  INVX0_RVT U107 ( .A(n117), .Y(n150) );
  INVX0_RVT U108 ( .A(n122), .Y(n155) );
  INVX0_RVT U109 ( .A(n68), .Y(n99) );
  INVX0_RVT U110 ( .A(n70), .Y(n100) );
  INVX0_RVT U111 ( .A(n72), .Y(n101) );
  INVX0_RVT U112 ( .A(n74), .Y(n102) );
  INVX0_RVT U113 ( .A(n76), .Y(n103) );
  INVX0_RVT U114 ( .A(n78), .Y(n104) );
  INVX0_RVT U115 ( .A(n80), .Y(n105) );
  INVX0_RVT U116 ( .A(n82), .Y(n106) );
  INVX0_RVT U117 ( .A(n84), .Y(n107) );
  INVX0_RVT U118 ( .A(n86), .Y(n108) );
  INVX0_RVT U119 ( .A(n90), .Y(n110) );
  INVX0_RVT U120 ( .A(n92), .Y(n111) );
  INVX0_RVT U121 ( .A(n94), .Y(n112) );
  INVX0_RVT U122 ( .A(n98), .Y(n114) );
  NOR2X0_RVT U127 ( .A1(n70), .A2(n108), .Y(n124) );
  NOR2X0_RVT U128 ( .A1(n86), .A2(n100), .Y(n123) );
  NOR2X0_RVT U129 ( .A1(n72), .A2(n109), .Y(n116) );
  NOR2X0_RVT U130 ( .A1(n88), .A2(n101), .Y(n115) );
  XOR2X1_RVT U131 ( .A1(n74), .A2(n90), .Y(n151) );
  NOR3X0_RVT U132 ( .A1(n116), .A2(n115), .A3(n151), .Y(n117) );
  XOR2X1_RVT U133 ( .A1(n84), .A2(n98), .Y(n148) );
  NOR2X0_RVT U134 ( .A1(n80), .A2(n112), .Y(n119) );
  NOR2X0_RVT U135 ( .A1(n94), .A2(n105), .Y(n118) );
  XOR2X1_RVT U136 ( .A1(n82), .A2(n96), .Y(n144) );
  NOR3X0_RVT U137 ( .A1(n119), .A2(n118), .A3(n144), .Y(n120) );
  XOR2X1_RVT U138 ( .A1(n78), .A2(n68), .Y(n139) );
  XOR2X1_RVT U139 ( .A1(n92), .A2(n76), .Y(n121) );
  NOR4X0_RVT U140 ( .A1(n148), .A2(n142), .A3(n139), .A4(n121), .Y(n122) );
  NOR4X0_RVT U141 ( .A1(n124), .A2(n123), .A3(n150), .A4(n155), .Y(eq_wire) );
  NOR2X0_RVT U142 ( .A1(n84), .A2(n114), .Y(n138) );
  NOR2X0_RVT U143 ( .A1(n82), .A2(n113), .Y(n130) );
  NOR2X0_RVT U144 ( .A1(n78), .A2(n99), .Y(n126) );
  NOR3X0_RVT U145 ( .A1(n76), .A2(n111), .A3(n139), .Y(n125) );
  NOR2X0_RVT U146 ( .A1(n126), .A2(n125), .Y(n127) );
  NOR2X0_RVT U147 ( .A1(n127), .A2(n142), .Y(n129) );
  NOR3X0_RVT U148 ( .A1(n80), .A2(n144), .A3(n112), .Y(n128) );
  NOR3X0_RVT U149 ( .A1(n130), .A2(n129), .A3(n128), .Y(n131) );
  NOR2X0_RVT U150 ( .A1(n131), .A2(n148), .Y(n137) );
  NOR2X0_RVT U151 ( .A1(n74), .A2(n110), .Y(n134) );
  NOR3X0_RVT U152 ( .A1(n70), .A2(n108), .A3(n150), .Y(n133) );
  NOR3X0_RVT U153 ( .A1(n72), .A2(n151), .A3(n109), .Y(n132) );
  NOR3X0_RVT U154 ( .A1(n134), .A2(n133), .A3(n132), .Y(n135) );
  NOR2X0_RVT U155 ( .A1(n135), .A2(n155), .Y(n136) );
  NOR3X0_RVT U156 ( .A1(n138), .A2(n137), .A3(n136), .Y(n164) );
  NOR2X0_RVT U157 ( .A1(n98), .A2(n107), .Y(n159) );
  NOR2X0_RVT U158 ( .A1(n96), .A2(n106), .Y(n147) );
  NOR2X0_RVT U159 ( .A1(n68), .A2(n104), .Y(n141) );
  NOR3X0_RVT U160 ( .A1(n92), .A2(n139), .A3(n103), .Y(n140) );
  NOR2X0_RVT U161 ( .A1(n141), .A2(n140), .Y(n143) );
  NOR2X0_RVT U162 ( .A1(n143), .A2(n142), .Y(n146) );
  NOR3X0_RVT U163 ( .A1(n94), .A2(n105), .A3(n144), .Y(n145) );
  NOR3X0_RVT U164 ( .A1(n147), .A2(n146), .A3(n145), .Y(n149) );
  NOR2X0_RVT U165 ( .A1(n149), .A2(n148), .Y(n158) );
  NOR2X0_RVT U166 ( .A1(n90), .A2(n102), .Y(n154) );
  NOR3X0_RVT U167 ( .A1(n86), .A2(n150), .A3(n100), .Y(n153) );
  NOR3X0_RVT U168 ( .A1(n88), .A2(n101), .A3(n151), .Y(n152) );
  NOR3X0_RVT U169 ( .A1(n154), .A2(n153), .A3(n152), .Y(n156) );
  NOR2X0_RVT U170 ( .A1(n156), .A2(n155), .Y(n157) );
  NOR3X0_RVT U171 ( .A1(n159), .A2(n158), .A3(n157), .Y(n165) );
endmodule

