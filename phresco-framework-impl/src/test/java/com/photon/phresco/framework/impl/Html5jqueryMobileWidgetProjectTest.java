//TODO Has To be Fixed
package com.photon.phresco.framework.impl;

import java.util.ArrayList;
import java.util.List;

import junit.framework.Assert;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.photon.phresco.commons.model.ApplicationInfo;
import com.photon.phresco.commons.model.ProjectInfo;
import com.photon.phresco.exception.PhrescoException;
import com.photon.phresco.framework.PhrescoFrameworkFactory;
import com.photon.phresco.framework.api.ActionType;
import com.photon.phresco.framework.api.ApplicationManager;
import com.photon.phresco.framework.api.ProjectManager;

public class Html5jqueryMobileWidgetProjectTest extends BaseTest{
	private List<ProjectInfo> appList=new ArrayList<ProjectInfo>();
	private static ProjectManager projectManager = null;
	private static ApplicationManager applicationManager = null;
	private List<ApplicationInfo> appInfos = new ArrayList<ApplicationInfo>();
	private ProjectInfo projectInfo;
	
	@Before
	public void setUp() throws PhrescoException {
		ApplicationInfo appInfo = getAppInfo("HTML5_JQUERY_MOBILE_WIDGET", "tech-html5-jquery-mobile-widget");
		appInfos.add(appInfo);
		projectInfo = getProjectInfo("tech-html5-jquery-mobile-widget", "tech-html5-jquery-mobile-widget" , "Sample-html5jquerymobilewidget-1" , "Sample-html5jquerymobilewidget-2", "PHR_html5jquerymobilewidget");
		if ((projectManager == null) && (applicationManager == null)) {
			projectManager = PhrescoFrameworkFactory.getProjectManager();
			applicationManager=PhrescoFrameworkFactory.getApplicationManager();
		}
	}
	
	@After
	public void tearDown() throws PhrescoException {
		boolean delete = projectManager.delete(appInfos);
		Assert.assertTrue(delete);
	}
	
//	@Test
	public void testCreateHtml5jqueryMobileWidgetProject() throws PhrescoException {
		System.out.println("serviceManager :::: " + serviceManager.getCustomers());
		projectManager.create(projectInfo, serviceManager);
		appList = projectManager.discover(customerId);
		Assert.assertEquals(2, appList.size());
	}
	
//	@Test
//	public void testUpdateProject() throws PhrescoException {		
//		ProjectInfo update = projectManager.update(projectInfo, serviceManager);
//		System.out.println(update.getDescription());
//	}
	
	@Test
	public void PerformActionTest() throws PhrescoException {
		System.out.println(projectInfo.getVersion());
//		applicationManager.performAction(projectInfo, ActionType.BUILD);
}
}
