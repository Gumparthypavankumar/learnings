package com.pavan.concurrency;

@FunctionalInterface
public interface ConcurrencyExecutor {
    void execute() throws Exception;
}
