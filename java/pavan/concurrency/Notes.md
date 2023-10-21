## Terminology:

* Core : A logical unit that executes the machine code.(Simply it's a brain)
* Thread : Smallest unit of execution.
* Program : A code snippet which is ready for execution.
* Process : A program that is bought into memory and under execution.
* Concurrency :  A process which is in multiple different stages of execution, it is possible that all the stages of
  execution might not happen same time.
* Parallelism : A process which is in multiple different stages of execution, all the stages of execution happen at the
  same time.
* Synchronization : The capability to control access to multiple processes using shared resource.

# JMM (Java Memory Model)

Following depicts a memory model for dual core system.
<!--
 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
|      Core1        |        Core2          |
|_ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _|
|    L1 Cache       |      L1 cache         |
|   |= = = = = =|   |     |= = = = = =|     |
|   |instruction|   |     |instruction|     |
|   |data cache |   |     |data cache |     |
|   | = = = = = |   |     | = = = = = |     |
|_ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _|
|  L2 Cache         |    L2 Cache           |
|_ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _|
|  CPU Registers    |   CPU Registers       |
|_ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _|
|                                           |
|                   RAM                     |
|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
-->

## Notes

DrawBack of usual Thread creation strategy:

* No matter how many threads you open the system will be only capable of physical hardware core count for example 4
  cores for Quad core processor, in this case even if you open 1000 JVM threads the performance would still have an
  impact since the CPU uses scheduling to process tasks submitted for a thread. ThreadPool : It is a container which
  holds desired count of threads, which could be further utilized for processing. Considerations Creating a ThreadPool:
* CPU intensive: Like CryptoGraphic Functions, Mathematical Calculations
    * Proportional to the CPU core count for Quad core processor it is 4 and similarly for other cores.
* IO intensive: Network calls
    * High
        * This is upto the individual who develops, since the CPU operates on time-scheduling mode if there are more
          threads than core count.
          <b>NOTE:</b> Running high no. of threads lead to higher memory consumption, so use judiciously.
You can get the available core count in java like following:
```java
    class Task {
    static final int availableProcessors = Runtime.getRuntime().availableProcessors();
    public static void main(String[] args) {
        System.out.println(availableProcessors);
    }
}
``` 

* ExecutorService:
    * It is a built-in interface to manage and process concurrent execution of processes submitted to Threads within a
      pool.
    * It internally uses <a href="https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html">
      BlockingQueue</a> to efficiently manage concurrent execution.