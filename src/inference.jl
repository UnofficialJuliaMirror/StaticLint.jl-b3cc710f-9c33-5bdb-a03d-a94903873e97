function inference(b, server, rrefs)
    if b.t isa Binding || b.t isa StaticLint.SymbolServer.SymStore
        return
    elseif b.val isa CSTParser.BinarySyntaxOpCall && b.val.op.kind == CSTParser.Tokenize.Tokens.EQ # assignment
        if b.val.arg2 isa CSTParser.LITERAL
            # rhs is a literal, inference is trivial
            if b.val.arg2.kind == CSTParser.Tokenize.Tokens.STRING || b.val.arg2.kind == CSTParser.Tokenize.Tokens.TRIPLE_STRING
                b.t = server.packages["Core"]["String"]
            elseif b.val.arg2.kind == CSTParser.Tokenize.Tokens.INTEGER
                b.t = server.packages["Core"]["Int"]
            elseif b.val.arg2.kind == CSTParser.Tokenize.Tokens.FLOAT
                b.t = server.packages["Core"]["Float64"]
            elseif b.val.arg2.kind == CSTParser.Tokenize.Tokens.HEX_INT || b.val.arg2.kind == CSTParser.Tokenize.Tokens.OCT_INT || b.val.arg2.kind == CSTParser.Tokenize.Tokens.BIN_INT
                b.t = server.packages["Core"]["UInt64"]
            elseif b.val.arg2.kind == CSTParser.Tokenize.Tokens.CHAR
                b.t = server.packages["Core"]["Char"]
            end
        elseif b.val.arg2 isa CSTParser.IDENTIFIER
            # rhs is an ID, copy typing from that reference
            offset = b.loc.offset + b.val.arg1.fullspan + b.val.op.fullspan
            rhs_ref = find_ref(rrefs, offset)
        elseif b.val.arg2 isa CSTParser.EXPR{CSTParser.Ref}
        elseif b.val.arg2 isa CSTParser.EXPR{CSTParser.Call}
        end
    end
end
