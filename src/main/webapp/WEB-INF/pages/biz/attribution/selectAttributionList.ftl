<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
	<form method="post" action='/vst_admin/biz/attribution/selectAttributionList.do' id="searchForm">
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
	        <th>选择</th>
	    	<th>编号</th>
	        <th>名称</th>
	        </tr>
	    </thead>
	    <tbody>
			<#list pageParam.items as attribution> 
				<tr>
					<td>
						<input type="radio" name="attributionId" value="${attribution.attributionId!''}">
						<input type="hidden" name="attributionNameHide" value="${attribution.attributionName!''}">
						
						<#list attributionTypeList as attributionTypeObj>
		            		<#if attribution.attributionType == attributionTypeObj.code>
		            			<input type="hidden"  name="attributionTypeNameHide" value="${attributionTypeObj.cnName!''}">
		            		</#if>
		        		</#list>
						
					 </td>
					<td>${attribution.attributionId!''} </td>
					<td>${attribution.attributionName!''} </td>
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

//查询
$("#search_button").bind("click",function(){
    if(!$("#searchForm").validate().form()){
		return;
	}
	$("#searchForm").submit();
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var dest = {};
	dest.destId = $("input[name='attributionId']",obj).val();
    dest.destName = $("input[name='attributionNameHide']",obj).val();
    dest.destType = $("input[name='attributionTypeNameHide']",obj).val();
	parent.onSelectDest(dest);
});

</script>


