class counter_rd_mon;

    virtual counter_if.RD_MON_MP rd_mon_if;

    mailbox #(counter_trans) mon2sb;

    counter_trans rd_data;

    bit first_sample;


    function new(
        virtual counter_if.RD_MON_MP rd_mon_if,
        mailbox #(counter_trans) mon2sb
    );

        this.rd_mon_if = rd_mon_if;
        this.mon2sb = mon2sb;

        this.rd_data = new();

        first_sample = 1'b1;

    endfunction


    virtual task monitor();

        @(rd_mon_if.rd_cb);

        rd_data = new();

        rd_data.data_out = rd_mon_if.rd_cb.data_out;

    endtask


    virtual task start();

        fork

            forever
            begin

                monitor();

                if(first_sample)
                begin
                    // Ignore initial X output before first transaction
                    first_sample = 1'b0;
                end
                else
                begin
                    mon2sb.put(rd_data);

                    $display("read monitor is working");
                end

            end

        join_none

    endtask

endclass
