# Collect top-level bindings from file 
function collect_bindings(f, index = f.index, syms=  [])
    if haskey(f.state.bindings, index)
        for (name, bs) in f.state.bindings[index]
            for (i, b) in enumerate(bs)
                if b.val isa CSTParser.AbstractEXPR
                    if b.val isa CSTParser.EXPR{CSTParser.ModuleH} && !(i > 1 && bs[i - 1].val == b.val)
                        target_index = add_to_tuple(b.si.i, b.si.n + 1)
                        collect_bindings(f, target_index, syms)
                    end
                    push!(syms, (name,b))
                end
            end
        end
    end
    return syms
end

# Find reference at offset
function find_ref(f::File, offset)
    for rref in f.rref
        if rref.r.loc.offset == offset
            return rref 
        elseif rref.r.loc.offset > offset
            break
        end
    end
    return nothing
end

function find_ref(rrefs::Vector{ResolvedRef}, offset)
    for rref in rrefs
        if rref.r.loc.offset == offset
            return rref 
        elseif rref.r.loc.offset > offset
            break
        end
    end
    return nothing
end

function find_ref(rrefs::Vector{ResolvedRef}, name::String, si::SIndex)
    for rref in rrefs
        if rref.r.val isa CSTParser.IDENTIFIER && rref.r.val.val == name && inscope(si, rref.r.si)
            return rref
        end
    end
    return nothing
end