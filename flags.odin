package flecs

import "core:c"

WorldFlags :: enum uint
{
    QuitWorkers = 1 << 0,
    Readonly = 1 << 1,
    Init = 1 << 2,
    Quit = 1 << 3,
    Fini = 1 << 4,
    MeasureFrameTime = 1 << 5,
    MeasureSystemTime = 1 << 6,
    MultiThreaded = 1 << 7,
    FrameInProgress = 1 << 8,
}

OSApiFlags :: enum uint
{
    HighResolutionTimer = 1 << 0,
    LogWithColors = 1 << 1,
    LogWithTimeStamp = 1 << 2,
    LogWithTimeDelta = 1 << 3,
}

EntityFlags :: enum uint
{
    IsId = 1 << 31,
    IsTarget = 1 << 30,
    IsTraversable = 1 << 29,
    HasDontFragment = 1 << 28,
}

IdFlags :: enum uint
{
    OnDeleteRemove = 1 << 0,
    OnDeleteDelete = 1 << 1,
    OnDeletePanic = 1 << 2,
    OnDeleteMask = (OnDeletePanic|OnDeleteRemove|OnDeleteDelete),
    
    OnDeleteTargetRemove = 1 << 3,
    OnDeleteTargetDelete = 1 << 4,
    OnDeleteTargetPanic = 1 << 5,
    OnDeleteObjectMask = (OnDeleteTargetPanic|OnDeleteTargetRemove|OnDeleteTargetDelete),

    OnInstantiateOverride = 1 << 6,
    OnInstantiateInherit = 1 << 7,
    OnInstantiateDontInherit = 1 << 8,
    OnInstantiateMask = (OnInstantiateOverride|OnInstantiateInherit|OnInstantiateDontInherit),

    Exclusive = 1 << 9,
    Traversable = 1 << 10,
    Tag = 1 << 11,
    With = 1 << 12,
    CanToggle = 1 << 13,
    IsTransitive = 1 << 14,
    IsInheritable = 1 << 15,

    HasOnAdd = 1 << 16, // Same values as table flags
    HasOnRemove = 1 << 17,
    HasOnSet = 1 << 18,
    HasOnTableCreate = 1 << 19,
    HasOnTableDelete = 1 << 20,
    IsSparse = 1 << 21,
    DontFragment = 1 << 22,
    MatchDontFragment = 1 << 23, // For (*, T) wildcards
    OrderedChildren = 1 << 24,
    Singleton = 1 << 25,
    EventMask = (HasOnAdd|HasOnRemove|HasOnSet|HasOnTableCreate|HasOnTableDelete|IsSparse| OrderedChildren),

    MarkedForDelete = 1 << 30,
}

/*

    /* Utilities for converting from flags to delete policies and vice versa */
    #define ECS_ID_ON_DELETE(flags) \
        ((ecs_entity_t[]){0, EcsRemove, EcsDelete, 0, EcsPanic}\
            [((flags) & EcsIdOnDeleteMask)])
    #define ECS_ID_ON_DELETE_TARGET(flags) ECS_ID_ON_DELETE(flags >> 3)
    #define ECS_ID_ON_DELETE_FLAG(id) (1u << ((id) - EcsRemove))
    #define ECS_ID_ON_DELETE_TARGET_FLAG(id) (1u << (3 + ((id) - EcsRemove)))

    /* Utilities for converting from flags to instantiate policies and vice versa */
    #define ECS_ID_ON_INSTANTIATE(flags) \
        ((ecs_entity_t[]){EcsOverride, EcsOverride, EcsInherit, 0, EcsDontInherit}\
            [(((flags) & EcsIdOnInstantiateMask) >> 6)])
    #define ECS_ID_ON_INSTANTIATE_FLAG(id) (1u << (6 + ((id) - EcsOverride)))
*/

NonTrivialId :: enum uint {
    Sparse = 1 << 0,
    NonFragmenting = 1 << 1,
    Inherit = 1 << 2
}

