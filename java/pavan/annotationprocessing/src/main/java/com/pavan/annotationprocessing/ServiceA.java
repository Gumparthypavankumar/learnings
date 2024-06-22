package com.pavan.annotationprocessing;

import com.pavan.annotationprocessing.annotations.Listener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * The type ServiceA.
 *
 * @author gumparthypavankumar[pk] created on 15/06/24
 */
@Service
public class ServiceA {

  private static final Logger logger = LoggerFactory.getLogger(ServiceA.class);

  @Listener(value = "A")
  public void serviceABean() {
    logger.info("Configured bean a");
  }
}
