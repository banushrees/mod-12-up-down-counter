class counter_env;

    virtual counter_if.DRV_MP dr_if;
    virtual counter_if.WR_MON_MP wr_mon_if;
    virtual counter_if.RD_MON_MP rd_mon_if;


    mailbox #(counter_trans) gen2dr = new();

    mailbox #(counter_trans) rm2sb = new();

    mailbox #(counter_trans) mon2sb = new();

    mailbox #(counter_trans) mon2rm = new();


    counter_gen gen_h;
    counter_wr_mon wrmon_h;
    counter_driver dri_h;
    counter_rd_mon rdmon_h;
    counter_sb sb_h;
    counter_ref mob_h;


    //------------------------- Constructor -------------------------

    function new(
        virtual counter_if.DRV_MP dr_if,
        virtual counter_if.WR_MON_MP wr_mon_if,
        virtual counter_if.RD_MON_MP rd_mon_if
    );

        this.dr_if = dr_if;
        this.wr_mon_if = wr_mon_if;
        this.rd_mon_if = rd_mon_if;

    endfunction


    //------------------------- Build -------------------------

    virtual task build();

        gen_h   = new(gen2dr);

        dri_h   = new(dr_if,gen2dr);

        wrmon_h = new(wr_mon_if,mon2rm);

        rdmon_h = new(rd_mon_if,mon2sb);

        mob_h   = new(mon2rm,rm2sb);

        sb_h    = new(rm2sb,mon2sb);

    endtask


    //------------------------- Start -------------------------

    virtual task start();

        gen_h.start();

        dri_h.start();

        wrmon_h.start();

        rdmon_h.start();

        mob_h.start();

        sb_h.start();

    endtask


    //------------------------- Stop -------------------------

    virtual task stop();

        wait(sb_h.DONE.triggered);

    endtask


    //------------------------- Run -------------------------

    virtual task run();

        start();

        stop();

        sb_h.report();

    endtask

endclass
