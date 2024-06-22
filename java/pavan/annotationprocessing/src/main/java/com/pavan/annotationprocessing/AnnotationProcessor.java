package com.pavan.annotationprocessing;

import com.pavan.annotationprocessing.annotations.Listener;
import java.lang.reflect.Method;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.support.AopUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.core.MethodIntrospector;
import org.springframework.core.annotation.AnnotatedElementUtils;
import org.springframework.stereotype.Service;

/**
 * The type AnnotationProcessor.
 *
 * @author gumparthypavankumar[pk] created on 15/06/24
 */
@Service
public class AnnotationProcessor implements BeanPostProcessor {

  private final Logger logger = LoggerFactory.getLogger(AnnotationProcessor.class);

  @Override
  public Object postProcessBeforeInitialization(final Object bean, final String beanName)
      throws BeansException {
    final Class<?> targetClass = AopUtils.getTargetClass(bean);
    final Map<Method, Listener> methodListenerMap = MethodIntrospector.selectMethods(
        targetClass,
        (MethodIntrospector.MetadataLookup<Listener>) method -> AnnotatedElementUtils.findMergedAnnotation(
            method,
            Listener.class
        )
    );
    methodListenerMap.forEach((key, value) -> logger.info("{} {}", key.getName(),
                                                          value.value()
    ));
    return BeanPostProcessor.super.postProcessBeforeInitialization(bean, beanName);
  }

}
