package com.pavan.concurrency;

/**
 * The interface Concurrency executor.
 */
@FunctionalInterface
public interface ConcurrencyExecutor {
  /**
   * Execute.
   *
   * @throws Exception
   *     the exception
   */
  void execute() throws Exception;
}
