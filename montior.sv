class monitor;

    transaction tr;
    virtual uart_if uif;
    mailbox #(bit [7:0]) mbx;
    bit [7:0] ds; // sending data
    bit [7:0] dr; // receiving data
    
    function new();
        this.mbx = mbx;
    endfunction

    task run();
        @(posedge uclktx)

        if((uif.send == 1'b1) && (uif.rx == 1'b1))
        begin
            @(posedge uclktx)
            for(int i = 0; i<= 7; i++)begin
                ds [i] = tr.tx;           
            end      
            $dislay("[MON]: THE DATA SEND ON UART TX: %0d",ds);
        
            @(posedge uclktx); //
            mbx.put(ds);
        end

         else if ((uif.send == 1'b0) && (uif.rx == 1'b0)) 
            begin
                wait(donerx ==1'b1)
                dr = uif.doutrx;
                $dislay("[MON: RX %0d", dr);
                @(posedge uif.uclkrx);
                mbx.put(dr);
             end
    endtask

endclass