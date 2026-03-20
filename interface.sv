interface intf(input logic pclk);
  logic prst, transfer, pwrite;
  logic [31:0] paddr, pwdata;
  logic  pready, pslverr;
  logic [31:0] prdata;

  logic psel, penable, pwrite_out;
  logic [31:0] paddr_out, pwdata_out, dataout;
  logic slverr, done;
  
  clocking drvcb @(posedge pclk);
    output prst, transfer, pwrite, paddr, pwdata;
    input pready, prdata, pslverr, psel, penable, paddr_out, pwrite_out, pwdata_out, dataout, slverr, done;
  endclocking
  
  clocking moncb @(posedge pclk);
    input prst, transfer, pwrite, paddr, pwdata;
    input pready, prdata, pslverr, psel, penable, paddr_out, pwrite_out, pwdata_out, dataout, slverr, done;
  endclocking
  
  modport drvmod(clocking drvcb, input pclk);
  modport monmod(clocking moncb, input pclk);
endinterface
