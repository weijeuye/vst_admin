<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">首页</a> &gt;</li>
            <li><a href="#">归属地区管理</a> &gt;</li>
            <li class="active">归属地区列表</li>
        </ul>
</div>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/biz/attribution/findAttributionList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">名称：</td>
                <td class="w18"><input type="text" name="attributionName" value="${attributionName!''}"></td>
                <td class="s_label">类别：</td>
                <td class="w18">
                	<select name="attributionType">
                		<option value="">不限</option>
                		<#list attributionTypeList as attributionTypeObj>
	                		<#if attributionType == attributionTypeObj.code>
	                			<option value="${attributionTypeObj.code!''}" selected="selected">${attributionTypeObj.cnName!''}</option>
	                		<#else>
	                			<option value="${attributionTypeObj.code!''}">${attributionTypeObj.cnName!''}</option>
	                		</#if>
                		</#list>
                	</select>
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="new_button">新增</a></td>
                 <input type="hidden" name="page" value="${page}">
            </tr>
        </tbody>
    </table>	
</form>

</div>
	
<!-- 主要内容显示区域\\ -->
    <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
        	<th>编号</th>
            <th>名称</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as attribution> 
				<tr>
					<td>${attribution.attributionId!''} </td>
					<td>${attribution.attributionName!''} </td>
					<td class="oper">
		                <a href="javascript:void(0);" class="editProp" data=${attribution.attributionId}>编辑</a>
		            </td>
				</tr>
			</#list>
        </tbody>
    </table>
	<#if pageParam.items?exists> 
		<div class="paging" > 
			${pageParam.getPagination()}
		</div> 
	</#if>

	</div><!-- div p_box -->
	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
var addDialog,updateDialog;

//查询
$("#search_button").bind("click",function(){
	if(!$("#searchForm").validate().form()){
		return;
	}
	$("#searchForm").submit();
});

//新建
$("#new_button").bind("click",function(){
	var url = "/vst_admin/biz/attribution/showAddAttribution.do";
	addDialog = new xDialog(url, {}, {title:"新增归属地区",width:800});
});

//修改
$("a.editProp").bind("click",function(){
	var attributionId = $(this).attr("data");
	var url = "/vst_admin/biz/attribution/showUpdateAttribution.do";
	updateDialog = new xDialog(url,{"attributionId":attributionId}, {title:"修改归属地区",width:800});
});
</script>