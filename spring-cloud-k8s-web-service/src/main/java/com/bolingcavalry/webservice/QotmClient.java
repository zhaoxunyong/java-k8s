package com.bolingcavalry.webservice;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

@FeignClient(name = "qotm")
public interface QotmClient {

    @GetMapping(path = "/")
    Quote getQuote();
}
