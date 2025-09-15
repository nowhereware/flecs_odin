package flecs

import "core:c"

when ODIN_OS == .Windows
{
    foreign import flecs "system:flecs.lib"
}

when ODIN_OS == .Linux {
    foreign import flecs "./libflecs.a"
}

// ************************ CORE API *********************************

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs {
    // Vec
    vec_init :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_init_w_dbg_info :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t, type_name: cstring) --- // Do we support debug ?
    vec_init_if :: proc(vec: ^Vec, size: size_t) ---
    vec_fini :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) ---
    vec_reset :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) ---
    vec_clear :: proc(vec: ^Vec) ---
    vec_append :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) -> rawptr ---
    vec_remove :: proc(vec: ^Vec, size: size_t, elem: c.int32_t) ---
    vec_remove_ordered :: proc(vec: ^Vec, size: size_t, index: c.int32_t) ---
    vec_remove_last :: proc(vec: ^Vec) ---
    vec_copy :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) -> Vec ---
    vec_copy_shrink :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) -> Vec ---
    vec_reclaim :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t) ---
    vec_set_size :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_min_size :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_min_size_w_type_info :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t, ti: ^TypeInfo) ---
    vec_set_min_count :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_min_count_zeromem :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_count :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) ---
    vec_set_count_w_type_info :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t, ti: ^TypeInfo) ---
    vec_set_min_count_w_type_info :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t, ti: ^TypeInfo) ---
    vec_grow :: proc(allocator: ^Allocator, vec: ^Vec, size: size_t, elem_count: c.int32_t) -> rawptr ---
    vec_count :: proc(vec: ^Vec) -> c.int32_t ---
    vec_size :: proc(vec: ^Vec) -> c.int32_t ---
    vec_get :: proc(vec: ^Vec, size: size_t, index: c.int32_t) -> rawptr ---
    vec_first :: proc(vec: ^Vec) -> rawptr ---
    vec_last :: proc(vec: ^Vec, size: size_t) -> rawptr ---

    /* Sparse set Publicly exposed APIs 
     * These APIs are not part of the public API and as a result may change without
     * notice (though they haven't changed in a long time). */
    sparse_init :: proc(sparse: ^Sparse, elem_size: size_t) ---
    sparse_add :: proc(sparse: ^Sparse, elem_size: size_t) -> rawptr ---
    sparse_last_id :: proc(sparse: ^Sparse) -> c.uint32_t ---
    sparse_count :: proc(sparse: ^Sparse) -> c.int32_t ---
    sparse_get_dense :: proc(sparse: ^Sparse, elem_size: size_t, index: c.int32_t) -> rawptr ---
    sparse_get :: proc(sparse: ^Sparse, elem_size: size_t, id: c.uint32_t) -> rawptr ---

    // Map
    map_params_init :: proc(params: ^MapParams, allocator: ^Allocator) ---
    map_params_fini :: proc(params: ^MapParams) ---
    map_init :: proc(map_t: ^Map, allocator: ^Allocator) ---
    map_init_w_params :: proc(map_t: ^Map, params: ^MapParams) ---
    map_init_if :: proc(map_t: ^Map, allocator: ^Allocator) ---
    map_init_w_params_if :: proc(result: ^Map, params: ^MapParams) ---
    map_fini :: proc(map_t: ^Map) ---
    map_get :: proc(map_t: ^Map, key: map_key_t) -> ^map_val_t ---
    map_get_deref_ :: proc(map_t: ^Map, key: map_key_t) -> rawptr ---
    map_ensure :: proc(map_t: ^Map, key: map_key_t) -> ^map_val_t ---
    map_ensure_alloc :: proc(map_t: ^Map, elem_size: size_t, key: map_key_t) -> rawptr ---
    map_insert :: proc(map_t: ^Map, key: map_key_t, value: map_val_t) ---
    map_insert_alloc :: proc(map_t: ^Map, elem_size: size_t, key: map_key_t) -> rawptr ---
    map_remove :: proc(map_t: ^Map, key: map_key_t) -> map_val_t ---
    map_remove_free :: proc(map_t: ^Map, key: map_key_t) ---
    map_clear :: proc(map_t: ^Map) ---
    map_iter :: proc(map_t: ^Map) -> MapIter ---
    map_next :: proc(iter: ^MapIter) -> bool ---
    map_copy :: proc(dst: ^Map, src: ^Map) ---

    // StrBuf

    // Append format string to a buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) ---

    // Append format string with argument list to a buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_vappend :: proc(buffer: ^StrBuf, fmt: cstring, args: c.va_list) ---

    // Append string to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendstr :: proc(buffer: ^StrBuf, str: cstring) ---

    // Append character to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendch :: proc(buffer: ^StrBuf, ch: c.char) ---

    // Append int to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendint :: proc(buffer: ^StrBuf, v: c.int64_t) ---

    // Append float to buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_appendflt :: proc(buffer: ^StrBuf, v: c.double, nan_delim: c.char) ---

    /* Append boolean to buffer.
     * Returns false when max is reached, true when there is still space */
    strbuf_appendbool :: proc(buffer: ^StrBuf, v: bool) ---

    // Append source buffer to destination buffer.
    // Returns false when max is reached, true when there is still space
    strbuf_mergebuff :: proc(dst_buffer: ^StrBuf, src_buffer: ^StrBuf) ---

    /* Append n characters to buffer.
     * Returns false when max is reached, true when there is still space */
    strbuf_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: c.int32_t) ---

    // Return result string
    strbuf_get :: proc(buffer: ^StrBuf) -> cstring ---

    // Return small string from first element (appends \0)
    strbuf_get_small :: proc(buffer: ^StrBuf) -> cstring ---

    // Reset buffer without returning a string
    strbuf_reset :: proc(buffer: ^StrBuf) ---

    // Push a list
    strbuf_list_push :: proc(buffer: ^StrBuf, list_open: cstring, separator: cstring) ---

    // Pop a new list
    strbuf_list_pop :: proc(buffer: ^StrBuf, list_close: cstring) ---

    // Insert a new element in list
    strbuf_list_next :: proc(buffer: ^StrBuf) ---

    // Append character to as new element in list
    strbuf_list_appendch :: proc(buffer: ^StrBuf, ch: c.char) ---

    // Append formatted string as new element in list
    strbuf_list_append :: proc(buffer: ^StrBuf, fmt: cstring, #c_vararg args: ..any) ---

    // Append string as new element in list
    strbuf_list_appendstr :: proc(buffer: ^StrBuf, str: cstring) ---

    // Append string as new element in list
    strbuf_list_appendstrn :: proc(buffer: ^StrBuf, str: cstring, n: c.int32_t) ---

    strbuf_written :: proc(buffer: ^StrBuf) -> c.int32_t ---

    // OSApi
    os_init :: proc() ---
    os_fini :: proc() ---
    os_set_api :: proc(os_api: ^OSApi) ---
    os_get_api :: proc() -> OSApi ---
    os_set_api_defaults :: proc() ---


    // Logging
    os_dbg :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_trace :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_warn :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_err :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_fatal :: proc(file: cstring, line: c.int32_t, msg: cstring) ---
    os_strerror :: proc(err: c.int) -> cstring ---
    os_strset :: proc(str: ^cstring, value: cstring) ---
    os_perf_trace_push_ :: proc(file: cstring, line: c.size_t, name: cstring) ---
    os_perf_trace_pop_ :: proc(file: cstring, line: c.size_t, name: cstring) ---
    sleepf :: proc(t: c.double) ---
    time_measure :: proc(start: ^Time) -> c.double ---
    time_sub :: proc(t1: Time, t2: Time) -> Time ---
    time_to_double :: proc(t: Time) -> c.double ---
    os_memdup :: proc(src: rawptr, size: size_t) -> rawptr ---
    os_has_heap :: proc() -> bool ---
    os_has_threading :: proc() -> bool ---
    os_has_task_support :: proc() -> bool ---
    os_has_time :: proc() -> bool ---
    os_has_logging :: proc() -> bool ---
    os_has_dl :: proc() -> bool ---
    os_has_modules :: proc() -> bool ---

    // Find record for entity
    record_find :: proc(world: ^World, entity: Entity) -> ^Record ---

    // Get entity corresponding with record
    record_get_entity :: proc(record: ^Record) -> Entity ---

    // Begin exclusive write access to entity
    write_begin :: proc(world: ^World, entity: Entity) -> ^Record ---

    // End exclusive write access to entity
    write_end :: proc(record: ^Record) ---

    // Begin read access to entity
    read_begin :: proc(world: ^World, entity: Entity) -> ^Record ---

    // End read access to entity
    read_end :: proc(record: ^Record) ---

    // Get component from entity record
    record_get_id :: proc(world: ^World, record: ^Record, id: id_t) -> rawptr ---

    // Same as record_get_id but returns a mutable pointer.
    record_ensure_id :: proc(world: ^World, record: ^Record, id: id_t) -> rawptr ---

    // Test if entity for record has a (component) id
    record_has_id :: proc(world: ^World, record: ^Record, id: id_t) -> bool ---

    // Get component pointer from column/record
    record_get_by_column :: proc(record: ^Record, column: c.int32_t, size: size_t) -> rawptr ---

    // World api

    // Create a new world
    init :: proc() -> ^World ---

    // Create a new world with just the core module
    mini :: proc() -> ^World ---

    // Create a new world with arguments
    init_w_args :: proc(argc: c.int, argv: [^]cstring) -> ^World ---

    // Delete a world
    fini :: proc(world: ^World) -> c.int ---

    // Returns whether the world is being deleted
    is_fini :: proc(world: ^World) -> bool ---

    // Register action to be executed when world is destroyed
    atfini :: proc(world: ^World, action: fini_action_t, ctx: rawptr) ---

    // Return entity identifiers in the world
    get_entities :: proc(world: ^World) -> Entities ---

    // Get flags set on the world
    world_get_flags :: proc(world: ^World) -> flags32_t ---

    // Begin Frame
    frame_begin :: proc(world: ^World, delta_time: ftime_t) -> ftime_t ---

    // End frame
    frame_end :: proc(world: ^World) ---

    // Register action to be executed once after frame
    run_post_frame :: proc(world: ^World, action: fini_action_t, ctx: rawptr) ---

    // Signal exit
    quit :: proc(world: ^World) ---

    // Return whether a quit has been requested
    should_quit :: proc(world: ^World) -> bool ---

    // Measure frame time
    measure_frame_time :: proc(world: ^World, enable: bool) ---

    // Measure system time
    measure_system_time :: proc(world: ^World, enable: bool) ---

    // Set target frames per second (FPS) for application
    set_target_fps :: proc(world: ^World, fps: ftime_t) ---

    // Set default query flags
    set_default_query_flags :: proc(world: ^World, flags: flags32_t) ---

    // Commands

    // Begin readonly mode
    readonly_begin :: proc(world: ^World, multi_threaded: bool) -> bool ---

    // End readonly mode
    readonly_end :: proc(world: ^World) ---

    // Merge world or stage
    merge :: proc(world: ^World) ---

    // Defer operations until end of frame
    defer_begin :: proc(world: ^World) -> bool ---

    // Test if deferring is enabled for current stage
    is_deferred :: proc(world: ^World) -> bool ---

    // End block of operations to defer
    defer_end :: proc(world: ^World) -> bool ---

    // Suspend deferring but do not flush the queue
    defer_suspend :: proc(world: ^World) ---

    // Resume deferring
    defer_resume :: proc(world: ^World) ---

    // Configure world to have N stages
    set_stage_count :: proc(world: ^World, stages: c.int32_t) ---

    // Get number of configured stages
    get_stage_count :: proc(world: ^World) -> c.int32_t ---

    // Get stage-specific world pointer
    get_stage :: proc(world: ^World, stage_id: c.int32_t) -> ^World ---

    // Test whether the current world is readonly
    stage_is_readonly :: proc(world: ^World) -> bool ---

    // Create unmanaged stage
    stage_new :: proc(world: ^World) -> ^World ---

    // Free unmanaged stage
    stage_free :: proc(stage: ^World) ---

    // Get stage id
    stage_get_id :: proc(world: ^World) -> c.int32_t ---

    // Misc

    // Set a world context
    set_ctx :: proc(world: ^World, ctx: rawptr, ctx_free: ctx_free_t) ---

    // Set a world binding context
    set_binding_ctx :: proc(world: ^World, ctx: rawptr, ctx_free: ctx_free_t) ---

    // Get the world context
    get_ctx :: proc(world: ^World) -> rawptr ---

    // Get the world binding context
    get_binding_ctx :: proc(world: ^World) -> rawptr ---

    // Get build info
    get_build_info :: proc() -> ^BuildInfo ---

    // Get world info
    get_world_info :: proc(world: ^World) -> ^WorldInfo ---

    // Dimension the world for a specified number of entities
    dim :: proc(world: ^World, entity_count: c.int32_t) ---

    // Free unused memory
    shrink :: proc(world: ^World) ---

    // Set a range for issuing new entity ids
    set_entity_range :: proc(world: ^World, id_start: Entity, id_end: Entity) ---

    // Enable/disable range limits
    enable_range_check :: proc(world: ^World, enable: bool) -> bool ---

    // Get the largest issued entity id (not counting generation)
    get_max_id :: proc(world: ^World) -> Entity ---

    // Force aperiodic actions
    run_aperiodic :: proc(world: ^World, flags: flags32_t) ---

    // Cleanup empty tables
    delete_empty_tables :: proc(world: ^World, desc: ^DeleteEmptyTablesDesc) -> c.int32_t ---

    // Get world from poly
    get_world :: proc(poly: poly_t) -> ^World ---

    // Get entity from poly
    get_entity :: proc(poly: poly_t) -> Entity ---

    // Make a pair id
    make_pair :: proc(first: Entity, second: Entity) -> id_t ---

    // Begin exclusive thread access
    exclusive_access_begin :: proc(world: ^World, thread_name: cstring) ---

    // End exclusive access
    exclusive_access_end :: proc(world: ^World, lock_world: bool) ---


    // Entities api

    // Create a new entity id
    new :: proc(world: ^World) -> Entity ---

    // Create a new low id
    new_low_id :: proc(world: ^World) -> Entity ---

    // Create new entity with (component) id
    new_w_id :: proc(world: ^World, component: id_t) -> Entity ---

    // Create new entity in table
    new_w_table :: proc(world: ^World, table: ^Table) -> Entity ---

    // Find or create an entity
    entity_init :: proc(world: ^World, desc: ^EntityDesc) -> Entity ---

    // Bulk create/populate new entities
    bulk_init :: proc(world: ^World, desc: ^BulkDesc) -> [^]Entity ---

    // Create N new entities
    bulk_new_w_id :: proc(world: ^World, component: id_t, count: c.int32_t) -> ^Entity ---

    // Clone an entity
    clone :: proc(world: ^World, dst: Entity, src: Entity, copy_value: bool) -> Entity ---

    // Delete an entity
    delete :: proc(world: ^World, entity: Entity) ---

    // Delete all entities with the specified component
    delete_with :: proc(world: ^World, component: id_t) ---

    // Set child order for parent with OrderedChildren
    set_child_order :: proc(world: ^World, parent: Entity, children: [^]Entity, child_count: c.int32_t) ---

    // Get ordered children.
    get_ordered_children :: proc(world: ^World, parent: Entity) -> Entities ---

    // Add a (component) id to an entity.
    add_id :: proc(world: ^World, entity: Entity, component: id_t) ---

    // Remove a component from an entity
    remove_id :: proc(world: ^World, entity: Entity, component: id_t) ---

    // Add auto override for component
    auto_override_id :: proc(world: ^World, entity: Entity, component: id_t) ---

    // Clear all components.
    clear :: proc(world: ^World, entity: Entity) ---

    // Remove all instances of the specified component.
    remove_all :: proc(world: ^World, component: id_t) ---

    // Create new entities with specified component
    set_with :: proc(world: ^World, component: id_t) -> Entity ---

    // Get component set with ecs_set_with().
    get_with :: proc(world: ^World) -> id_t ---

    // Enable or disable entity.
    enable :: proc(world: ^World, entity: Entity, enabled: bool) ---

    // Enable or disable component
    enable_id :: proc(world: ^World, entity: Entity, component: id_t, enable: bool) ---

    // Test if component is enabled
    is_enabled_id :: proc(world: ^World, entity: Entity, component: id_t) -> bool ---

    // Get an immutable to a component.
    get_id :: proc(world: ^World, entity: Entity, component: id_t) -> rawptr ---

    // Get a mutable pointer to a component.
    get_mut_id :: proc(world: ^World, entity: Entity, component: id_t) -> rawptr ---

    // Ensure entity has component, return pointer.
    ensure_id :: proc(world: ^World, entity: Entity, component: id_t, size: size_t) -> rawptr ---

    // Create a component ref.
    ref_init_id :: proc(world: ^World, entity: Entity, component: id_t) -> Ref ---

    // Get component from ref.
    ref_get_id :: proc(world: ^World, ref: ^Ref, component: id_t) -> rawptr ---

    // Update ref.
    ref_update :: proc(world: ^World, ref: ^Ref) ---

    // Emplace a component.
    emplace_id :: proc(world: ^World, entity: Entity, component: id_t, size: size_t, is_new: ^bool) -> rawptr ---

    // Signal that a component has been modified
    modified_id :: proc(world: ^World, entity: Entity, component: id_t) ---

    // Set the value of a component
    set_id :: proc(world: ^World, entity: Entity, component: id_t, size: size_t, ptr: rawptr) ---

    // Test whether an entity is valid
    is_valid :: proc(world: ^World, e: Entity) -> bool ---

    // Test whether an entity is alive
    is_alive :: proc(world: ^World, e: Entity) -> bool ---

    // Remove generation from entity id.
    strip_generation :: proc(e: Entity) -> id_t ---

    // Get alive identifier
    get_alive :: proc(world: ^World, e: Entity) -> Entity ---

    // Ensure id is alive
    make_alive :: proc(world: ^World, entity: Entity) ---

    // Same as ecs_make_alive(), but for components
    make_alive_id :: proc(world: ^World, component: id_t) ---

    // Test whether an entity exists.
    exists :: proc(world: ^World, entity: Entity) -> bool ---

    // Override the generation of an entity.
    set_version :: proc(world: ^World, entity: Entity) ---

    // Get the type of an entity
    get_type :: proc(world: ^World, entity: Entity) -> ^Type ---

    // Get the table of an entity.
    get_table :: proc(world: ^World, entity: Entity) -> ^Table ---

    // Convert type to string.
    type_str :: proc(world: ^World, type: ^Type) -> cstring ---

    // Convert table to string
    table_str :: proc(world: ^World, table: ^Table) -> cstring ---

    // Convert entity to string.
    entity_str :: proc(world: ^World, entity: Entity) -> cstring ---

    // Test if an entity has a component
    has_id :: proc(world: ^World, entity: Entity, component: id_t) -> bool ---

    // Test if an entity owns a component.
    owns_id :: proc(world: ^World, entity: Entity, component: id_t) -> bool ---

    // Get the target of a relationship.
    get_target :: proc(world: ^World, entity: Entity, rel: Entity, index: c.int32_t) -> Entity ---

    // Get parent (target of `ChildOf` relationship) for entity.
    get_parent :: proc(world: ^World, entity: Entity) -> Entity ---

    // Get the target of a relationship for a given component.
    get_target_for_id :: proc(world: ^World, entity: Entity, rel: Entity, component: id_t) -> Entity ---

    // Return depth for entity in tree for the specified relationship.
    get_depth :: proc(world: ^World, entity: Entity, rel: Entity) -> c.int32_t ---

    // Count entities that have the specified id.
    count_id :: proc(world: ^World, entity: id_t) -> c.int32_t ---

    // Get the name of an entity
    get_name :: proc(world: ^World, entity: Entity) -> cstring ---

    // Get the symbol of an entity
    get_symbol :: proc(world: ^World, entity: Entity) -> cstring ---

    // Set the name of an entity.
    set_name :: proc(world: ^World, entity: Entity, name: cstring) -> Entity ---

    // Set the symbol of an entity.
    set_symbol :: proc(world: ^World, entity: Entity, symbol: cstring) -> Entity ---

    // Set alias for entity.
    set_alias :: proc(world: ^World, entity: Entity, alias: cstring) ---

    // Lookup an entity by it's path.
    lookup :: proc(world: ^World, path: cstring) -> Entity ---

    // Lookup a child entity by name.
    lookup_child :: proc(world: ^World, parent: Entity, name: cstring) -> Entity ---

    // Lookup an entity from a path
    lookup_path_w_sep :: proc(world: ^World, parent: Entity, path: cstring, sep: cstring, prefix: cstring, recursive: bool) -> Entity ---

    // Lookup an entity by its symbol name.
    lookup_symbol :: proc(world: ^World, symbol: cstring, lookup_as_path: bool, recursive: bool) -> Entity ---

    // Get a path identifier for an entity.
    get_path_w_sep :: proc(world: ^World, parent: Entity, child: Entity, sep: cstring, prefix: cstring) -> cstring ---

    // Write path identifier to buffer.
    get_path_w_sep_buf :: proc(world: ^World, parent: Entity, child: Entity, sep: cstring, prefix: cstring, buf: ^StrBuf, escape: bool) ---

    // Find or create entity from path.
    new_from_path_w_sep :: proc(world: ^World, parent: Entity, path: cstring, sep: cstring, prefix: cstring) -> Entity ---

    // Add specified path to entity.
    add_path_w_sep :: proc(world: ^World, entity: Entity, parent: Entity, path: cstring, sep: cstring, prefix: cstring) -> Entity ---

    // Set the current scope.
    set_scope :: proc(world: ^World, scope: Entity) -> Entity ---

    // Get the current scope
    get_scope :: proc(world: ^World) -> Entity ---

    // Set a name prefix for newly created entities.
    set_name_prefix :: proc(world: ^World, prefix: cstring) -> cstring ---

    // Set the search path for lookup operations.
    set_lookup_path :: proc(world: ^World, lookup_path: [^]Entity) -> [^]Entity ---

    // Get current lookup path.
    get_lookup_path :: proc(world: ^World) -> [^]Entity ---

    // Components

    // Find or create a component
    component_init :: proc(world: ^World, desc: ^ComponentDesc) -> Entity ---

    // Get the type info for a component
    get_type_info :: proc(world: ^World, component: id_t) -> ^TypeInfo ---

    // Register hooks for component.
    set_hooks_id :: proc(world: ^World, component: Entity, hooks: ^TypeHooks) ---

    // Get hooks for component.
    get_hooks_id :: proc(world: ^World, component: Entity) -> ^TypeHooks ---

    // Ids

    // Returns whether specified component is a tag.
    id_is_tag :: proc(world: ^World, component: id_t) -> bool ---

    // Returns whether specified component is in use.
    id_in_use :: proc(world: ^World, component: id_t) -> bool ---

    // Gets the type for a component
    get_typeid :: proc(world: ^World, component: id_t) -> Entity ---

    // Utility to match a component with a pattern.
    id_match :: proc(component: id_t, pattern: id_t) -> bool ---

    // Utility to check if component is a pair
    id_is_pair :: proc(component: id_t) -> bool ---

    // Utility to check if component is a wildcard
    id_is_wildcard :: proc(component: id_t) -> bool ---

    // Utility to check if component is an any wildcard
    id_is_any :: proc(component: id_t) -> bool ---

    // Utility to check if id is valid
    id_is_valid :: proc(world: ^World, component: id_t) -> bool ---

    // Get flags associated with id
    id_get_flags :: proc(world: ^World, component: id_t) -> flags32_t ---

    // Convert component flag to string
    id_flag_str :: proc(component_flags: id_t) -> cstring ---

    // Convert component id to string.
    id_str :: proc(world: ^World, component: id_t) -> cstring ---

    // Write component string to buffer.
    id_str_buf :: proc(world: ^World, component: id_t, buf: ^StrBuf) ---

    // Convert string to a component
    id_from_str :: proc(world: ^World, expr: cstring) -> id_t ---

    // Queries

    // Test whether term ref is set
    term_ref_is_set :: proc(ref: ^TermRef) -> bool ---

    // Test whether a term is set
    term_is_initialized :: proc(term: ^Term) -> bool ---

    // Is term matched on $this variable
    term_match_this :: proc(term: ^Term) -> bool ---

    // Is term matched on 0 source
    term_match_0 :: proc(term: ^Term) -> bool ---

    // Convert term to string expression.
    term_str :: proc(world: ^World, term: ^Term) -> cstring ---

    // Convert query to string expression.
    query_str :: proc(query: ^Query) -> cstring ---

    // Each iterator

    // Iterate all entities with specified (component id).
    each_id :: proc(world: ^World, component: id_t) -> Iter ---

    // Progress an iterator created with each_id().
    each_next :: proc(it: ^Iter) -> bool ---

    // Iterate children of parent
    children :: proc(world: ^World, parent: Entity) -> Iter ---

    // Progress an iterator created with ecs_children().
    children_next :: proc(it: ^Iter) -> bool ---

    // Queries

    // Create a query
    query_init :: proc(world: ^World, desc: ^QueryDesc) -> ^Query ---

    // Delete a query
    query_fini :: proc(query: ^Query) ---

    // Find variable index
    query_find_var :: proc(query: ^Query, name: cstring) -> c.int32_t ---

    // Get variable name
    query_var_name :: proc(query: ^Query, var_id: c.int32_t) -> cstring ---

    // Test if variable is an entity
    query_var_is_entity :: proc(query: ^Query, var_id: c.int32_t) -> bool ---

    // Create a query iterator
    query_iter :: proc(world: ^World, query: ^Query) -> Iter ---

    // Progress query iterator
    query_next :: proc(it: ^Iter) -> bool ---

    // Match entity with query
    query_has :: proc(query: ^Query, entity: Entity, it: ^Iter) -> bool ---

    // Match table with query
    query_has_table :: proc(query: ^Query, table: ^Table, it: ^Iter) -> bool ---

    // Match range with query
    query_has_range :: proc(query: ^Query, range: ^TableRange, it: ^Iter) -> bool ---

    // Returns how often a match event happend for a cached query
    query_match_count :: proc(query: ^Query) -> c.int32_t ---

    // Convert query to a string
    query_plan :: proc(query: ^Query) -> cstring ---

    // Convert query to string with profile
    query_plan_w_profile :: proc(query: ^Query, it: ^Iter) -> cstring ---

    // Populate variables from key-value string
    query_args_parse :: proc(query: ^Query, it: ^Iter, expr: cstring) -> cstring ---

    // Returns whether the query data changed since the last iteration
    query_changed :: proc(query: ^Query) -> bool ---

    // Get query object
    query_get :: proc(world: ^World, query: Entity) -> ^Query ---

    // Skip a table while iterating
    iter_skip :: proc(it: ^Iter) ---

    // Set group to iterate for query iterator
    iter_set_group :: proc(it: ^Iter, group_id: c.uint64_t) ---

    // Get context of query group
    query_get_group_ctx :: proc(query: ^Query, group_id: c.uint64_t) -> rawptr ---

    // Get information about query group
    query_get_group_info :: proc(query: ^Query, group_id: c.uint64_t) -> ^QueryGroupInfo ---

    // Returns number of entities and results the query matches with.
    query_count :: proc(query: ^Query) -> QueryCount ---

    // Does query return one or more results
    query_is_true :: proc(query: ^Query) -> bool ---

    // Get query used to populate cache
    query_get_cache_query :: proc(query: ^Query) -> ^Query ---

    // Observers

    // Send event
    emit :: proc(world: ^World, desc: ^EventDesc) ---

    // Enqueue event
    enqueue :: proc(world: ^World, desc: ^EventDesc) ---

    // Create observer
    observer_init :: proc(world: ^World, desc: ^ObserverDesc) -> Entity ---

    // Get observer object.
    observer_get :: proc(world: ^World, observer: Entity) -> ^Observer ---

    // Iterators

    // Progress any iterator
    iter_next :: proc(it: ^Iter) -> bool ---

    // Cleanup iterator resources
    iter_fini :: proc(it: ^Iter) ---

    // Count number of matched entities in query
    iter_count :: proc(it: ^Iter) -> c.int32_t ---

    // Test if iterator is true
    iter_is_true :: proc(it: ^Iter) -> bool ---

    // Get first matching entity from iterator.
    iter_first :: proc(it: ^Iter) -> Entity ---

    // Set value for iterator variable.
    iter_set_var :: proc(it: ^Iter, var_id: c.int32_t, entity: Entity) ---

    // Same as iter_set_var, but for a table.
    iter_set_var_as_table :: proc(it: ^Iter, var_id: c.int32_t, table: ^Table) ---

    // Same as iter_set_var, but for a range of entities
    iter_set_var_as_range :: proc(it: ^Iter, var_id: c.int32_t, range: ^TableRange) ---

    // Get value of iterator variable as entity
    iter_get_var :: proc(it: ^Iter, var_id: c.int32_t) -> Entity ---

    // Get variable name
    iter_get_var_name :: proc(it: ^Iter, var_id: c.int32_t) -> cstring ---

    // Get number of variables
    iter_get_var_count :: proc(it: ^Iter) -> c.int32_t ---

    // Get variable array.
    iter_get_vars :: proc(it: ^Iter) -> ^Var ---

    // Get value of iterator variable as table
    iter_get_var_as_table :: proc(it: ^Iter, var_id: c.int32_t) -> ^Table ---

    // Get value of iterator variable as table range.
    iter_get_var_as_range :: proc(it: ^Iter, var_id: c.int32_t) -> TableRange ---

    // Returns whether variable is constrained.
    iter_var_is_constrained :: proc(it: ^Iter, var_id: c.int32_t) -> bool ---

    // Return the group id for the currently iterated result.
    iter_get_group :: proc(it: ^Iter) -> c.int64_t ---

    // Returns whether current iterator result has changed.
    iter_changed :: proc(it: ^Iter) -> bool ---

    // Convert iterator to string
    iter_str :: proc(it: ^Iter) -> cstring ---

    // Create a paged iterator
    page_iter :: proc(it: ^Iter, offset: c.int32_t, limit: c.int32_t) -> Iter ---

    // Progress a paged iterator
    page_next :: proc(it: ^Iter) -> bool ---

    // Create a worker iterator
    worker_iter :: proc(it: ^Iter, index: c.int32_t, count: c.int32_t) -> Iter ---

    // Progress a worker iterator
    worker_next :: proc(it: ^Iter) -> bool ---

    // Get data for field.
    field_w_size :: proc(it: ^Iter, size: size_t, index: c.int8_t) -> rawptr ---

    // Get data for field at specified row
    field_at_w_size :: proc(it: ^Iter, size: size_t, index: c.int8_t, row: c.int32_t) -> rawptr ---

    // Test whether the field is readonly
    field_is_readonly :: proc(it: ^Iter, index: c.int8_t) -> bool ---

    // Test whether the field is writeonly.
    field_is_writeonly :: proc(it: ^Iter, index: c.int8_t) -> bool ---

    // Test whether field is set
    field_is_set :: proc(it: ^Iter, index: c.int8_t) -> bool ---

    // Return id matched for field
    field_id :: proc(it: ^Iter, index: c.int8_t) -> id_t ---

    // Return index of matched table column
    field_column :: proc(it: ^Iter, index: c.int8_t) -> c.int32_t ---

    // Return field source
    field_src :: proc(it: ^Iter, index: c.int8_t) -> Entity ---

    // Return field type size
    field_size :: proc(it: ^Iter, index: c.int8_t) -> size_t ---

    // Test whether the field is matched on self.
    field_is_self :: proc(it: ^Iter, index: c.int8_t) -> bool ---

    // Tables

    // Get type for table
    table_get_type :: proc(table: ^Table) -> ^Type ---

    // Get type index for component
    table_get_type_index :: proc(world: ^World, table: ^Table, component: id_t) -> c.int32_t ---

    // Get column index for component
    table_get_column_index :: proc(world: ^World, table: ^Table, component: id_t) -> c.int32_t ---

    // Return number of columns in table
    table_column_count :: proc(table: ^Table) -> c.int32_t ---

    // Convert type index to column index
    table_type_to_column_index :: proc(table: ^Table, index: c.int32_t) -> c.int32_t ---

    // Convert column index to type index.
    table_column_to_type_index :: proc(table: ^Table, index: c.int32_t) -> c.int32_t ---

    // Get column from table by column index
    table_get_column :: proc(table: ^Table, index: c.int32_t, offset: c.int32_t) -> rawptr ---

    // Get column from table by component.
    table_get_id :: proc(world: ^World, table: ^Table, component: id_t, offset: c.int32_t) -> rawptr ---

    // Get column size from table
    table_get_column_size :: proc(table: ^Table, index: c.int32_t) -> size_t ---

    // Returns the number of entities in the table
    table_count :: proc(table: ^Table) -> c.int32_t ---

    // Returns allocated size of table.
    table_size :: proc(table: ^Table) -> c.int32_t ---

    // Returns array with entity ids for table
    table_entities :: proc(table: ^Table) -> [^]Entity ---

    // Test if table has component.
    table_has_id :: proc(world: ^World, table: ^Table, component: id_t) -> bool ---

    // Return depth for table in tree for relationship rel
    table_get_depth :: proc(world: ^World, table: ^Table, rel: Entity) -> c.int32_t ---

    // Get table that has all components of current talbe plus the specified id.
    table_add_id :: proc(world: ^World, table: ^Table, component: id_t) -> ^Table ---

    // Find table from id array.
    table_find :: proc(world: ^World, ids: [^]id_t, id_count: c.int32_t) -> ^Table ---

    // Get table that has all components of current talbe minus the specified component.
    table_remove_id :: proc(world: ^World, table: ^Table, component: id_t) -> ^Table ---

    // Lock a table
    table_lock :: proc(world: ^World, table: ^Table) ---

    // Unlock a table
    table_unlock :: proc(world: ^World, table: ^Table) ---

    // Test table for flags.
    table_has_flags :: proc(table: ^Table, flags: flags32_t) -> bool ---

    // Check if table has traversable entities
    table_has_traversable :: proc(table: ^Table) -> bool ---

    // Swaps two elements inside the table. This is useful for impleenting custom talbe sorting algorithms.
    table_swap_rows :: proc(world: ^World, table: ^Table, row_1: c.int32_t, row_2: c.int32_t) ---

    // Commit (move) entity to a table
    commit :: proc(world: ^World, entity: Entity, record: ^Record, table: ^Table, added: ^Type, removed: ^Type) -> bool ---

    // Search for component in table type.
    search :: proc(world: ^World, table: ^Table, component: id_t, component_out: ^id_t) -> c.int32_t ---

    // Search for component in talbe type starting from an offset.
    search_offset :: proc(world: ^World, table: ^Table, offset: c.int32_t, component: id_t, component_out: ^id_t) -> c.int32_t ---

    // Search for component/relationship id in table type starting from an offset.
    search_relation :: proc(world: ^World, table: ^Table, offset: c.int32_t, component: id_t, rel: Entity, flags: flags64_t, subject_out: ^Entity, component_out: ^id_t, tr_out: [^]^TableRecord) -> c.int32_t ---

    // Remove all entities in a talbe. Does not deallocate table memory.
    table_clear_entities :: proc(world: ^World, table: ^Table) ---

    // Values

    // Construct a value in existing storage
    value_init :: proc(world: ^World, type: Entity, ptr: rawptr) -> c.int ---

    // Construct a value in existing storage
    value_init_w_type_info :: proc(world: ^World, ti: ^TypeInfo, ptr: rawptr) -> c.int ---

    // Construct a value in new storage
    value_new :: proc(world: ^World, type: Entity) -> rawptr ---

    // Construct a value in new storage
    value_new_w_type_info :: proc(world: ^World, ti: ^TypeInfo) -> rawptr ---

    // Destruct a value
    value_fini_w_type_info :: proc(world: ^World, ti: ^TypeInfo, ptr: rawptr) -> c.int ---

    // Destruct a value
    value_fini :: proc(world: ^World, type: Entity, ptr: rawptr) -> c.int ---

    // Destruct a value, free storage
    value_free :: proc(world: ^World, type: Entity, ptr: rawptr) -> c.int ---

    // Copy value
    value_copy_w_type_info :: proc(world: ^World, ti: ^TypeInfo, dst: rawptr, src: rawptr) -> c.int ---

    // Copy Value
    value_copy :: proc(world: ^World, type: Entity, dst: rawptr, src: rawptr) -> c.int ---

    // Move value
    value_move_w_type_info :: proc(world: ^World, ti: ^TypeInfo, dst: rawptr, src: rawptr) -> c.int ---

    // Move value
    value_move :: proc(world: ^World, type: Entity, dst: rawptr, src: rawptr) -> c.int ---

    // Move construct value
    value_move_ctor_w_type_info :: proc(world: ^World, ti: ^TypeInfo, dst: rawptr, src: rawptr) -> c.int ---

    // Move construct value
    value_move_ctor :: proc(world: ^World, type: Entity, dst: rawptr, src: rawptr) -> c.int ---
}

