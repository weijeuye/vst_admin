<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>股东信息-框架页</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/framework.css"/>
</head>
<body>

<div id="nav">
    <ul>
        <li class="main">主菜单</li>
        <li>
        	<a class="item active" id="shold_base_info" href="javascript:void(0);" target="sholdIframe">
        		<i class="triangle"></i>
        		基本信息
        		<#if type?upper_case == "COMPARED" && SHOLD?? && SHOLD &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
        	<input type="hidden" id="shareholderId" value="${shareholderId}">
        	<input type="hidden" id="viewType" value="${type}">
        	<input type="hidden" id="auditType" value="${auditStatus!''}">
    	</li>
        <li>
        	<a class="item" id="materials" href="javascript:void(0);" data-type="SHOLD" target="sholdIframe">
        		<i class="triangle"></i>
        		资质
        		<#if type?upper_case == "COMPARED" && MATERIALS?? && MATERIALS &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
        	</a>
    	</li>
        <li>
        	<a class="item" id="shold_principal" href="javascript:void(0);" target="sholdIframe">
        		<i class="triangle"></i>
        		主要负责人
        		<#if type?upper_case == "COMPARED" && PRINCIPAL?? && PRINCIPAL &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
    </ul>
</div>
<div id="content">
    <iframe id="sholdIframe" style="width:100%;height:100%" name="sholdIframe" frameborder="0"></iframe>
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
			var sholdId = $("#shareholderId").val();
			var viewType = $("#viewType").val();
			if(sholdId==""){
				$("#sholdIframe").attr("src","/vst_admin/o2o/shareholder/showAddShareholder.do?type=" + viewType + "&_="+new Date());
			}else{
			    $("#sholdIframe").attr("src","/vst_admin/o2o/shareholder/showUpdateShareholder.do?shareholderId="+ sholdId + "&type=" + viewType + "&_="+new Date());
			}
		};
		showBaseInfoHandler();
		
		_createShareholderFirst = function (target) {
			$(target).find("a").removeClass("active");
			$("#shold_base_info").addClass("active");
		}
	
		$("#shold_base_info").parent("li").click(showBaseInfoHandler);

		$("#materials").parent("li").click(function(){
			var sholdId = $("#shareholderId").val(),
				param = {},
				objectType = $("#materials").data("type"),
				auditType = $("#auditType").val(),
				that = this;
			param.objectType = objectType;
			param.objectId = sholdId;
			param.type=$("#viewType").val();
			param.dataRefer = "SHOLD";
			if(!sholdId){
				backstage.alert({
					content:"请先创建股东",
					callback: function () {
						_createShareholderFirst(that);
					}
				});
				return;
			}else{
			    $("#sholdIframe").attr("src","/vst_admin/o2o/showMaterials.do?param=" + JSON.stringify(param) + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		$("#shold_principal").parent("li").click(function(){
			var sholdId = $("#shareholderId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!sholdId){
				backstage.alert({
					content:"请先创建股东",
					callback: function () {
						_createShareholderFirst(that);
					}
				});
				return;
			}else{
			    $("#sholdIframe").attr("src","/vst_admin/o2o/shareholder/showPrincipal.do?shareholderId=" + sholdId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
	});
</script>