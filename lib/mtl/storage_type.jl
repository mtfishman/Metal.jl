export Shared, Managed, Private, CPUStorage
export ReadUsage, WriteUsage, ReadWriteUsage

# Metal Has 4 storage types
# Shared  -> Buffer in Host memory, accessed by the GPU. Requires no sync
# Managed -> Mirrored memory buffers in host and GPU. Requires syncing
# Private -> Memory in Device, not accessible by Host.
# Memoryless -> iOS stuff. ignore it

abstract type StorageMode end

"""
    struct Shared <: MTL.StorageMode

Used to indicate that the resource is stored using `MTLStorageModeShared` in memory.

For more information on Metal storage modes, refer to the official Metal documentation.

See also [`Private`](@ref) and [`Managed`](@ref).
"""
struct Shared      <: StorageMode end

"""
    struct Managed <: MTL.StorageMode

Used to indicate that the resource is stored using `MTLStorageModeManaged` in memory.

For more information on Metal storage modes, refer to the official Metal documentation.

See also [`Shared`](@ref) and [`Private`](@ref).
"""
struct Managed     <: StorageMode end

"""
    struct Private <: MTL.StorageMode

Used to indicate that the resource is stored using `MTLStorageModePrivate` in memory.

For more information on Metal storage modes, refer to the official Metal documentation.

See also [`Shared`](@ref) and [`Managed`](@ref).
"""
struct Private     <: StorageMode end
struct Memoryless  <: StorageMode end

"""
    CPUStorage

Union type of [`Shared`](@ref) and [`Managed`](@ref) storage modes.

Represents storage modes where the resource is accessible via the CPU.
"""
const CPUStorage = Union{Shared,Managed}
Base.convert(::Type{MTLStorageMode}, ::Type{Shared})     = MTLStorageModeShared
Base.convert(::Type{MTLStorageMode}, ::Type{Managed})    = MTLStorageModeManaged
Base.convert(::Type{MTLStorageMode}, ::Type{Private})    = MTLStorageModePrivate
Base.convert(::Type{MTLStorageMode}, ::Type{Memoryless}) = MTLStorageModeMemoryless

Base.convert(::Type{MTLResourceOptions}, ::Type{Shared})     = MTLResourceStorageModeShared
Base.convert(::Type{MTLResourceOptions}, ::Type{Managed})    = MTLResourceStorageModeManaged
Base.convert(::Type{MTLResourceOptions}, ::Type{Private})    = MTLResourceStorageModePrivate
Base.convert(::Type{MTLResourceOptions}, ::Type{Memoryless}) = MTLResourceStorageModeMemoryless

Base.convert(::Type{MTLResourceOptions}, SM::MTLStorageMode)     = MTLResourceOptions(UInt(SM) << 4)

const DefaultCPUCache       = MTLResourceCPUCacheModeDefaultCache
const CombinedWriteCPUCache = MTLResourceCPUCacheModeWriteCombined

const DefaultTracking       = MTLResourceHazardTrackingModeDefault
const Untracked             = MTLResourceHazardTrackingModeUntracked
const Tracked               = MTLResourceHazardTrackingModeTracked

const Default               = DefaultCPUCache

Base.:(==)(a::MTLResourceOptions, b::MTLStorageMode) =
    (UInt(a) >> 4) == UInt(b)

Base.:(==)(a::MTLStorageMode, b::MTLResourceOptions) =
    b == a

##################
Base.convert(::Type{MTLResourceUsage}, val::Integer)    = MTLResourceUsage(val)

const ReadUsage = MTLResourceUsageRead
const WriteUsage = MTLResourceUsageWrite
const ReadWriteUsage = convert(MTLResourceUsage, MTLResourceUsageRead | MTLResourceUsageWrite)
