<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<#if dictId == ''>
	<div class="iframe_header">
	        <ul class="iframe_nav">
	            <li><a href="#">首页</a> &gt;</li>
	            <li><a href="#">购物点管理</a> &gt;</li>
	            <li class="active">购物点列表</li>
	        </ul>
	</div>
</#if>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/biz/bizDestShop/findBizDestShopList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">目的地名称：</td>
                <td class="w18"><input type="text" name="destName" value="${destName!''}"></td>
                <td class="s_label">目的地ID：</td>
                <td class="w18"><input type="text" name="destId" value="${bizDestShop.destId!''}" digits=true></td>
                <td class="s_label">主营产品：</td>
                <td class="w18"><input type="text" name="mainProducts" value="${bizDestShop.mainProducts!''}"></td>
            </tr>
            <tr>
            	<td class="s_label">兼营产品：</td>
                <td class="w18"><input type="text" name="subjoinProducts" value="${bizDestShop.subjoinProducts!''}"></td>
                <td class="s_label">目的地状态：</td>
                <td class="w18">
	                <input type="checkbox" name="cancelFlag" value="Y" >有效
	                <input type="checkbox" name="cancelFlag" value="N" >无效
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
        	<th>目的地编号</th>
            <th>目的地名称</th>
            <th>所属行政关系</th>
            <th>主营产品</th>
            <th>兼营产品</th>
            <th>是否有效</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as dest> 
			<#if dest??>
				<tr>
					<td>${dest.destId!''} </td>
					<td>${dest.destName!''} </td>
					<td>${dest.districtName!''} </td>
					<td><#if dest.bizDestShop??>${dest.bizDestShop.mainProducts!''}</#if></td>
					<td><#if dest.bizDestShop??>${dest.bizDestShop.subjoinProducts!''}</#if></td>
					<td>
						<#if dest.cancelFlag == "Y"> 
							<span style="color:green" class="cancelProp">有效</span>
						<#elseif dest.cancelFlag == "N">
							<span style="color:red" class="cancelProp">无效</span>
					    <#else>
					        <span style="color:red" class="cancelProp"></span>
						</#if>
					</td>
						<td class="oper">
			               <a href="javascript:void(0);" class="editProp" data=${dest.destId}>编辑</a>
			            </td>
					</tr>
				</#if>
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
var updateDialog;

var cancelFlag = '${cancelFlag}';
$('input[name="cancelFlag"]').each(function(){
	if(cancelFlag == 'all'){
		$(this).attr("checked", true);
	}else if($(this).val() == cancelFlag){
		$(this).attr("checked", true);
	}
});

//查询
$("#search_button").bind("click",function(){
	if(!$("#searchForm").validate().form()){
		return;
	}
	$("#searchForm").submit();
});

//修改
$("a.editProp").bind("click",function(){
	var destId = $(this).attr("data");
	var url = "/vst_admin/biz/bizDestShop/showUpdateBizDestShop.do";
	updateDialog = new xDialog(url,{"destId":destId}, {title:"编辑购物点",height:"550",width:800});
});

</script>