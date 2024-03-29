<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/districtSign/findDistrictSignList.do' id="searchForm">
	<input type="hidden" id="signType" value="${signType!''}" name="signType" />
	<input type="hidden" id="flag" value="${flag!''}" name="flag" />
    <table class="s_table">
        <tbody>
            <tr>
           		<td class="s_label">编号:
	                <input type="text" name="signId" value="${signId}" digits=true>
                </td>
                <td class="s_label">名称:
	                <input type="text" name="signName" value="${signName}">
	                <a class="btn btn_cc1" id="search_button">查询</a>
                </td>
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
	        	<th>行政区名称</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as districtSign>
			<tr>
			<td>
				<input type="radio" name="signId" value="${districtSign.signId!''}">
				<input type="hidden" name="signName" value="${districtSign.signName!''}">
			</td>
			<td>${districtSign.signId!''}</td>
			<td>${districtSign.signName!''}</td>
			<td>${districtSign.districtName!''}<#if districtSign.parentDistrictName??>--${districtSign.parentDistrictName!''}</#if></td>
			</tr>
			</#list>
        </tbody>
    </table>
     <table class="co_table">
        <tbody>
            <tr>
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

//查询
$("#search_button").bind("click",function(){
	if(!$("#searchForm").validate().form()){
		return;
	}
	$("#searchForm").submit();
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var districtSign = {};
	districtSign.signType = $("#signType").val();
	districtSign.signId = $("input[name='signId']",obj).val();
    districtSign.signName = $("input[name='signName']",obj).val();
	parent.onSelectDistrictSign(districtSign);
});

</script>


