package flecs

import "core:c"

poly_t :: rawptr

id_t :: c.uint64_t

// Breaks style rules
Entity :: id_t

Entities :: struct {
    ids: [^]Entity,
    count: c.int32_t,
    alive_count: c.int32_t
}

EntityIndex :: struct {
    dense: Vec,
    pages: Vec,
    alive_count: c.int32_t,
    max_id: c.int64_t,
    page_allocator: BlockAllocator,
    allocator: ^Allocator
}

Type :: struct
{
    array: [^]id_t,
    count: c.int32_t,
}

World :: struct
{
    hdr: Header,

    // Metadata
    id_index_lo: [^]ComponentRecord,
    id_index_hi: Map,
    type_info: Map,

    cr_wildcard: ^ComponentRecord,
    cr_wildcard_wildcard: ^ComponentRecord,
    cr_any: ^ComponentRecord,
    cr_isa_wildcard: ^ComponentRecord,
    cr_childof_0: ^ComponentRecord,
    cr_childof_wildcard: ^ComponentRecord,
    cr_identifier_name: ^ComponentRecord,

    cr_non_fragmenting_head: ^ComponentRecord,

    self: ^World,
    observable: Observable,

    event_id: c.int32_t,

    table_version: [TABLE_VERSION_ARRAY_SIZE]c.uint32_t,
    table_columN_version: [TABLE_VERSION_ARRAY_SIZE]c.uint32_t,

    non_trivial_lookup: [HI_COMPONENT_ID]flags8_t,
    non_trivial_set: [HI_COMPONENT_ID]flags8_t,

    range_check_enabled: bool,
    store: Store,

    monitors: MonitorSet,
    pipeline: Entity,

    aliases: Hashmap,
    symbols: Hashmap,

    stages: [^]Stage, // update
    stage_count: c.int32_t,

    component_ids: Vec,

    on_commands: on_commands_action,
    on_commands_active: on_commands_action,
    on_commands_ctx: rawptr,
    on_commands_ctx_active: rawptr,

    worker_cond: os_cond_t,
    sync_cond: os_cond_t,
    sync_mutex: os_mutex_t,
    workers_running: c.int32_t,
    workers_waiting: c.int32_t,
    pq: PipelineDesc,
    workers_use_task_api: bool,

    exclusive_access: os_thread_id_t,
    exclusive_thread_name: cstring,

    world_start_time: Time,
    frame_start_time: Time,
    fps_sleep: ftime_t,

    info: WorldInfo,
    flags: flags32_t,

    default_query_flags: flags32_t,
    monitor_generation: c.int32_t,

    allocators: WorldAllocators,
    allocator: Allocator,

    ctx: rawptr,
    binding_ctx: rawptr,

    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,

    fini_actions: Vec,
}

when FLECS_DEBUG {
    TableMetadata :: struct {
        hash: c.uint64_t,
        lock: c.int32_t,
        traversable_count: c.int32_t,

        generation: c.uint16_t,
        record_count: c.int16_t,

        bs_count: c.int16_t,
        bs_offset: c.int16_t,
        bs_columns: [^]Bitset,

        records: [^]TableRecord,
        childof_r: ^PairRecord,

        parent: struct {
            world: ^World,
            id: Entity
        },

        name_column: c.int16_t,
        doc_name_column: c.int16_t
    }
} else {
    TableMetadata :: struct {
        hash: c.uint64_t,
        lock: c.int32_t,
        traversable_count: c.int32_t,

        generation: c.uint16_t,
        record_count: c.int16_t,

        bs_count: c.int16_t,
        bs_offset: c.int16_t,
        bs_columns: [^]Bitset,

        records: [^]TableRecord,
        childof_r: ^PairRecord,
    }

}

DeleteEmptyTablesDesc :: struct {
    clear_generation: c.uint16_t,
    delete_generaiton: c.uint16_t,
    time_budget_seconds: c.double
}

Table :: struct
{
    id: c.uint64_t,
    flags: flags32_t,
    column_count: c.int16_t,
    version: c.uint16_t,
    bloom_filter: c.uint64_t,
    type: Type,

    data: Data,
    node: GraphNode,

    component_map: ^c.int16_t,
    dirty_state: ^c.int32_t,
    column_map: [^]c.int16_t,

    _: ^TableMetadata
}

