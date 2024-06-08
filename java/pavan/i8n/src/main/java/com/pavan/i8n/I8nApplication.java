package com.pavan.i8n;

import java.util.Locale;
import java.util.Map;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.MessageSource;
import org.springframework.context.MessageSourceAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;

/**
 * The type I8nApplication.
 *
 * @author gumparthypavankumar[pk] created on 08/06/24
 */
@SpringBootApplication
class I8nApplication {

  public static void main(String[] args) {
    SpringApplication.run(I8nApplication.class, args);
  }

  @Configuration
  static class I8nConfiguration {

    @Bean
    public LocaleResolver localeResolver() {
      AcceptHeaderLocaleResolver locale = new AcceptHeaderLocaleResolver();
      locale.setDefaultLocale(Locale.ENGLISH);
      return locale;
    }
  }

  @RestController
  @RequestMapping("/i8n")
  @ResponseBody
  static class I8nController implements MessageSourceAware {

    private MessageSourceAccessor messageSource;

    @GetMapping
    public Map<String, String> getMessages(@RequestParam(value = "key") String key, Locale locale) {
      return Map.of(key, this.messageSource.getMessage(key, "Not Found!!", locale));
    }


    @Override
    public void setMessageSource(@NonNull MessageSource messageSource) {
      this.messageSource = new MessageSourceAccessor(messageSource);
    }
  }
}