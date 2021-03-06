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

<%@ taglib uri="/struts-tags" prefix="s"%>

<%@ page import="java.util.List"%>

<%@ page import="com.photon.phresco.commons.FrameworkConstants"%>
<%@ page import="com.photon.phresco.framework.model.TestCaseFailure"%>
<%@ page import="com.photon.phresco.framework.model.TestCaseError"%>
<%@ page import="com.photon.phresco.framework.model.TestCase"%>
<%@ page import="com.photon.phresco.commons.model.ProjectInfo"%>

<style type="text/css">
   	table th {
		padding: 0 0 0 9px;  
	}
	   	
	td {
	 	padding: 5px;
	 	text-align: left;
	}
	  
	th {
	 	padding: 0 5px;
	 	text-align: left;
	}
</style>

<%
	ProjectInfo projectInfo = (ProjectInfo) request.getAttribute(FrameworkConstants.REQ_PROJECT_INFO);
	String customerId = "";
	String projectId = "";
	String appId = "";
	if (projectInfo != null) {
		customerId = projectInfo.getCustomerIds().get(0);
		projectId = projectInfo.getId();
		appId = projectInfo.getAppInfos().get(0).getId();
	}
	
	List<TestCase> testCases = (List<TestCase>) request.getAttribute(FrameworkConstants.REQ_TESTCASES);
	String testSuiteName = (String) request.getAttribute(FrameworkConstants.REQ_TESTSUITE_NAME);
	float failures = Float.parseFloat((String) request.getAttribute(FrameworkConstants.REQ_TESTSUITE_FAILURES));
	float errors  = Float.parseFloat((String) request.getAttribute(FrameworkConstants.REQ_TESTSUITE_ERRORS));
	float tests  = Float.parseFloat((String) request.getAttribute(FrameworkConstants.REQ_TESTSUITE_TESTS)); 
	String testError = (String) request.getAttribute(FrameworkConstants.REQ_ERROR_TESTSUITE);
	String testType = (String) request.getAttribute(FrameworkConstants.REQ_TEST_TYPE);
	boolean hideClassColumn = (Boolean) request.getAttribute("isClassEmpty");
    
	if (testError != null) {
%>
		<div class="alert-message block-message warning" >
		    <center><label class="errorMsgLabel"><%= testError %></label></center>
		</div>
<%
	} else {
		float success = 0;
		if (failures != 0 && errors == 0) {
			if (failures > tests) {
				success = failures - tests;
			} else {
				success = tests - failures;
			}
		} else if (failures == 0 && errors != 0) {
			if (errors > tests) {
				success = errors - tests;
			} else {
				success = tests - errors;
			}
		} else if (failures != 0 && errors != 0) {
			float failTotal = (failures + errors);
			if (failTotal > tests) {
				success = failTotal - tests;
			} else {
				success = tests - failTotal;
			}
		} else {
			success = tests;
		}

		float total = tests;
		int failurePercentage = (int) (Math.round((failures / total) * 100));
		int errorsPercentage = (int) (Math.round((errors / total) * 100));
		int successPercentage = (int) (Math.round((success / total) * 100));
%>

		<script>
		$(document).ready(function() {
			showLoadingIcon();
			canvasInit();
		});
			
		function canvasInit() {
			var failurePercent = '<%= failurePercentage %>';
			var errorsPercent = '<%= errorsPercentage %>';
			var successPercent = '<%= successPercentage %>';
		
			var pie2 = new RGraph.Pie('pie2', [ parseInt(failurePercent), parseInt(errorsPercent), parseInt(successPercent)]); // Create the pie object
			pie2.Set('chart.gutter.left', 45);
			pie2.Set('chart.colors', ['orange', 'red', '#6f6']);
			pie2.Set('chart.key', ['Failures (<%= failurePercentage %>%)[<%= (int) failures %>]', 'Errors (<%= errorsPercentage %>%)[<%= (int) errors %>]', 'Success (<%= successPercentage %>%)[<%= (int) success %>]', 'Total (' + parseInt(<%= total %>) + ' Tests)']);
			pie2.Set('chart.key.background', 'white');
			pie2.Set('chart.strokestyle', 'white');
			pie2.Set('chart.linewidth', 3);
			pie2.Set('chart.title', '<%= testSuiteName %> Report');
			pie2.Set('chart.title.size',10);
			pie2.Set('chart.title.color', '#8A8A8A');
			pie2.Set('chart.exploded', [5,5,0]);
			pie2.Set('chart.shadow', true);
			pie2.Set('chart.shadow.offsetx', 0);
			pie2.Set('chart.shadow.offsety', 0);
			pie2.Set('chart.shadow.blur', 25);
			pie2.Set('chart.radius', 100);
			pie2.Set('chart.background.grid.autofit',true);
			if (RGraph.isIE8()) {
		    	pie2.Draw();
			} else {
		    	RGraph.Effects.Pie.RoundRobin(pie2);
			}
		}
		</script>
	
		<div class="table_div_unit qtyTable_view" id="tabularView">
			<div class="fixed-table-container responsiveFixedTableContainer qtyFixedTblContainer">
				<div class="header-background"> </div>
				<div class="fixed-table-container-inner">
					<div style="overflow: auto;">
						<table cellspacing="0" class="zebra-striped">
							<thead>
								<tr>
									<th class="first">
					                	<div id="th-first" class="th-inner-test"><s:text name="lbl.name"/></div>
					              	</th>
					              	<%if (hideClassColumn != true) { %>
					              	<th class="second">
					                	<div id="th-second" class="th-inner-test"><s:text name="lbl.class"/></div>
					              	</th>
					              	<% } %>
					              	<th class="third">
					                	<div id="th-third" class="th-inner-test"><s:text name="lbl.time"/></div>
					              	</th>
					              	<th class="third">
					                	<div id="th-fourth" class="th-inner-test"><s:text name="lbl.status"/></div>
					              	</th>
					              	<th class="third">
					                	<div id="th-fivth" class="th-inner-test"><s:text name="lbl.log"/></div>
					              	</th>
					              	<% if (FrameworkConstants.FUNCTIONAL.equals(testType)) { %>
						              	<th class="width-ten-percent">
						                	<div class="th-inner-test"><s:text name="label.screenshot"/></div>
						              	</th>
					              	<% } %>
					            </tr>
				          	</thead>
					
				          	<tbody>
				          	<%
					          	for (TestCase testCase : testCases) {
									TestCaseFailure failure = testCase.getTestCaseFailure();
									TestCaseError error = testCase.getTestCaseError(); 	
							%>
					            	<tr>
					              		<td id="tstRst_td1" class="width-twenty-five-percent"><%= testCase.getName() %></td>
					              		<%if (hideClassColumn != true) { %>
					              		<td id="tstRst_td2" class="width-twenty-five-percent"><%= testCase.getTestClass() == null ? "" : testCase.getTestClass() %></td>
					              		<% } %>
					              		<td class="width-fifteen-percent"><%= testCase.getTime() == null ? "" : testCase.getTime() %></td>
					              		<td class="width-fifteen-percent">
					              			<% if (failure != null) { %>
												<img src="images/icons/failure.png" title="Failure">
											<% } else if (error != null) { %>
												<img src="images/icons/error.png" title="Error">
											<% } else { %>
												<img src="images/icons/success.png" title="Success">
											<% } %>  
					              		</td>
					              		<td class="width-ten-percent">
					              			<% if (failure != null) { %>
				              					<textarea class="hideContent" name="<%= testCase.getName().replace("\\", "") %>_Type">
													<%= testCase.getTestCaseFailure().getFailureType()%>
												</textarea>
												<textarea class="hideContent" name="<%= testCase.getName().replace("\\", "") %>_Desc">
													<%= testCase.getTestCaseFailure().getDescription()%>
												</textarea>
												<a class="testCaseFailOrErr" onClick="showLogMsg('<%= testCase.getName() %>');" name="<%= testCase.getName() %>" href="#"><img src="images/icons/log.png" alt="logo"> </a>
											<% } else if (error != null) { %>
												<textarea class="hideContent" name="<%= testCase.getName().replace("\\", "") %>_Type">
													<%= testCase.getTestCaseError().getErrorType()%>
												</textarea>
												<textarea class="hideContent" name="<%= testCase.getName().replace("\\", "") %>_Desc">
													<%= testCase.getTestCaseError().getDescription()%>
												</textarea>
												<a class="testCaseFailOrErr" onClick="showLogMsg('<%= testCase.getName() %>');" href="#"><img src="images/icons/log.png" alt="logo"> </a>
											<% } else { %>
												&nbsp;
											<% } %>
					              		</td>
					             		<% 
						              		if (FrameworkConstants.FUNCTIONAL.equals(testType)) {
						              	%>
						            		<td class="width-ten-percent">
						            			<% 
						            				if ((failure != null && failure.isHasFailureImg()) || (error != null && error.isHasErrorImg())) { 
						            			%>
						            				<a class="testCaseScreenShot" name="<%= testCase.getName() %>" href="#"><img src="images/icons/screenshot.png" alt="logo"> </a>
						            			<% 
						            				}
						            			%>
						              		</td>
					             		<% 
						              		}
						              	%>
					            	</tr>
					            <%
									}
								%>	
			          	</tbody>
			        </table>
		       </div>
      		</div>
		</div>
	</div>
<% } %>
	
