package flecs

import "core:c"

EntityDesc :: struct
{
    _canary: c.int32_t,
    id: Entity,
    parent: Entity,
    name: cstring,
    sep: cstring,
    root_sep: cstring,
    symbol: cstring,

    use_low_id: bool,
    add: [^]id_t,
    set: [^]Value,
    add_expr: cstring,
}

BulkDesc :: struct
{
    _canary: c.int32_t,
    entities: [^]Entity,
    count: c.int32_t,

    ids: [ID_CACHE_SIZE]id_t,

    data: [^]rawptr,

    table: ^Table,
}

ComponentDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    type: TypeInfo,
}

QueryDesc :: struct
{
    _canary: c.int32_t,
    terms: [FLECS_TERM_COUNT_MAX]Term,
    expr: cstring,
    cache_kind: QueryCacheKind,
    flags: flags32_t,
    order_by_callback: order_by_action_t,
    order_by_table_callback: sort_table_action_t,
    order_by: Entity,
    group_by: id_t,
    group_by_callback: group_by_action_t,
    on_group_create: group_create_action_t,
    on_group_delete: group_delete_action_t,
    group_by_ctx: rawptr,
    group_by_ctx_free: ctx_free_t,
    ctx: rawptr,
    binding_ctx: rawptr,
    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,
    entity: Entity
}

ObserverDesc :: struct
{
    _canary: c.int32_t,
    entity: Entity,
    query: QueryDesc,
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    yield_existing: bool,
    callback: iter_action_t,
    run: run_action_t,
    ctx: rawptr,
    ctx_free: ctx_free_t,
    callback_ctx: rawptr,
    callback_ctx_free: ctx_free_t,
    run_ctx: rawptr,
    run_ctx_free: ctx_free_t,
    observable: poly_t,
    last_event_id: ^c.int32_t,
    term_index_: c.int8_t,
    flags_: flags32_t
}

// Builtin components
EcsIdentifier :: struct
{
    value: cstring,
    length: size_t,
    hash: c.uint64_t,
    index_hash: c.uint64_t,
    index: ^Hashmap,
}

EcsComponent :: struct
{
    size: size_t,
    alignment: size_t,
}

EcsPoly :: struct
{
    poly: ^poly_t,
}

EcsDefaultChildComponent :: struct {
    component: id_t
}

// EcsIterable :: Iterable

// misc types
Value :: struct
{
    type: Entity,
    ptr: rawptr,
}

WorldInfo :: struct
{
    last_component_id: Entity,
    min_id: Entity,
    max_id: Entity,

    delta_time_raw: ftime_t,
    delta_time: ftime_t,
    time_scale: ftime_t,
    target_fps: ftime_t,
    frame_time_total: ftime_t,
    system_time_total: ftime_t,
    emit_time_total: ftime_t,
    merge_time_total: ftime_t,
    rematch_time_total: ftime_t,
    world_time_total: c.double,
    world_time_total_raw: c.double,

    frame_count_total: c.int64_t,
    merge_count_total: c.int64_t,
    eval_comp_monitors_total: c.int64_t,
    rematch_count_total: c.int64_t,

    id_create_total: c.int64_t,
    id_delete_total: c.int64_t,
    table_create_total: c.int64_t,
    table_delete_total: c.int64_t,
    pipeline_build_count_total: c.int64_t,
    systems_ran_frame: c.int64_t,
    observers_ran_frame: c.int64_t,

    tag_id_count: c.int32_t,
    component_id_count: c.int32_t,
    pair_id_count: c.int32_t,

    table_count: c.int32_t,

    cmd: struct
    {
        add_count: c.int64_t,
        remove_count: c.int64_t,
        delete_count: c.int64_t,
        clear_count: c.int64_t,
        set_count: c.int64_t,
        ensure_count: c.int64_t,
        modified_count: c.int64_t,
        discard_count: c.int64_t,
        event_count: c.int64_t,
        other_count: c.int64_t,
        batched_entity_count: c.int64_t,
        batched_command_count: c.int64_t,
    },

    name_prefix: cstring,
}

QueryGroupInfo :: struct
{
    id: c.uint64_t,
    match_count: c.int32_t,
    table_count: c.int32_t,
    ctx: rawptr,
}
