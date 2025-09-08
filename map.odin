package flecs

import "core:c"

BucketEntry :: struct
{
    key: map_key_t,
    value: map_val_t,
    next: ^BucketEntry,
}

Bucket :: struct
{
    first: ^BucketEntry,
}

Map :: struct
{
    buckets: [^]Bucket,
    bucket_count: c.int32_t,
    count: c.uint32_t, // Hardcoded as 26, also an unsigned.
    bucket_shift: c.uint32_t, // Hardcoded as 6, also an unsigned.
    allocator: ^Allocator,
}

MapIter :: struct
{
    map_t: ^Map,
    bucket: ^Bucket,
    entry: ^BucketEntry,
    res: ^map_data_t
}

MapParams :: struct
{
    allocator: ^Allocator,
    entry_allocator: BlockAllocator,
}

map_count :: proc(map_t: ^Map) -> c.uint32_t {
    return map_t.count
}

map_is_init :: proc(map_t: ^Map) -> bool {
    return map_t.bucket_shift != 0
}

// TODO (@day): this shit needs to be figured out maybe??
// #define ecs_map_get_ref(m, T, k) ECS_CAST(T**, ecs_map_get(m, k))
// #define ecs_map_get_deref(m, T, k) ECS_CAST(T*, ecs_map_get_deref_(m, k))
// #define ecs_map_get_ptr(m, k) ECS_CAST(void*, ecs_map_get_deref_(m, k))
// #define ecs_map_ensure_ref(m, T, k) ECS_CAST(T**, ecs_map_ensure(m, k))

// #define ecs_map_insert_ptr(m, k, v) ecs_map_insert(m, k, ECS_CAST(ecs_map_val_t, ECS_PTR_CAST(uintptr_t, v)))
// #define ecs_map_insert_alloc_t(m, T, k) ECS_CAST(T*, ecs_map_insert_alloc(m, ECS_SIZEOF(T), k))
// #define ecs_map_ensure_alloc_t(m, T, k) ECS_PTR_CAST(T*, (uintptr_t)ecs_map_ensure_alloc(m, ECS_SIZEOF(T), k))
// #define ecs_map_remove_ptr(m, k) (ECS_PTR_CAST(void*, ECS_CAST(uintptr_t, (ecs_map_remove(m, k)))))

// #define ecs_map_key(it) ((it)->res[0])
// #define ecs_map_value(it) ((it)->res[1])
// #define ecs_map_ptr(it) ECS_PTR_CAST(void*, ECS_CAST(uintptr_t, ecs_map_value(it)))
// #define ecs_map_ref(it, T) (ECS_CAST(T**, &((it)->res[1])))

