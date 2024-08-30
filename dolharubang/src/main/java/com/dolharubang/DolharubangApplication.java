package com.dolharubang;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@OpenAPIDefinition(
    servers = {
        @Server(url = "https://www.dolharubang.store", description = "Default Server url")
    }
)
@SpringBootApplication
@EnableJpaAuditing
public class DolharubangApplication {

    public static void main(String[] args) {
        SpringApplication.run(DolharubangApplication.class, args);
    }
}
