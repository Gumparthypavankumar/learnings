package com.pavan.annotationprocessing;

import com.pavan.annotationprocessing.annotations.Listener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * The type ServiceB.
 *
 * @author gumparthypavankumar[pk] created on 15/06/24
 */
@Service
public class ServiceB {

  private static final Logger logger = LoggerFactory.getLogger(ServiceB.class);

  @Listener(value = "B")
  public void serviceBBean() {
    logger.info("Configured bean B");
  }
}
