package com.bolingcavalry.webservice;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "account-service", fallback = FallbackAccountClient.class)
public interface AccountClient {

    @GetMapping(path = "/name")
    String getName();
}
