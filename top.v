module top (
    input hwrite_in,readyin1,readyin2,readyin3,hclk,hresetn,start,burst,data_ready,input[31:0] hwdata_in,haddr_in,input [2:0]hsize_in,input[1:0]offset_in,
    output [31:0] hrdata_out
);
    wire [31:0] haddr, hwdata, hrdata;
    wire hwrite, hready, hresp;
    wire [2:0] hsize,hburst;
    wire [1:0] htrans, add_offset;
    wire hsel1, hsel2, hsel3;
    wire hready1, hready2, hready3;
    wire hresp1, hresp2, hresp3;
    wire hreadyout;
    wire [31:0] hrdata1, hrdata2, hrdata3;
    mast m1(
        .hwrite_in(hwrite_in),
        .hready(hready),
        .hresp(hresp),
        .hclk(hclk),
        .hresetn(hresetn),
        .start(start),
        .burst(burst),
        .data_ready(data_ready),
        .hrdata(hrdata),
        .haddrin(haddr_in),
        .hwdatain(hwdata_in),
        .hsize_in(hsize_in),
        .offset_in(offset_in),
        .hwrite(hwrite),
        .haddr(haddr),
        .hwdata(hwdata),
        .hrdata_out(hrdata_out),
        .hsize(hsize),
        .hburst(hburst),
        .htrans(htrans),
        .offset(add_offset)
    );
    interconnect ic1(
        .sel(haddr[14:13]),
        .hready1(hready1),
        .hclk(hclk),
        .hresetn(hresetn),
        .hready2(hready2),
        .hready3(hready3),
        .hresp1(hresp1),
        .hresp2(hresp2),
        .hresp3(hresp3),
        .hrdata1(hrdata1),
        .hrdata2(hrdata2),
        .hrdata3(hrdata3),
        .hrdata(hrdata),
        .hready(hready),
        .hresp(hresp),
        .hsel1(hsel1),
        .hsel2(hsel2),
        .hsel3(hsel3)
    );
    slave s1(
        .hsel(hsel1),
        .hwrite(hwrite),
        .hready(hready),
        .readyin(readyin1),
        .hresetn(hresetn),
        .hclk(hclk),
        .haddr(haddr),
        .hwdata(hwdata),
        .hsize(hsize),
        .hburst(hburst),
        .htrans(htrans),
        .add_offset(add_offset),
        .hrdata(hrdata1),
        .hreadyout(hready1),
        .hresp(hresp1)
    );
    slave s2(
        .hsel(hsel2),
        .hwrite(hwrite),
        .hready(hready),
        .readyin(readyin2),
        .hresetn(hresetn),
        .hclk(hclk),
        .haddr(haddr),
        .hwdata(hwdata),
        .hsize(hsize),
        .hburst(hburst),
        .htrans(htrans),
        .add_offset(add_offset),
        .hrdata(hrdata2),
        .hreadyout(hready2),
        .hresp(hresp2)
    );
    slave s3(
        .hsel(hsel3),
        .hwrite(hwrite),
        .hready(hready),
        .readyin(readyin3),
        .hresetn(hresetn),
        .hclk(hclk),
        .haddr(haddr),
        .hwdata(hwdata),
        .hsize(hsize),
        .hburst(hburst),
        .htrans(htrans),
        .add_offset(add_offset),
        .hrdata(hrdata3),
        .hreadyout(hready3),
        .hresp(hresp3)
    );
endmodule