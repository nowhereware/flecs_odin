package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "system:flecs.lib"
}

// _ Functions
@(default_calling_convention = "c", link_prefix = "_ecs", private)
foreign flecs
{
    // Example
    // _map_get_deref :: proc(map_: ^Map, key: Map_Key) -> rawptr ---
}

// Public functions
@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // Table Cache
    table_cache_init :: proc(world: ^World, cache: ^Table_Cache) ---
    table_cache_fini :: proc(cache: ^Table_Cache) ---
    table_cache_insert :: proc(cache: ^Table_Cache, table: ^Table, result: ^Table_Cache_Hdr) ---
    table_cache_insert_w_empty :: proc(cache: ^Table_Cache, table: ^Table, result: ^Table_Cache_Hdr, is_empty: bool) ---
    table_cache_replace :: proc(cache: ^Table_Cache, table: ^Table, elem: ^Table_Cache_Hdr) ---
    table_cache_remove :: proc(cache: ^Table_Cache, table_id: u64, elem: ^Table_Cache_Hdr) -> rawptr ---
    table_cache_get :: proc(cache: ^Table_Cache, table: ^Table) -> rawptr ---
    table_cache_set_empty :: proc(cache: ^Table_Cache, table: ^Table, empty: bool) -> bool ---
    table_cache_is_empty :: proc(cache: ^Table_Cache) -> bool ---

}

// Flecs functions
@(default_calling_convention = "c", link_prefix = "flecs_")
foreign flecs
{
    // Table Cache
    table_cache_iter :: proc(cache: ^Table_Cache, out: ^Table_Cache_Iter) -> bool ---
    table_cache_empty_iter :: proc(cache: ^Table_Cache, out: ^Table_Cache_Iter) -> bool ---
    table_cache_all_iter :: proc(cache: ^Table_Cache, out: ^Table_Cache_Iter) -> bool ---
    table_cache_next_ :: proc(it: ^Table_Cache_Iter) -> ^Table_Cache_Hdr ---

    // Id Record
    id_record_get :: proc(world: ^World, id: Id) -> ^Id_Record ---
    id_record_ensure :: proc(world: ^World, id: Id) -> ^Id_Record ---
    id_record_claim :: proc(world: ^World, idr: ^Id_Record) ---
    id_record_release :: proc(world: ^World, idr: ^Id_Record) -> i32 ---
    id_record_release_tables :: proc(world: ^World, idr: ^Id_Record) ---
    id_record_set_type_info :: proc(world: ^World, idr: ^Id_Record, ti: ^Ecs_Type_Info) -> bool ---
    id_name_index_ensure :: proc(world: ^World, id: Id) -> ^Hash_Map ---
    id_record_name_index_ensure :: proc(world: ^World, idr: ^Id_Record) -> ^Hash_Map ---
    id_name_index_get :: proc(world: ^World, id: Id) -> ^Hash_Map ---
    table_record_get :: proc(world: ^World, table: ^Table, id: Id) -> ^Table_Record ---
    id_record_get_table :: proc(idr: ^Id_Record, table: ^Table) -> ^Table_Record ---
    id_record_init_sparse :: proc(world: ^World, idr: ^Id_Record) ---
    init_id_records :: proc(world: ^World) ---
    fini_id_records :: proc(world: ^World) ---
}

/// Externs
@(default_calling_convention = "c")
foreign flecs
{
    ECS_ID_FLAG_BIT: c.ulonglong
    ECS_PAIR: c.ulonglong
    ECS_OVERRIDE: c.ulonglong
    ECS_TOGGLE: c.ulonglong
    ECS_AND: c.ulonglong

    // Builtin component ids
    @(link_name="EcsQuery") Ecs_Query: Entity
    @(link_name="EcsObserver") Ecs_Observer: Entity

    @(link_name="EcsSystem") Ecs_System: Entity
    @(link_name="EcsFlag") Ecs_Flag: Entity
    @(link_name="EcsFlecsInternals") Ecs_Flecs_Internals: Entity

    // Doc entities
    @(link_name="DocBrief") Doc_Brief: Entity
    @(link_name="DocDetail") Doc_Detail: Entity
    @(link_name="DocLink") Doc_Link: Entity
    @(link_name="DocColor") Doc_Color: Entity

    // Global OS API
    @(link_name="ecs_os_api") Global_OS_API: OS_API

    @(link_name="EcsConstant") Ecs_Constant: Entity
    @(link_name="EcsQuantity") Ecs_Quantity: Entity

    @(link_name="EcsPeriod1s") Ecs_Period_1s: Entity
    @(link_name="EcsPeriod1m") Ecs_Period_1m: Entity
    @(link_name="EcsPeriod1h") Ecs_Period_1h: Entity
    @(link_name="EcsPeriod1d") Ecs_Period_1d: Entity
    @(link_name="EcsPeriod1w") Ecs_Period_1w: Entity

    rest_request_count: i64
    rest_entity_count: i64
    rest_entity_error_count: i64
    rest_query_count: i64
    rest_query_error_count: i64
    rest_query_name_count: i64
    rest_query_name_error_count: i64
    rest_query_name_from_cache_count: i64
    rest_enable_count: i64
    rest_enable_error_count: i64
    rest_delete_count: i64
    rest_delete_error_count: i64
    rest_world_stats_count: i64
    rest_pipeline_stats_count: i64
    rest_stats_error_count: i64
}

/// Module imports
@(default_calling_convention = "c", link_prefix = "Flecs")
foreign flecs
{
    DocImport :: proc(world: ^World) ---
    MetaImport :: proc(world: ^World) ---
    MetricsImport :: proc(world: ^World) ---
    MonitorImport :: proc(world: ^World) ---
    PipelineImport :: proc(world: ^World) ---
    ScriptImport :: proc(world: ^World) ---
    RestImport :: proc(world: ^World) ---
}