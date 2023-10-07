package com.pavan.concurrency.visibility;

import com.pavan.concurrency.ConcurrencyExecutor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The type Compound atomic operations.
 */
public class CompoundAtomicOperations implements ConcurrencyExecutor {

  private final Log logger = LogFactory.getLog(CompoundAtomicOperations.class);
  private final ExecutorService executorService = Executors.newFixedThreadPool(5);
  private final AtomicInteger count = new AtomicInteger(0);

  @Override
  public void execute() throws Exception {
    increment();
    Thread.sleep(100);
    logger.info("count is " + count);
  }

  private void increment() {
    IntStream.range(0, 1000)
             .forEach(value -> executorService.submit(() -> count.addAndGet(1)));
  }

  public int getCount() {
    return count.get();
  }
}
