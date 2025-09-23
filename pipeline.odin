package flecs

import "core:c"
import "core:strings"

PipelineOp :: struct {
    offset: c.int32_t,
    count: c.int32_t,
    time_spent: c.double,
    commands_enqueued: c.int64_t,
    multi_threaded: bool,
    immediate: bool
}

PipelineState :: struct {
    query: ^Query,
    ops: Vec,
    systems: Vec,

    last_system: Entity,
    cr_inactive: ^ComponentRecord,
    match_count: c.int32_t,
    rebuild_count: c.int32_t,
    iters: [^]Iter,
    iter_count: c.int32_t,

    cur_op: ^PipelineOp,
    cur_i: c.int32_t,
    ran_since_merge: c.int32_t,
    immediate: bool
}

Pipeline :: struct {
    state: ^PipelineState
}

PipelineDesc :: struct
{
    entity: Entity,
    query: QueryDesc,
}

PipelineDefine :: proc(world: ^World, $T: typeid, args: ..string) -> Entity
{
    pdesc: PipelineDesc
    edesc: EntityDesc

    comp_name_c := _GetTypeName(T)

    edesc.name = comp_name_c
    edesc.symbol = comp_name_c

    pdesc.entity = entity_init(world, &edesc)
    pdesc.query.filter.expr = strings.clone_to_cstring(strings.concatenate(args))

    id := pipeline_init(world, &pdesc)

    // Return id if user wants to store it?
    return id
}

pipeline :: proc(world: ^World, desc: PipelineDesc) -> Entity
{
    desc := desc
    return pipeline_init(world, &desc)
}
