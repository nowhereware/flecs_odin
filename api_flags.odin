package flecs

//5669
import "core:c"

ID_FLAG_BIT :: c.ulonglong(1) << 63

IdBitFlags :: enum id_t
{
    PAIR = c.ulonglong(1) << 63,
    OVERRIDE = c.ulonglong(1) << 62,
    TOGGLE = c.ulonglong(1) << 61,
    AND = c.ulonglong(1) << 60,
}

// Builtin components and tags

EcsComponentGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsComponent)
}

EcsIdentifierGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsIdentifier)
}

EcsPolyGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsPoly)
}

EcsDefaultChildComponentGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsDefaultChildComponent)
}

EcsTickSourceGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsTickSource)
}

// I can't actually find a definition for this ANYWHERE
EcsPipelineQuery :: struct {}

EcsPipelineQueryGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsPipelineQuery)
}


EcsPipeline :: Pipeline

EcsPipelineGet :: proc(world: ^World) -> Entity
{
 return id(world, EcsPipeline)
}

// Timer module component ids
EcsTimerGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsTimer)
}

EcsRateFilterGet :: proc(world: ^World) -> Entity
{
    return id(world, EcsRateFilter)
}

// Poly target components
EcsQuery : Entity : HI_COMPONENT_ID + 0
EcsObserver : Entity : HI_COMPONENT_ID + 1
EcsSystem : Entity : HI_COMPONENT_ID + 2

// Core scopes & entities
EcsWorld : Entity : HI_COMPONENT_ID + 3 // 
EcsFlecs : Entity : HI_COMPONENT_ID + 4 //
EcsFlecsCore : Entity : HI_COMPONENT_ID + 5 // 
EcsFlecsInternals : Entity : HI_COMPONENT_ID + 6
EcsModule : Entity : HI_COMPONENT_ID + 7 //
EcsPrivate : Entity : HI_COMPONENT_ID + 8 //
EcsPrefab : Entity : HI_COMPONENT_ID + 9 //
EcsDisabled : Entity : HI_COMPONENT_ID + 10 //
EcsNotQueryable : Entity : HI_COMPONENT_ID + 11 //

EcsSlotOf : Entity : HI_COMPONENT_ID + 12 //
EcsFlag : Entity : HI_COMPONENT_ID + 13

EcsWildcard : Entity : HI_COMPONENT_ID + 14 //
EcsAny : Entity : HI_COMPONENT_ID + 15 //
EcsThis : Entity : HI_COMPONENT_ID + 16 //
EcsVariable : Entity : HI_COMPONENT_ID + 17 //

// Traits
EcsTransitive : Entity : HI_COMPONENT_ID + 18 //
EcsReflexive : Entity : HI_COMPONENT_ID + 19 //
EcsSymmetric : Entity : HI_COMPONENT_ID + 20 //
EcsFinal : Entity : HI_COMPONENT_ID + 21 //
EcsInheritable : Entity : HI_COMPONENT_ID + 22 //

/** Mark component as singleton. Singleton components may only be added to 
 * themselves. */
EcsSingleton : Entity : HI_COMPONENT_ID + 23

EcsOnInstantiate : Entity : HI_COMPONENT_ID + 24 //
EcsOverride : Entity : HI_COMPONENT_ID + 25 //
EcsInherit : Entity : HI_COMPONENT_ID + 26 //
EcsDontInherit : Entity : HI_COMPONENT_ID + 27 //
EcsPairIsTag : Entity : HI_COMPONENT_ID + 28 //
EcsExclusive : Entity : HI_COMPONENT_ID + 29 //
EcsAcyclic : Entity : HI_COMPONENT_ID + 30 //
EcsTraversable : Entity : HI_COMPONENT_ID + 31 //
EcsWith : Entity : HI_COMPONENT_ID + 32 //
EcsOneOf : Entity : HI_COMPONENT_ID + 33 //
EcsCanToggle : Entity : HI_COMPONENT_ID + 34 //
EcsTrait : Entity : HI_COMPONENT_ID + 35 //
EcsRelationship : Entity : HI_COMPONENT_ID + 36
EcsTarget : Entity : HI_COMPONENT_ID + 37 //

