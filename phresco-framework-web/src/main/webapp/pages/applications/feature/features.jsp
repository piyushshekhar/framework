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

<%@ page import="org.apache.commons.collections.CollectionUtils"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="com.google.gson.Gson" %>

<%@ page import="com.photon.phresco.commons.model.ArtifactGroup"%>
<%@ page import="com.photon.phresco.commons.model.ArtifactGroup.Type"%>
<%@ page import="com.photon.phresco.commons.model.ApplicationInfo"%>
<%@ page import="com.photon.phresco.commons.model.SelectedFeature"%>
<%@ page import="com.photon.phresco.commons.model.ProjectInfo"%>
<%@ page import="com.photon.phresco.commons.FrameworkConstants"%>

<%
	List<SelectedFeature> features = (List<SelectedFeature>)session.getAttribute(FrameworkConstants.REQ_SELECTED_FEATURES);
	List<SelectedFeature> defaultfeatures = (List<SelectedFeature>)request.getAttribute(FrameworkConstants.REQ_DEFAULT_FEATURES);
	String oldAppDirName = (String) request.getAttribute(FrameworkConstants.REQ_OLD_APPDIR);
	String appId = (String) request.getAttribute(FrameworkConstants.REQ_APP_ID);
	List<String> scopeList= (List<String>) request.getAttribute(FrameworkConstants.REQ_SCOPE);
	List<ArtifactGroup> selectedFeatures = (List<ArtifactGroup>) request.getAttribute(FrameworkConstants.REQ_PROJECT_FEATURES);
	ProjectInfo projectInfo = (ProjectInfo)session.getAttribute(appId + FrameworkConstants.SESSION_APPINFO);
	String technologyId = "";
	List<String> selectedModules = null;
	List<String> selectedJSLibs = null;
	List<String> selectedComponents = null;
	Gson gson = new Gson();
	if (projectInfo != null) {
		ApplicationInfo appInfo = projectInfo.getAppInfos().get(0);
		technologyId = appInfo.getTechInfo().getId();
	}
	Object optionsObj = session.getAttribute(FrameworkConstants.REQ_OPTION_ID);
	List<String> optionIds  = null;
	if (optionsObj != null) {
		optionIds  = (List<String>) optionsObj;
	}
%> 
<form id="formFeatures" class="featureForm">
	<div class="form-horizontal featureTypeWidth">
		<label for="myselect" class="control-label features_cl">Type&nbsp;:</label>
		 <select id="featureselect" name="type" onchange="featuretype()">
	        <option value="<%= ArtifactGroup.Type.FEATURE.name() %>" selected="selected" data-imagesrc="images/features.png"
	            data-description="An independent self-contained unit of a spacecraft"><s:text name="lbl.options.modules"/></option>
	        <option value="<%= ArtifactGroup.Type.JAVASCRIPT.name() %>" data-imagesrc="images/libraries.png"
	            data-description="Library of pre-written JavaScript to develop JavaScript-based applications"><s:text name="lbl.options.js.libs"/></option>
	        <option value="<%= ArtifactGroup.Type.COMPONENT.name() %>" data-imagesrc="images/components.png"
	            data-description="Single piece which forms part of a larger unit"><s:text name="lbl.options.components"/></option>
	    </select>
	    <div class="alert alert-success alert-message hideContent" id="successmsg">
			<s:text name="succ.feature.configure"/>
		</div>
		<div class="featureImage">
			<img id="allFeatures" title="<s:text name="title.selected.modules"/>" src="images/all.png">
			<span class="bubbleAll"></span>
			<img id="selectModules" title="<s:text name="title.selected.modules"/>" src="images/features.png">
			<span class="bubbleModule"></span>
			<img id="selectJsLibs" title="<s:text name="title.selected.jsLibs"/>" src="images/libraries.png">
			<span class="bubbleJsLibs"></span>
			<img id="selectComponents" title="<s:text name="title.selected.components"/>" src="images/components.png">
			<span class="bubbleComponenet"></span>
		</div>
	</div>
	<div class="custom_features">
		<div class="tblheader">
		   	<label>
		   		<label>
		   			<input class="checkAllFeatures" type="checkbox" value="" id="checkAllAuto" 
		   				onclick="checkAllEvent($('#checkAllAuto'), $('.feature_checkbox'))"/>
			   		<label class="feature_heading" id="featuresHeading"></label>
	   			</label>
	   		</label>
		</div>
		<div id="accordianchange"  class="feature_content_adder">
			
		</div>
        <div style="clear:both"></div>
	</div>
	      
	<input type="button" class="btn btn-primary fea_add_but" onclick="clickToAdd()" value=">>"/>
	<div class="custom_features_wrapper_right">
		<div class="tblheader">
			<label class="feature_heading"><s:text name="lbl.selected.features"/></label>
			
		</div>
		<div class="theme_accordion_container">
			<div id="result"></div>
	   </div>
	</div>
	    
	<div class="features_actions">
		<input type="button" id="previous" value="<s:text name="label.previous"/>" class="btn btn-primary" 
			onclick="showAppInfoPage();">
		<input id="finish" type="button" value="<s:text name="lbl.update"/>"  class="btn btn-primary"
			onclick="updateApplication();"/>
		<input type="button" id="cancel" value="<s:text name="lbl.btn.cancel"/>" class="btn btn-primary" 
			onclick="loadContent('applications', $('#formCustomers'), $('#container'), '', '', true);">
	</div>
	
	<!-- Hidden fields --> 
	<input type="hidden" name="technologyId" value="<%= technologyId %>">
	<input type="hidden" name="oldAppDirName" value="<%= oldAppDirName %>">
