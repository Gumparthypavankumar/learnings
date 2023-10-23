package com.pavan.concurrency;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * ThreadLocal. Use-Case: There would many use-cases where in a common context is shared across
 * multiple layers involved in processing. one such example could be a web request where a user data
 * is expected by multiple parties involved in processing to either identify or validate the request
 * source. One solution could be to maintain a global map that is exchanged in chain, which is
 * further used to get the necessary data but this approach introduce complexity, performance,
 * memory leaks and No Thread Safety problems. There is a better way to this i.e ThreadLocal which
 * is guaranteed to hold the information per thread with necessary precautions like: 1. ThreadLocal
 * context have to be cleared after processing using remove() method
 */
public class ThreadLocalInJava implements ConcurrencyExecutor {

  private static final Log logger;

  static {
    logger = LogFactory.getLog(ThreadLocalInJava.class);
  }

  @Override
  public void execute() throws Exception {
    ThreadContextHolder contextHolder = null;
    try {
      contextHolder = new ThreadContextHolder();
      contextHolder.setContext("JohnDoe");
      logger.info("Context : " + contextHolder.getContext());
    } finally {
      contextHolder.clearContext();
    }
  }

  static class ThreadContextHolder {
    private static final ThreadLocal<String> loggedInUserNameContext = new ThreadLocal<>();

    public String getContext() {
      return loggedInUserNameContext.get();
    }

    public void setContext(String userName) {
      loggedInUserNameContext.set(userName);
    }

    public void clearContext() {
      loggedInUserNameContext.remove();
    }

  }
}
