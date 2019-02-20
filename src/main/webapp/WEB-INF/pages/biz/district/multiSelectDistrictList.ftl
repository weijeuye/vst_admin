<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/district/multiSelectDistrictList.do' id="searchForm">
	<input type="hidden" name="callBack" value="${callBack}"/>
	<input type="hidden" name="elementId" value="${elementId}"/>
	<input type="hidden" name="nameId" value="${nameId}"/>
	<input type="hidden" name="districtTypeForVisa" value="${district.districtTypeForVisa}"/>
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">名称：</td>
                <td class="w18"><input type="text" name="districtName" value="${districtName!''}"></td>
                <td class="s_label">区域类型：</td>
                <td class="w18">
                	<select name="districtType">
                		<#if district.districtTypeForVisa != "">
                			<option value="" <#if districtType == ''>selected ='selected'</#if>>不限</option>
	                		<option value="PROVINCE" <#if districtType == 'PROVINCE'>selected ='selected'</#if>>省份</option>
	                		<option value="PROVINCE_DCG" <#if districtType == 'PROVINCE_DCG'>selected ='selected'</#if>>直辖市</option>
	                		<option value="PROVINCE_AN" <#if districtType == 'PROVINCE_AN'>selected ='selected'</#if>>自治区</option>
	                		<option value="PROVINCE_SA" <#if districtType == 'PROVINCE_SA'>selected ='selected'</#if>>特别行政区</option>
	                	<#else>
	                		<option value="">不限</option>
	                    	<#list districtTypeList as distType>
	                    		<#if districtType == distType.code>
	                    		<option value="${distType.code!''}" selected="selected">${distType.cnName!''}</option>
	                    		<#else>
	                    		<option value="${distType.code!''}">${distType.cnName!''}</option>
	                    		</#if>
	                    	</#list>
	                	</#if>
                	</select>
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                 <input type="hidden" name="page" value="${page}">
            </tr>
        </tbody>
    </table>
	</form>
</div>
</div>



<!-- 主要内容显示区域\\ -->
<div class="iframe-content">
    <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
            <th>选择</th>
        	<th>编号</th>
            <th>名称</th>
            <th>直接上级目的地</th>
            <th>类型</th>
            <th>拼音</th>
            <th>URL拼音</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDistrict> 
			<tr>
				<td>
					<input type="checkbox" name="district">
					<input type="hidden" name="districtNameHide" value="${bizDistrict.districtName!''}">
					<input type="hidden" name="districtIdHide" value="${bizDistrict.districtId!''}">
					<input type="hidden" name="foreighFlagHide" value="${bizDistrict.foreighFlag!''}">
				</td>
				<td>${bizDistrict.districtId!''} </td>
				<td>${bizDistrict.districtName!''} </td>
				<td>${(bizDistrict.parentDistrict.districtName)!''} </td>
				<td>${bizDistrict.districtTypeCnName!''} </td>
				<td>${bizDistrict.pinyin!''} </td>
				<td>${bizDistrict.urlPinyin!''} </td>
			</tr>
			</#list>
        </tbody>
    </table>
     <table class="co_table">
        <tbody>
            <tr>
                <td class=" operate mt10">
                	<input type="checkbox" name="all_checkbox">全选</input>
                </td>
                <td class=" operate mt10">
                	<a class="btn btn_cc1" id="yes_button">确定</a>
                </td>
                 <td class="s_label">
                 	<#if pageParam.items?exists> 
						<div class="paging" > 
						${pageParam.getPagination()}
						</div> 
					</#if>
                 </td>
            </tr>
        </tbody>
    </table>
    <div style="border-color: inherit;"></div>
	</div><!--p_box-->
	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
$(function(){

//查询
$("#search_button").bind("click",function(){
	$("#searchForm").submit();
});

//确定按钮
$("#yes_button").bind("click",function(){
	//拿到已选中的checkbox
	var checkedBoxTds = $("input[name='district']:checkbox:checked").parent('td');
	var checkedCitys = new Array();

	$.each(checkedBoxTds, function(index, value) {
		var district = {};
		district.districtId = $("input[name='districtIdHide']",value).val();
		district.districtName = $("input[name='districtNameHide']",value).val();
		district.foreighFlag = $("input[name='foreighFlagHide']",value).val();
		checkedCitys.push(district);
	});

	var location = {};
    location.elementId='${elementId}';
    location.nameId='${nameId}';
    <#if callBack?? && callBack!=''>
    	parent.${callBack}(location, checkedCitys);
    <#else>
    	parent.onMultiSelectDistrict(location, checkedCitys);
    </#if>
});

//选择单个复选框
$("input[name='district']:checkbox").bind("click",function(){
	//判断是不是所有的checkbox item 都被选中
	var allCheckBoxs = $("input[name='district']:checkbox");
	var checkedBoxs = $("input[name='district']:checkbox:checked");
	if (allCheckBoxs.length == checkedBoxs.length) {
		$("input[name='all_checkbox']").attr("checked", true);
	} else {
		$("input[name='all_checkbox']").attr("checked", false);
	}
});

//全选按钮
$("input[name='all_checkbox']").bind("click",function(){
	if ($(this).is(':checked')) {
		$("input[name = 'district']:checkbox").attr("checked", true);
	} else {
		$("input[name = 'district']:checkbox").attr("checked", false);
	}
});

});
</script>


