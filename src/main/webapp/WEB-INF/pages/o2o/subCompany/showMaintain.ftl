<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>O2O子公司管理-框架页</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/framework.css"/>
</head>
<body>

<div id="nav">
    <ul>
        <li class="main">主菜单</li>
        <li>
        	<a class="item active" href="javascript:void(0);" id="subco_base" target="subCOIframe">
        		<i class="triangle"></i>
        		基本信息
        		<#if type?upper_case == "COMPARED" && SUB_CO?? && SUB_CO &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
    		<input type="hidden" id="subCompanyId" value="${subCompanyId!''}" />
        	<input type="hidden" id="viewType" value="${type!''}" />
        	<input type="hidden" id="auditType" value="${auditStatus!''}" />
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="materials" data-type="SUB_CO" target="subCOIframe">
        		<i class="triangle"></i>
        		资质
        		<#if type?upper_case == "COMPARED" && MATERIALS?? && MATERIALS &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="subco_principal" target="subCOIframe">
        		<i class="triangle"></i>
        		主要负责人
        		<#if type?upper_case == "COMPARED" && PRINCIPAL?? && PRINCIPAL &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="subco_parent_shold" target="subCOIframe">
        		<i class="triangle"></i>
        		父级合作股东
        		<#if type?upper_case == "COMPARED" && PARENT_SHOLD?? && PARENT_SHOLD &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="subco_shold" target="subCOIframe">
        		<i class="triangle"></i>
        		股东方
        		<#if type?upper_case == "COMPARED" && SHOLD?? && SHOLD &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="subco_contract" target="subCOIframe">
    			<i class="triangle"></i>
    			合同签署备案信息
    			<#if type?upper_case == "COMPARED" && CONTRACT?? && CONTRACT &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
			</a>
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="subco_pos" target="subCOIframe">
        		<i class="triangle"></i>
        		营业网点
        		<#if type?upper_case == "COMPARED" && POINT_OF_SALES?? && POINT_OF_SALES &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
		<li>
        	<a class="item" href="javascript:void(0);" id="subco_relate_supplier" target="subCOIframe">
        		<i class="triangle"></i>
        		关联供应商
        		<#if type?upper_case == "COMPARED" && RELATE_SUPPLIER?? && RELATE_SUPPLIER &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
    </ul>
</div>
<div id="content">
    <iframe id="subCOIframe" style="width:100%;height:100%" name="subCOIframe" frameborder="0"></iframe>
</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/framework.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
</body>
</html>

<script>

	$(function () {
	
	    <#if errorMsg??>
	    	backstage.alert({
		  		content: "${errorMsg}"
		  	});
	    </#if>
	
		var showBaseInfoHandler = function(){
			var subCompanyId = $("#subCompanyId").val();
			var viewType = $("#viewType").val();
			if(!subCompanyId){
				$("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showAddSubCompany.do?type=" + viewType + "&_="+new Date());
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showUpdateSubCompany.do?subCompanyId="+ subCompanyId + "&type=" + viewType + "&_="+new Date());
			}
		};
		showBaseInfoHandler();
	
		$("#subco_base").parent("li").click(showBaseInfoHandler);
		
		_createSubCompanyFirst = function (target) {
			$(target).find("a").removeClass("active");
			$("#subco_base").addClass("active");
		}

		$("#materials").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				param = {},
				objectType = $("#materials").data("type"),
				auditType = $("#auditType").val(),
				that = this;
			param.objectType = objectType;
			param.objectId = subCompanyId;
			param.subCompanyId = subCompanyId;
			param.type=$("#viewType").val();
			param.dataRefer = "SUB_CO";
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/showMaterials.do?param=" + JSON.stringify(param) + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#subco_principal").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId) {
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showPrincipal.do?subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		
		$("#subco_parent_shold").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showSholds.do?relationType=Y&subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#subco_shold").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showSholds.do?relationType=N&subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#subco_contract").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/contracts.do?subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#subco_pos").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/poses.do?subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#subco_relate_supplier").parent("li").click(function(){
			var subCompanyId = $("#subCompanyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!subCompanyId){
				backstage.alert({
					content:"请先创建子公司信息",
					callback: function () {
						_createSubCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#subCOIframe").attr("src","/vst_admin/o2o/subCompany/showRelateSuppliers.do?subCompanyId=" + subCompanyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
	});
</script>