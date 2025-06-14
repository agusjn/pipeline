module compare_32_u #(parameter N = 32)(
    input logic[N-1:0] a, b,
    output logic eq, lt
);
    localparam M = N/2;

    generate
        if (N == 1) begin
            // Base case: so sanh 1 bit
            assign eq = ~(a ^ b);
            assign lt = ~a & b;
        end
        else begin
            // Recursive case: ghep 2 bo so sanh M bit lai voi nhau
            logic ehigh, lhigh, elow, llow;
            compare_32_u #(M) highcomp(a[N-1:M], b[N-1:M], ehigh, lhigh);
            compare_32_u #(M) lowcomp(a[M-1:0], b[M-1:0], elow, llow); 
			                              
            // Merge
            assign eq = ehigh & elow;
            assign lt = lhigh | ehigh & llow;
        end
    endgenerate
endmodule