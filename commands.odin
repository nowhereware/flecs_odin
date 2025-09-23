package flecs

import "core:c"

CmdKind :: enum uint {
	Clone,
	BulkNew,
	Add,
	Remove,
	Set,
	Emplace,
	Ensure,
	Modified,
	ModifiedNoHook,
	AddModified,
	Path,
	Delete,
	Clear,
	OnDelteAction,
	Enable,
	Disable,
	Event,
	Skip
}

CmdEntry :: struct {
	first: c.int32_t,
	last: c.int32_t,
}

Cmd1 :: struct {
	value: rawptr,
	size: size_t,
	clone_value: bool
}

CmdN :: struct {
	entities: [^]Entity,
	count: c.int32_t,
}

Cmd :: struct {
	kind: CmdKind,
	next_for_entity: c.int32_t,
	id: id_t,
	entry: ^CmdEntry,
	entity: Entity,

	is: struct #raw_union {
		_1: Cmd1,
		_n: CmdN,
	},

	system: Entity
}

on_commands_action :: #type proc "c" (stage: ^Stage, commands: ^Vec, ctx: rawptr)
