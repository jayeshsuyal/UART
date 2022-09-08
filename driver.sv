class driver;
    virtual uart_if uif;

    transaction tr;

    mailbox #(transaction) mbx; //recieve the data from the generator
    mailbox #(bit [7:0]) mbxds; //send data

    bit [7:0] datarx; ///data recieved. 
    bit wr = 0; // random read/write operation
    int i = 0;
    event drvnext;

    int din;

    ///applying reset to the DUT
    task reset();
    
        uif.rst <= 1'b1;
        uif.rx <= 1'b0;
        uif.send <= 1'b0;
        uif.dintx <= 1'b0;
        uif.doutrx <= 1'b0;
        uif.donerx <= 1'b0;
        uif.donerx <= 1'b0;
        repeat (5) @(posedge uclktx)
        ui.rst <= 1'b0;
        @(posedge uclktx);
        $display("[DRV]: REST COMPLETE");
    endtask

    //main task, tx and rx of data
    task run();
        
        forever 
        begin
            mbx.get(tr);
            //sending the data
            if (tr.oper == 2'b00)begin
                
                @(posedge uclktx)
                uif.rst <= 1'b0;
                uif.send <= 1'b1; //send data: High
                uif.tx <= 1'b1;
                uif.rx <= 1'b1;  //high is the idle state for RX
                uif.dintx <= tr.dintx
                din <= uif.dintx;
                @(posedge uclktx)
                vif.send <= 1'b0;
                mbxds.put(tr.dintx);
                
                $dislay("[DRV]: DATA SENT");
                wait(uif.donetx == 1'b1);
                -> drvnext;
            end

            // data recpetion
            else if (tr.oper == 2'b01) begin
            
                @(posedge uif.uclkrx)
                uif.rst <= 1'b0;
                uif.send <= 1'b0;
                uif.rx <= 1'b0;
                @(posedge uif.uclkrx)

                for (i = 0; i<7; i++)begin 
                    uif.rx <= $urandom;
                    datarx [i]<= uif.rx;
                end

                mbxds.put(datarx);

                $display("[DRV]: DATA RECIEVED - %0d", datarx);

                wait(uif.donerx == 1'b1);
                vif.rx <= 1'b1; //High indicates the completion of data reception.

                -> donerx;

            end                      
        end

    endtask 

endclass