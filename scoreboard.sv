class scoreboard;

    mailbox #(bit [7:0]) mbxds, mbxms;

    int [7:0]ds;
    int [7:0] ms;

    event sconext;

    function new(mailbox #(bit [7:0]) mbxds, mailbox #(bit [7:0]) mbxms)
        this.mbxds = mbxds;
        this.mbxgs = mbxgs;
    endfunction

    task run();

        forever 
        begin

            mbxds.get(ds);
            mbxgs.get(ms);
            $dislay("DATA DRV:%0d, MON: %0d ", ds,ms);

            if (ds == ms)
                $dislay("DATA MATCHED");        
            else
            $dislay("DATA MISMATCH");
            -> sconext;
        end
    endtask 
endclass