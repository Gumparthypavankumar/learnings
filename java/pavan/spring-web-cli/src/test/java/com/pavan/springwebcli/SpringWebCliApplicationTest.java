package com.pavan.springwebcli;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.ApplicationContext;

/**
 * The type SpringCliApplicationTest.
 *
 * @author gumparthypavankumar[pk] created on 27/07/24
 */
@SpringBootTest
class SpringWebCliApplicationTest {

  @Test
  void contextLoads(ApplicationContext context) {
    Assertions.assertNotNull(context);
  }
}
