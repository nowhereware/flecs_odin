package flecs

import "core:c"

BlockAllocatorBlock :: struct
{
    memory: rawptr,
    next: ^BlockAllocatorBlock,
}

BlockAllocatorChunkHeader :: struct
{
    next: ^BlockAllocatorChunkHeader,
}

when FLECS_USE_OS_ALLOC {
    BlockAllocator :: struct
    {
        data_size: c.int32_t,
    }
} else {
    when FLECS_SANITIZE {
        BlockAllocator :: struct
        {
            data_size: c.int32_t,
            chunk_size: c.int32_t,
            chunks_per_block: c.int32_t,
            block_size: c.int32_t,
            head: ^BlockAllocatorChunkHeader,
            block_head: ^BlockAllocatorBlock,
            alloc_count: c.int32_t,
            outstanding: ^Map
        }
    } else {
        BlockAllocator :: struct
        {
            data_size: c.int32_t,
            chunk_size: c.int32_t,
            chunks_per_block: c.int32_t,
            block_size: c.int32_t,
            head: ^BlockAllocatorChunkHeader,
            block_head: ^BlockAllocatorBlock,
        }
    }
}

ballocator_init_t :: proc(ba: ^BlockAllocator, $T: typeid) {
    ballocator_init(ba, size_of(T))
}

ballocator_init_n :: proc(ba: ^BlockAllocator, $T: typeid, count: size_t) {
    ballocator_init(ba, size_of(T) * count)
}

ballocator_new_t :: proc($T: typeid) {
    ballocator_new(size_of(T))
}

ballocator_new_n :: proc($T: typeid, count: size_t) {
    ballocator_new(size_of(T) * count)
}
