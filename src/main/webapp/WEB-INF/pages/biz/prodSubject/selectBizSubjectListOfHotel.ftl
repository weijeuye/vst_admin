<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/biz/prodSubject/searchSubjectOfHotel.do' id="searchForm">
 <input type="hidden" name="type" value="${type}"/>
  <input type="hidden" name="categoryId" value="${categoryId}"/>
  
  <#if categoryId ==1>
  	<input type="hidden" name="dictDefId" value="1022"/>
  <#else>
  	<input type="hidden" name="dictDefId" value=""/>
  </#if> 
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">主题名称:
                <input type="text" name="search" value="${search}">
                <a class="btn btn_cc1" id="search_button">查询</a>
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
            <tr>
            <th>选择</th>
        	<th>主题名称</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDict> 
			<tr>
			<td>
				<input type="radio" name="dictId" value="${bizDict.dictId!''}">
				<input type="hidden" name="dictName" value="${bizDict.dictName!''}">
			 </td>
			<td>${bizDict.dictName!''}</td>
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
	$("#searchForm").submit();
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var bizDict = {};
	bizDict.dictId = $("input[name='dictId']",obj).val();
    bizDict.dictName = $("input[name='dictName']",obj).val();
	parent.onSelectHotel(bizDict);
});

</script>