Term :: struct
{
    id: id_t,

    src: TermRef,
    first: TermRef,
    second: TermRef,

    trav: Entity,

    inout: c.int16_t,
    oper: c.int16_t,

    field_index: c.int8_t,
    flags_: flags16_t
}

Query :: struct
{
    hdr: Header,

    terms: [^]Term,
    sizes: [^]c.int32_t,
    ids: [^]id_t,

    bloom_filter: c.uint64_t,
    flags: flags32_t,
    var_count: c.int8_t,
    term_count: c.int8_t,
    field_count: c.int8_t,

    fixed_fields: termset_t,
    var_fields: termset_t,
    static_id_fields: termset_t,
    data_fields: termset_t,
    write_fields: termset_t,
    read_fields: termset_t,
    row_fields: termset_t,
    shared_readonly_fields: termset_t,
    set_fields: termset_t,

    cache_kind: QueryCacheKind,

    vars: [^]cstring,

    ctx: rawptr,
    binding_ctx: rawptr,

    entity: Entity,
    real_world: ^World,
    world: ^World,

    eval_count: c.int32_t
}

Observer :: struct
{
    hdr: Header,
    query: ^Query,
    events: [OBSERVER_DESC_EVENT_COUNT_MAX]Entity,
    event_count: c.int32_t,
    callback: iter_action_t,
    run: run_action_t,

    ctx: rawptr,
    callback_ctx: rawptr,
    run_ctx: rawptr,

    ctx_free: ctx_free_t,
    callback_ctx_free: ctx_free_t,
    run_ctx_free: ctx_free_t,

    observable: ^Observable,

    world: ^World,
    entity: Entity,
}

// Opaque type
EventIdRecord :: struct {
    self: Map,
    self_up: Map,
    up: Map,

    observers: Map,

    set_observers: Map,
    entity_observers: Map,

    observer_count: c.int32_t
}

EventRecord :: struct {
    any: ^EventIdRecord,
    wildcard: ^EventIdRecord,
    wildcard_pair: ^EventIdRecord,
    event_ids: Map,
    event: Entity
}

Observable :: struct
{
    on_add: EventRecord,
    on_remove: EventRecord,
    on_set: EventRecord,
    on_wildcard: EventRecord,
    events: ^Sparse,
    last_observer_id: ^c.uint64_t
}

Iter :: struct
{
    world: ^World,
    real_world: ^World,

    offset: c.int32_t,
    count: c.int32_t,
    entities: [^]Entity,
    ptrs: [^]rawptr,
    trs: [^]^TableRecord,
    sizes: [^]size_t,
    table: ^Table,
    other_table: ^Table,
    ids: [^]id_t,
    sources: [^]Entity,
    constrained_vars: flags64_t,
    set_fields: termset_t,
    ref_fields: termset_t,
    row_fields: termset_t,
    up_fields: termset_t,

    system: Entity,
    event: Entity,
    event_id: id_t,
    event_cur: c.int32_t,

    field_count: c.int8_t,
    term_index: c.int8_t,
    query: ^Query,
    
    param: rawptr,
    ctx: rawptr,
    binding_ctx: rawptr,
    callback_ctx: rawptr,
    run_ctx: rawptr,

    delta_time: ftime_t,
    delta_system_time: ftime_t,

    frame_offset: c.int32_t,

    flags: flags32_t,
    interrupted_by: Entity,
    priv_: IterPrivate,

    next: iter_next_action_t,
    callback: iter_action_t,
    fini: iter_fini_action_t,
    chain_it: ^Iter,
}

Ref :: struct
{
    entity: Entity,
    id: Entity,
    table_id: c.uint64_t,
    table_version_fast: c.uint32_t,
    table_version: c.uint16_t,
    record: ^Record,
    ptr: rawptr,
}

