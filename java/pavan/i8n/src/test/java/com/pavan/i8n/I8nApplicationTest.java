package com.pavan.i8n;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

/**
 * The type I8nApplicationTest.
 *
 * @author gumparthypavankumar[pk] created on 08/06/24
 */
@SpringBootTest(classes = {I8nApplication.class})
@AutoConfigureMockMvc
class I8nApplicationTest {

  @Autowired
  private MockMvc mockMvc;

  @Test
  void contextLoads() throws Exception {

    MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders.get("/i8n")
        .header("Accept-Language", "it")
        .queryParam("key", "App.Name");
    MockHttpServletResponse response =
        this.mockMvc.perform(requestBuilder).andReturn().getResponse();
    Assertions.assertEquals(200, response.getStatus());
    Assertions.assertTrue(response.getContentAsString().contains("internazionalizzazione"));

    requestBuilder = MockMvcRequestBuilders.get("/i8n")
        .header("Accept-Language", "en")
        .queryParam("key", "App.Name");
    response =
        this.mockMvc.perform(requestBuilder).andReturn().getResponse();
    Assertions.assertEquals(200, response.getStatus());
    Assertions.assertTrue(response.getContentAsString().contains("Internationalization"));

  }
}
