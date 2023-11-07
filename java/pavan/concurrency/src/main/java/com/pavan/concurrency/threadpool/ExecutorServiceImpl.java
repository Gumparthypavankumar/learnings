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
      fixedExecutorService.submit(() -> {
        try {
          ThreadContextHolder.setContext("fixedPool");
          new Task().run();
        } finally {
          ThreadContextHolder.clearContext();
        }
      });
      cachedExecutorService.execute(() -> {
        try {
          ThreadContextHolder.setContext("cachedPool");
          new Task().run();
        } finally {
          ThreadContextHolder.clearContext();
        }
      });
      Runnable executable = () -> {
        try {
          ThreadContextHolder.setContext("schedulePool");
          new Task().run();
        } finally {
          ThreadContextHolder.clearContext();
        }
      };
      scheduledExecutorService.schedule(executable, 10,
                                        TimeUnit.SECONDS
      );
      singleThreadedExecutorService.execute(() -> {
        try {
          ThreadContextHolder.setContext("singlePool");
          new Task().run();
        } finally {
          ThreadContextHolder.clearContext();
        }
      });
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
      logger.info("Execution begin on thread " + Thread.currentThread().getName() + " "
                      + ThreadContextHolder.getContext());
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
          .between(endTime, startTime).toMillis() + "ms");
    }
  }

  static class ThreadContextHolder {
    private static final ThreadLocal<String> coRelationId = new ThreadLocal<>();

    private ThreadContextHolder() {
    }

    public static String getContext() {
      return coRelationId.get();
    }

    public static void setContext(String userName) {
      coRelationId.set(userName);
    }

    public static void clearContext() {
      coRelationId.remove();
    }

  }
}