TypeHooks :: struct
{
    ctor: xtor_t,
    dtor: xtor_t,
    copy: copy_t,
    move: move_t,

    copy_ctor: copy_t,
    move_ctor: move_t,
    ctor_move_dtor: move_t,
    move_dtor: move_t,

    cmp: cmp_t,
    equals: equals_t,

    flags: flags32_t,
    
    on_add: iter_action_t,
    on_set: iter_action_t,
    on_remove: iter_action_t,
    on_replace: iter_action_t,

    ctx: rawptr,
    binding_ctx: rawptr,
    lifecycle_ctx: rawptr,

    ctx_free: ctx_free_t,
    binding_ctx_free: ctx_free_t,
    lifecycle_ctx_free: ctx_free_t,
}

TypeInfo :: struct
{
    size: size_t,
    alignment: size_t,
    hooks: TypeHooks,
    component: Entity,
    name: cstring,
}

Mixins :: struct
{
    type_name: cstring,
    elems: [MixinKind.Max]size_t,
}

// API constants
ID_CACHE_SIZE :: 32
TERM_DESC_CACHE_SIZE :: 16
OBSERVER_DESC_EVENT_COUNT_MAX :: 8
VARIABLE_COUNT_MAX :: 64

// Function Prototypes
run_action_t :: #type proc "c" (it: ^Iter)
iter_action_t :: #type proc (it: ^Iter)
iter_next_action_t :: #type proc "c" (it: ^Iter) -> c.bool
iter_fini_action_t :: #type proc "c" (it: ^Iter)
order_by_action_t :: #type proc "c" (e1: Entity, ptr1: rawptr, e2: Entity, ptr2: rawptr) -> c.int
sort_table_action_t :: #type proc "c" (world: ^World, table: ^Table, entities: [^]Entity, ptr: rawptr, size: c.int32_t, lo: c.int32_t, hi: c.int32_t, order_by: order_by_action_t)
group_by_action_t :: #type proc "c" (world: ^World, table: ^Table, group_id: id_t, ctx: rawptr) -> c.uint64_t
group_create_action_t :: #type proc "c" (world: ^World, group_id: c.uint64_t, group_by_ctx: rawptr) -> rawptr
group_delete_action_t :: #type proc "c" (world: ^World, group_id: c.uint64_t, group_ctx: rawptr, group_by_ctx: rawptr)
module_action_t :: #type proc "c" (world: ^World)
fini_action_t :: #type proc "c" (world: ^World, ctx: rawptr)
ctx_free_t :: #type proc "c" (ctx: rawptr)
compare_action_t :: #type proc "c" (ptr1: rawptr, ptr2: rawptr) -> c.int
hash_value_action_t :: #type proc "c" (ptr: rawptr) -> c.uint64_t
xtor_t :: #type proc "c" (ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
copy_t :: #type proc "c" (dst_ptr: rawptr, src_ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
move_t :: #type proc "c" (dst_ptr: rawptr, src_ptr: rawptr, count: c.int32_t, type_info: ^TypeInfo)
cmp_t :: #type proc "c" (a_ptr: rawptr, b_ptr: rawptr, type_info: ^TypeInfo) -> bool
equals_t :: #type proc "c" (a_ptr: rawptr, b_ptr: rawptr, type_info: ^TypeInfo) -> bool
poly_dtor_t :: #type proc "c" (poly: ^poly_t)

MixinKind :: enum
{
    World,
    Entity,
    Observable,
    Iterable,
    Dtor,
    Base,
    Max,
}

Header :: struct
{
    type: c.int32_t,
    refcount: c.int32_t,
    mixins: ^Mixins,
}

// Iterable :: struct
// {
//     init: iter_init_action_t,
// }

InOutKind :: enum c.int
{
    InOutDefault,
    InOutNone,
    InOutFilter,
    InOut,
    In,
    Out,
}

OperKind :: enum c.int
{
    And,
    Or,
    Not,
    Optional,
    AndFrom,
    OrFrom,
    NotFrom,
}

QueryCacheKind :: enum c.int
{
    Default,
    Auto,
    All,
    None
}

TermId :: struct
{
    id: Entity,
    name: cstring,
    trav: Entity,
    flags: flags32_t,
}

TermRef :: struct
{
    id: Entity,
    name: cstring
}