</form>

<script type="text/javascript">
<%	
	if (CollectionUtils.isNotEmpty(features)) {
		for (SelectedFeature feature : features) {
			if(StringUtils.isEmpty(feature.getScope())) {
				feature.setScope(FrameworkConstants.REQ_DEFAULT_SCOPE);
			}
		    boolean showImage = false;
		    if (feature.isCanConfigure()) {
		        showImage = true;
		    }
%>
			constructFeaturesDiv('<%= feature.getName() %>', '<%= feature.getDispName() %>', '<%= feature.getDispValue() %>', '<%= feature.getType() %>', '<%= feature.getVersionID() %>', '<%= feature.getModuleId() %>', <%= feature.isCanConfigure() %>, <%= showImage %>, <%= feature.isDefaultModule() %>, '<%= feature.getArtifactGroupId() %>', '<%= feature.getPackaging() %>', '<%= feature.getScope() %>'); 
<%		
	 	}
	}
%>

<%	
if (CollectionUtils.isNotEmpty(defaultfeatures)) {
	for (SelectedFeature feature : defaultfeatures) {
		if(StringUtils.isEmpty(feature.getScope())) {
			feature.setScope(FrameworkConstants.REQ_DEFAULT_SCOPE);
		}
	    boolean showImage = false;
	    if (feature.isCanConfigure()) {
	        showImage = true;
	    }
%>
		constructFeaturesDiv('<%= feature.getName() %>', '<%= feature.getDispName() %>', '<%= feature.getDispValue() %>', '<%= feature.getType() %>', '<%= feature.getVersionID() %>', '<%= feature.getModuleId() %>', <%= feature.isCanConfigure() %>, <%= showImage %>, <%= feature.isDefaultModule() %>, '<%= feature.getArtifactGroupId() %>', '<%= feature.getPackaging() %>', '<%= feature.getScope() %>'); 
<%		
 	}
}
%>

	inActivateAllMenu($("a[name='appTab']"));
	activateMenu($('#features'));

	var selectedType = "";
    $(document).ready(function () {
    	//To check whether the device is ipad or not and then apply jquery scrollbar
    	if (!isiPad()) {
     		$("#accordianchange").scrollbars();  
    	}
    	showLoadingIcon();
        
        $('#featureselect').ddslick({
        	onSelected: function(data) {
        		selectedType = data.selectedData.value;
        		featureType(data.selectedData.value, data.selectedData.text); 
        	}
        });
        
        $('#clipboard').click(function() {
    		copyToClipboard($('#popup_div').text());
    	});
        
        $('#clipboard').click(function() {
    		copyToClipboard($('#popup_div').text());
    	});
    });
    
    // Function for the feature list selection
    function featureType(selectedFeatureValue, selectedFeatureText) {
    	fillHeading(selectedFeatureText);
    	getFeature(selectedFeatureValue);
    }

    //Function for to get the list of features
    function getFeature(selectedType) {
    	var params = getBasicParams() + '&type=' + selectedType;
	    loadContent("listFeatures", $('#formFeatures'), $('#accordianchange'), params, '', true);
    }
    
    //Function to add the features to the right tab
    function clickToAdd() {
        $('#accordianchange input:checked').each(function () {
        	var name = $(this).val();
        	var dispName = $(this).attr("dispName");
        	var packaging = $(this).attr('packaging');
        	var scope = $(this).attr('scope');
        	var id = removeSpaces(name);
        	var hiddenFieldVersion = $('#'+id).val();
        	var artifactGroupId = $('#'+id).attr('artifactGroupId');
        	var moduleId = $('#'+id).attr('moduleId');
        	var dispValue = $("#" + id + " option:selected").text();
        	var canConfigure = Boolean($(this).attr("canConfigure"));
        	var defaultModule =$(this).attr("defaultModule");
        	var isDefault = defaultModule.toLowerCase()=="true"?true:false;
        	constructFeaturesDiv(name, dispName, dispValue, selectedType, hiddenFieldVersion, moduleId, canConfigure,'', isDefault, artifactGroupId, packaging, scope);
        });
    }
    
    // Function to construct the hidden fields for selected features
    function constructFeaturesDiv(name, dispName, dispValue, hiddenFieldname, hiddenFieldVersion, moduleId, canConfigure, showImage, isDefault, artifactGroupId, packaging, scope) {
		var jsonParamObj = {};
		jsonParamObj.name = name;
		jsonParamObj.dispName = dispName;
		jsonParamObj.packaging = packaging;
		jsonParamObj.moduleId = moduleId;
		jsonParamObj.dispValue = dispValue;
		jsonParamObj.versionID = hiddenFieldVersion;
		jsonParamObj.type = hiddenFieldname;
		jsonParamObj.artifactGroupId = artifactGroupId;
		jsonParamObj.canConfigure = canConfigure;
		jsonParamObj.defaultModule = isDefault;
		jsonParamObj.scope = scope;
		var jsonParam = JSON.stringify(jsonParamObj);
		var ctrlClass = removeSpaces(artifactGroupId);
		var elementsSize = $("#" + ctrlClass + "Div").size();
		var divName = hiddenFieldname.toLowerCase();
// 		$("div[id='"+ ctrlClass +"Div']").remove();
		if (elementsSize === 0) {
			var removeImg = "";
			var selectClass = "";
			var gearClass = "";
			var featureName = dispName + '-' + dispValue;
			if(!isDefault) {
				removeImg = "&nbsp;&times;";
				selectClass = "scopeGearCrossList";
				gearClass = "gearWithCross";
			} else {
				removeImg = "";
				selectClass = "scopeList";
				gearClass = "gear";
			}
			if(!showImage && packaging == "jar") {
				if (isBlank(removeImg)) {
					selectClass = "defaultScope";
				} else {
					selectClass = "scopeGearCrossList";
				}
				var displayName = featuresTextTrim(featureName);
				$("#result").append('<div id="'+ctrlClass+'Div" title="'+ featureName +'" class="'+divName+'">'+displayName+
						'<a href="#" class="crossImg" onclick="removed(this);">'+ removeImg +'</a>'+
						'<input type="hidden" class="'+ctrlClass+'" name="jsonData">'+
						'<select id="'+ctrlClass+'Select" temp="'+ctrlClass+'" class="'+ selectClass +'" onchange="selectBoxChangeEvent(this);" >'+
						'</select>'+
						'</div>');
				getScopeVal(ctrlClass, scope);
			} else if (showImage && packaging != "jar") {
				var displayName = featuresTextTrim(featureName);
				$("#result").append('<div id="'+ctrlClass+'Div" title="'+ featureName +'" class="'+divName+'">'+displayName+
						'<a href="#" onclick="removed(this);">'+ removeImg +'</a>'+
						'<input type="hidden" class="'+ctrlClass+'" name="jsonData">' +
<%-- 						<% --%>
//						if (optionIds != null && optionIds.contains(FrameworkConstants.FEATURES_KEY) || optionIds.contains(FrameworkConstants.COMPONENT_CONFIG)) {
// 						%>
						'<a href="#" id="'+name+'" onclick="showFeatureConfigPopup(this);">'+ 
						'<img src="images/icons/gear.png" title="Configure"/></a>' +
<%-- 						<%  --%>
// 							}
// 						%>
						'</div>');
			} else if (showImage && packaging == "jar") {
				var displayName = featuresTextTrim(featureName);
				$("#result").append('<div id="'+ctrlClass+'Div" title="'+ featureName +'" class="'+divName+'">'+displayName+
						'<a href="#" class="crossImg" onclick="removed(this);">'+ removeImg +'</a>'+
						'<input type="hidden" class="'+ctrlClass+'" name="jsonData">' +
						'<a href="#" class="'+ gearClass +'" id="'+name+'" onclick="showFeatureConfigPopup(this);">'+ 
						'<img src="images/icons/gear.png" title="Configure"/></a>' +
						'<select id="'+ctrlClass+'Select" class="scopeGearList" temp="'+ctrlClass+'" onchange="selectBoxChangeEvent(this);" >'+
						'</select>'+
						'</div>');
				getScopeVal(ctrlClass, scope);
			} else if(!showImage && packaging != "jar") {
				var displayName = featuresTextTrim(featureName);
				$("#result").append('<div id="'+ctrlClass+'Div" title="'+ featureName +'" class="'+divName+'">'+displayName+
						'<a href="#" onclick="removed(this);">'+ removeImg +'</a>'+
						'<input type="hidden" class="'+ctrlClass+'" name="jsonData"></div>');
			}
			
			$("."+ctrlClass).val(jsonParam);
			//featureNotification();
			updateFeatureNotification();
		}
    }
    
    function getScopeVal(ctrlClass, scope) {
    	if (scope !== undefined && !isBlank(scope)) {
    		<% 	for (String scope : scopeList) { %>
	    			if(scope == "<%= scope %>") {
	    				$("#"+ctrlClass+"Select").append($("<option></option>").attr("value", scope).text(scope).attr("selected","selected"));
	    			} else {
	    				$("#"+ctrlClass+"Select").append($("<option></option>").attr("value", "<%= scope %>").text("<%= scope %>"));
	    			}
	    	<%
				} 
			%>	
    	}
    }
    
    function selectBoxChangeEvent(thisObj) {
    	var jsonObj = $.parseJSON($(thisObj).siblings('input[name=jsonData]').val());
    	jsonObj.scope = $(thisObj).val();
    	var ctrlClass = $(thisObj).attr("temp");
    	var jsonParam = JSON.stringify(jsonObj);
    	$("."+ctrlClass).val(jsonParam);
    }
    
    // Function to remove the final features in right tab  
    function removed(thisObj) {
    	$(thisObj).closest('div').remove();
    	updateFeatureNotification();
    }
    
    // Function to fill the heading of the left tab
    function fillHeading(selectedType) {
    	$("#featuresHeading").text(selectedType)
    }
    
  	//Function to get the list of features
    function updateApplication() {
    	var params = getBasicParams();
    	showProgressBar('<s:text name='progress.txt.update.app'/>');
    	loadContent('finish', $('#formFeatures'), $('#container'), params, false, true);
    }
  	
  	//To show the configuration popup
  	function showFeatureConfigPopup(obj) {
  		var featureName = $(obj).attr("id");
  		var featureData = $.parseJSON($(obj).parent().find('input[name="jsonData"]').val());
  		var type = featureData.type;
  		var params = "&featureName=";
  		params = params.concat(featureName);
  		params = params.concat("&featureType=");
  		if (type == "FEATURE") {
  			type = "Features";
  		} else if (type == "COMPONENT") {
  			type = "Component";
  		}
  		params = params.concat(type);
  		yesnoPopup('showFeatureConfigPopup', '<s:text name="lbl.configure"/>', 'configureFeature', '<s:text name="lbl.configure"/>', '', params);
  	}
  	
  	function successEvent(url, data) {
  		if (url === "showConfigProperties") {
  			$('#propertiesDiv').empty();
  			$('#propertiesDiv').html(data);
  		} else if (url === "configureFeature" || url === "configureFeatureParam") {
  			hideLoadingIcon();
  			$("#successmsg").show();
  			setTimeOut();
  		} else if (url === "fetchDefaultFeatures") {
			makeFeaturesSelected(data.depArtifactGroupNames, data.depArtifactInfoIds, "defaultFeature");
  		} else if (url === "fetchSelectedFeatures") {
  			makeFeaturesSelected(data.selArtifactGroupNames, data.selArtifactInfoIds, "fetchSelectedFeatures");
		} else if (url === "fetchDependentFeatures") {
			if (data.dependency) {
				makeFeaturesSelected(data.depArtifactGroupNames, data.dependencyIds, "fetchDependentFeatures");
			}
		}
  	}
  	
  	$('#allFeatures').click(function() {
  		$(".feature").show();
  		$(".javascript").show();
  		$(".component").show();
	});
  	
  	$('#selectModules').click(function() {
  		$(".feature").show();
  		$(".javascript").hide();
  		$(".component").hide();
	});
    
    $('#selectJsLibs').click(function() {
    	$(".feature").hide();
    	$(".javascript").show();
  		$(".component").hide();
	});
    
    $('#selectComponents').click(function() {
    	$(".javascript").hide();
  		$(".feature").hide();
  		$(".component").show();
	});
    
    featureNotification();
    
    function featureNotification() {
	    var total = $(".feature:visible").length + $(".javascript:visible").length + $(".component:visible").length;
	    var counterValue = parseInt(total); 
		$('.bubbleAll').html(counterValue); 
	
	    var counterValue = parseInt($(".feature:visible").length); 
		$('.bubbleModule').html(counterValue); 
	
		var counterValue = parseInt($(".javascript:visible").length); 
		$('.bubbleJsLibs').html(counterValue);
			
		var counterValue = parseInt($(".component:visible").length); 
		$('.bubbleComponenet').html(counterValue);
    }
    
    function updateFeatureNotification() {
    	var total = $(".feature").length + $(".javascript").length+ $(".component").length;
	    var counterValue = parseInt(total); 
		$('.bubbleAll').html(counterValue); 
	
	    var counterValue = parseInt($(".feature").length); 
		$('.bubbleModule').html(counterValue); 
	
		var counterValue = parseInt($(".javascript").length); 
		$('.bubbleJsLibs').html(counterValue);
			
		var counterValue = parseInt($(".component").length); 
		$('.bubbleComponenet').html(counterValue);
    }
</script>