package flecs

import "core:c"

STACK_PAGE_SIZE :: 4096


StackPage :: struct
{
    data: rawptr,
    next: ^StackPage,
    sp: c.int16_t,
    id: c.uint32_t,
}

when FLECS_DEBUG {
    StackCursor :: struct
    {
        prev: ^StackCursor,
        page: ^StackPage,
        sp: c.int16_t,
        is_free: bool,
        owner: ^Stack
    }
} else {
    StackCursor :: struct
    {
        prev: ^StackCursor,
        page: ^StackPage,
        sp: c.int16_t,
        is_free: bool
    }
}

when FLECS_DEBUG {
    Stack :: struct
    {
        first: ^StackPage,
        tail_page: ^StackPage,
        tail_cursor: ^StackCursor,
        cursor_count: c.int32_t
    }
} else {
    Stack :: struct
    {
        first: ^StackPage,
        tail_page: ^StackPage,
        tail_cursor: ^StackCursor
    }
}