IterFlags :: enum uint
{
    IsValid = 1 << 0, /* Does iterator contain valid result */
    NoData = 1 << 1, /* Does iterator provide (component) data */
    NoResults = 1 << 2, /* Iterator has no results */
    MatchEmptyTables = 1 << 3, /* Match empty tables */
    IgnoreThis = 1 << 4, /* Only evaluate non-this terms */
    TrivialChangeDetection = 1 << 5,
    HasCondSet = 1 << 6, /* Does iterator have conditionally set fields */
    Profile = 1 << 7, /* Profile iterator performance */
    TrivialSearch = 1 << 8, /* Trivial iterator mode */
    TrivialTest = 1 << 11, /* Trivial test mode (constrained $this) */
    TrivialCached = 1 << 14, /* Trivial search for cached query */
    Cached = 1 << 15, /* Cached query */
    FixedInChangeComputed = 1 << 16, /* Change detection for fixed in terms is done */
    FixedInChanged = 1 << 17, /* Fixed in terms changed */
    Skip = 1 << 18, /* Result was skipped for change detection */
    CppEach = 1 << 19, /* Uses C++ 'each' iterator */
    TableOnly = 1 << 20, /* Result only populates table */
}

EventFlags :: enum uint
{
    TableOnly = 1 << 20,
    NoOnSet = 1 << 16,
}

/* Flags that can only be set by the query implementation */
QueryFlags :: enum uint
{
    MatchPrefab = 1 << 1,
    MatchDisabled = 1 << 2,
    MatchEmptyTables = 1 << 3,
    AllowUnresolvedByName = 1 << 6,
    TableOnly = 1 << 7,
    DetectChanges = 1 << 8,
    MatchThis = 1 << 11, /* Query has terms with $this source */
    MatchOnlyThis = 1 << 12, /* Query only has terms with $this source */
    MatchOnlySelf = 1 << 13, /* Query has no terms with up traversal */
    MatchWildcards = 1 << 14, /* Query matches wildcards */
    MatchNothing = 1 << 15, /* Query matches nothing */
    HasCondSet = 1 << 16, /* Query has conditionally set fields */
    HasPred = 1 << 17, /* Query has equality predicates */
    HasScopes = 1 << 18, /* Query has query scopes */
    HasRefs = 1 << 19, /* Query has terms with static source */
    HasOutTerms = 1 << 20, /* Query has [out] terms */
    HasNonThisOutTerms = 1 << 21, /* Query has [out] terms with no $this source */
    HasChangeDetection = 1 << 22, /* Query has monitor for change detection */
    IsTrivial = 1 << 23, /* Query can use trivial evaluation function */
    HasCacheable = 1 << 24, /* Query has cacheable terms */
    IsCacheable = 1 << 25, /* All terms of query are cacheable */
    HasTableThisVar = 1 << 26, /* Does query have $this table var */
    CacheYieldEmptyTables = 1 << 28, /* Trivial cache (no wildcards, traversal, order_by, group_by, change detection) */
    Nested = 1 << 29, /* Query created by a query (for observer, cache) */
}

TermFlags :: enum uint {
    MatchAny = 1 << 0,
    MatchAnySrc = 1 << 1,
    Transitive = 1 << 2,
    Reflexive = 1 << 3,
    IdInherited = 1 << 4,
    IsTrivial = 1 << 5,
    IsCacheable = 1 << 7,
    IsScope = 1 << 8,
    IsMember = 1 << 9,
    IsToggle = 1 << 10,
    KeepAlive = 1 << 11,
    IsSparse = 1 << 12,
    IsOr = 1 << 13,
    DontFragment = 1 << 14,
    Self = 1 << 63,
    Up = 1<< 62,
    Trav = 1 << 61,
    Cascade = 1 << 60,
    Desc = 1 << 59,
    IsVariable = 1 << 58,
    IsEntity = 1 << 57,
    IsName = 1 << 56,
    TraverseFlags = (Self|Up|Trav|Cascade|Desc),
    TermRefFlags = (TraverseFlags|IsVariable|IsEntity|IsName)
}

ObserverFlags :: enum uint {
    MatchPrefab = 1 << 1,  /* Same as query*/
    MatchDisabled = 1 << 2,  /* Same as query*/
    IsMulti = 1 << 3,  /* Does observer have multiple terms */
    IsMonitor = 1 << 4,  /* Is observer a monitor */
    IsDisabled = 1 << 5,  /* Is observer entity disabled */
    IsParentDisabled = 1 << 6,  /* Is module parent of observer disabled  */
    BypassQuery = 1 << 7,  /* Don't evaluate query for multi-component observer*/
    YieldOnCreate = 1 << 8,  /* Yield matching entities when creating observer */
    YieldOnDelete = 1 << 9,  /* Yield matching entities when deleting observer */
    KeepAlive = 1 << 11, /* Observer keeps component alive (same value as EcsTermKeepAlive) */
}