// Builtin relationships
EcsChildOf : Entity : HI_COMPONENT_ID + 38 //
EcsIsA : Entity : HI_COMPONENT_ID + 39 //
EcsDependsOn : Entity : HI_COMPONENT_ID + 40 //

// Identifier tags
EcsName : Entity : HI_COMPONENT_ID + 41 // 
EcsSymbol : Entity : HI_COMPONENT_ID + 42 //
EcsAlias : Entity : HI_COMPONENT_ID + 43 //

// Events
EcsOnAdd : Entity : HI_COMPONENT_ID + 44 //
EcsOnRemove : Entity : HI_COMPONENT_ID + 45 //
EcsOnSet : Entity : HI_COMPONENT_ID + 46 //
EcsOnDelete : Entity : HI_COMPONENT_ID + 47 //
EcsOnDeleteTarget : Entity : HI_COMPONENT_ID + 48 //
EcsOnTableCreate : Entity : HI_COMPONENT_ID + 49 //
EcsOnTableDelete : Entity : HI_COMPONENT_ID + 50 //

// Actions
EcsRemove : Entity : HI_COMPONENT_ID + 54 //
EcsDelete : Entity : HI_COMPONENT_ID + 55 //

/** Panic cleanup policy. Must be used as target in pair with #EcsOnDelete or
 * #EcsOnDeleteTarget. */
EcsPanic : Entity : HI_COMPONENT_ID + 56

// Storage

/** Mark component as sparse */
EcsSparse : Entity : HI_COMPONENT_ID + 57

/** Mark component as non-fragmenting */
EcsDontFragment : Entity : HI_COMPONENT_ID + 58

// Misc
EcsOrderedChildren : Entity : HI_COMPONENT_ID + 60 //

// Builtin predicate ids (used by query engine)

/** Marker used to indicate `$var == ...` matching in queries. */
EcsPredEq : Entity : HI_COMPONENT_ID + 61

/** Marker used to indicate `$var == "name"` matching in queries. */
EcsPredMatch : Entity : HI_COMPONENT_ID + 62

/** Marker used to indicate `$var ~= "pattern"` matching in queries. */
EcsPredLookup : Entity : HI_COMPONENT_ID + 63

/** Marker used to indicate the start of a scope (`{`) in queries. */
EcsScopeOpen : Entity : HI_COMPONENT_ID + 64

/** Marker used to indicate the end of a scope (`}`) in queries. */
EcsScopeClose : Entity : HI_COMPONENT_ID + 65

// Systems
EcsMonitor : Entity : HI_COMPONENT_ID + 66 //

/** Tag used to indicate query is empty.
 * This tag is removed automatically when a query becomes non-empty, and is not
 * automatically re-added when it becomes empty.
 */
EcsEmpty : Entity : HI_COMPONENT_ID + 67
EcsOnStart : Entity : HI_COMPONENT_ID + 69 //
EcsPreFrame : Entity : HI_COMPONENT_ID + 70 //
EcsOnLoad : Entity : HI_COMPONENT_ID + 71 //
EcsPostLoad : Entity : HI_COMPONENT_ID + 72 //
EcsPreUpdate : Entity : HI_COMPONENT_ID + 73 //
EcsOnUpdate : Entity : HI_COMPONENT_ID + 74 //
EcsOnValidate : Entity : HI_COMPONENT_ID + 75 //
EcsPostUpdate : Entity : HI_COMPONENT_ID + 76 //
EcsPreStore : Entity : HI_COMPONENT_ID + 77 //
EcsOnStore : Entity : HI_COMPONENT_ID + 78 //
EcsPostFrame : Entity : HI_COMPONENT_ID + 79 //
EcsPhase : Entity : HI_COMPONENT_ID + 80 //
