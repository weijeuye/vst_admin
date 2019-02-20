<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/front/districtAround/findDistrictList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">出发地名称：</td>
                <td class="w18"><input type="text" name="districtName" value="${districtName}"></td>
                <td class="s_label">出发地ID：</td>
                <td class="w18"><input type="text" name="districtId" value="${districtId}" digits=true></td>
                <td class="s_label">出发地类型：</td>
                <td class="w18">
                	<select name="districtType">
                	<option value="">不限</option>
                    	<#list districtTypeList as distType>
                    		<#if districtType == distType.code>
                    		<option value="${distType.code}" selected="selected">${distType.cnName}</option>
                    		<#else>
                    		<option value="${distType.code}">${distType.cnName}</option>
                    		</#if>
                    	</#list>
                	</select>
                </td>
                </tr>
                <tr>
                <td class="s_label">有效状态：</td>
                <td class="w18">
                <select name="cancelFlag">
                <option value="">全部</option>
                <option <#if cancelFlag == "Y">selected="selected"</#if> value="Y">有效</option>
                <option <#if cancelFlag == "N">selected="selected"</#if> value="N">无效</option>
                </select>
                </td>
                <td class="s_label">第二出发地：</td>
                <td class="w18">
                <select name="hasSetDistrict">
                <option value="">全部</option>
                <option <#if hasSetDistrict == "Y">selected="selected"</#if> value="Y">显示配置第二出发地</option>
                </select>
                </td>
                
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
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
            <th>类型</th>
            <th>拼音</th>
            <th>简拼</th>
            <th>URL拼音</th>
            <th>上级区域</th>
            <th>状态</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDistrict> 
			<tr>
				<td>${bizDistrict.districtId!''} </td>
				<td>${bizDistrict.districtName!''} </td>
				<td>${bizDistrict.districtTypeCnName!''} </td>
				<td>${bizDistrict.pinyin!''} </td>
				<td>${bizDistrict.shortPinyin!''} </td>
				<td>${bizDistrict.urlPinyin!''} </td>
				<#if bizDistrict.parentDistrict??>
					<td>${bizDistrict.parentDistrict.districtName} </td>
				<#else>
					<td></td>
				</#if>
				<td>
					<#if bizDistrict.cancelFlag == "Y"> 
						<span style="color:green" class="cancelProp">有效</span>
					<#else>
						<span style="color:red" class="cancelProp">无效</span>
					</#if>
				</td>
				<td class="oper">
	                <a href="javascript:void(0);" class="editDistrictAround" data=${bizDistrict.districtId} data1=${bizDistrict.districtName}>设置</a>
	                <a href="javascript:void(0);" class="showLogDialog" param='parentId=${bizDistrict.districtId}&parentType=BIZ_DISTRICT&sysName=VST'>操作日志</a>
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



//编辑第2出发地
$("a.editDistrictAround").bind("click",function(){
	var districtId = $(this).attr("data");
	var destName = $(this).attr("data1");
	var url = "/vst_admin/front/districtAround/showAddAndUpdateDistrictAround.do?districtId="+districtId;
	addAndUpdateDialog = new xDialog(url,{},{title:"编辑"+destName+":第2出发地",width:900,height:500});
	
});



</script>