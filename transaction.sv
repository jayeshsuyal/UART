class transaction;

   typedef enum bit [1:0] { read=2'b00, write=2'b01
   } oper_type;

   oper_type oper;

    randc oper;

    rand bit [7:0] dintx;
    bit rx;
    

    bit send;
    bit tx;
    
    bit [7:0] doutrx;
    
    bit donetx;
    bit donerx;


    function transaction copy();
        copy = new();
        copy.dintx = this.dintx;
        copy.rx = this.rx;
        copy.send = this.send;
        copy.tx = this.tx;
        copy.doutrx = this.doutrx;
        copy.donetx = this.donetx;
        copy.donerx = this.donerx;
        copy.oper = this.oper;
    endfunction

    function display(input string tag);
        $display("[%0s]: %0s /t DINTX: %0d, /t RX: %0d, TX: %0d, RX_OUT: %0d, DONE_TX: %0d, DONE_RX: %0d, send: %0b", tag,oper.name(),dintx,rx,tx,doutrx,donetx,donerx,send);
    endfunction

endclass