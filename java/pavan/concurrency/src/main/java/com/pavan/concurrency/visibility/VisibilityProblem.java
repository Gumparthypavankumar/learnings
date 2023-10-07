package com.pavan.concurrency.visibility;

import com.pavan.concurrency.ConcurrencyExecutor;
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The type Visibility problem.
 */
public class VisibilityProblem implements ConcurrencyExecutor {

  /*
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
*/
  private static final Log logger = LogFactory.getLog(VisibilityProblem.class);
  private static int count = 0;
  private final ExecutorService executorService = Executors.newFixedThreadPool(5);

  @Override
  public void execute() throws Exception {
    final Task task = new Task();
    IntStream.range(0, 100).forEach(value -> executorService.submit(task));
    Thread.sleep(100);
    logger.info("Count is : " + count);
    executorService.shutdown();
  }

  private static class Task implements Runnable {

    @Override
    public void run() {
      Instant start = Instant.now();
      String currentThreadName = Thread.currentThread().getName();
      logger.info("Processing started for thread : " + currentThreadName);
      for (int i = 0; i < 10; i++) {
        count++;
      }
      Instant end = Instant.now();
      logger.info("Processing " + currentThreadName + " ended in : " +
                      Duration.between(start, end).toMillis() + " ms");
    }
  }
}
