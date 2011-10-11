//
//  KSMemoryPool.h
//

#ifndef KSMemoryPool_h
#define KSMemoryPool_h

#ifdef __cplusplus
extern "C" {
#endif


/* A VERY simple chunk-based memory allocator.
 *
 * For use in VERY simple systems.
 */


/** Represents an allocation of some memory.
 */
typedef struct
{
    /** The first chunk of memory that has been allocated */
    unsigned int firstChunk;
    
    /** The number of chunks allocated */
    unsigned int numChunks;
} KSMemoryAllocation;

/** A memory pool, which allows allocation of smaller chunks of memory.
 */
typedef struct
{
    /** The start of this pool's memory */
    unsigned char* memory;
    
    /** All memory allocations */
    KSMemoryAllocation* memoryAllocations;
    
    /** Individual chunks of allocated memory */
    unsigned char* allocatedChunks;
    
    /** The total number of chunks that can be allocated */
    unsigned int totalChunks;
    
    /** The size of each memory chunk in bytes */
    unsigned int chunkSize;
} KSMemoryPool;


/** Initialize a memory pool.
 *
 * @param pool The pool to initialize.
 *
 * @param meory The memory to assign to this pool.
 *
 * @param size The size of the memory in bytes.
 *
 * @param chunkSize The size of chunks to allocate. The memory system reserves
 *                  an extra 9 bytes per chunk.
 */
void ksmempool_init(KSMemoryPool* pool, void* memory, unsigned int size, unsigned int chunkSize);

/** Allocate some memory from the pool.
 *
 * @param pool The pool to allocate memory from.
 *
 * @param size The number of bytes of memory requested.
 *
 * @return A pointer to the memory, or NULL if there were not enough contiguous
 *         free chunks available.
 */
void* ksmempool_alloc(KSMemoryPool* pool, unsigned int size);

/** Free some previously allocated memory.
 *
 * If the specified memory is not being managed by the specified pool, this
 * function does nothing.
 *
 * @param pool The pool that is managing this memory.
 *
 * @param memory The memory to free.
 */
void ksmempool_free(KSMemoryPool* pool, void* memory);


#ifdef __cplusplus
}
#endif

#endif // KSMemoryPool_h