<div class="canvas_div canvasDiv" id="graphicalView">
	<canvas id="pie2" width="620" height="335">[No canvas support]</canvas>
</div>

   <!-- Test case error or Test case failure starts -->	
<div id="testCaseErrOrFail" class="modal confirm">
	<div class="modal-header">
		<div class="TestType" style="word-wrap: break-word;"></div><a id="closeTestCasePopup" href="#" class="close">&times;</a>
	</div>
	<div class="abt_div">
		<div id="testCaseDesc" class="testCaseDesc">
				
		</div>
	</div>
	<div class="modal-footer">
		<div class="action abt_action">
			<input type="button" class="btn primary" value="<s:text name="label.close"/>" id="closeDialog">
		</div>
	</div>
</div>
<!-- Test case error or Test case failure starts -->

<!-- Screen shot pop-up starts -->
<div id=testCaseScreenShotPopUp class="modal hide fade">
	<div class="modal-header">
		<a class="close" data-dismiss="modal" >&times;</a>
		<img id="clipboard" class="hideClipBoardImage" title="<s:text name="title.copy.to.clipBoard"/>" src="images/icons/clipboard-copy.png">
		<h3 id="popupTitle"></h3>
    </div>
	<div class="modal-body" id="funcpopup_div">
		<img class="testCaseImg" id="screenShotImgSrc" src="" title="screenShot" height= "100px" width= "100px"></img>
		<div id="log-div"></div>
	</div>
	<div class="modal-footer">
		<input type="button" class="btn btn-primary popupClose" value="<s:text name='lbl.btn.close'/>" data-dismiss="modal" href="#"/>
	</div>
