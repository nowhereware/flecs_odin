package flecs

import "core:c"

SPARSE_CHUNK_SIZE :: 4096

Sparse :: struct
{
    dense: ^Vec,
    pages: ^Vec,
    size: size_t,
    count: c.int32_t,
    max_id: c.int64_t,
    allocator: ^Allocator,
    page_allocator: ^BlockAllocator,
}

sparse_init_t :: proc(sparse: ^Sparse, $T: typeid) {
    sparse_init(sparse, size_of(T))
}

sparse_add_t :: proc(sparse: ^Sparse, $T: typeid) -> ^T {
    return cast(^T)sparse_add(sparse, size_of(T))
}

sparse_get_dense_t :: proc(sparse: ^Sparse, $T: typeid, index: c.int32_t) -> ^T {
    return cast(^T)sparse_get_dense(sparse, size_of(T), index)
}

sparse_get_t :: proc(sparse: ^Sparse, $T: typeid, index: c.uint32_t) -> ^T {
    return cast(^T)sparse_get(sparse, size_of(T), index)
}
