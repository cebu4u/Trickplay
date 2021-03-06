package com.trickplay.gameservice.service;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;

import com.trickplay.gameservice.domain.Device;

public interface DeviceService {
	
    @PreAuthorize("isAuthenticated()")
	@Transactional
	public void create(Device entity);

	public Device find(Long id);
	
	public Device findByKey(String deviceKey);
	
	@PreAuthorize("isAuthenticated()")
	@Transactional
	public Device addGame(String deviceKey, String appId);

}
