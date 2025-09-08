package flecs

import "core:c"

STRBUF_INIT :: proc() -> StrBuf
{
    return {}
}

STRBUF_ELEMENT_SIZE :: 511
STRBUF_MAX_LIST_DEPTH :: 32

StrBufListElem :: struct
{
    count: c.int32_t,
    separator: cstring,
}

StrBuf :: struct
{
    content: cstring,
    length: size_t,
    size: size_t,
    
    list_stack: [STRBUF_MAX_LIST_DEPTH]StrBufListElem,
    list_sp: c.int32_t,

    small_string: cstring // this is a stack allocated char array originally, so idk what to do about that
}

strbuf_appendlit :: proc(buf: ^StrBuf, str: cstring) -> bool
{
    return strbuf_appendstrn(buf, str, cast(c.int32_t)(size_of(str) - 1))
}

strbuf_list_appendlit :: proc(buf: ^StrBuf, str: cstring) -> bool
{
    return strbuf_list_appendstrn(buf, str, cast(c.int32_t)(size_of(str) - 1))
}
