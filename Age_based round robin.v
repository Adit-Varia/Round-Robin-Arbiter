module age_based_rr_arbiter #(
    parameter N     = 4,   // number of requesters
    parameter AGE_W = 4    // age counter width (saturating)
)(
    input                   clk,
    input                   rst,
    input      [N-1:0]      req,
    output reg [N-1:0]      grant
);

    reg [AGE_W-1:0] age [0:N-1];   // per-requester wait counter
    reg [1:0]       pointer;       // tie-breaker rotation

    // -------- combinational: decide next grant --------
    reg [AGE_W-1:0] max_age;
    reg [N-1:0]     max_mask;      // requesters tied at max_age
    reg [N-1:0]     grant_next;
    reg [1:0]       pointer_next;
    integer k, i, idx;
    reg found;

    always @(*) begin
        max_age = 0;
        for (k = 0; k < N; k = k + 1)
            if (req[k] && age[k] > max_age)
                max_age = age[k];

        for (k = 0; k < N; k = k + 1)
            max_mask[k] = req[k] && (age[k] == max_age);

        grant_next   = {N{1'b0}};
        pointer_next = pointer;
        found        = 1'b0;
        for (i = 0; i < N; i = i + 1) begin
            idx = pointer + i;
            if (idx >= N) idx = idx - N;
            if (!found && max_mask[idx]) begin
                grant_next[idx] = 1'b1;
                pointer_next    = (idx == N-1) ? 2'd0 : idx + 1;
                found = 1'b1;
            end
        end
    end

    // -------- sequential: register grant, pointer, ages --------
    integer m;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant   <= {N{1'b0}};
            pointer <= 2'd0;
            for (m = 0; m < N; m = m + 1) age[m] <= 0;
        end else begin
            grant   <= grant_next;
            pointer <= pointer_next;
            for (m = 0; m < N; m = m + 1) begin
                if (grant_next[m])      age[m] <= 0;
                else if (req[m])        age[m] <= (age[m]=={AGE_W{1'b1}}) ? age[m] : age[m]+1'b1;
                else                    age[m] <= 0;
            end
        end
    end
endmodule


dry run this code 
