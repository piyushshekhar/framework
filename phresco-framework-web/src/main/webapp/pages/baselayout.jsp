<%--
  ###
  Framework Web Archive
  
  Copyright (C) 1999 - 2012 Photon Infotech Inc.
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  ###
  --%>
<!doctype html>
<%@ taglib uri="/struts-tags" prefix="s"%>

<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>

<%@ page import="java.util.List"%>

<%@ page import="org.apache.commons.collections.CollectionUtils"%>

<%@ page import="com.photon.phresco.commons.FrameworkConstants"%>
<%@ page import="com.photon.phresco.commons.model.User"%>

<html>
	<head>
		<meta name="viewport" content="width=device-width, height=device-height, minimum-scale=0.25, maximum-scale=1.6">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Phresco</title>
		<link REL="SHORTCUT ICON" HREF="images/favicon.ico">
		<link rel="stylesheet" href="css/bootstrap.css">

		<link type="text/css" rel="stylesheet" href="theme/photon/css/phresco_default.css" id="phresco" >
		<link type="text/css" rel="stylesheet" class="changeme" title="phresco">
		<!-- media queries css -->
		<link type="text/css" rel="stylesheet" href="theme/photon/css/media-queries.css">
		
		<!-- jquery file tree css starts -->
		<link type="text/css" rel="stylesheet" href="css/jqueryFileTree.css" media="screen">
		<!-- jquery file tree css ends -->
		
		<!-- basic js -->
		<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
		
		<!-- Pop Up box -->
		<script type="text/javascript" src="js/bootstrap-modal.js"></script>
		<script type="text/javascript" src="js/bootstrap-transition.js"></script>
		<!--<script type="text/javascript" src="js/bootstrap.js"></script>-->

		<!-- right panel scroll bar -->
		<script type="text/javascript" src="js/home.js"></script>
		<script type="text/javascript" src="js/common.js"></script>
		
		<script type="text/javascript" src="js/home-header.js"></script>
		<script type="text/javascript" src="js/jquery.loadmask.js"></script>
		<script type="text/javascript" src="js/main.js"></script>
		<script type="text/javascript" src="js/jquery.cookie.js"></script>
		<script type="text/javascript" src="js/selection-list.js"></script>
		<script type="text/javascript" src="js/jquery-jvert-tabs-1.1.4.js"></script>
		<script type="text/javascript" src="js/RGraph.common.core.js"></script>
		<script type="text/javascript" src="js/RGraph.common.tooltips.js"></script>
		<script type="text/javascript" src="js/RGraph.common.effects.js"></script>
		<script type="text/javascript" src="js/RGraph.pie.js"></script>
		<script type="text/javascript" src="js/RGraph.bar.js"></script>
		<script type="text/javascript" src="js/RGraph.line.js"></script>
		<script type="text/javascript" src="js/RGraph.common.key.js"></script>
		<script type="text/javascript" src="js/video.js"></script>
		<script type="text/javascript" src="js/confirm-dialog.js"></script>
		
		<!-- Scroll Bar -->
		<script type="text/javascript" src="js/scrollbars.js"></script>
		<script type="text/javascript" src="js/jquery.event.drag-2.0.min.js"></script>
		<script type="text/javascript" src="js/jquery.ba-resize.min.js"></script>
		<script type="text/javascript" src="js/jquery.mousewheel.js"></script>
		<script type="text/javascript" src="js/mousehold.js"></script>
		
		<!-- jquery file tree starts-->
		<script type="text/javascript" src="js/jqueryFileTree.js"></script>
		<script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
		<!-- jquery file tree ends -->
		
		<script type="text/javascript" src="js/delete.js" ></script>
		<script type="text/javascript" src="js/loading.js"></script>
		<script type="text/javascript" src="js/reader.js" ></script>
		<script type="text/javascript" src="js/jquery-tojson.js" ></script>

		<!-- Window Resizer -->
		<script type="text/javascript" src="js/windowResizer.js"></script>
		
		<script type="text/javascript">
			changeTheme(); 
		
		    $(document).ready(function() {
		    	enableScreen();
		    	
				$(".styles").click(function() {
					localStorage.clear();
		             var value = $(this).attr("rel");
		             localStorage["color"]= value;
		             localstore = localStorage["color"];
		             $("link[title='phresco']").attr("href",localstore);
		             showWelcomeImage();
				});

				// function to show user info in toggle 
				$('div li.usersettings div').hide(0);
				$('div li.usersettings').click(function() {
					$('div li.usersettings div').slideToggle(0);
				});

				// to show user info on mouse over
				$('#signOut li').mouseenter(function() {
					$("div li.usersettings div").hide(0);
					$(this).children("div li.usersettings div").show(0);
				}).mouseleave(function() {
					$("div li.usersettings div").hide(0);
				});

				clickMenu($("a[name='headerMenu']"), $("#container"), $('#formCustomers'));
				loadContent("home", '', $("#container"));
				activateMenu($("#home"));
				showWelcomeImage();
			});
		</script>
	</head>
	<body>
        <%
            User userInfo = (User) session.getAttribute(FrameworkConstants.SESSION_USER_INFO);
            String displayName = "";
            if (userInfo != null) {
                displayName = userInfo.getDisplayName();
            }
        %>
		<div class="modal-backdrop fade in popupalign"></div>
	    
	    <!-- In Progress starts -->
		<div id="progressbar" class="progressPosition">
			<div id="indicatorInnerElem">
				<span id="progressnum"></span>
			</div>
			<div id="indicator"></div>
		</div>
		<!-- In Progress Ends -->
		
		<!-- Loding icon div starts -->
		<div id="loadingIconDiv" class="hideContent"> 
			<img class="loadingIcon" id="loadingIconImg" src="" />
		</div>
		<!-- Loding icon div ends -->
		
		<!-- Header Starts Here -->
		<header>
			<div class="header">
				<div class="Logo">
					 <a href="#" id="goToHome"><img class="headerlogoimg" src="theme/photon/images/phresco_header_red.png" alt="logo"></a>
				</div>
				<div class="headerInner">
					<div class="nav_slider">
						<nav class="headerInnerTop">
							<ul>
								<li class="wid_home"><a href="#" class="inactive" name="headerMenu" id="home">
								    <s:label key="lbl.hdr.home"  theme="simple"/></a>
                                </li>
								<li class="wid_app"><a href="#" class="inactive" name="headerMenu" id="applications">
								    <s:label key="lbl.hdr.applications" theme="simple"/></a>
								</li>
								<li class="wid_set"><a href="#" class="inactive" name="headerMenu" id="settings">
								    <s:label key="lbl.hdr.settings"  theme="simple"/></a>
								</li>
								<li class="wid_help"><a href="#" class="inactive" name="headerMenu" id="help">
								    <s:label key="lbl.hdr.help"  theme="simple"/></a>
								</li>
							</ul>
							<div class="close_links" id="close_links">
								<a href="JavaScript:void(0);">
									<div class="headerInnerbottom">
										<img src="images/uparrow.png" alt="logo">
									</div>
								</a>
							</div>
						</nav>
					</div>
					<div class="quick_lnk" id="quick_lnk">
						<a href="JavaScript:void(0);">
							<div class="quick_links_outer">
								<s:label key="lbl.hdr.quicklinks" theme="simple"/>
							</div>
						</a>
					</div>
				</div>
				<div id="signOut" class="signOut">
					<li class="usersettings">
						<%= displayName %>
						<img src="images/downarrow.png" class="arrow">
                        <div class="userInfo" >&nbsp;&nbsp;<s:text name="lbl.skins" />&nbsp;
                            <a class="styles" href="#"  rel="theme/photon/css/red.css">
								<img src="images/red_themer.jpg" class="skinImage">
							</a>&nbsp;
							<a class="styles" href="#"  rel="theme/photon/css/blue.css">
								<img src="images/blue_themer.jpg" class="skinImage">
							</a>
                        </div>
                        <div class="userInfo"><a href="#" class="">&nbsp;&nbsp;<s:text name="lbl.hdr.help"/></a></div>
                        <div class="userInfo"><a href="#" class="abtPopUp about">&nbsp;&nbsp;<s:text name="lbl.abt.phresco"/></a></div>
                        <div class="userInfo"><a href="<s:url action='admin/logout'/>" id="signOut">&nbsp;<s:text name="lbl.signout"/></a></div>
					</li>
				</div>
			</div>
		</header>
		<!-- Header Ends Here -->
		
		
		<!-- Content Starts Here -->
		<section class="main_wrapper">
			<section class="wrapper">
			
				<!-- Shortcut Top Arrows Starts Here -->
				<aside class="shortcut_top">
					<div class="lefttopnav">
						<a href="JavaScript:void(0);" id="applications" name="headerMenu"
							class="arrow_links_top">
							<span class="shortcutRed" id=""></span>
							<span class="shortcutWh" id="">
							<s:text name="lbl.hdr.applications"/></span>
						</a>
					</div>
					
					<form id="formCustomers" class="form">
						<div class="control-group customer_name">
							<s:label key="lbl.customer" cssClass="control-label custom_label labelbold" theme="simple"/>
							<div class="controls customer_select_div">
								<select name="customerId" class="customer_listbox">
					                <%
					                	User user = (User) session.getAttribute(FrameworkConstants.SESSION_USER_INFO);
					                    if (user != null) {
					                    	List<String> customerIds = user.getCustomerIds();
								            for (String customerId : customerIds) { 
								    %>
					                            <option value="<%= customerId %>"><%= customerId %></option>
									<% 
								            }
								        } 
								    %>
								</select>
							</div>
						</div>
					</form>
					
					<div class="righttopnav">
						<a href="JavaScript:void(0);" class="abtPopUp" class="arrow_links_top"><span
							class="shortcutRed" id=""></span><span class="shortcutWh"
							id="">
							<s:text name="lbl.aboutus"/></span>
						</a>
					</div>
				</aside>
				<!-- Shortcut Top Arrows Ends Here -->
				
				<section id="container" class="container">
				
					<!-- Content Comes here-->
					
				</section>
				
				<!-- Shortcut Bottom Arrows Starts Here -->
				<aside class="shortcut_bottom">
				   <div class="leftbotnav">
						<a href="JavaScript:void(0);" id="forum" name="headerMenu"
							class="arrow_links_bottom"><span class="shortcutRed" id=""></span><span
							class="shortcutWh" id=""><s:text name="lbl.hdr.help"/></span>
						</a>
					</div>
					<div class="rightbotnav">
						<a href="JavaScript:void(0);" id="settings" name="headerMenu"
							class="arrow_links_bottom"><span class="shortcutRed" id="lf_tp1"></span><span
							class="shortcutWh" id="lf_tp2"><s:text name="lbl.hdr.settings"/></span>
						</a>
					</div>
				</aside>
				
				<!-- Shortcut Bottom Arrows Ends Here -->
			</section>
			
			<!-- Slide News Panel Starts Here -->
			<aside>
				<section>
					<div class="right">
						<div class="right_navbar active">
							<div class="barclose">
								<div class="lnclose">Latest&nbsp;News</div>
							</div>
						</div>
						<div class="right_barcont">
							<div class="searchsidebar">
								<div class="newstext">
									Latest<span>News</span>
								</div>
								<div class="topsearchinput">
									<input name="" type="text">
								</div>
								<div class="linetopsearch"></div>
							</div>
							<div id="tweets" class="sc7 scrollable dymanic paddedtop">
								<div class="tweeterContent"></div>
							</div>
						</div>
						<br clear="left">
					</div>
				</section>
			</aside>
			<!-- Slide News Panel Ends Here -->
		</section>
		<!-- Content Ends Here -->
		
		<!-- Footer Starts Here -->
		<footer>
			<address class="copyrit">&copy; 2012.Photon Infotech Pvt Ltd. |<a href="http://www.photon.in"> www.photon.in</a></address>
		</footer>
		<!-- Footer Ends Here -->
		
		<!-- Delete confirmation dialog starts -->
		<%-- <%@ include file="confirmDialog.jsp" %> --%>
		<!-- Delete confirmation dialog ends -->
		
		<!-- Popup Starts-->
	    <div id="popupPage" class="modal hide fade">
			<div class="modal-header">
				<a class="close" data-dismiss="modal" >&times;</a>
				<h3 id="popupTitle"><s:text name='lbl.progress'/></h3>
			</div>
			<div class="modal-body" id="console_div">
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-primary" data-dismiss="modal" id="popupCancel"><s:text name='lbl.btn.cancel'/></a>
				<a href="#" class="btn btn-primary popupOk" data-dismiss="modal" id="" onclick="popupOnOk(this);" ><s:text name='lbl.btn.ok'/></a>
				<a href="#" class="btn btn-primary popupClose" data-dismiss="modal" id="" onclick="popupOnClose(this);"><s:text name='lbl.btn.close'/></a>
				<div id="errMsg" class="envErrMsg"></div>
				<img class="popuploadingIcon" id="popuploadingIcon" src="" />
			</div>
		</div>
	    <!-- Popup Ends -->
	</body>
	
	<script type="text/javascript">
		var refreshIntervalId;
		if ($.browser.safari && $.browser.version == 530.17) {
			$(".shortcut_bottom").show().css("float","left");
		}
		
		/** To include the js based on the device **/
		var body = document.getElementsByTagName('body')[0];
		var script = document.createElement('script');
		if (isiPad()) {
			script.src = 'js/windowResizer-ipad.js';
		} else {
			script.src = 'js/windowResizer.js';
		}
		body.appendChild(script);
	</script>
</html>
