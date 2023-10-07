package com.pavan.concurrency.visibility;

import com.pavan.concurrency.ConcurrencyExecutor;
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.IntStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The type Synchronization problem.
 */
public class SynchronizationProblem implements ConcurrencyExecutor {

  private static final Log logger = LogFactory.getLog(SynchronizationProblem.class);
  private final ExecutorService executorService = Executors.newFixedThreadPool(5);
  private int count = 0;

  private void increment() {
    ++count;
  }

  private void synchronizedIncrement() {
    synchronized (this) { // this refers to the monitor object. Only one thread per monitor
      // object is executed
      ++count;
    }
  }

  public int getCount() {
    return count;
  }

  @Override
  public void execute() throws Exception {
    resultsWithInconsistency();
    this.count = 0;
    resultsWithConsistency();
    executorService.shutdown();
  }

  private void resultsWithInconsistency() throws Exception {
    Instant start = Instant.now();
    IntStream.range(0, 1000)
             .forEach(value -> executorService.submit(this::increment));
    executorService.awaitTermination(1000, TimeUnit.MILLISECONDS);
    logger.info("Count With Inconsistency : " + count);
    Instant end = Instant.now();
    logger.info("Processing ended in : " + Duration.between(start, end).toMillis() + " ms");
  }

  private void resultsWithConsistency() throws Exception {
    Instant start = Instant.now();
    IntStream.range(0, 1000)
             .forEach(value -> executorService.submit(this::synchronizedIncrement));
    executorService.awaitTermination(1000, TimeUnit.MILLISECONDS);
    logger.info("Count With Consistency : " + count);
    Instant end = Instant.now();
    logger.info("Processing ended in : " + Duration.between(start, end).toMillis() + " ms");
  }
}