QueryFlags :: enum uint {
}

TableFlags :: enum uint
{
    HasBuiltins = 1 << 1,  /* Does table have builtin components */
    IsPrefab = 1 << 2,  /* Does the table store prefabs */
    HasIsA = 1 << 3,  /* Does the table have IsA relationship */
    HasMultiIsA = 1 << 4,  /* Does table have multiple IsA pairs */
    HasChildOf = 1 << 5,  /* Does the table type ChildOf relationship */
    HasName = 1 << 6,  /* Does the table type have (Identifier, Name) */
    HasPairs = 1 << 7,  /* Does the table type have pairs */
    HasModule = 1 << 8,  /* Does the table have module data */
    IsDisabled = 1 << 9,  /* Does the table type has EcsDisabled */
    NotQueryable = 1 << 10,  /* Table should never be returned by queries */
    HasCtors = 1 << 11,
    HasDtors = 1 << 12,
    HasCopy = 1 << 13,
    HasMove = 1 << 14,
    HasToggle = 1 << 15,
    HasOnAdd = 1 << 16, /* Same values as id flags */
    HasOnRemove = 1 << 17,
    HasOnSet = 1 << 18,
    HasOnTableCreate = 1 << 19,
    HasOnTableDelete = 1 << 20,
    HasSparse = 1 << 21,
    HasDontFragment = 1 << 22,
    OverrideDontFragment = 1 << 23,
    HasOrderedChildren = 1 << 24,
    HasOverrides = 1 << 25,
    HasTraversable = 1 << 27,
    EdgeReparent = 1 << 28,
    MarkedForDelete = 1 << 29,
    HasLifecycle    = (HasCtors | HasDtors),
    IsComplex       = (HasLifecycle | HasToggle | HasSparse),
    HasAddActions   = (HasIsA | HasCtors | HasOnAdd | HasOnSet),
    HasRemoveActions= (HasIsA | HasDtors | HasOnRemove),
    EdgeFlags       = (HasOnAdd | HasOnRemove | HasSparse),
    AddEdgeFlags    = (HasOnAdd | HasSparse),
    RemoveEdgeFlags = (HasOnRemove | HasSparse | HasOrderedChildren),
}

AperiodicFlags :: enum uint
{
    ComponentMonitors = 1 << 2,
    EmptyQueries = 1 << 4,
}

TypeHook :: enum flags32_t {
    /* Flags that can be used to check which hooks a type has set */
    CTOR = 1 << 0,
    DTOR = 1 << 1,
    COPY = 1 << 2,
    MOVE = 1 << 3,
    COPY_CTOR = 1 << 4,
    MOVE_CTOR = 1 << 5,
    CTOR_MOVE_DTOR = 1 << 6,
    MOVE_DTOR = 1 << 7,
    CMP = 1 << 8,
    EQUALS = 1 << 9,

    /* Flags that can be used to set/check which hooks of a type are invalid */
    CTOR_ILLEGAL = 1 << 10,
    DTOR_ILLEGAL = 1 << 12,
    COPY_ILLEGAL = 1 << 13,
    MOVE_ILLEGAL = 1 << 14,
    COPY_CTOR_ILLEGAL = 1 << 15,
    MOVE_CTOR_ILLEGAL = 1 << 16,
    CTOR_MOVE_DTOR_ILLEGAL = 1 << 17,
    MOVE_DTOR_ILLEGAL = 1 << 18,
    CMP_ILLEGAL = 1 << 19,
    EQUALS_ILLEGAL = 1 << 20,

    HOOKS = (CTOR|DTOR|COPY|MOVE|COPY_CTOR|MOVE_CTOR|CTOR_MOVE_DTOR|MOVE_DTOR|CMP|EQUALS),
    ILLEGAL = (CTOR_ILLEGAL|DTOR_ILLEGAL|COPY_ILLEGAL|MOVE_ILLEGAL|COPY_CTOR_ILLEGAL|MOVE_CTOR_ILLEGAL|CTOR_MOVE_DTOR_ILLEGAL|MOVE_DTOR_ILLEGAL|CMP_ILLEGAL|EQUALS_ILLEGAL)
}
