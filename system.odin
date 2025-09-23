package flecs

import "core:c"
import "core:strings"
import "core:reflect"

EcsTickSource :: struct
{
    tick: c.bool,
    time_elapsed: ftime_t,
}

SystemDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    query: QueryDesc,
    callback: iter_action_t,
    run: run_action_t,

    ctx: rawptr,
    ctx_free: ctx_free_t,
    callback_ctx: rawptr,
    callback_ctx_free: ctx_free_t,
    run_ctx: rawptr,
    run_ctx_free: ctx_free_t,

    interval: ftime_t,
    rate: c.int32_t,
    tick_source: Entity,
    multi_threaded: c.bool,
    immediate: c.bool,
}

System :: struct {
    hdr: Header,
    run: run_action_t,
    action: iter_action_t,
    query: ^Query,
    tick_source: Entity,
    multi_threaded: c.bool,
    immediate: c.bool,
    name: cstring,

    ctx: rawptr,
    callback_ctx: rawptr,
    run_ctx: rawptr,
    ctx_free: ctx_free_t,
    callback_ctx_free: ctx_free_t,
    run_ctx_free: ctx_free_t,

    time_spent: ftime_t,
    time_passed: ftime_t,
    last_frame: c.int64_t,
    dtor: poly_dtor_t,
}

SystemDefine :: proc(world: ^World, func: iter_action_t, phase: c.uint64_t, args: cstring, name := #caller_expression(func)) -> Entity
{
    sdesc: SystemDesc
    edesc: EntityDesc

    edesc.add[0] = phase != 0 ? pair(EcsDependsOn, phase) : 0
    edesc.add[1] = phase
    edesc.add[3] = 0
    edesc.name = strings.clone_to_cstring(name)

    sdesc.entity = entity_init(world, &edesc)
    sdesc.query.expr = args
    sdesc.callback = func
    id := system_init(world, &sdesc)
    return id
}
