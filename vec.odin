package flecs

import "core:c"
import "core:fmt"

Vec :: struct
{
    array: [^]rawptr,
    count: c.int32_t,
    size: c.int32_t,
}

vec_init_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t) -> ^Vec
{
    return vec_init_w_dbg_info(allocator, vec, size_of(T), elem_count, fmt.tprintf("vec<%v>", T))
}

vec_init_if_t :: proc(vec: ^Vec, $T: typeid) {
    vec_init_if(vec, size_of(T))
}

vec_fini_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid)
{
    vec_fini(allocator, vec, size_of(T))
}

vec_reset_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> ^Vec {
    return vec_reset(allocator, vec, size_of(T))
}

vec_append_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_append(allocator, vec, size_of(T))
}

vec_remove_t :: proc(vec: ^Vec, $T: typeid, elem: c.int32_t)
{
    vec_remove(vec, size_of(T), elem)
}

vec_remove_ordered_t :: proc(vec: ^Vec, $T: typeid, elem: c.int32_t) {
    vec_remove_ordered(vec, size_of(T), elem)
}

vec_copy_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> Vec
{
    return vec_copy(allocator, vec, size_of(T))
}

vec_copy_shrink_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid) -> Vec {
    return vec_copy_shrink(allocator, vec, size_of(T))
}

vec_reclaim_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid)
{
    vec_reclaim(allocator, vec, size_of(T))
}

vec_set_size_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t)
{
    vec_set_size(allocator, vec, size_of(T), elem_count)
}

vec_set_min_size_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t) {
    vec_set_min_size(allocator, vec, size_of(T), elem_count)
}

vec_set_min_count_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t) {
    vec_set_min_count(allocator, vec, size_of(T), elem_count)
}

vec_set_min_count_zeromem_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t) {
    vec_set_min_count_zeromem(allocator, vec, size_of(T), elem_count)
}

vec_set_count_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t)
{
    vec_set_count(allocator, vec, size_of(T), elem_count)
}

vec_grow_t :: proc(allocator: ^Allocator, vec: ^Vec, $T: typeid, elem_count: c.int32_t) -> ^T
{
    vec_grow(allocator, vec, size_of(T), elem_count)
}

vec_get_t :: proc(vec: ^Vec, $T: typeid, index: c.int32_t) -> ^T
{
    return cast(^T)vec_get(vec, size_of(T), index)
}

vec_first_t :: proc(vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_first(vec)
}

vec_last_t :: proc(vec: ^Vec, $T: typeid) -> ^T
{
    return cast(^T)vec_last(vec, size_of(T))
}
