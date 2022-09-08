class generator:


    mailbox #(transaction) mbx;

    function new(mailbox #(transaction) mbx);
        this.mbx = mbx
        tr = new(); 
    endfunction
    
    int count = 0;
    event sconext;
    event drvnext; 

    task run();
        repeat(count) begin
            assert (tr.randomzie()) else $error("Randomization Failed.!!!");
            mbx.put(tr.copy);
            tr.display("GEN");
            @(drvnext);
            @(sconext);
        end
        -> done;
    endtask


endclass
    
