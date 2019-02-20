<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>O2O股东关联公司管理-框架页</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/framework.css"/>
</head>
<body>

<div id="nav">
    <ul>
        <li class="main">主菜单</li>
        <li>
        	<a class="item active" href="javascript:void(0);" id="asso_co_base" target="ASSCO_Iframe">
        		<i class="triangle"></i>
        		基本信息
        		<#if type?upper_case == "COMPARED" && ASSCO_CO?? && ASSCO_CO &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
    		<input type="hidden" id="companyId" value="${companyId!''}" />
        	<input type="hidden" id="viewType" value="${type!''}" />
        	<input type="hidden" id="auditType" value="${auditStatus!''}" />
		</li>
        <li>
        	<a class="item" href="javascript:void(0);" id="asso_co_shold" target="ASSCO_Iframe">
        		<i class="triangle"></i>
        		股东方
        		<#if type?upper_case == "COMPARED" && SHOLD?? && SHOLD &gt; 0>
        			<i class="icon icon-warning"></i>
        		</#if>
    		</a>
		</li>
    </ul>
</div>
<div id="content">
    <iframe id="ASSCO_Iframe" style="width:100%;height:100%" name="ASSCO_Iframe" frameborder="0"></iframe>
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
			var companyId = $("#companyId").val();
			var viewType = $("#viewType").val();
			if(!companyId){
				$("#ASSCO_Iframe").attr("src","/vst_admin/o2o/sholdAssCompany/showAddAssCompany.do?type=" + viewType + "&_="+new Date());
			}else{
			    $("#ASSCO_Iframe").attr("src","/vst_admin/o2o/sholdAssCompany/showUpdateAssCompany.do?companyId="+ companyId + "&type=" + viewType + "&_="+new Date());
			}
		};
		showBaseInfoHandler();
	
		$("#asso_co_base").parent("li").click(showBaseInfoHandler);
		
		_createASSOCompanyFirst = function (target) {
			$(target).find("a").removeClass("active");
			$("#asso_co_base").addClass("active");
		}

		
		
		$("#asso_co_shold").parent("li").click(function(){
			var companyId = $("#companyId").val(),
				auditType = $("#auditType").val(),
				viewType = $("#viewType").val(),
				that = this;
			if(!companyId){
				backstage.alert({
					content:"请先创建股东关联公司信息",
					callback: function () {
						_createASSOCompanyFirst(that);
					}
				});
				return;
			}else{
			    $("#ASSCO_Iframe").attr("src","/vst_admin/o2o/sholdAssCompany/showSholds.do?companyId=" + companyId +"&type=" + viewType + "&auditType=" + auditType +"&_="+new Date());
			}
		});
		
	});
</script>