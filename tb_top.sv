module tb();

    uart_if uif;

    uart_top #1000 (uif.rst, uif.send, uif.rx, uif.tx, uif.dintx,uif.clk,uif.doutrx,uif.donerx,uif.donetx);

   

    intial begin
        vif.clk <= 0;
    end

    always #10 vif.clk =~ vif.clk;

    environment env;

    initial begin
        env= new(uif);
        env.gen.count(5);
        env.run();
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end


endmodule