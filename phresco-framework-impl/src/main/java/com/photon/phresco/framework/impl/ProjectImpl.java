/*
 * ###
 * Phresco Framework Implementation
 * 
 * Copyright (C) 1999 - 2012 Photon Infotech Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ###
 */
package com.photon.phresco.framework.impl;

import java.io.Serializable;

import com.photon.phresco.commons.model.ApplicationInfo;
import com.photon.phresco.framework.api.Project;

class ProjectImpl implements Project, Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private ApplicationInfo appInfo;
	
	
	public ProjectImpl(ApplicationInfo info) {
		appInfo = info;
	}
	
	public ApplicationInfo getApplicationInfo() {
		return appInfo;
	}
}