// Term, Filter, Observer, TypeHooks, TypeInfo

Commands :: struct {
    queue: Vec,
    stack: Stack,
    entries: Sparse
}

ExprValue :: struct {
    value: Value,
    type_info: ^TypeInfo,
    owned: bool
}

ExprStackFrame :: struct {
    cur: StackCursor,
    sp: c.int32_t
}

ExprStack :: struct {
    values: [EXPR_STACK_MAX]ExprValue,
    frames: [EXPR_STACK_MAX]ExprStackFrame,
    stack: Stack,
    frame: c.int32_t,
}

ScriptRuntime :: struct {
    allocator: Allocator,
    expr_stack: ExprStack,
    stack: Stack,
    _using: Vec,
    with: Vec,
    with_type_info: Vec,
    annot: Vec,
}

StageAllocators :: struct {
    iter_stack: Stack,
    deser_stack: Stack,
    cmd_entry_chunk: BlockAllocator,
    query_impl: BlockAllocator,
    query_cache: BlockAllocator,
}

when FLECS_SCRIPT {
    Stage :: struct
    {
        hdr: Header,

        // Unique id
        id: c.int32_t,

        // Deferred command queue
        _defer: c.int32_t,
        commands: ^Commands,
        cmd_stack: [2]Commands,
        cmd_flushing: bool,

        thread_ctx: ^World,
        world: ^World,
        thread: os_thread_t,

        post_frame_actions: Vec,

        scope: Entity,
        with: Entity,
        base: Entity,

        lookup_path: ^Entity,

        system: Entity,

        allocators: StageAllocators,
        allocator: Allocator,

        variables: Vec,
        operations: Vec,

        runtime: ^ScriptRuntime
    }
} else {
    Stage :: struct
    {
        hdr: Header,

        // Unique id
        id: c.int32_t,

        // Deferred command queue
        _defer: c.int32_t,
        commands: ^Commands,
        cmd_stack: [2]Commands,
        cmd_flushing: bool,

        thread_ctx: ^World,
        world: ^World,
        thread: os_thread_t,

        post_frame_actions: Vec,

        scope: Entity,
        with: Entity,
        base: Entity,

        lookup_path: ^Entity,

        system: Entity,

        allocators: StageAllocators,
        allocator: Allocator,

        variables: Vec,
        operations: Vec,
    }
}


Record :: struct
{
    cr: ^ComponentRecord,
    table: ^Table,
    row: c.uint32_t,
    dense: c.int32_t
}

// Opaque
Column :: struct {
    data: rawptr,
    ti: ^TypeInfo
}

// Opaque, gonna stop replicating these cause I don't think it's necessary
TableOverrides :: struct { }

// Opaque
Data :: struct
{
    entities: [^]Entity,
    columns: [^]Column,
    overrides: [^]TableOverrides,
    count: c.int32_t,
    size: c.int32_t,
}

// Opaque
QueryCacheMatch :: struct {}

// Opaque
QueryCacheGroup :: struct {}

// Sparse

Switch :: struct
{
    hdrs: Map,
    nodes: Vec,
    values: Vec,
}

IdRecord :: struct
{
    cache: TableCache,
    flags: flags32_t,
    refcount: c.int32_t,
    name_index: ^Hashmap,
    type_info: ^TypeInfo,
    id: id_t,
    parent: ^IdRecord,
    
    first: IdRecordElem,
    second: IdRecordElem,
    acyclic: IdRecordElem,
}

QueryTableNode :: struct
{
    next: ^QueryTableNode,
    prev: ^QueryTableNode,
    table: ^Table,
    group_id: c.uint64_t,
    offset: c.int32_t,
    count: c.int32_t,
    match: ^QueryTableMatch,
}

TableRecords :: struct {
    array: [^]TableRecord,
    count: c.int32_t
}

TableRecord :: struct
{
    hdr: TableCacheHdr,
    index: c.int16_t,
    count: c.int16_t,
    column: c.int16_t,
}

TableDiff :: struct
{
    added: Type,
    removed: Type,
    added_flags: flags32_t,
    removed_flags: flags32_t,
}

// Allocator

// Observable, Record

