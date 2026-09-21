import counter_pkg::*;

class counter_gen;

    counter_trans trans_h;
    counter_trans data2send;

    mailbox #(counter_trans) gen2dr;


    function new(mailbox #(counter_trans) gen2dr);

        this.gen2dr = gen2dr;
        this.trans_h = new();

    endfunction


    virtual task start();

        fork
        begin

            // 96 combinations
            // RESET x UP_DOWN x LOAD x DATA_IN
            // 2 x 2 x 2 x 12 = 96

            for(int reset_val = 0;
                reset_val <= 1;
                reset_val++)
            begin

                for(int up_down_val = 0;
                    up_down_val <= 1;
                    up_down_val++)
                begin

                    for(int load_val = 0;
                        load_val <= 1;
                        load_val++)
                    begin

                        for(int data_val = 0;
                            data_val <= 11;
                            data_val++)
                        begin

                            data2send = new();

                            data2send.reset   = reset_val;
                            data2send.up_down = up_down_val;
                            data2send.load    = load_val;
                            data2send.data_in = data_val;

                            gen2dr.put(data2send);

                        end

                    end

                end

            end


            // Extra 4 transactions
            repeat(4)
            begin

                data2send = new();

                data2send.reset   = 0;
                data2send.up_down = $urandom_range(0,1);
                data2send.load    = 1;
                data2send.data_in = $urandom_range(0,11);

                gen2dr.put(data2send);

            end

        end
        join_none

    endtask

endclass