@(default_calling_convention = "c", link_prefix = "flecs_")
foreign flecs {
    // Block Allocator
    ballocator_init :: proc(ba: ^BlockAllocator, size: size_t) ---
    ballocator_new :: proc(size: size_t) -> ^BlockAllocator ---
    ballocator_fini :: proc(ba: ^BlockAllocator) ---
    ballocator_free :: proc(ba: ^BlockAllocator) ---
    balloc :: proc(allocator: ^BlockAllocator) -> rawptr ---
    balloc_w_dbg_info :: proc(allocator: ^BlockAllocator, type_name: cstring) -> rawptr ---
    bcalloc :: proc(allocator: ^BlockAllocator) -> rawptr ---
    bcalloc_w_dbg_info :: proc(allocator: ^BlockAllocator, type_name: cstring) -> rawptr ---
    bfree :: proc(allocator: ^BlockAllocator, memory: rawptr) ---
    bfree_w_dbg_info :: proc(allocator: ^BlockAllocator, memory: rawptr, type_name: cstring) ---
    brealloc :: proc(dst: ^BlockAllocator, src: ^BlockAllocator, memory: rawptr) -> rawptr ---
    brealloc_w_dbg_info :: proc(dst: ^BlockAllocator, src: ^BlockAllocator, memory: rawptr, type_name: cstring) -> rawptr ---
    bdup :: proc(ba: ^BlockAllocator, memory: rawptr) -> rawptr ---

    // Allocator
    allocator_init :: proc(a: ^Allocator) ---
    allocator_fini :: proc(a: ^Allocator) ---
    allocator_get :: proc(a: ^Allocator, size: size_t) -> ^BlockAllocator ---
    strdup :: proc(a: ^Allocator, str: cstring) -> cstring ---
    strfree :: proc(a: ^Allocator, str: cstring) ---
    dup :: proc(a: ^Allocator, size: size_t, src: rawptr) -> rawptr ---

    // Get component record for component id
    components_get :: proc(world: ^World, id: id_t) -> ^ComponentRecord ---

    // Get component id from component record
    component_get_id :: proc(cr: ^ComponentRecord) -> id_t ---

    // Find table record for component record.
    component_get_table :: proc(cr: ^ComponentRecord, table: ^Table) -> ^TableRecord ---

    // Create a component record iterator
    component_iter :: proc(cr: ^ComponentRecord, iter_out: ^TableCacheIter) -> bool ---

    // Get the next table record for iterator
    component_next :: proc(iter: ^TableCacheIter) -> ^TableRecord ---

    // Get table records
    table_records :: proc(table: ^Table) -> TableRecords ---

    // Get component record from table record.
    table_record_get_component :: proc(tr: ^TableRecord) -> ^ComponentRecord ---

    // Get table id.
    table_id :: proc(table: Table) -> c.uint64_t ---

    // Find table by adding id to current table
    // Same as table_add_id, but with additional diff parameter that contains
    // information about the traversed edge
    table_traverse_add :: proc (world: ^World, table: ^Table, id_ptr: ^id_t, diff: ^TableDiff) -> ^Table ---

    // Test if pointer is of specified type.
    poly_is_ :: proc(object: poly_t, type: c.int32_t) -> bool ---
}

