class counter_ref;

    counter_trans w_data;

    static logic [3:0] ref_count = 4'd0;

    mailbox #(counter_trans) wrmon2rm;
    mailbox #(counter_trans) rm2sb;


    function new(
        mailbox #(counter_trans) wrmon2rm,
        mailbox #(counter_trans) rm2sb
    );

        this.wrmon2rm = wrmon2rm;
        this.rm2sb = rm2sb;

    endfunction


    virtual task count_mod(counter_trans model_counter);

        if(model_counter.reset)
        begin
            ref_count = 4'd0;
        end

        else if(model_counter.load)
        begin
            ref_count = model_counter.data_in;
        end

        else if(model_counter.up_down == 0)
        begin
            if(ref_count == 4'd11)
                ref_count = 4'd0;
            else
                ref_count = ref_count + 1'b1;
        end

        else
        begin
            if(ref_count == 4'd0)
                ref_count = 4'd11;
            else
                ref_count = ref_count - 1'b1;
        end

        model_counter.data_out = ref_count;

    endtask


    virtual task start();

        fork

            forever
            begin

                wrmon2rm.get(w_data);

                count_mod(w_data);

                rm2sb.put(w_data);

            end

        join_none

    endtask

endclass
