//
//  KSMemMgrTests.m
//

#import <SenTestingKit/SenTestingKit.h>

#import "KSMemoryPool.h"

@interface KSMemMgrTests : SenTestCase @end

@implementation KSMemMgrTests

- (void) testInit1
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    STAssertEquals(pool.chunkSize, chunkSize, @"");
    STAssertEquals((void*)pool.memory, memory, @"");
    STAssertEquals(pool.totalChunks, 1u, @"");

    free(memory);
}

- (void) testInit2
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    STAssertEquals(pool.chunkSize, chunkSize, @"");
    STAssertEquals((void*)pool.memory, memory, @"");
    STAssertEquals(pool.totalChunks, 3u, @"");
    
    free(memory);
}

- (void) testInit3
{
    KSMemoryPool pool;
    unsigned int memorySize = 2048;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    STAssertEquals(pool.chunkSize, chunkSize, @"");
    STAssertEquals((void*)pool.memory, memory, @"");
    STAssertEquals(pool.totalChunks, 7u, @"");
    
    free(memory);
}

- (void) testAlloc1
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 1);
    STAssertNotNil(alloced, @"");
}

- (void) testAlloc2
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 150);
    STAssertNotNil(alloced, @"");
}

- (void) testAlloc3
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 511);
    STAssertNotNil(alloced, @"");
}


- (void) testAlloc4
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 512);
    STAssertNotNil(alloced, @"");
}

- (void) testAllocZero
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 0);
    STAssertNil(alloced, @"");
}

- (void) testAllocTooBig
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 512;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 513);
    STAssertNil(alloced, @"");
}

- (void) testAllocMultChunks1
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 257);
    STAssertNotNil(alloced, @"");
}

- (void) testAllocMultChunks2
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 512);
    STAssertNotNil(alloced, @"");
}

- (void) testAllocMultChunks3
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 513);
    STAssertNotNil(alloced, @"");
}

- (void) testAllocMultChunks4
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 768);
    STAssertNotNil(alloced, @"");
}

- (void) testAllocMultChunksTooBig
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 769);
    STAssertNil(alloced, @"");
}

- (void) testMultipleAllocs
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 512);
    STAssertNotNil(alloced, @"");
    void* alloced2 = ksmempool_alloc(&pool, 30);
    STAssertNotNil(alloced2, @"");
    STAssertTrue(alloced != alloced2, @"");
    void* alloced3 = ksmempool_alloc(&pool, 30);
    STAssertNil(alloced3, @"");
}

- (void) testMultipleAllocsAndFrees
{
    KSMemoryPool pool;
    unsigned int memorySize = 1024;
    unsigned int chunkSize = 256;
    void* memory = malloc(memorySize);
    ksmempool_init(&pool, memory, memorySize, chunkSize);
    
    void* alloced = ksmempool_alloc(&pool, 512);
    STAssertNotNil(alloced, @"");
    void* alloced2 = ksmempool_alloc(&pool, 30);
    STAssertNotNil(alloced2, @"");
    STAssertTrue(alloced != alloced2, @"");
    void* alloced3 = ksmempool_alloc(&pool, 30);
    STAssertNil(alloced3, @"");

    ksmempool_free(&pool, alloced);
    void* alloced4 = ksmempool_alloc(&pool, 30);
    STAssertNotNil(alloced4, @"");
    STAssertTrue(alloced4 != alloced2, @"");
    void* alloced5 = ksmempool_alloc(&pool, 30);
    STAssertNotNil(alloced5, @"");
    STAssertTrue(alloced5 != alloced4, @"");
    STAssertTrue(alloced5 != alloced2, @"");
}


@end
