<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_header">
 <i class="icon-home ihome"></i>
    <ul class="iframe_nav">
        <li><a href="#">首页</a> &gt;</li>
        <li><a href="#">品类管理</a> &gt;</li>
        <li class="active">品类列表</li>
    </ul>
</div>

<div class="iframe_search">
	<form method="post" action='/vst_admin/biz/category/findObjectList.do?code=${code}' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">sql：</td>
                <td><textarea name="sql" rows="10" style="width:600px;">${sql!''}</textarea></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
            </tr>
        </tbody>
    </table>	
	</form>
</div>
	
<!-- 主要内容显示区域\\ -->
<div class="iframe_content">
    <div style="color:red">${ERROR}</div>
    <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
            <#list resultHead as head> 
        	<th>${head}</th>
        	</#list>
            </tr>
        </thead>
        <tbody>
			<#list resultList as result> 
			<tr>
			<#list resultHead as head>
                <#if head=='MOBILE' || head == 'FULL_NAME' || head == 'ID_NO'>
        		<td>机密不显示</td>
                <#else>
        		<td>${result[head]}</td>
                </#if>
        	</#list>
			</tr>
			</#list>
        </tbody>
    </table>

</div><!-- div p_box -->
	
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
var categoryPropListDialog,categoryPropGroupsDialog,branchListDialog;
$(function(){

$("searchForm input[name='sql']").focus();
	$("#search_button").bind("click",function(){
		$("#searchForm").submit();
});
	


function confirmAndRefresh(result){
	if (result.code == "success") {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			$("#searchForm").submit();
		}});
	}else {
		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			//$.alert(result.message);
		}});
	}
}
});

</script>

