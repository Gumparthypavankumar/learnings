package com.pavan.concurrency.threadpool;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The type Executor service.
 */
public class ExecutorServiceImpl {
  private static final Log logger = LogFactory.getLog(ExecutorServiceImpl.class);
  private static final ExecutorService fixedExecutorService = Executors.newFixedThreadPool(3);
  private static final ExecutorService cachedExecutorService = Executors.newCachedThreadPool();
  private static final ScheduledExecutorService scheduledExecutorService =
      Executors.newScheduledThreadPool(3);
  private static final ExecutorService singleThreadedExecutorService =
      Executors.newSingleThreadExecutor();

  /**
   * The entry point of application.
   *
   * @param args
   *     the input arguments
   * @throws Exception
   *     the exception
   */
  public static void main(String[] args) throws Exception {
    try {
      logger.info("FixedThreadPool execution begins...");
      fixedExecutorService.execute(new Task());
      fixedExecutorService.execute(new Task());
      Thread.sleep(1000);
      logger.info("CachedThreadPool execution begins...");
      cachedExecutorService.execute(new Task());
      cachedExecutorService.execute(new Task());
      Thread.sleep(1000);
      logger.info("ScheduledThreadPool execution begins...");
      scheduledExecutorService.schedule(new Task(), 10, TimeUnit.SECONDS);
      scheduledExecutorService.scheduleAtFixedRate(new Task(), 10, 10, TimeUnit.SECONDS);
      Thread.sleep(1000);
      logger.info("SingleThreadedExecutor execution begins...");
      singleThreadedExecutorService.execute(new Task());
      singleThreadedExecutorService.execute(new Task());
    } finally {
      fixedExecutorService.shutdown();
      cachedExecutorService.shutdown();
      scheduledExecutorService.shutdown();
      singleThreadedExecutorService.shutdown();
    }
  }

  static class Task implements Runnable {
    @Override
    public void run() {
      logger.info("Execution begin on thread " + Thread.currentThread().getName());
      List<Integer> primes = new ArrayList<>();
      Instant startTime = Instant.now();
      for (int i = 2; i < 10000; i++) {
        boolean isPrime = true;
        for (int j = 2; j <= Math.sqrt(i); j++) {
          if (i % j == 0) {
            isPrime = false;
            break;
          }
        }
        if (isPrime) {
          primes.add(i);
        }
      }
      Instant endTime = Instant.now();
      logger.info("Primes between 1 to 100 are " + primes.size() + " executed in " + Duration
          .between(endTime, startTime).toNanos() + "ns");
    }
  }
}
