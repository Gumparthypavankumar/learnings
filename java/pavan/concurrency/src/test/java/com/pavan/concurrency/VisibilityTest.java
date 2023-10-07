package com.pavan.concurrency;

import com.pavan.concurrency.visibility.CompoundAtomicOperations;
import com.pavan.concurrency.visibility.SynchronizationProblem;
import com.pavan.concurrency.visibility.VisibilityProblem;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

/**
 * The type Visibility test.
 *
 * @author pavankumar[pk]
 */
class VisibilityTest {

  @Test
  void testVisibility() throws Exception{
    final VisibilityProblem visibilityProblem = new VisibilityProblem();
    final SynchronizationProblem synchronizationProblem = new SynchronizationProblem();
    final CompoundAtomicOperations compoundAtomicOperations = new CompoundAtomicOperations();
    visibilityProblem.execute();
    synchronizationProblem.execute();
    compoundAtomicOperations.execute();

    Assertions.assertEquals(1000, VisibilityProblem.count);
    Assertions.assertEquals(1000, synchronizationProblem.getCount());
    Assertions.assertEquals(1000, compoundAtomicOperations.getCount());
  }
}
