//
//  KSMemoryPool.c
//

#include "KSMemoryPool.h"


void ksmempool_init(KSMemoryPool* pool,
                    void* memory,
                    unsigned int size,
                    unsigned int chunkSize)
{
    pool->memory = memory;
    pool->chunkSize = chunkSize;
    
    unsigned int totalChunks = size / chunkSize;
    totalChunks = (size - totalChunks *
                   (sizeof(*pool->memoryAllocations) +
                    sizeof(*pool->allocatedChunks))) / chunkSize;
    pool->totalChunks = totalChunks;
    
    unsigned char* ptr = pool->memory + size;
    
    ptr -= sizeof(*pool->memoryAllocations) * totalChunks;
    pool->memoryAllocations = (void*)ptr;
    
    ptr -= sizeof(*pool->allocatedChunks) * totalChunks;
    pool->allocatedChunks = (void*)ptr;
    
    KSMemoryAllocation empty = {0};
    for(unsigned int i = 0; i < totalChunks; i++)
    {
        pool->memoryAllocations[i] = empty;
        pool->allocatedChunks[i] = 0;
    }
}


void ksmempool_free(KSMemoryPool* pool, void* memory)
{
    // Check all allocation blocks
    KSMemoryAllocation* alloc = pool->memoryAllocations;
    KSMemoryAllocation* allocEnd = alloc + pool->totalChunks;
    for(; alloc < allocEnd; alloc++)
    {
        if(pool->memory + (alloc->firstChunk * pool->chunkSize) == memory)
        {
            // Found a match. Clear out allocation chunk map.
            unsigned int endChunk = alloc->firstChunk + alloc->numChunks;
            for(unsigned int chunk = alloc->firstChunk; chunk < endChunk; chunk++)
            {
                pool->allocatedChunks[chunk] = 0;
            }
            
            // Mark this allocation block free.
            alloc->numChunks = 0;
            break;
        }
    }
}


void* ksmempool_alloc(KSMemoryPool* pool, unsigned int size)
{
    if(size == 0)
    {
        return 0;
    }
    
    unsigned int requiredChunks = size / pool->chunkSize +
    (size % pool->chunkSize > 0 ? 1 : 0);
    if(requiredChunks > pool->totalChunks)
    {
        return 0;
    }
    
    // Find a free allocation block.
    KSMemoryAllocation* allocation = 0;
    for(unsigned int i = 0; i < pool->totalChunks; i++)
    {
        if(pool->memoryAllocations[i].numChunks == 0)
        {
            allocation = &pool->memoryAllocations[i];
            break;
        }
    }
    if(allocation == 0)
    {
        return 0;
    }
    
    // Look for enough contiguous memory chunks
    unsigned int chunk = 0;
    unsigned int lastChunk = pool->totalChunks - requiredChunks;
    for(; chunk <= lastChunk; chunk++)
    {
        if(pool->allocatedChunks[chunk] == 0)
        {
            // Found an unallocated chunk. Look for a big enough run.
            unsigned int chunkEnd = chunk + requiredChunks;
            unsigned int tstChunk = chunk;
            for(; tstChunk < chunkEnd; tstChunk++)
            {
                if(pool->allocatedChunks[tstChunk] != 0)
                {
                    break;
                }
            }
            if(tstChunk >= chunkEnd)
            {
                // Found it!
                break;
            }
            // Not enough free chunks. Skip ahead and try again.
            chunk = tstChunk;
        }
    }
    
    if(chunk > lastChunk)
    {
        return 0;
    }
    
    // Mark the chunks as "allocated".
    for(unsigned int i = chunk; i < chunk + requiredChunks; i++)
    {
        pool->allocatedChunks[i] = 1;
    }
    
    // Mark the allocation block as "in use".
    allocation->firstChunk = chunk;
    allocation->numChunks = requiredChunks;
    
    return pool->memory + allocation->firstChunk * pool->chunkSize;
}
