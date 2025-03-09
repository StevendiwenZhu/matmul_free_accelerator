/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : V-2023.12-SP5
// Date      : Thu Dec  5 17:54:40 2024
/////////////////////////////////////////////////////////////


module fxp_div ( clk, rst, start, busy, done, valid, dbz, ovf, a, b, val );
  input [15:0] a;
  input [15:0] b;
  output [15:0] val;
  input clk, rst, start;
  output busy, done, valid, dbz, ovf;
  wire   next_state_0_, sig_diff_r, N209, n341, n342, n343, n344, n345, n346,
         n347, n348, n349, n350, n351, n352, n353, n354, n355, n356, n357,
         n358, n359, n360, n361, n362, n363, n364, n365, n366, n367, n368,
         n369, n370, n371, n372, n373, n374, n375, n376, n377, n378, n379,
         n380, n381, n382, n383, n384, n385, n386, n387, n388, n389, n390,
         n391, n392, n393, n394, n395, n396, n397, n398, n399, n400, n401,
         n402, n403, n404, n405, n406, n407, n408, n409, n410, n411, n412,
         n413, n414, n415, n416, n417, n418, n419, n420, n421, n422, n423,
         n424, n425, n426, n427, n428, n430, n432, n433, n434, n435, n436,
         n437, n438, n439, n440, n441, n442, n443, n444, n445, n446, n447,
         n448, n449, n450, n451, n452, n453, n454, n455, n456, n457, n458,
         n459, n460, n461, n462, n463, n464, n465, n468, n469, n470, n471,
         n474, n475, n476, n479, n480, n481, n484, n485, n486, n487, n490,
         n491, n492, n493, n496, n497, n498, n499, n500, n501, n502, n503,
         n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514,
         n515, n516, n517, n518, n519, n520, n521, n523, n524, n525, n526,
         n527, n528, n529, n530, n531, n532, n533, n534, n535, n536, n537,
         n538, n539, n540, n541, n542, n543, n544, n545, n546, n547, n548,
         n549, n550, n551, n552, n553, n554, n555, n556, n557, n558, n559,
         n560, n561, n562, n563, n564, n565, n566, n567, n568, n569, n570,
         n571, n572, n573, n574, n575, n576, n577, n578, n579, n580, n581,
         n582, n583, n584, n585, n586, n588, n589, n590, n591, n592, n594,
         n595, n596, n597, n598, n599, n600, n601, n602, n603, n604, n605,
         n606, n607, n608, n609, n610, n611, n612, n613, n614, n615, n616,
         n617, n618, n619, n620, n621, n622, n623, n624, n625, n626, n627,
         n628, n629, n630, n631, n632, n633, n634, n635, n636, n637, n638,
         n639, n640, n641, n642, n643, n644, n645, n646, n647, n648, n649,
         n650, n651, n652, n653, n654, n655, n656, n657, n658, n659, n660,
         n661, n662, n663, n664, n665, n666, n667, n668, n669, n670, n671,
         n672, n673, n674, n675, n676, n677, n679, n680, n681, n682, n683,
         n684, n685, n686, n687, n688, n689, n690, n691, n692, n693, n694,
         n695, n696, n697, n698, n699, n700, n701, n702, n703, n704, n705,
         n706, n707, n708, n709, n710, n711, n712, n713, n714, n715, n716,
         n717, n718, n719, n720, n721, n722, n723, n724, n725, n726, n727,
         n728, n729, n730, n731, n732, n733, n734, n735, n736, n737, n738,
         n739, n740, n741, n742, n743, n744, n745, n746, n747, n748, n749,
         n750, n751, n752, n753, n754, n755, n756, n757, n758, n759, n760,
         n761, n762, n763, n764, n765, n766, n767, n768, n769, n770, n772,
         n773, n774, n775, n776, n777, n778, n779, n780, n781, n782, n783,
         n784, n785, n786, n787, n788, n789, n790, n791, n792, n793, n794,
         n795, n796, n797, n798, n799, n800, n801, n802, n803, n804, n805,
         n806, n807, n808, n809, n810, n811, n812, n813, n814, n815, n816,
         n817, n818, n819, n820, n821, n822, n823, n824, n825, n826, n827,
         n828, n829, n830, n831, n832, n833, n834;
  wire   [5:0] count_r;
  wire   [15:0] acc_r;
  wire   [14:1] quo_r;
  wire   [14:0] bu_r;
  wire   [2:0] state_r;
  wire   [14:0] au_r;

  DFFARX1_RVT ovf_r_reg ( .D(n428), .CLK(n433), .RSTB(n823), .Q(ovf) );
  DFFARX1_RVT sig_diff_r_reg ( .D(n426), .CLK(n453), .RSTB(n827), .Q(
        sig_diff_r) );
  DFFARX1_RVT bu_r_reg_14_ ( .D(n425), .CLK(n439), .RSTB(n435), .Q(bu_r[14]), 
        .QN(n820) );
  DFFARX1_RVT bu_r_reg_13_ ( .D(n424), .CLK(clk), .RSTB(n432), .Q(bu_r[13]), 
        .QN(n792) );
  DFFARX1_RVT bu_r_reg_12_ ( .D(n423), .CLK(n453), .RSTB(n435), .Q(bu_r[12])
         );
  DFFARX1_RVT bu_r_reg_11_ ( .D(n422), .CLK(n439), .RSTB(n821), .Q(bu_r[11])
         );
  DFFARX1_RVT bu_r_reg_10_ ( .D(n421), .CLK(n434), .RSTB(n822), .Q(bu_r[10])
         );
  DFFARX1_RVT bu_r_reg_9_ ( .D(n420), .CLK(n453), .RSTB(n432), .Q(bu_r[9]) );
  DFFARX1_RVT bu_r_reg_8_ ( .D(n419), .CLK(clk), .RSTB(n823), .Q(bu_r[8]) );
  DFFARX1_RVT bu_r_reg_7_ ( .D(n418), .CLK(n433), .RSTB(n436), .Q(bu_r[7]) );
  DFFARX1_RVT bu_r_reg_6_ ( .D(n417), .CLK(n440), .RSTB(n436), .Q(bu_r[6]) );
  DFFARX1_RVT bu_r_reg_5_ ( .D(n416), .CLK(n440), .RSTB(n823), .Q(bu_r[5]) );
  DFFARX1_RVT bu_r_reg_4_ ( .D(n415), .CLK(n452), .RSTB(n822), .Q(bu_r[4]) );
  DFFARX1_RVT bu_r_reg_3_ ( .D(n414), .CLK(n442), .RSTB(n825), .Q(bu_r[3]) );
  DFFARX1_RVT bu_r_reg_2_ ( .D(n413), .CLK(n439), .RSTB(n822), .Q(bu_r[2]), 
        .QN(n817) );
  DFFARX1_RVT bu_r_reg_1_ ( .D(n412), .CLK(n434), .RSTB(n828), .Q(bu_r[1]), 
        .QN(n816) );
  DFFARX1_RVT bu_r_reg_0_ ( .D(n411), .CLK(n441), .RSTB(n828), .Q(bu_r[0]), 
        .QN(n807) );
  DFFARX1_RVT au_r_reg_0_ ( .D(n427), .CLK(n442), .RSTB(n825), .Q(au_r[0]) );
  DFFARX1_RVT au_r_reg_14_ ( .D(n410), .CLK(n433), .RSTB(n823), .Q(au_r[14])
         );
  DFFARX1_RVT au_r_reg_13_ ( .D(n409), .CLK(n440), .RSTB(n823), .Q(au_r[13])
         );
  DFFARX1_RVT au_r_reg_12_ ( .D(n408), .CLK(n439), .RSTB(n826), .Q(au_r[12])
         );
  DFFARX1_RVT au_r_reg_11_ ( .D(n407), .CLK(n434), .RSTB(n432), .Q(au_r[11])
         );
  DFFARX1_RVT au_r_reg_10_ ( .D(n406), .CLK(n441), .RSTB(n825), .Q(au_r[10])
         );
  DFFARX1_RVT au_r_reg_9_ ( .D(n405), .CLK(n442), .RSTB(n826), .Q(au_r[9]) );
  DFFARX1_RVT au_r_reg_8_ ( .D(n404), .CLK(n433), .RSTB(n824), .Q(au_r[8]) );
  DFFARX1_RVT au_r_reg_7_ ( .D(n403), .CLK(n440), .RSTB(n435), .Q(au_r[7]) );
  DFFARX1_RVT au_r_reg_6_ ( .D(n402), .CLK(n441), .RSTB(n436), .Q(au_r[6]) );
  DFFARX1_RVT au_r_reg_5_ ( .D(n401), .CLK(n452), .RSTB(n436), .Q(au_r[5]) );
  DFFARX1_RVT au_r_reg_4_ ( .D(n400), .CLK(n442), .RSTB(n432), .Q(au_r[4]) );
  DFFARX1_RVT au_r_reg_3_ ( .D(n399), .CLK(n452), .RSTB(n821), .Q(au_r[3]) );
  DFFARX1_RVT au_r_reg_2_ ( .D(n398), .CLK(n434), .RSTB(n828), .Q(au_r[2]) );
  DFFARX1_RVT au_r_reg_1_ ( .D(n397), .CLK(n441), .RSTB(n825), .Q(au_r[1]) );
  DFFARX1_RVT quo_r_reg_2_ ( .D(n370), .CLK(n441), .RSTB(n826), .Q(quo_r[2]), 
        .QN(n788) );
  DFFARX1_RVT quo_r_reg_3_ ( .D(n369), .CLK(n452), .RSTB(n821), .Q(quo_r[3]), 
        .QN(n780) );
  DFFARX1_RVT quo_r_reg_4_ ( .D(n368), .CLK(n442), .RSTB(n821), .Q(quo_r[4]), 
        .QN(n815) );
  DFFARX1_RVT quo_r_reg_5_ ( .D(n367), .CLK(n434), .RSTB(n824), .Q(quo_r[5]), 
        .QN(n800) );
  DFFARX1_RVT quo_r_reg_6_ ( .D(n366), .CLK(n434), .RSTB(n823), .Q(quo_r[6]), 
        .QN(n806) );
  DFFARX1_RVT quo_r_reg_7_ ( .D(n365), .CLK(n441), .RSTB(n436), .Q(quo_r[7]), 
        .QN(n798) );
  DFFARX1_RVT quo_r_reg_8_ ( .D(n364), .CLK(clk), .RSTB(n824), .Q(quo_r[8]), 
        .QN(n809) );
  DFFARX1_RVT state_r_reg_1_ ( .D(n430), .CLK(n433), .RSTB(n827), .Q(
        state_r[1]), .QN(n782) );
  DFFARX1_RVT count_r_reg_4_ ( .D(n389), .CLK(n440), .RSTB(n436), .Q(
        count_r[4]), .QN(n802) );
  DFFARX1_RVT state_r_reg_0_ ( .D(next_state_0_), .CLK(n440), .RSTB(n823), .Q(
        state_r[0]), .QN(n805) );
  DFFARX1_RVT state_r_reg_2_ ( .D(n796), .CLK(n452), .RSTB(n824), .Q(
        state_r[2]), .QN(n779) );
  DFFARX1_RVT count_r_reg_5_ ( .D(n394), .CLK(n442), .RSTB(n821), .Q(
        count_r[5]), .QN(n808) );
  DFFARX1_RVT count_r_reg_0_ ( .D(n393), .CLK(clk), .RSTB(n821), .Q(count_r[0]), .QN(n778) );
  DFFARX1_RVT count_r_reg_1_ ( .D(n392), .CLK(n433), .RSTB(n822), .Q(
        count_r[1]), .QN(n786) );
  DFFARX1_RVT count_r_reg_2_ ( .D(n391), .CLK(n440), .RSTB(n823), .Q(
        count_r[2]), .QN(n818) );
  DFFARX1_RVT count_r_reg_3_ ( .D(n390), .CLK(n440), .RSTB(n821), .Q(
        count_r[3]), .QN(n801) );
  DFFARX1_RVT quo_r_reg_0_ ( .D(n372), .CLK(n452), .RSTB(n822), .Q(N209), .QN(
        n777) );
  DFFARX1_RVT quo_r_reg_1_ ( .D(n371), .CLK(n442), .RSTB(n825), .Q(quo_r[1]), 
        .QN(n804) );
  DFFARX1_RVT quo_r_reg_9_ ( .D(n363), .CLK(n439), .RSTB(n827), .Q(quo_r[9]), 
        .QN(n787) );
  DFFARX1_RVT quo_r_reg_10_ ( .D(n362), .CLK(n434), .RSTB(n822), .Q(quo_r[10]), 
        .QN(n776) );
  DFFARX1_RVT quo_r_reg_11_ ( .D(n361), .CLK(n441), .RSTB(n828), .Q(quo_r[11]), 
        .QN(n781) );
  DFFARX1_RVT quo_r_reg_12_ ( .D(n360), .CLK(n442), .RSTB(n825), .Q(quo_r[12]), 
        .QN(n783) );
  DFFARX1_RVT quo_r_reg_13_ ( .D(n359), .CLK(n433), .RSTB(n824), .Q(quo_r[13]), 
        .QN(n803) );
  DFFARX1_RVT quo_r_reg_14_ ( .D(n395), .CLK(n440), .RSTB(n824), .Q(quo_r[14]), 
        .QN(n797) );
  DFFARX1_RVT acc_r_reg_0_ ( .D(n388), .CLK(n452), .RSTB(n825), .Q(acc_r[0])
         );
  DFFARX1_RVT acc_r_reg_1_ ( .D(n387), .CLK(n434), .RSTB(n824), .Q(acc_r[1]), 
        .QN(n784) );
  DFFARX1_RVT acc_r_reg_2_ ( .D(n386), .CLK(n441), .RSTB(n435), .Q(acc_r[2]), 
        .QN(n785) );
  DFFARX1_RVT acc_r_reg_3_ ( .D(n385), .CLK(clk), .RSTB(n432), .Q(acc_r[3]), 
        .QN(n791) );
  DFFARX1_RVT acc_r_reg_4_ ( .D(n384), .CLK(n433), .RSTB(n828), .QN(n812) );
  DFFARX1_RVT acc_r_reg_5_ ( .D(n383), .CLK(n440), .RSTB(n436), .QN(n795) );
  DFFARX1_RVT acc_r_reg_6_ ( .D(n382), .CLK(n442), .RSTB(n821), .Q(acc_r[6]), 
        .QN(n799) );
  DFFARX1_RVT acc_r_reg_7_ ( .D(n381), .CLK(n452), .RSTB(n828), .Q(acc_r[7]), 
        .QN(n790) );
  DFFARX1_RVT acc_r_reg_8_ ( .D(n380), .CLK(n442), .RSTB(n822), .QN(n813) );
  DFFARX1_RVT acc_r_reg_9_ ( .D(n379), .CLK(n433), .RSTB(n824), .QN(n794) );
  DFFARX1_RVT acc_r_reg_10_ ( .D(n378), .CLK(n434), .RSTB(n828), .QN(n814) );
  DFFARX1_RVT acc_r_reg_11_ ( .D(n377), .CLK(n441), .RSTB(n432), .QN(n793) );
  DFFARX1_RVT acc_r_reg_12_ ( .D(n376), .CLK(n433), .RSTB(n436), .QN(n811) );
  DFFARX1_RVT acc_r_reg_13_ ( .D(n375), .CLK(n453), .RSTB(n827), .Q(acc_r[13]), 
        .QN(n789) );
  DFFARX1_RVT acc_r_reg_14_ ( .D(n374), .CLK(n439), .RSTB(n432), .Q(acc_r[14]), 
        .QN(n819) );
  DFFARX1_RVT acc_r_reg_15_ ( .D(n373), .CLK(n441), .RSTB(n827), .Q(acc_r[15]), 
        .QN(n810) );
  DFFARX1_RVT dbz_r_reg ( .D(n396), .CLK(n440), .RSTB(n827), .Q(dbz) );
  DFFARX1_RVT busy_r_reg ( .D(n358), .CLK(clk), .RSTB(n826), .Q(busy) );
  DFFARX1_RVT valid_r_reg ( .D(n357), .CLK(n434), .RSTB(n826), .Q(valid) );
  DFFARX1_RVT val_r_reg_15_ ( .D(n356), .CLK(clk), .RSTB(n826), .Q(val[15]) );
  DFFARX1_RVT val_r_reg_0_ ( .D(n355), .CLK(n453), .RSTB(n432), .Q(val[0]) );
  DFFARX1_RVT val_r_reg_1_ ( .D(n354), .CLK(n453), .RSTB(n435), .Q(val[1]) );
  DFFARX1_RVT val_r_reg_2_ ( .D(n353), .CLK(n452), .RSTB(n436), .Q(val[2]) );
  DFFARX1_RVT val_r_reg_3_ ( .D(n352), .CLK(n442), .RSTB(n435), .Q(val[3]) );
  DFFARX1_RVT val_r_reg_4_ ( .D(n351), .CLK(n439), .RSTB(n826), .Q(val[4]) );
  DFFARX1_RVT val_r_reg_5_ ( .D(n350), .CLK(clk), .RSTB(n827), .Q(val[5]) );
  DFFARX1_RVT val_r_reg_6_ ( .D(n349), .CLK(n453), .RSTB(n435), .Q(val[6]) );
  DFFARX1_RVT val_r_reg_7_ ( .D(n348), .CLK(n439), .RSTB(n435), .Q(val[7]) );
  DFFARX1_RVT val_r_reg_8_ ( .D(n347), .CLK(n439), .RSTB(n822), .Q(val[8]) );
  DFFARX1_RVT val_r_reg_9_ ( .D(n346), .CLK(n452), .RSTB(n827), .Q(val[9]) );
  DFFARX1_RVT val_r_reg_10_ ( .D(n345), .CLK(n453), .RSTB(n826), .Q(val[10])
         );
  DFFARX1_RVT val_r_reg_11_ ( .D(n344), .CLK(n439), .RSTB(n825), .Q(val[11])
         );
  DFFARX1_RVT val_r_reg_12_ ( .D(n343), .CLK(clk), .RSTB(n828), .Q(val[12]) );
  DFFARX1_RVT val_r_reg_13_ ( .D(n342), .CLK(n453), .RSTB(n823), .Q(val[13])
         );
  DFFARX1_RVT val_r_reg_14_ ( .D(n341), .CLK(n439), .RSTB(n821), .Q(val[14])
         );
  INVX1_RVT U436 ( .A(rst), .Y(n432) );
  INVX1_RVT U437 ( .A(n451), .Y(n433) );
  INVX1_RVT U438 ( .A(n451), .Y(n434) );
  INVX1_RVT U439 ( .A(n451), .Y(n453) );
  INVX1_RVT U440 ( .A(rst), .Y(n435) );
  INVX1_RVT U441 ( .A(rst), .Y(n436) );
  INVX1_RVT U442 ( .A(n732), .Y(n437) );
  INVX1_RVT U443 ( .A(n451), .Y(n452) );
  INVX1_RVT U444 ( .A(n453), .Y(n438) );
  INVX1_RVT U445 ( .A(n438), .Y(n439) );
  INVX1_RVT U446 ( .A(n438), .Y(n440) );
  INVX1_RVT U447 ( .A(n438), .Y(n441) );
  INVX1_RVT U448 ( .A(n438), .Y(n442) );
  INVX1_RVT U449 ( .A(n562), .Y(n443) );
  INVX1_RVT U450 ( .A(n443), .Y(n444) );
  INVX1_RVT U451 ( .A(n443), .Y(n445) );
  INVX1_RVT U452 ( .A(n443), .Y(n446) );
  INVX1_RVT U453 ( .A(n443), .Y(n447) );
  INVX1_RVT U455 ( .A(n448), .Y(n449) );
  INVX1_RVT U456 ( .A(n448), .Y(n450) );
  NAND2X1_RVT U457 ( .A1(n738), .A2(n615), .Y(n550) );
  NAND2X1_RVT U458 ( .A1(n732), .A2(n537), .Y(n430) );
  INVX1_RVT U459 ( .A(clk), .Y(n451) );
  NOR2X0_RVT U460 ( .A1(n449), .A2(sig_diff_r), .Y(n763) );
  AO222X1_RVT U462 ( .A1(n526), .A2(bu_r[3]), .A3(n526), .A4(n791), .A5(
        bu_r[3]), .A6(n791), .Y(n509) );
  INVX1_RVT U463 ( .A(n508), .Y(n516) );
  INVX1_RVT U464 ( .A(n492), .Y(n493) );
  AND2X1_RVT U465 ( .A1(n753), .A2(n806), .Y(n758) );
  OR2X1_RVT U466 ( .A1(n765), .A2(n764), .Y(n766) );
  AND2X1_RVT U467 ( .A1(sig_diff_r), .A2(n592), .Y(n481) );
  INVX1_RVT U468 ( .A(n729), .Y(n730) );
  INVX1_RVT U469 ( .A(n705), .Y(n706) );
  OR2X1_RVT U470 ( .A1(n668), .A2(a[6]), .Y(n669) );
  OR2X1_RVT U471 ( .A1(a[13]), .A2(n657), .Y(n654) );
  OR2X1_RVT U472 ( .A1(b[7]), .A2(n642), .Y(n637) );
  INVX1_RVT U473 ( .A(n461), .Y(n525) );
  INVX1_RVT U474 ( .A(n550), .Y(n687) );
  INVX1_RVT U475 ( .A(n537), .Y(n737) );
  AND2X1_RVT U476 ( .A1(n579), .A2(n572), .Y(n675) );
  OR2X1_RVT U477 ( .A1(b[13]), .A2(n563), .Y(n628) );
  OAI222X1_RVT U478 ( .A1(n430), .A2(n819), .A3(n550), .A4(n528), .A5(n789), 
        .A6(n551), .Y(n374) );
  OAI222X1_RVT U479 ( .A1(n551), .A2(n814), .A3(n550), .A4(n534), .A5(n793), 
        .A6(n430), .Y(n377) );
  OR2X1_RVT U480 ( .A1(n539), .A2(n538), .Y(n371) );
  INVX1_RVT U481 ( .A(start), .Y(n454) );
  NOR4X1_RVT U482 ( .A1(n454), .A2(busy), .A3(dbz), .A4(ovf), .Y(n461) );
  NOR4X1_RVT U483 ( .A1(b[3]), .A2(b[2]), .A3(b[0]), .A4(b[1]), .Y(n646) );
  INVX1_RVT U484 ( .A(b[4]), .Y(n645) );
  NAND2X0_RVT U485 ( .A1(n646), .A2(n645), .Y(n647) );
  OR2X1_RVT U486 ( .A1(b[5]), .A2(n647), .Y(n641) );
  OR2X1_RVT U487 ( .A1(b[6]), .A2(n641), .Y(n642) );
  OR2X1_RVT U488 ( .A1(b[8]), .A2(n637), .Y(n638) );
  OR2X1_RVT U489 ( .A1(b[9]), .A2(n638), .Y(n633) );
  OR2X1_RVT U490 ( .A1(b[10]), .A2(n633), .Y(n634) );
  OR2X1_RVT U491 ( .A1(b[11]), .A2(n634), .Y(n630) );
  OR2X1_RVT U492 ( .A1(b[12]), .A2(n630), .Y(n563) );
  OR2X1_RVT U493 ( .A1(b[14]), .A2(n628), .Y(n456) );
  OR3X2_RVT U494 ( .A1(a[2]), .A2(a[1]), .A3(a[0]), .Y(n672) );
  OR2X1_RVT U495 ( .A1(n672), .A2(a[3]), .Y(n673) );
  OR3X2_RVT U496 ( .A1(a[5]), .A2(a[4]), .A3(n673), .Y(n668) );
  OR2X1_RVT U497 ( .A1(a[7]), .A2(n669), .Y(n664) );
  OR2X1_RVT U498 ( .A1(a[8]), .A2(n664), .Y(n665) );
  OR2X1_RVT U499 ( .A1(a[9]), .A2(n665), .Y(n660) );
  OR2X1_RVT U500 ( .A1(a[10]), .A2(n660), .Y(n661) );
  OR2X1_RVT U501 ( .A1(a[11]), .A2(n661), .Y(n656) );
  OR2X1_RVT U502 ( .A1(a[12]), .A2(n656), .Y(n657) );
  INVX1_RVT U503 ( .A(a[15]), .Y(n572) );
  AO222X1_RVT U504 ( .A1(n456), .A2(a[14]), .A3(n456), .A4(n654), .A5(n456), 
        .A6(n572), .Y(n460) );
  NAND3X0_RVT U505 ( .A1(state_r[1]), .A2(n805), .A3(n779), .Y(n498) );
  OAI21X1_RVT U506 ( .A1(n525), .A2(n460), .A3(n498), .Y(n459) );
  INVX0_RVT U507 ( .A(n498), .Y(n682) );
  AND4X1_RVT U508 ( .A1(n803), .A2(n783), .A3(n781), .A4(n776), .Y(n455) );
  NAND3X0_RVT U509 ( .A1(n455), .A2(n787), .A3(n809), .Y(n464) );
  AND4X1_RVT U510 ( .A1(count_r[3]), .A2(count_r[1]), .A3(n464), .A4(n802), 
        .Y(n499) );
  AND3X1_RVT U511 ( .A1(count_r[2]), .A2(n808), .A3(n778), .Y(n625) );
  NAND3X0_RVT U512 ( .A1(n682), .A2(n499), .A3(n625), .Y(n462) );
  AND3X1_RVT U513 ( .A1(n805), .A2(n782), .A3(n779), .Y(n599) );
  OR3X2_RVT U514 ( .A1(b[15]), .A2(n456), .A3(n525), .Y(n457) );
  NAND2X0_RVT U515 ( .A1(n599), .A2(n457), .Y(n598) );
  NAND2X0_RVT U516 ( .A1(n462), .A2(n598), .Y(n458) );
  MUX21X1_RVT U517 ( .A1(ovf), .A2(n459), .S0(n458), .Y(n428) );
  NAND2X0_RVT U518 ( .A1(n461), .A2(n460), .Y(n554) );
  NAND3X0_RVT U519 ( .A1(n554), .A2(n462), .A3(n450), .Y(n463) );
  MUX21X1_RVT U520 ( .A1(busy), .A2(n599), .S0(n463), .Y(n358) );
  NAND4X0_RVT U521 ( .A1(n777), .A2(n780), .A3(n788), .A4(n804), .Y(n750) );
  INVX0_RVT U522 ( .A(n750), .Y(n743) );
  NAND2X0_RVT U523 ( .A1(n743), .A2(n815), .Y(n755) );
  INVX0_RVT U524 ( .A(n755), .Y(n748) );
  NAND2X0_RVT U525 ( .A1(n748), .A2(n800), .Y(n760) );
  INVX0_RVT U526 ( .A(n760), .Y(n753) );
  NAND2X0_RVT U527 ( .A1(n758), .A2(n798), .Y(n767) );
  NOR2X0_RVT U528 ( .A1(n767), .A2(quo_r[8]), .Y(n765) );
  NAND2X0_RVT U529 ( .A1(n765), .A2(n787), .Y(n476) );
  INVX0_RVT U530 ( .A(n476), .Y(n487) );
  NAND2X0_RVT U531 ( .A1(n487), .A2(n776), .Y(n486) );
  INVX0_RVT U532 ( .A(n486), .Y(n471) );
  NAND2X0_RVT U533 ( .A1(n471), .A2(n781), .Y(n470) );
  INVX0_RVT U534 ( .A(n470), .Y(n465) );
  NAND2X0_RVT U535 ( .A1(n465), .A2(n783), .Y(n492) );
  INVX0_RVT U536 ( .A(n449), .Y(n592) );
  AO222X1_RVT U537 ( .A1(n481), .A2(quo_r[14]), .A3(n481), .A4(n464), .A5(n481), .A6(n767), .Y(n770) );
  AO22X1_RVT U541 ( .A1(quo_r[12]), .A2(n763), .A3(val[12]), .A4(n449), .Y(
        n468) );
  OR2X1_RVT U542 ( .A1(n469), .A2(n468), .Y(n343) );
  AO22X1_RVT U546 ( .A1(quo_r[11]), .A2(n763), .A3(val[11]), .A4(n449), .Y(
        n474) );
  OR2X1_RVT U547 ( .A1(n475), .A2(n474), .Y(n344) );
  AO22X1_RVT U551 ( .A1(quo_r[9]), .A2(n763), .A3(val[9]), .A4(n449), .Y(n479)
         );
  OR2X1_RVT U552 ( .A1(n480), .A2(n479), .Y(n346) );
  AO22X1_RVT U556 ( .A1(quo_r[7]), .A2(n763), .A3(val[7]), .A4(n449), .Y(n484)
         );
  OR2X1_RVT U557 ( .A1(n485), .A2(n484), .Y(n348) );
  AO22X1_RVT U561 ( .A1(quo_r[10]), .A2(n763), .A3(val[10]), .A4(n449), .Y(
        n490) );
  OR2X1_RVT U562 ( .A1(n491), .A2(n490), .Y(n345) );
  NAND2X0_RVT U563 ( .A1(n493), .A2(n803), .Y(n773) );
  AO22X1_RVT U567 ( .A1(quo_r[13]), .A2(n763), .A3(val[13]), .A4(n449), .Y(
        n496) );
  OR2X1_RVT U568 ( .A1(n497), .A2(n496), .Y(n342) );
  INVX1_RVT U569 ( .A(rst), .Y(n821) );
  INVX1_RVT U570 ( .A(rst), .Y(n823) );
  INVX1_RVT U571 ( .A(rst), .Y(n824) );
  INVX1_RVT U572 ( .A(rst), .Y(n825) );
  INVX1_RVT U573 ( .A(rst), .Y(n822) );
  INVX1_RVT U574 ( .A(rst), .Y(n828) );
  INVX1_RVT U575 ( .A(rst), .Y(n826) );
  INVX1_RVT U576 ( .A(rst), .Y(n827) );
  AND3X2_RVT U577 ( .A1(state_r[1]), .A2(state_r[0]), .A3(n779), .Y(n796) );
  AO21X1_RVT U578 ( .A1(n499), .A2(n625), .A3(n498), .Y(n732) );
  NAND3X0_RVT U579 ( .A1(state_r[0]), .A2(n782), .A3(n779), .Y(n537) );
  INVX0_RVT U580 ( .A(n732), .Y(n738) );
  NAND2X0_RVT U581 ( .A1(acc_r[14]), .A2(n820), .Y(n602) );
  NAND2X0_RVT U582 ( .A1(n810), .A2(n602), .Y(n520) );
  OA22X1_RVT U583 ( .A1(bu_r[12]), .A2(n811), .A3(bu_r[13]), .A4(n789), .Y(
        n500) );
  NAND3X0_RVT U584 ( .A1(n500), .A2(n810), .A3(n602), .Y(n508) );
  OA22X1_RVT U585 ( .A1(bu_r[10]), .A2(n814), .A3(bu_r[11]), .A4(n793), .Y(
        n515) );
  OA21X1_RVT U586 ( .A1(bu_r[9]), .A2(n794), .A3(bu_r[8]), .Y(n501) );
  AO22X1_RVT U587 ( .A1(bu_r[9]), .A2(n794), .A3(n813), .A4(n501), .Y(n502) );
  AOI22X1_RVT U588 ( .A1(bu_r[11]), .A2(n793), .A3(n515), .A4(n502), .Y(n506)
         );
  OR2X1_RVT U589 ( .A1(n793), .A2(bu_r[11]), .Y(n503) );
  NAND3X0_RVT U590 ( .A1(bu_r[10]), .A2(n503), .A3(n814), .Y(n505) );
  OA22X1_RVT U591 ( .A1(acc_r[13]), .A2(n792), .A3(acc_r[14]), .A4(n820), .Y(
        n504) );
  OA221X1_RVT U592 ( .A1(n508), .A2(n506), .A3(n508), .A4(n505), .A5(n504), 
        .Y(n519) );
  NAND2X0_RVT U593 ( .A1(acc_r[13]), .A2(n792), .Y(n507) );
  NAND3X0_RVT U594 ( .A1(bu_r[12]), .A2(n507), .A3(n811), .Y(n518) );
  OA22X1_RVT U595 ( .A1(bu_r[8]), .A2(n813), .A3(bu_r[9]), .A4(n794), .Y(n514)
         );
  NOR2X0_RVT U596 ( .A1(n807), .A2(acc_r[0]), .Y(n688) );
  AO222X1_RVT U597 ( .A1(bu_r[1]), .A2(n688), .A3(bu_r[1]), .A4(n784), .A5(
        n688), .A6(n784), .Y(n548) );
  AO222X1_RVT U598 ( .A1(bu_r[2]), .A2(n548), .A3(bu_r[2]), .A4(n785), .A5(
        n548), .A6(n785), .Y(n526) );
  AO222X1_RVT U599 ( .A1(bu_r[4]), .A2(n509), .A3(bu_r[4]), .A4(n812), .A5(
        n509), .A6(n812), .Y(n510) );
  AO222X1_RVT U600 ( .A1(bu_r[5]), .A2(n795), .A3(bu_r[5]), .A4(n510), .A5(
        n795), .A6(n510), .Y(n511) );
  OR2X1_RVT U601 ( .A1(n799), .A2(bu_r[6]), .Y(n616) );
  AO22X1_RVT U602 ( .A1(bu_r[6]), .A2(n799), .A3(n511), .A4(n616), .Y(n512) );
  AO222X1_RVT U603 ( .A1(bu_r[7]), .A2(n790), .A3(bu_r[7]), .A4(n512), .A5(
        n790), .A6(n512), .Y(n513) );
  NAND4X0_RVT U604 ( .A1(n516), .A2(n515), .A3(n514), .A4(n513), .Y(n517) );
  OA221X1_RVT U605 ( .A1(n520), .A2(n519), .A3(n520), .A4(n518), .A5(n517), 
        .Y(n521) );
  AND2X1_RVT U606 ( .A1(n521), .A2(n682), .Y(n615) );
  OAI222X1_RVT U609 ( .A1(n430), .A2(n812), .A3(n550), .A4(n523), .A5(n791), 
        .A6(n551), .Y(n384) );
  NAND2X0_RVT U610 ( .A1(n805), .A2(n782), .Y(n524) );
  AO221X1_RVT U611 ( .A1(valid), .A2(n525), .A3(valid), .A4(n524), .A5(n592), 
        .Y(n357) );
  NAND2X0_RVT U612 ( .A1(bu_r[6]), .A2(n799), .Y(n617) );
  INVX0_RVT U613 ( .A(n617), .Y(n527) );
  FADDX1_RVT U614 ( .A(bu_r[3]), .B(n791), .CI(n526), .CO(n542), .S(n523) );
  OA21X1_RVT U615 ( .A1(n527), .A2(n619), .A3(n616), .Y(n544) );
  FADDX1_RVT U616 ( .A(bu_r[12]), .B(n811), .CI(n529), .CO(n600), .S(n530) );
  OAI222X1_RVT U617 ( .A1(n551), .A2(n811), .A3(n550), .A4(n530), .A5(n789), 
        .A6(n430), .Y(n375) );
  FADDX1_RVT U618 ( .A(bu_r[11]), .B(n793), .CI(n531), .CO(n529), .S(n532) );
  OAI222X1_RVT U619 ( .A1(n430), .A2(n811), .A3(n550), .A4(n532), .A5(n793), 
        .A6(n551), .Y(n376) );
  FADDX1_RVT U620 ( .A(bu_r[10]), .B(n814), .CI(n533), .CO(n531), .S(n534) );
  FADDX1_RVT U621 ( .A(bu_r[9]), .B(n794), .CI(n535), .CO(n533), .S(n536) );
  OAI222X1_RVT U622 ( .A1(n551), .A2(n794), .A3(n550), .A4(n536), .A5(n814), 
        .A6(n430), .Y(n378) );
  AO22X1_RVT U623 ( .A1(n737), .A2(au_r[0]), .A3(N209), .A4(n738), .Y(n539) );
  OA21X1_RVT U624 ( .A1(state_r[2]), .A2(n805), .A3(n732), .Y(n735) );
  NAND2X0_RVT U625 ( .A1(N209), .A2(quo_r[1]), .Y(n690) );
  OA21X1_RVT U626 ( .A1(N209), .A2(quo_r[1]), .A3(n690), .Y(n742) );
  AO22X1_RVT U627 ( .A1(n735), .A2(quo_r[1]), .A3(n796), .A4(n742), .Y(n538)
         );
  FADDX1_RVT U628 ( .A(bu_r[8]), .B(n813), .CI(n540), .CO(n535), .S(n541) );
  OAI222X1_RVT U629 ( .A1(n551), .A2(n813), .A3(n550), .A4(n541), .A5(n794), 
        .A6(n430), .Y(n379) );
  FADDX1_RVT U630 ( .A(bu_r[4]), .B(n812), .CI(n542), .CO(n546), .S(n543) );
  OAI222X1_RVT U631 ( .A1(n551), .A2(n812), .A3(n550), .A4(n543), .A5(n795), 
        .A6(n430), .Y(n383) );
  FADDX1_RVT U632 ( .A(bu_r[7]), .B(n790), .CI(n544), .CO(n540), .S(n545) );
  OAI222X1_RVT U633 ( .A1(n430), .A2(n813), .A3(n550), .A4(n545), .A5(n790), 
        .A6(n551), .Y(n380) );
  FADDX1_RVT U634 ( .A(bu_r[5]), .B(n795), .CI(n546), .CO(n619), .S(n547) );
  OAI222X1_RVT U635 ( .A1(n551), .A2(n795), .A3(n550), .A4(n547), .A5(n799), 
        .A6(n430), .Y(n382) );
  AO22X1_RVT U636 ( .A1(bu_r[2]), .A2(n785), .A3(n817), .A4(acc_r[2]), .Y(n549) );
  HADDX1_RVT U637 ( .A0(n549), .B0(n548), .SO(n553) );
  INVX0_RVT U638 ( .A(n551), .Y(n685) );
  INVX0_RVT U639 ( .A(n430), .Y(n686) );
  AO22X1_RVT U640 ( .A1(acc_r[2]), .A2(n685), .A3(acc_r[3]), .A4(n686), .Y(
        n552) );
  AO21X1_RVT U641 ( .A1(n553), .A2(n687), .A3(n552), .Y(n385) );
  INVX0_RVT U642 ( .A(n554), .Y(n555) );
  NOR2X0_RVT U644 ( .A1(n562), .A2(b[15]), .Y(n651) );
  INVX0_RVT U646 ( .A(n562), .Y(n579) );
  AND2X1_RVT U647 ( .A1(b[15]), .A2(n579), .Y(n650) );
  AO22X1_RVT U648 ( .A1(sig_diff_r), .A2(n446), .A3(n650), .A4(n572), .Y(n556)
         );
  AO21X1_RVT U649 ( .A1(a[15]), .A2(n651), .A3(n556), .Y(n426) );
  OR2X1_RVT U650 ( .A1(b[0]), .A2(b[1]), .Y(n559) );
  OA21X1_RVT U651 ( .A1(b[2]), .A2(n559), .A3(b[15]), .Y(n557) );
  HADDX1_RVT U652 ( .A0(b[3]), .B0(n557), .SO(n558) );
  AO22X1_RVT U653 ( .A1(n579), .A2(n558), .A3(n445), .A4(bu_r[3]), .Y(n414) );
  HADDX1_RVT U654 ( .A0(b[2]), .B0(n559), .SO(n560) );
  AO22X1_RVT U655 ( .A1(b[2]), .A2(n651), .A3(n560), .A4(n650), .Y(n561) );
  AO21X1_RVT U656 ( .A1(bu_r[2]), .A2(n447), .A3(n561), .Y(n413) );
  AO22X1_RVT U657 ( .A1(b[13]), .A2(n651), .A3(bu_r[13]), .A4(n562), .Y(n565)
         );
  NAND2X0_RVT U658 ( .A1(b[13]), .A2(n563), .Y(n564) );
  OA222X1_RVT U659 ( .A1(n565), .A2(n650), .A3(n565), .A4(n628), .A5(n565), 
        .A6(n564), .Y(n424) );
  AO22X1_RVT U660 ( .A1(n579), .A2(b[0]), .A3(n446), .A4(bu_r[0]), .Y(n411) );
  HADDX1_RVT U661 ( .A0(b[5]), .B0(n647), .SO(n566) );
  AO22X1_RVT U662 ( .A1(b[5]), .A2(n651), .A3(n566), .A4(n650), .Y(n567) );
  AO21X1_RVT U663 ( .A1(bu_r[5]), .A2(n445), .A3(n567), .Y(n416) );
  HADDX1_RVT U664 ( .A0(b[11]), .B0(n634), .SO(n568) );
  AO22X1_RVT U665 ( .A1(b[11]), .A2(n651), .A3(n568), .A4(n650), .Y(n569) );
  AO21X1_RVT U666 ( .A1(bu_r[11]), .A2(n446), .A3(n569), .Y(n422) );
  HADDX1_RVT U667 ( .A0(b[9]), .B0(n638), .SO(n570) );
  AO22X1_RVT U668 ( .A1(b[9]), .A2(n651), .A3(n570), .A4(n650), .Y(n571) );
  AO21X1_RVT U669 ( .A1(bu_r[9]), .A2(n447), .A3(n571), .Y(n420) );
  HADDX1_RVT U670 ( .A0(a[13]), .B0(n657), .SO(n573) );
  AND2X1_RVT U671 ( .A1(a[15]), .A2(n579), .Y(n674) );
  AO22X1_RVT U672 ( .A1(a[13]), .A2(n675), .A3(n573), .A4(n674), .Y(n574) );
  AO21X1_RVT U673 ( .A1(au_r[13]), .A2(n445), .A3(n574), .Y(n409) );
  HADDX1_RVT U674 ( .A0(b[7]), .B0(n642), .SO(n575) );
  AO22X1_RVT U675 ( .A1(b[7]), .A2(n651), .A3(n575), .A4(n650), .Y(n576) );
  AO21X1_RVT U676 ( .A1(bu_r[7]), .A2(n446), .A3(n576), .Y(n418) );
  HADDX1_RVT U677 ( .A0(a[11]), .B0(n661), .SO(n577) );
  AO22X1_RVT U678 ( .A1(a[11]), .A2(n675), .A3(n577), .A4(n674), .Y(n578) );
  AO21X1_RVT U679 ( .A1(au_r[11]), .A2(n447), .A3(n578), .Y(n407) );
  AO22X1_RVT U680 ( .A1(n579), .A2(a[0]), .A3(n447), .A4(au_r[0]), .Y(n427) );
  HADDX1_RVT U681 ( .A0(a[9]), .B0(n665), .SO(n580) );
  AO22X1_RVT U682 ( .A1(a[9]), .A2(n675), .A3(n580), .A4(n674), .Y(n581) );
  AO21X1_RVT U683 ( .A1(au_r[9]), .A2(n445), .A3(n581), .Y(n405) );
  AO22X1_RVT U684 ( .A1(quo_r[2]), .A2(n763), .A3(val[2]), .A4(n450), .Y(n584)
         );
  NAND3X0_RVT U685 ( .A1(n777), .A2(n788), .A3(n804), .Y(n745) );
  NAND2X0_RVT U686 ( .A1(n777), .A2(n804), .Y(n582) );
  NAND2X0_RVT U687 ( .A1(quo_r[2]), .A2(n582), .Y(n583) );
  OA222X1_RVT U688 ( .A1(n584), .A2(n770), .A3(n584), .A4(n745), .A5(n584), 
        .A6(n583), .Y(n353) );
  HADDX1_RVT U689 ( .A0(a[7]), .B0(n669), .SO(n585) );
  AO22X1_RVT U690 ( .A1(a[7]), .A2(n675), .A3(n585), .A4(n674), .Y(n586) );
  AO21X1_RVT U691 ( .A1(au_r[7]), .A2(n446), .A3(n586), .Y(n403) );
  AO22X1_RVT U692 ( .A1(a[5]), .A2(n675), .A3(au_r[5]), .A4(n446), .Y(n589) );
  OA222X1_RVT U695 ( .A1(n589), .A2(n674), .A3(n589), .A4(n668), .A5(n589), 
        .A6(n588), .Y(n401) );
  HADDX1_RVT U696 ( .A0(a[4]), .B0(n673), .SO(n590) );
  AO22X1_RVT U697 ( .A1(a[4]), .A2(n675), .A3(n590), .A4(n674), .Y(n591) );
  AO21X1_RVT U698 ( .A1(au_r[4]), .A2(n447), .A3(n591), .Y(n400) );
  AO22X1_RVT U699 ( .A1(n592), .A2(N209), .A3(n450), .A4(val[0]), .Y(n355) );
  AO22X1_RVT U700 ( .A1(a[2]), .A2(n675), .A3(au_r[2]), .A4(n447), .Y(n595) );
  OA222X1_RVT U703 ( .A1(n595), .A2(n674), .A3(n595), .A4(n672), .A5(n595), 
        .A6(n594), .Y(n398) );
  NAND2X0_RVT U704 ( .A1(n738), .A2(n778), .Y(n596) );
  NAND2X0_RVT U705 ( .A1(n430), .A2(n596), .Y(n597) );
  OA222X1_RVT U706 ( .A1(count_r[1]), .A2(count_r[0]), .A3(count_r[1]), .A4(
        n437), .A5(n786), .A6(n597), .Y(n392) );
  AO21X1_RVT U707 ( .A1(val[15]), .A2(n450), .A3(n770), .Y(n356) );
  OA21X1_RVT U708 ( .A1(n599), .A2(dbz), .A3(n598), .Y(n396) );
  FADDX1_RVT U709 ( .A(bu_r[13]), .B(n789), .CI(n600), .CO(n604), .S(n528) );
  NAND2X0_RVT U710 ( .A1(bu_r[14]), .A2(n819), .Y(n601) );
  NAND2X0_RVT U711 ( .A1(n602), .A2(n601), .Y(n603) );
  HADDX1_RVT U712 ( .A0(n604), .B0(n603), .SO(n606) );
  AO22X1_RVT U713 ( .A1(acc_r[15]), .A2(n686), .A3(acc_r[14]), .A4(n685), .Y(
        n605) );
  AO21X1_RVT U714 ( .A1(n687), .A2(n606), .A3(n605), .Y(n373) );
  NAND3X0_RVT U715 ( .A1(count_r[1]), .A2(count_r[2]), .A3(count_r[0]), .Y(
        n612) );
  AO221X1_RVT U716 ( .A1(n682), .A2(n801), .A3(n682), .A4(n612), .A5(n686), 
        .Y(n607) );
  INVX0_RVT U717 ( .A(n612), .Y(n614) );
  AND3X1_RVT U718 ( .A1(count_r[3]), .A2(n437), .A3(n614), .Y(n609) );
  AO22X1_RVT U719 ( .A1(count_r[4]), .A2(n607), .A3(n802), .A4(n609), .Y(n389)
         );
  AO21X1_RVT U720 ( .A1(n738), .A2(n802), .A3(n607), .Y(n608) );
  OA222X1_RVT U721 ( .A1(count_r[5]), .A2(count_r[4]), .A3(count_r[5]), .A4(
        n609), .A5(n808), .A6(n608), .Y(n394) );
  AO22X1_RVT U722 ( .A1(count_r[0]), .A2(n686), .A3(n778), .A4(n738), .Y(n393)
         );
  AND2X1_RVT U723 ( .A1(count_r[1]), .A2(count_r[0]), .Y(n611) );
  AO221X1_RVT U724 ( .A1(n682), .A2(n786), .A3(n682), .A4(n778), .A5(n686), 
        .Y(n610) );
  OA222X1_RVT U725 ( .A1(count_r[2]), .A2(n437), .A3(count_r[2]), .A4(n611), 
        .A5(n818), .A6(n610), .Y(n391) );
  AO21X1_RVT U726 ( .A1(n682), .A2(n612), .A3(n686), .Y(n613) );
  OA222X1_RVT U727 ( .A1(count_r[3]), .A2(n437), .A3(count_r[3]), .A4(n614), 
        .A5(n801), .A6(n613), .Y(n390) );
  OA22X1_RVT U728 ( .A1(n615), .A2(n735), .A3(N209), .A4(n430), .Y(n372) );
  NAND2X0_RVT U729 ( .A1(n617), .A2(n616), .Y(n618) );
  HADDX1_RVT U730 ( .A0(n619), .B0(n618), .SO(n621) );
  AO22X1_RVT U731 ( .A1(acc_r[7]), .A2(n686), .A3(acc_r[6]), .A4(n685), .Y(
        n620) );
  AO21X1_RVT U732 ( .A1(n687), .A2(n621), .A3(n620), .Y(n381) );
  AO22X1_RVT U733 ( .A1(bu_r[1]), .A2(n784), .A3(n816), .A4(acc_r[1]), .Y(n622) );
  HADDX1_RVT U734 ( .A0(n622), .B0(n688), .SO(n624) );
  AO22X1_RVT U735 ( .A1(acc_r[2]), .A2(n686), .A3(acc_r[1]), .A4(n685), .Y(
        n623) );
  AO21X1_RVT U736 ( .A1(n624), .A2(n687), .A3(n623), .Y(n386) );
  OA221X1_RVT U737 ( .A1(state_r[2]), .A2(state_r[1]), .A3(state_r[2]), .A4(
        n805), .A5(n732), .Y(done) );
  AND2X1_RVT U738 ( .A1(n682), .A2(n625), .Y(n626) );
  NAND4X0_RVT U739 ( .A1(count_r[4]), .A2(n626), .A3(n786), .A4(n801), .Y(n627) );
  NAND2X0_RVT U740 ( .A1(n445), .A2(n627), .Y(next_state_0_) );
  NAND2X0_RVT U741 ( .A1(b[14]), .A2(n628), .Y(n629) );
  AO222X1_RVT U742 ( .A1(n629), .A2(n650), .A3(n446), .A4(bu_r[14]), .A5(n651), 
        .A6(b[14]), .Y(n425) );
  INVX1_RVT U743 ( .A(b[12]), .Y(n632) );
  NAND2X0_RVT U744 ( .A1(b[15]), .A2(n630), .Y(n631) );
  MUX41X1_RVT U745 ( .A1(n632), .A3(b[12]), .A2(bu_r[12]), .A4(bu_r[12]), .S0(
        n631), .S1(n444), .Y(n423) );
  NAND2X0_RVT U746 ( .A1(b[10]), .A2(n633), .Y(n636) );
  AND2X1_RVT U747 ( .A1(n650), .A2(n634), .Y(n635) );
  AO222X1_RVT U748 ( .A1(n636), .A2(n635), .A3(n447), .A4(bu_r[10]), .A5(n651), 
        .A6(b[10]), .Y(n421) );
  NAND2X0_RVT U749 ( .A1(b[8]), .A2(n637), .Y(n640) );
  AND2X1_RVT U750 ( .A1(n650), .A2(n638), .Y(n639) );
  AO222X1_RVT U751 ( .A1(n640), .A2(n639), .A3(n445), .A4(bu_r[8]), .A5(n651), 
        .A6(b[8]), .Y(n419) );
  NAND2X0_RVT U752 ( .A1(b[6]), .A2(n641), .Y(n644) );
  AND2X1_RVT U753 ( .A1(n650), .A2(n642), .Y(n643) );
  AO222X1_RVT U754 ( .A1(n644), .A2(n643), .A3(n446), .A4(bu_r[6]), .A5(n651), 
        .A6(b[6]), .Y(n417) );
  OR2X1_RVT U755 ( .A1(n646), .A2(n645), .Y(n649) );
  AND2X1_RVT U756 ( .A1(n650), .A2(n647), .Y(n648) );
  AO222X1_RVT U757 ( .A1(n649), .A2(n648), .A3(n447), .A4(bu_r[4]), .A5(n651), 
        .A6(b[4]), .Y(n415) );
  NAND2X0_RVT U758 ( .A1(b[0]), .A2(b[1]), .Y(n653) );
  OA21X1_RVT U759 ( .A1(b[0]), .A2(b[1]), .A3(n650), .Y(n652) );
  AO222X1_RVT U760 ( .A1(n653), .A2(n652), .A3(n445), .A4(bu_r[1]), .A5(n651), 
        .A6(b[1]), .Y(n412) );
  NAND2X0_RVT U761 ( .A1(a[14]), .A2(n654), .Y(n655) );
  AO222X1_RVT U762 ( .A1(n655), .A2(n674), .A3(n446), .A4(au_r[14]), .A5(n675), 
        .A6(a[14]), .Y(n410) );
  NAND2X0_RVT U763 ( .A1(a[12]), .A2(n656), .Y(n659) );
  AND2X1_RVT U764 ( .A1(n674), .A2(n657), .Y(n658) );
  AO222X1_RVT U765 ( .A1(n659), .A2(n658), .A3(n447), .A4(au_r[12]), .A5(n675), 
        .A6(a[12]), .Y(n408) );
  NAND2X0_RVT U766 ( .A1(a[10]), .A2(n660), .Y(n663) );
  AND2X1_RVT U767 ( .A1(n674), .A2(n661), .Y(n662) );
  AO222X1_RVT U768 ( .A1(n663), .A2(n662), .A3(n445), .A4(au_r[10]), .A5(n675), 
        .A6(a[10]), .Y(n406) );
  NAND2X0_RVT U769 ( .A1(a[8]), .A2(n664), .Y(n667) );
  AND2X1_RVT U770 ( .A1(n674), .A2(n665), .Y(n666) );
  AO222X1_RVT U771 ( .A1(n667), .A2(n666), .A3(n446), .A4(au_r[8]), .A5(n675), 
        .A6(a[8]), .Y(n404) );
  NAND2X0_RVT U772 ( .A1(a[6]), .A2(n668), .Y(n671) );
  AND2X1_RVT U773 ( .A1(n674), .A2(n669), .Y(n670) );
  AO222X1_RVT U774 ( .A1(n671), .A2(n670), .A3(n447), .A4(au_r[6]), .A5(n675), 
        .A6(a[6]), .Y(n402) );
  NAND2X0_RVT U775 ( .A1(a[3]), .A2(n672), .Y(n677) );
  AND2X1_RVT U776 ( .A1(n674), .A2(n673), .Y(n676) );
  AO222X1_RVT U777 ( .A1(n677), .A2(n676), .A3(n445), .A4(au_r[3]), .A5(n675), 
        .A6(a[3]), .Y(n399) );
  INVX1_RVT U778 ( .A(a[1]), .Y(n680) );
  NAND2X0_RVT U779 ( .A1(a[0]), .A2(a[15]), .Y(n679) );
  MUX41X1_RVT U780 ( .A1(n680), .A3(a[1]), .A2(au_r[1]), .A4(au_r[1]), .S0(
        n679), .S1(n444), .Y(n397) );
  INVX0_RVT U781 ( .A(n735), .Y(n681) );
  NAND3X0_RVT U782 ( .A1(N209), .A2(quo_r[2]), .A3(quo_r[1]), .Y(n697) );
  INVX0_RVT U783 ( .A(n697), .Y(n698) );
  NAND3X0_RVT U784 ( .A1(quo_r[4]), .A2(quo_r[3]), .A3(n698), .Y(n705) );
  NAND3X0_RVT U785 ( .A1(quo_r[6]), .A2(quo_r[5]), .A3(n706), .Y(n713) );
  INVX0_RVT U786 ( .A(n713), .Y(n714) );
  NAND3X0_RVT U787 ( .A1(quo_r[8]), .A2(quo_r[7]), .A3(n714), .Y(n723) );
  INVX0_RVT U788 ( .A(n723), .Y(n721) );
  NAND3X0_RVT U789 ( .A1(quo_r[9]), .A2(quo_r[10]), .A3(n721), .Y(n729) );
  AND4X1_RVT U790 ( .A1(quo_r[12]), .A2(quo_r[11]), .A3(n730), .A4(n796), .Y(
        n740) );
  AO22X1_RVT U791 ( .A1(n682), .A2(n681), .A3(n740), .A4(n797), .Y(n684) );
  NAND3X0_RVT U792 ( .A1(quo_r[12]), .A2(quo_r[11]), .A3(n730), .Y(n736) );
  AO221X1_RVT U793 ( .A1(n796), .A2(n803), .A3(n796), .A4(n736), .A5(n735), 
        .Y(n683) );
  AO222X1_RVT U794 ( .A1(n684), .A2(quo_r[13]), .A3(n683), .A4(quo_r[14]), 
        .A5(n737), .A6(au_r[13]), .Y(n395) );
  AO222X1_RVT U795 ( .A1(acc_r[0]), .A2(n686), .A3(n737), .A4(au_r[14]), .A5(
        n738), .A6(quo_r[14]), .Y(n388) );
  AO21X1_RVT U796 ( .A1(n687), .A2(n807), .A3(n685), .Y(n689) );
  AO222X1_RVT U797 ( .A1(n689), .A2(acc_r[0]), .A3(n688), .A4(n687), .A5(
        acc_r[1]), .A6(n686), .Y(n387) );
  AO21X1_RVT U798 ( .A1(n796), .A2(n690), .A3(n735), .Y(n693) );
  NAND3X0_RVT U799 ( .A1(N209), .A2(n796), .A3(n788), .Y(n691) );
  NAND2X0_RVT U800 ( .A1(n732), .A2(n691), .Y(n692) );
  AO222X1_RVT U801 ( .A1(n693), .A2(quo_r[2]), .A3(n692), .A4(quo_r[1]), .A5(
        au_r[1]), .A6(n737), .Y(n370) );
  AO21X1_RVT U802 ( .A1(n796), .A2(n697), .A3(n735), .Y(n696) );
  AND2X1_RVT U803 ( .A1(n698), .A2(n796), .Y(n695) );
  AO22X1_RVT U804 ( .A1(n737), .A2(au_r[2]), .A3(quo_r[2]), .A4(n738), .Y(n694) );
  AO221X1_RVT U805 ( .A1(quo_r[3]), .A2(n696), .A3(n780), .A4(n695), .A5(n694), 
        .Y(n369) );
  AO221X1_RVT U806 ( .A1(n796), .A2(n780), .A3(n796), .A4(n697), .A5(n735), 
        .Y(n701) );
  NAND3X0_RVT U807 ( .A1(n698), .A2(n796), .A3(n815), .Y(n699) );
  NAND2X0_RVT U808 ( .A1(n732), .A2(n699), .Y(n700) );
  AO222X1_RVT U809 ( .A1(n701), .A2(quo_r[4]), .A3(n700), .A4(quo_r[3]), .A5(
        au_r[3]), .A6(n737), .Y(n368) );
  AO21X1_RVT U810 ( .A1(n796), .A2(n705), .A3(n735), .Y(n704) );
  AND2X1_RVT U811 ( .A1(n706), .A2(n796), .Y(n703) );
  AO22X1_RVT U812 ( .A1(au_r[4]), .A2(n737), .A3(quo_r[4]), .A4(n738), .Y(n702) );
  AO221X1_RVT U813 ( .A1(quo_r[5]), .A2(n704), .A3(n800), .A4(n703), .A5(n702), 
        .Y(n367) );
  AO221X1_RVT U814 ( .A1(n796), .A2(n800), .A3(n796), .A4(n705), .A5(n735), 
        .Y(n709) );
  NAND3X0_RVT U815 ( .A1(n706), .A2(n796), .A3(n806), .Y(n707) );
  NAND2X0_RVT U816 ( .A1(n732), .A2(n707), .Y(n708) );
  AO222X1_RVT U817 ( .A1(n709), .A2(quo_r[6]), .A3(n708), .A4(quo_r[5]), .A5(
        au_r[5]), .A6(n737), .Y(n366) );
  AO21X1_RVT U818 ( .A1(n796), .A2(n713), .A3(n735), .Y(n712) );
  AND2X1_RVT U819 ( .A1(n714), .A2(n796), .Y(n711) );
  AO22X1_RVT U820 ( .A1(n737), .A2(au_r[6]), .A3(quo_r[6]), .A4(n738), .Y(n710) );
  AO221X1_RVT U821 ( .A1(quo_r[7]), .A2(n712), .A3(n798), .A4(n711), .A5(n710), 
        .Y(n365) );
  AO221X1_RVT U822 ( .A1(n796), .A2(n798), .A3(n796), .A4(n713), .A5(n735), 
        .Y(n717) );
  NAND3X0_RVT U823 ( .A1(n714), .A2(n796), .A3(n809), .Y(n715) );
  NAND2X0_RVT U824 ( .A1(n732), .A2(n715), .Y(n716) );
  AO222X1_RVT U825 ( .A1(n717), .A2(quo_r[8]), .A3(n716), .A4(quo_r[7]), .A5(
        n737), .A6(au_r[7]), .Y(n364) );
  AO21X1_RVT U826 ( .A1(n796), .A2(n723), .A3(n735), .Y(n720) );
  AND2X1_RVT U827 ( .A1(n721), .A2(n796), .Y(n719) );
  AO22X1_RVT U828 ( .A1(quo_r[8]), .A2(n437), .A3(n737), .A4(au_r[8]), .Y(n718) );
  AO221X1_RVT U829 ( .A1(quo_r[9]), .A2(n720), .A3(n787), .A4(n719), .A5(n718), 
        .Y(n363) );
  NAND3X0_RVT U830 ( .A1(n721), .A2(n796), .A3(n776), .Y(n722) );
  NAND2X0_RVT U831 ( .A1(n732), .A2(n722), .Y(n725) );
  AO221X1_RVT U832 ( .A1(n796), .A2(n787), .A3(n796), .A4(n723), .A5(n735), 
        .Y(n724) );
  AO222X1_RVT U833 ( .A1(n725), .A2(quo_r[9]), .A3(n724), .A4(quo_r[10]), .A5(
        n737), .A6(au_r[9]), .Y(n362) );
  AO21X1_RVT U834 ( .A1(n796), .A2(n729), .A3(n735), .Y(n728) );
  AND2X1_RVT U835 ( .A1(n730), .A2(n796), .Y(n727) );
  AO22X1_RVT U836 ( .A1(quo_r[10]), .A2(n437), .A3(n737), .A4(au_r[10]), .Y(
        n726) );
  AO221X1_RVT U837 ( .A1(quo_r[11]), .A2(n728), .A3(n781), .A4(n727), .A5(n726), .Y(n361) );
  AO221X1_RVT U838 ( .A1(n796), .A2(n781), .A3(n796), .A4(n729), .A5(n735), 
        .Y(n734) );
  NAND3X0_RVT U839 ( .A1(n730), .A2(n796), .A3(n783), .Y(n731) );
  NAND2X0_RVT U840 ( .A1(n732), .A2(n731), .Y(n733) );
  AO222X1_RVT U841 ( .A1(n734), .A2(quo_r[12]), .A3(n733), .A4(quo_r[11]), 
        .A5(n737), .A6(au_r[11]), .Y(n360) );
  AO21X1_RVT U842 ( .A1(n796), .A2(n736), .A3(n735), .Y(n741) );
  AO22X1_RVT U843 ( .A1(quo_r[12]), .A2(n437), .A3(n737), .A4(au_r[12]), .Y(
        n739) );
  AO221X1_RVT U844 ( .A1(quo_r[13]), .A2(n741), .A3(n803), .A4(n740), .A5(n739), .Y(n359) );
  AO222X1_RVT U845 ( .A1(n450), .A2(val[1]), .A3(n763), .A4(quo_r[1]), .A5(
        n770), .A6(n742), .Y(n354) );
  AOI22X1_RVT U846 ( .A1(quo_r[3]), .A2(n763), .A3(val[3]), .A4(n449), .Y(n747) );
  INVX0_RVT U847 ( .A(n770), .Y(n764) );
  OR2X1_RVT U848 ( .A1(n743), .A2(n764), .Y(n744) );
  AO21X1_RVT U849 ( .A1(quo_r[3]), .A2(n745), .A3(n744), .Y(n746) );
  NAND2X0_RVT U850 ( .A1(n747), .A2(n746), .Y(n352) );
  AOI22X1_RVT U851 ( .A1(quo_r[4]), .A2(n763), .A3(val[4]), .A4(n450), .Y(n752) );
  OR2X1_RVT U852 ( .A1(n748), .A2(n764), .Y(n749) );
  AO21X1_RVT U853 ( .A1(quo_r[4]), .A2(n750), .A3(n749), .Y(n751) );
  NAND2X0_RVT U854 ( .A1(n752), .A2(n751), .Y(n351) );
  AOI22X1_RVT U855 ( .A1(quo_r[5]), .A2(n763), .A3(val[5]), .A4(n450), .Y(n757) );
  OR2X1_RVT U856 ( .A1(n753), .A2(n764), .Y(n754) );
  AO21X1_RVT U857 ( .A1(quo_r[5]), .A2(n755), .A3(n754), .Y(n756) );
  NAND2X0_RVT U858 ( .A1(n757), .A2(n756), .Y(n350) );
  AOI22X1_RVT U859 ( .A1(quo_r[6]), .A2(n763), .A3(val[6]), .A4(n450), .Y(n762) );
  OR2X1_RVT U860 ( .A1(n758), .A2(n764), .Y(n759) );
  AO21X1_RVT U861 ( .A1(quo_r[6]), .A2(n760), .A3(n759), .Y(n761) );
  NAND2X0_RVT U862 ( .A1(n762), .A2(n761), .Y(n349) );
  AOI22X1_RVT U863 ( .A1(quo_r[8]), .A2(n763), .A3(val[8]), .A4(n450), .Y(n769) );
  AO21X1_RVT U864 ( .A1(quo_r[8]), .A2(n767), .A3(n766), .Y(n768) );
  NAND2X0_RVT U865 ( .A1(n769), .A2(n768), .Y(n347) );
  AOI22X1_RVT U866 ( .A1(n770), .A2(n797), .A3(val[14]), .A4(n450), .Y(n775)
         );
  OR2X1_RVT U867 ( .A1(n449), .A2(n797), .Y(n772) );
  AO21X1_RVT U868 ( .A1(sig_diff_r), .A2(n773), .A3(n772), .Y(n774) );
  NAND2X0_RVT U869 ( .A1(n775), .A2(n774), .Y(n341) );
  OAI21X1_RVT U454 ( .A1(a[4]), .A2(n673), .A3(a[5]), .Y(n588) );
  OAI21X1_RVT U461 ( .A1(a[0]), .A2(a[1]), .A3(a[2]), .Y(n594) );
  AND3X1_RVT U538 ( .A1(n770), .A2(n476), .A3(n829), .Y(n480) );
  OR2X1_RVT U539 ( .A1(n765), .A2(n787), .Y(n829) );
  AND3X1_RVT U540 ( .A1(n770), .A2(n492), .A3(n830), .Y(n469) );
  OR2X1_RVT U543 ( .A1(n465), .A2(n783), .Y(n830) );
  AND3X1_RVT U544 ( .A1(n770), .A2(n470), .A3(n831), .Y(n475) );
  OR2X1_RVT U545 ( .A1(n471), .A2(n781), .Y(n831) );
  AND3X1_RVT U548 ( .A1(n770), .A2(n486), .A3(n832), .Y(n491) );
  OR2X1_RVT U549 ( .A1(n487), .A2(n776), .Y(n832) );
  AND3X1_RVT U550 ( .A1(n770), .A2(n773), .A3(n833), .Y(n497) );
  OR2X1_RVT U553 ( .A1(n493), .A2(n803), .Y(n833) );
  AND3X1_RVT U554 ( .A1(n481), .A2(n767), .A3(n834), .Y(n485) );
  OR2X1_RVT U555 ( .A1(n758), .A2(n798), .Y(n834) );
  OR2X2_RVT U558 ( .A1(n732), .A2(n521), .Y(n551) );
  NAND2X0_RVT U559 ( .A1(n555), .A2(n599), .Y(n562) );
  AND3X1_RVT U560 ( .A1(state_r[2]), .A2(n782), .A3(n805), .Y(n448) );
endmodule

