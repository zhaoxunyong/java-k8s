package com.bolingcavalry.webservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Description: 测试用的controller，会远程调用account-service的服务
 * @author: willzhao E-mail: zq2599@gmail.com
 * @date: 2019/6/16 11:46
 */
@RestController
public class WebServiceController {

    @Autowired
    private AccountClient accountClient;

    @Autowired
    private QotmClient qotmClient;

    /**
     * 探针检查响应类
     * @return
     */
    @RequestMapping("/health")
    public String health() {
        return "OK";
    }

    /**
     * 远程调用account-service提供的服务
     * @return 多次远程调返回的所有结果.
     */
    @RequestMapping("/account")
    public String account() {

        StringBuilder sbud = new StringBuilder();

        for(int i=0;i<10;i++){
            sbud.append(accountClient.getName()).append("<br>");
        }

        return sbud.toString();
    }

    @GetMapping(path = "/quote/{name}")
    public String quote(@PathVariable String name) {
        final String quote = qotmClient.getQuote().getQuote();
        return String.format("A quote for %s: %s", name, quote);
    }
}
