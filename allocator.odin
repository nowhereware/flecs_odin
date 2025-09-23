package flecs

import "core:c"

when FLECS_USE_OS_ALLOC {
    Allocator :: struct
    {
        chunks: BlockAllocator,
        sizes: Sparse,
    }   
} else {
    Allocator :: struct {
        dummy: bool
    }
}

// NOTE (@day): there are a bunch of macros here that we could probably replicate, not sure if it's super necessary though
