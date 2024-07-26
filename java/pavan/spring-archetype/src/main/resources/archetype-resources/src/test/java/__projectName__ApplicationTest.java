package ${package};

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.junit.jupiter.api.Assertions;
import org.springframework.context.ApplicationContext;

@SpringBootTest
class ${projectName}ApplicationTest {

  @Test
  void contextLoads(ApplicationContext context) {
    Assertions.assertNotNull(context);
  }

}