// *********************** ADDONS **************************************

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{

    // Log

    // Log message indicating an operation is deprecated
    deprecated_ :: proc(file: cstring, line: c.int32_t, msg: cstring) ---

    // Increase log stack
    log_push_ :: proc(level: c.int32_t) ---

    // Decrease log stack
    log_pop_ :: proc(level: c.int32_t) ---

    // Should current level be logged
    should_log :: proc(level: c.int32_t) -> bool ---

    // Get description for error code
    strerror :: proc(error_code: c.int32_t) -> cstring ---

    print_ :: proc(level: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    printv_ :: proc(level: c.int, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    log_ :: proc(level: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    logv_ :: proc(level: c.int, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    abort_ :: proc(error_code: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    assert_log_ :: proc(error_code: c.int32_t, file: cstring, line: c.int32_t, fmt: cstring, #c_vararg args: ..any) ---

    parser_error_ :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, #c_vararg args: ..any) ---

    parser_errorv_ :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, #c_vararg args: ..any) ---

    parser_warning_ :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, #c_vararg args: ..any) ---

    parser_warningv_ :: proc(name: cstring, expr: cstring, column: c.int64_t, fmt: cstring, #c_vararg args: ..any) ---

    // Enable or disable log
    log_set_level :: proc(level: c.int) -> c.int ---

    // Get current log level
    log_get_level :: proc() -> c.int ---

    // Enable/disable tracing with colors
    log_enable_colors :: proc(enabled: c.bool) -> c.bool ---

    // Enable/disable logging timestamp
    log_enable_timestamp :: proc(enabled: c.bool) -> c.bool ---

    // Enable/disable logging time since last log
    log_enable_timedelta :: proc(enabled: c.bool) -> c.bool ---

    // Get last logged error code
    log_last_error :: proc() -> c.int ---

    log_start_capture :: proc(capture_try: bool) ---

    log_stop_capture :: proc() -> cstring ---
}

@(default_calling_convention = "c", link_prefix = "ecs_")
foreign flecs
{
    // App addon


    // Run application
    app_run :: proc(world: ^World, desc: ^AppDesc) -> c.int ---

    // Default frame callback
    app_run_frame :: proc(world: ^World, desc: ^AppDesc) -> c.int ---

    // Set custom run action
    app_set_run_action :: proc(callback: app_run_action_t) -> c.int ---

    app_set_frame_action :: proc(callback: app_frame_action_t) -> c.int ---


    // Timer addon


    // Set timer timeout
    set_timeout :: proc(world: ^World, tick_source: Entity, timeout: ftime_t) -> Entity ---

    // Get current timeout value for the specified timer
    get_timeout :: proc(world: ^World, tick_source: Entity) -> ftime_t ---

    // Set timer interval
    set_interval :: proc(world: ^World, tick_source: Entity, interval: ftime_t) -> Entity ---

    // Get current interval value for the specified timer
    get_interval :: proc(world: ^World, tick_source: Entity) -> ftime_t ---

    // Start timer
    start_timer :: proc(world: ^World, tick_source: Entity) ---

    // Stop timer
    stop_timer :: proc(world: ^World, tick_source: Entity) ---

    // Set rate filter
    set_rate :: proc(world: ^World, tick_source: Entity, rate: c.int32_t, source: Entity) -> Entity ---

    // Assign tick source to system
    set_tick_source :: proc(world: ^World, system: Entity, tick_source: Entity) ---


    // Pipeline addon


    // Create a custom pipeline
    pipeline_init :: proc(world: ^World, desc: ^PipelineDesc) -> Entity ---

    // Set a custom pipeline
    set_pipeline :: proc(world: ^World, pipeline: Entity) ---

    // Get the current pipeline
    get_pipeline :: proc(world: ^World) -> Entity ---

    // Progress a world
    progress :: proc(world: ^World, delta_time: ftime_t) -> c.bool ---

    // Set time scale
    set_time_scale :: proc(world: ^World, scale: ftime_t) ---

    // Reset world clock
    reset_clock :: proc(world: ^World) ---

    // Run pipeline
    run_pipeline :: proc(world: ^World, pipeline: Entity, delta_time: ftime_t) ---

    // Set number of worker threads
    set_threads :: proc(world: ^World, threads: c.int32_t) ---


    // System addon


    // Create a system
    system_init :: proc(world: ^World, desc: ^SystemDesc) -> Entity ---

    // Run a specific system manually
    run :: proc(world: ^World, system: Entity, delta_time: ftime_t, param: rawptr) -> Entity ---

    // Same as run, but subdivides entities across num of provided stages
    run_worker :: proc(
        world: ^World, 
        system: Entity,
        stage_current: c.int32_t,
        stage_count: c.int32_t,
        delta_time: ftime_t,
        param: rawptr,
    ) -> Entity ---

    // Run system with offset/limit and type filter
    run_w_filter :: proc(
        world: ^World,
        system: Entity,
        delta_time: ftime_t,
        offset: c.int32_t,
        limit: c.int32_t,
        param: rawptr,
    ) -> Entity ---

    // Get the query object for a system
    system_get_query :: proc(
        world: ^World,
        system: Entity,
    ) -> ^Query ---

    // Get system context
    get_system_ctx :: proc(
        world: ^World,
        system: Entity,
    ) -> rawptr ---

    // Get system binding context
    get_system_binding_ctx :: proc(
        world: ^World,
        system: Entity,
    ) -> rawptr ---
}
