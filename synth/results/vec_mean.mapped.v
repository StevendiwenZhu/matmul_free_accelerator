/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : V-2023.12-SP5
// Date      : Thu Dec  5 11:22:42 2024
/////////////////////////////////////////////////////////////


module vec_mean ( input_arr, mean_out );
  input [63:0] input_arr;
  output [15:0] mean_out;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127;

  INVX1_RVT U1 ( .A(n3), .Y(n1) );
  INVX1_RVT U2 ( .A(n2), .Y(n4) );
  INVX0_RVT U3 ( .A(n64), .Y(n89) );
  INVX0_RVT U4 ( .A(n62), .Y(n66) );
  INVX0_RVT U5 ( .A(n11), .Y(n91) );
  INVX0_RVT U6 ( .A(n60), .Y(n70) );
  INVX0_RVT U7 ( .A(n13), .Y(n68) );
  INVX0_RVT U8 ( .A(n15), .Y(n72) );
  INVX0_RVT U9 ( .A(n58), .Y(n74) );
  INVX0_RVT U10 ( .A(n17), .Y(n76) );
  INVX0_RVT U11 ( .A(n56), .Y(n78) );
  INVX0_RVT U12 ( .A(n54), .Y(n82) );
  INVX0_RVT U13 ( .A(n52), .Y(n97) );
  INVX0_RVT U14 ( .A(n21), .Y(n84) );
  INVX0_RVT U15 ( .A(n23), .Y(n99) );
  INVX0_RVT U16 ( .A(n50), .Y(n101) );
  INVX0_RVT U17 ( .A(n25), .Y(n103) );
  INVX0_RVT U18 ( .A(n48), .Y(n105) );
  INVX0_RVT U19 ( .A(n46), .Y(n109) );
  INVX0_RVT U20 ( .A(n27), .Y(n107) );
  INVX0_RVT U21 ( .A(n44), .Y(n113) );
  INVX0_RVT U22 ( .A(n29), .Y(n111) );
  INVX0_RVT U23 ( .A(n31), .Y(n115) );
  INVX0_RVT U24 ( .A(n40), .Y(n121) );
  INVX0_RVT U25 ( .A(n33), .Y(n119) );
  INVX0_RVT U26 ( .A(n7), .Y(n37) );
  OA22X1_RVT U27 ( .A1(n10), .A2(n5), .A3(n4), .A4(n3), .Y(n38) );
  INVX0_RVT U28 ( .A(n35), .Y(n123) );
  INVX1_RVT U29 ( .A(n8), .Y(n36) );
  INVX1_RVT U30 ( .A(n42), .Y(n117) );
  INVX1_RVT U31 ( .A(n19), .Y(n80) );
  INVX1_RVT U32 ( .A(n92), .Y(n126) );
  AND2X1_RVT U33 ( .A1(input_arr[1]), .A2(input_arr[17]), .Y(n10) );
  AND2X1_RVT U34 ( .A1(input_arr[48]), .A2(input_arr[32]), .Y(n6) );
  NAND2X0_RVT U35 ( .A1(input_arr[16]), .A2(input_arr[0]), .Y(n3) );
  OAI22X1_RVT U36 ( .A1(n2), .A2(n1), .A3(input_arr[1]), .A4(input_arr[17]), 
        .Y(n5) );
  FADDX1_RVT U37 ( .A(input_arr[33]), .B(input_arr[49]), .CI(n6), .CO(n39), 
        .S(n2) );
  INVX1_RVT U38 ( .A(n9), .Y(mean_out[0]) );
  INVX1_RVT U39 ( .A(input_arr[15]), .Y(n88) );
  INVX1_RVT U40 ( .A(input_arr[31]), .Y(n87) );
  FADDX1_RVT U41 ( .A(input_arr[18]), .B(input_arr[2]), .CI(n10), .CO(n34), 
        .S(n8) );
  FADDX1_RVT U42 ( .A(input_arr[30]), .B(input_arr[14]), .CI(n12), .CO(n86), 
        .S(n13) );
  FADDX1_RVT U43 ( .A(input_arr[29]), .B(input_arr[13]), .CI(n14), .CO(n12), 
        .S(n15) );
  FADDX1_RVT U44 ( .A(input_arr[28]), .B(input_arr[12]), .CI(n16), .CO(n14), 
        .S(n17) );
  FADDX1_RVT U45 ( .A(input_arr[27]), .B(input_arr[11]), .CI(n18), .CO(n16), 
        .S(n19) );
  FADDX1_RVT U46 ( .A(input_arr[26]), .B(input_arr[10]), .CI(n20), .CO(n18), 
        .S(n21) );
  FADDX1_RVT U47 ( .A(input_arr[25]), .B(input_arr[9]), .CI(n22), .CO(n20), 
        .S(n23) );
  FADDX1_RVT U48 ( .A(input_arr[24]), .B(input_arr[8]), .CI(n24), .CO(n22), 
        .S(n25) );
  FADDX1_RVT U49 ( .A(input_arr[23]), .B(input_arr[7]), .CI(n26), .CO(n24), 
        .S(n27) );
  FADDX1_RVT U50 ( .A(input_arr[22]), .B(input_arr[6]), .CI(n28), .CO(n26), 
        .S(n29) );
  FADDX1_RVT U51 ( .A(input_arr[21]), .B(input_arr[5]), .CI(n30), .CO(n28), 
        .S(n31) );
  FADDX1_RVT U52 ( .A(input_arr[20]), .B(input_arr[4]), .CI(n32), .CO(n30), 
        .S(n33) );
  FADDX1_RVT U53 ( .A(input_arr[19]), .B(input_arr[3]), .CI(n34), .CO(n32), 
        .S(n35) );
  FADDX1_RVT U54 ( .A(n38), .B(n37), .CI(n36), .CO(n122), .S(n9) );
  FADDX1_RVT U55 ( .A(input_arr[34]), .B(input_arr[50]), .CI(n39), .CO(n41), 
        .S(n7) );
  FADDX1_RVT U56 ( .A(input_arr[35]), .B(input_arr[51]), .CI(n41), .CO(n43), 
        .S(n40) );
  FADDX1_RVT U57 ( .A(input_arr[36]), .B(input_arr[52]), .CI(n43), .CO(n45), 
        .S(n42) );
  FADDX1_RVT U58 ( .A(input_arr[37]), .B(input_arr[53]), .CI(n45), .CO(n47), 
        .S(n44) );
  FADDX1_RVT U59 ( .A(input_arr[38]), .B(input_arr[54]), .CI(n47), .CO(n49), 
        .S(n46) );
  FADDX1_RVT U60 ( .A(input_arr[39]), .B(input_arr[55]), .CI(n49), .CO(n51), 
        .S(n48) );
  FADDX1_RVT U61 ( .A(input_arr[40]), .B(input_arr[56]), .CI(n51), .CO(n53), 
        .S(n50) );
  FADDX1_RVT U62 ( .A(input_arr[41]), .B(input_arr[57]), .CI(n53), .CO(n55), 
        .S(n52) );
  FADDX1_RVT U63 ( .A(input_arr[42]), .B(input_arr[58]), .CI(n55), .CO(n57), 
        .S(n54) );
  FADDX1_RVT U64 ( .A(input_arr[43]), .B(input_arr[59]), .CI(n57), .CO(n59), 
        .S(n56) );
  FADDX1_RVT U65 ( .A(input_arr[44]), .B(input_arr[60]), .CI(n59), .CO(n61), 
        .S(n58) );
  FADDX1_RVT U66 ( .A(input_arr[45]), .B(input_arr[61]), .CI(n61), .CO(n63), 
        .S(n60) );
  INVX1_RVT U67 ( .A(input_arr[47]), .Y(n95) );
  INVX1_RVT U68 ( .A(input_arr[63]), .Y(n94) );
  FADDX1_RVT U69 ( .A(input_arr[46]), .B(input_arr[62]), .CI(n63), .CO(n93), 
        .S(n62) );
  INVX1_RVT U70 ( .A(n65), .Y(mean_out[13]) );
  FADDX1_RVT U71 ( .A(n68), .B(n67), .CI(n66), .CO(n90), .S(n69) );
  INVX1_RVT U72 ( .A(n69), .Y(mean_out[12]) );
  FADDX1_RVT U73 ( .A(n72), .B(n71), .CI(n70), .CO(n67), .S(n73) );
  INVX1_RVT U74 ( .A(n73), .Y(mean_out[11]) );
  FADDX1_RVT U75 ( .A(n76), .B(n75), .CI(n74), .CO(n71), .S(n77) );
  INVX1_RVT U76 ( .A(n77), .Y(mean_out[10]) );
  FADDX1_RVT U77 ( .A(n80), .B(n79), .CI(n78), .CO(n75), .S(n81) );
  INVX1_RVT U78 ( .A(n81), .Y(mean_out[9]) );
  FADDX1_RVT U79 ( .A(n84), .B(n83), .CI(n82), .CO(n79), .S(n85) );
  INVX1_RVT U80 ( .A(n85), .Y(mean_out[8]) );
  FADDX1_RVT U81 ( .A(n88), .B(n87), .CI(n86), .CO(n127), .S(n11) );
  FADDX1_RVT U82 ( .A(n91), .B(n90), .CI(n89), .CO(n92), .S(n65) );
  FADDX1_RVT U83 ( .A(n95), .B(n94), .CI(n93), .CO(n125), .S(n64) );
  INVX1_RVT U84 ( .A(n96), .Y(mean_out[15]) );
  FADDX1_RVT U85 ( .A(n99), .B(n98), .CI(n97), .CO(n83), .S(n100) );
  INVX1_RVT U86 ( .A(n100), .Y(mean_out[7]) );
  FADDX1_RVT U87 ( .A(n103), .B(n102), .CI(n101), .CO(n98), .S(n104) );
  INVX1_RVT U88 ( .A(n104), .Y(mean_out[6]) );
  FADDX1_RVT U89 ( .A(n107), .B(n106), .CI(n105), .CO(n102), .S(n108) );
  INVX1_RVT U90 ( .A(n108), .Y(mean_out[5]) );
  FADDX1_RVT U91 ( .A(n111), .B(n110), .CI(n109), .CO(n106), .S(n112) );
  INVX1_RVT U92 ( .A(n112), .Y(mean_out[4]) );
  FADDX1_RVT U93 ( .A(n115), .B(n114), .CI(n113), .CO(n110), .S(n116) );
  INVX1_RVT U94 ( .A(n116), .Y(mean_out[3]) );
  FADDX1_RVT U95 ( .A(n119), .B(n118), .CI(n117), .CO(n114), .S(n120) );
  INVX1_RVT U96 ( .A(n120), .Y(mean_out[2]) );
  FADDX1_RVT U97 ( .A(n123), .B(n122), .CI(n121), .CO(n118), .S(n124) );
  INVX1_RVT U98 ( .A(n124), .Y(mean_out[1]) );
  FADDX1_RVT U99 ( .A(n127), .B(n126), .CI(n125), .CO(n96), .S(mean_out[14])
         );
endmodule