TableRange :: struct
{
    table: ^Table,
    offset: c.int32_t,
    count: c.int32_t,
}

Var :: struct
{
    range: TableRange,
    entity: Entity,
}

// Ref

PageIter :: struct
{
    offset: c.int32_t,
    limit: c.int32_t,
    remaining: c.int32_t,
}

WorkerIter :: struct
{
    index: c.int32_t,
    count: c.int32_t,
}

TableCacheIter :: struct
{
    cur: ^TableCacheHdr,
    next: ^TableCacheHdr,
    iter_fill: bool,
    iter_empty: bool
}

ReachableCache :: struct {
    generation: c.int32_t,
    current: c.int32_t,
    ids: Vec
}

PairRecord :: struct {
    name_index: ^Hashmap,
    ordered_children: Vec,

    first: IdRecordElem,
    second: IdRecordElem,
    trav: IdRecordElem,

    parent: ^ComponentRecord,
    reachable: ReachableCache
}

when FLECS_DEBUG {
    ComponentRecord :: struct {
        cache: TableCache,
        id: id_t,
        flags: flags32_t,
        str: cstring,
        type_info: ^TypeInfo,
        sparse: rawptr,
        pair: PairRecord,
        non_fragmenting: IdRecordElem,
        refcount: c.int32_t,
        keep_alive: c.int32_t,
    }
} else {
    ComponentRecord :: struct {
        cache: TableCache,
        id: id_t,
        flags: flags32_t,
        type_info: ^TypeInfo,
        sparse: rawptr,
        pair: PairRecord,
        non_fragmenting: IdRecordElem,
        refcount: c.int32_t,
        keep_alive: c.int32_t,
    }
}

TableCacheHdr :: struct
{
    cr: ^ComponentRecord,
    table: ^Table,
    prev: ^TableCacheHdr,
    next: ^TableCacheHdr,
}

TermIter :: struct
{
    term: Term,
    self_index: ^IdRecord,
    set_index: ^IdRecord,

    cur: ^IdRecord,
    it: TableCacheIter,
    index: c.int32_t,
    observed_table_count: c.int32_t,

    table: ^Table,
    cur_match: c.int32_t,
    match_count: c.int32_t,
    last_column: c.int32_t,

    empty_tables: bool,

    id: id_t,
    column: c.int32_t,
    subject: Entity,
    size: size_t,
    ptr: rawptr,
}

IterKind :: enum c.int
{
    Condition,
    Tables,
    Chain,
    None,
}

QueryIter :: struct
{
    query: ^Query,
    node: ^QueryTableNode,
    prev: ^QueryTableNode,
    last: ^QueryTableNode,
    sparse_smallest: c.int32_t,
    sparse_first: c.int32_t,
    bitset_first: c.int32_t,
    skip_count: c.int32_t,
}

SparseIter :: struct
{
    sparse: ^Sparse,
    ids: [^]c.uint64_t,
    size: size_t,
    i: c.int32_t,
    count: c.int32_t,
}

iter_cache_ids :: u32(1) << u32(0)
iter_cache_columns :: u32(1) << u32(1)
iter_cache_sources :: u32(1) << u32(2)
iter_cache_sizes :: u32(1) << u32(3)
iter_cache_ptrs :: u32(1) << u32(4)
iter_cache_match_indices :: u32(1) << u32(5)
iter_cache_variables :: u32(1) << u32(6)
iter_cache_all :: 255

EachIter :: struct {
    it: TableCacheIter,

    ids: id_t,
    sources: Entity,
    sizes: size_t,
    columns: c.int32_t,
    trs: [^]TableRecord
}

IterCache :: struct
{
    stack_cursor: StackCursor,
    used: flags8_t,
    allocated: flags8_t,
}

IterPrivate :: struct
{
    iter: struct #raw_union
    {
        query: QueryIter,
        page: PageIter,
        worker: WorkerIter,
        each: EachIter
    },

    entity_iter: rawptr,
    stack_cursor: ^StackCursor
}

// Iter definition


IdRecordElem :: struct
{
    prev: ^ComponentRecord,
    next: ^ComponentRecord,
}
