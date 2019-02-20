
<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body  style="min-height:445px;">
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/bizBrand/findSelectBrandList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">名称：</td>
                <td class="w18"><input type="text" name="brandName" value="${brandName!''}"></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10">
                	<input type="radio" name="otherBrand" value="1" /> 其它品牌
					<input type="hidden" name="brandNameHide" value="其它品牌">
					<input type="hidden" name="brandIdHide" value="1">
                </td>
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
             <th>选择</th>
             <th>ID</th>
             <th>名称</th>
            </tr>
        </thead>
        <tbody>
        	<#if pageParam??>
			<#list pageParam.items as bizBrand> 
			<#if bizBrand.brandId != 1>
			<tr>
			<td>
				<input type="radio" name="bizBrandId">
				<input type="hidden" name="brandNameHide" value="${bizBrand.brandName!''}">
				<input type="hidden" name="brandIdHide" value="${bizBrand.brandId!''}">
			 </td>
			<td>${bizBrand.brandId!''}</td>
			<td>${bizBrand.brandName!''} </td>
			</tr>
        	</#if>
			</#list>
        	</#if>
        </tbody>
    </table>
     <table class="co_table">
        <tbody>
            <tr>
                 <td class="s_label">
                 	<#if pageParam?? && pageParam.items?exists> 
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
	$("#searchForm").submit();
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var brand = {};
	brand.brandId = $("input[name='brandIdHide']",obj).val();
	brand.brandName = $("input[name='brandNameHide']",obj).val();

	parent.onSelectBrand(brand);
});
	
</script>