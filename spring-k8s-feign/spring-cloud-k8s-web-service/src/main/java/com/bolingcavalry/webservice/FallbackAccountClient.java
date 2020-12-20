package com.bolingcavalry.webservice;

import org.springframework.stereotype.Component;

@Component
public class FallbackAccountClient implements AccountClient {

	@Override
	public String getName() {
		return "error.";
	}
	
}
