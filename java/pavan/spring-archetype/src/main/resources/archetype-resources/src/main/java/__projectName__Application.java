package ${package};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
public class ${projectName}Application {
  public static void main(String[] args) {
    SpringApplication.run(${projectName}Application.class, args);
  }
}