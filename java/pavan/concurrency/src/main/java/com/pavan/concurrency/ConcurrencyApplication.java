package com.pavan.concurrency;


import com.pavan.concurrency.visibility.SynchronizationProblem;
import com.pavan.concurrency.visibility.VisibilityProblem;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * The type Concurrency application.
 */
public final class ConcurrencyApplication {
  private static final Log logger = LogFactory.getLog(ConcurrencyApplication.class);

  private ConcurrencyApplication() {
  }

  /**
   * Main.
   */
  public static void main(final String[] args) throws Exception {
    logger.info("ConcurrencyApplication started");
    day1();
  }

  private static void day1() throws Exception {
    new VisibilityProblem().execute();
    new SynchronizationProblem().execute();
  }
}