</div>
<!-- Screen shot pop-up ends -->

<script type="text/javascript">
	/* To check whether the divice is ipad or not */
	if(!isiPad()) {
		/* JQuery scroll bar */
		$(".fixed-table-container-inner").scrollbars();
		$("#graphicalView").scrollbars();
	}
	
    $(document).ready(function() {
    	hideLoadingIcon();
    	
    	changeView();
    	
    	if ($('#label').hasClass('techLabel')){
            $("#th-first").removeClass("th-inner-test").addClass("th-inner-testtech");
            $("#th-second").removeClass("th-inner-test").addClass("th-inner-testtech");
            $("#th-third").removeClass("th-inner-test").addClass("th-inner-testtech");
            $("#th-fourth").removeClass("th-inner-test").addClass("th-inner-testtech");
            $("#th-fivth").removeClass("th-inner-test").addClass("th-inner-testtech");
        }
    	
    	if ($.browser.safari) {
            $(".th-inner-test").css("top","231px");  
            $(".th-inner-testtech").css("top","266px"); 
        }
    	
    	var OSName="Unknown OS";
        if (navigator.appVersion.indexOf("Mac")!=-1) {
			OSName="MacOS";
	    }
        
        if (OSName == "MacOS") { 
        	if ($('#label').hasClass('techLabel')) {
        		$(".th-inner-test").css("top","250px");
            } else {
	            $(".th-inner-test").css("top","225px");  
	            $(".th-inner-testtech").css("top","225px");
            }
        	if ($.browser.safari) {
                $(".th-inner-testtech").css("top","255px"); 
            }
        }
    	
        $("td[id = 'tstRst_td1']").text(function(index) {
            return textTrim($(this));
        });
        
        $("td[id = 'tstRst_td2']").text(function(index) {
            return textTrim($(this));
        });
        
    	$('#closeDialog').click(function() {
    		$(".wel_come").show().css("display", "none");
    		$("#testCaseErrOrFail").show().css("display", "none");
    	});
    	
    	$(".testCaseScreenShot").click(function() {
    		$("#testCaseScreenShotPopUp").modal("show");
    		$("#screenShotImgSrc").attr("src", "");
    		// This code loads image
    		var testCaseName = $(this).attr('name');
    		$('#popupTitle').html(testCaseName);
    		$("#screenShotImgSrc").empty();
			$("#screenShotImgSrc").attr("src", "<%= request.getContextPath()%>/getScreenshot.action?appId=<%= appId %>&projectId=<%= projectId %>&customerId=<%= customerId %>&testCaseName=" + testCaseName);
			$("#log-div").empty();
		});
    	
    	// table resizing
		var tblheight = (($("#subTabcontainer").height() - $("#form_test").height()));
		$('.responsiveTableDisplay').css("height", parseInt((tblheight/($("#subTabcontainer").height()))*100) +'%');
		
		var fixedTblheight = ((($('#tabularView').height() - 30) / $('#tabularView').height()) * 100);
		$('.responsiveFixedTableContainer').css("height", fixedTblheight+'%');
		 
		// jquery affects pie chart responsive
		window.setTimeout(function () { $(".scroll-content").css("width", "100%"); }, 350);
    });
    
    function textTrim(obj) {
        var val = $(obj).text();
        $(obj).attr("title", val);
        var len = val.length;
        if (len > 10) {
            val = val.substr(0, 30) + "...";
            return val;
        }
        return val;
    }
    
    function showLogMsg(testCaseName) {
    	$("#testCaseScreenShotPopUp").modal("show");
		var testCaseErrorOrFailName = $('textarea[name="'+ testCaseName +'_Type"]').val();
	   	var testCaseErrorOrFailDesc = $('textarea[name="'+ testCaseName +'_Desc"]').val();
	   	$('#popupTitle').html(testCaseErrorOrFailName);
	   	$("#log-div").html(testCaseErrorOrFailDesc);
	   	$("#screenShotImgSrc").attr("src", "");
	}
</script>