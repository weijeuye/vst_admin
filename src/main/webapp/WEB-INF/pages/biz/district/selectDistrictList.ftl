<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/district/selectDistrictList.do' id="searchForm">
	<input type="hidden" name="callBack" value="${callBack}"/>
	<input type="hidden" name="elementId" value="${elementId}"/>
	<input type="hidden" name="nameId" value="${nameId}"/>
	<input type="hidden" name="districtTypeForVisa" value="${districtTypeForVisa}"/>
	<input type="hidden" name="districtTypeForKeyword" value="${districtTypeForKeyword}"/>
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">名称：</td>
                <td class="w18"><input type="text" name="districtName" value="${districtName!''}"></td>
                <td class="s_label">区域类型：</td>
                <td class="w18">
                	<select name="districtType">
	                	<#if districtTypeForVisa != "">
							<option value="COUNTRY" <#if districtType == 'COUNTRY'>selected ='selected'</#if>>国家</option>
	                		<option value="PROVINCE_SA" <#if districtType == 'PROVINCE_SA'>selected ='selected'</#if>>特别行政区</option>
	                		<option value="PROVINCE" <#if districtType == 'PROVINCE'>selected ='selected'</#if>>省</option>
	                	<#elseif districtTypeForKeyword == "keyword">
	                		<option value="PROVINCE" <#if districtType == 'PROVINCE'>selected ='selected'</#if>>省</option>
	                		<option value="PROVINCE_DCG" <#if districtType == 'PROVINCE_DCG'>selected ='selected'</#if>>直辖市</option>
	                		<option value="PROVINCE_SA" <#if districtType == 'PROVINCE_SA'>selected ='selected'</#if>>特别行政区</option>
	                		<option value="PROVINCE_AN" <#if districtType == 'PROVINCE_AN'>selected ='selected'</#if>>自治区</option>
	                		<option value="CITY" <#if districtType == 'CITY'>selected ='selected'</#if>>市</option>
							<option value="COUNTY" <#if districtType == 'COUNTY'>selected ='selected'</#if>>区/县</option>
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
					<input type="radio" name="district">
					<input type="hidden" name="districtNameHide" value="${bizDistrict.districtName!''}">
					<input type="hidden" name="districtIdHide" value="${bizDistrict.districtId!''}">
					<input type="hidden" name="foreighFlagHide" value="${bizDistrict.foreighFlag!''}">
                    <input type="hidden" name="districtTypeHide" value="${bizDistrict.districtType!''}">
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
                <td class=" operate mt10"><a class="btn btn_cc1" id="clear_Button">清除</a></td>
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
	</div><!--p_box-->
	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>

$(document).ready(function(){
	var obj = {};
	obj.districtType = '${districtType}';
	obj.selectType = $("select[name='districtType']");
	var graparentdom = window.parent.parent.document;
	if (graparentdom.getElementById("visaProduct") != null) {
		if (typeof(parent.setDistrictType) === "function") {
			parent.setDistrictType(obj);
		}
	}
});

$("select[name='districtType']").change(function(){
	var obj = {};
	obj.districtName = $("input[name='districtName']");
    var graparentdom = window.parent.parent.document;
	if (graparentdom.getElementById("visaProduct") != null) {
		if (typeof(parent.clearDistrictNameSearch) === "function") {
			parent.clearDistrictNameSearch(obj);
		}
	}
});

//查询
$("#search_button").bind("click",function(){
	var obj = {};
	obj.districtType = $("select[name='districtType']").find("option:selected").val();
	obj.districtName = $("input[name='districtName']");
    var graparentdom = window.parent.parent.document;
	if (graparentdom.getElementById("visaProduct") != null) {
		if (typeof(parent.setDistrictVisaSearch) === "function") {
			parent.setDistrictVisaSearch(obj);
		}
	}
	$("#searchForm").submit();
});

//清除
$("#clear_Button").bind("click",function(){
	if (typeof(parent.onClearDistrict) === "function") {
		var district = {};
		parent.onClearDistrict(district);
	}
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var district = {};
	district.districtId = $("input[name='districtIdHide']",obj).val();
    district.districtName = $("input[name='districtNameHide']",obj).val();
    district.foreighFlag = $("input[name='foreighFlagHide']",obj).val();
	district.districtType= $("input[name='districtTypeHide']",obj).val();
    district.elementId='${elementId}';
    district.nameId='${nameId}';
    <#if callBack?? && callBack!=''>
    	parent.${callBack}(district);
    <#else>   	
		<#if districtTypeForVisa != "">
			parent.onSelectDistrictForVisa(district);
		<#else>
			parent.onSelectDistrict(district);
		</#if>
    </#if>
	
});

</script>


