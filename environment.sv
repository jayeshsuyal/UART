class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sco;

    event nextgd; //gen -> drv 
    event nextgs; //gen -> sco

    mailbox #(transaction) mbxgd; //gen -> drv
    mailbox #(bit [7:0]) mbxms;  // mon -> sco
    mailbox #(bit[7:0]) mbxds; //drv -> sco

    event nextgd;
    event nextgs;

    virtual uart_if uif;

    function new(virtual uart_if uif)
        mbx = new();
        mbxms = new();
        mbxds = new();
        gen = new(mbxgd);
        drv = new(mbxgd,mbxds);
        mon = new(mbxms);
        sco = new(mbxms,mbxds);
    

        this.vif = vif;
        drv.vif = vif;
        mon.vif = vif;

        gen.sconext = nextgs;
        sco.sconext = nextgs;

        gen.drvnext = nextgd;
        drv.drvnext = nextgd;
    endfunction


    task pre_test();
        drv.rst();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
        join_any
    endtask

    task post_test();;
        wait(gen.done.triggered);
        $finish;
    endtask
endclass