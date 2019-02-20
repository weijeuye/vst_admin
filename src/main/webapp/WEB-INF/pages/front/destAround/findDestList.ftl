<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/front/destAround/findDestLists.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">目的地名称：</td>
                <td class="w18"><input type="text" name="destName" value="${destName!''}"></td>
                <td class="s_label">目的地ID：</td>
                <td class="w18"><input type="text" name="destId" value="${destId!''}" digits=true></td>
                <td class="s_label">目的地类型：</td>
                <td class="w18">
                	<select name="destType">
                	<option value="">不限</option>
                    	<#list destTypeList as distTypeItem>
                    		<#if destType == distTypeItem.code>
                    		<option value="${distTypeItem.code!''}" selected="selected">${distTypeItem.cnName!''}</option>
                    		<#else>
                    		<option value="${distTypeItem.code!''}">${distTypeItem.cnName!''}</option>
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
                <select name="hasSetAroundDest">
                <option value="">全部</option>
                <option <#if hasSetAroundDest == "Y">selected="selected"</#if> value="Y">显示配置第二出发地</option>
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
        	<th>目的地编号</th>
            <th>目的地名称</th>
            <th>目的地类型</th>
            <th>所属行政关系</th>
            <th>父级目的地关系</th>
            <th>目的地状态</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDest> 
			<tr>
				<td>${bizDest.destId!''} </td>
				<td>${bizDest.destName!''} </td>
				<td>${bizDest.destTypeCnName!''} </td>
				<td>${bizDest.districtName!''} </td>
				<td><#if bizDest.parentDest ??>${bizDest.parentDest.destName!''}</#if></td>
				<td>
					<#if bizDest.cancelFlag == "Y"> 
						<span style="color:green" class="cancelProp">有效</span>
					<#elseif bizDest.cancelFlag == "N">
						<span style="color:red" class="cancelProp">无效</span>
				    <#else>
				        <span style="color:red" class="cancelProp"></span>
					</#if>
				</td>
				<td class="oper">
	                <a href="javascript:void(0);" class="editDestAround" data1=${bizDest.destId} data2=${bizDest.destName}>设置</a>
	                <a href="javascript:void(0);" class="showLogDialog" param='parentId=${bizDest.destId}&parentType=BIZ_DEST&sysName=VST'>操作日志</a>
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
var addAndUpdateDialog;
var cancelflag = '${cancelFlag}';

$('input[name="cancelFlags"]').each(function(){  
     if(cancelflag == 'nonull'){
        $(this).attr("checked",true);
     }else if($(this).val() == cancelflag){
        $(this).attr("checked",true);
     }
});

function checkCancel(){
   var oo = $('input[name="cancelFlags"]:checked');
     if(oo.size()==0)
     {
        $("#cancelFlag").val("all");
     }else if(oo.size()==1){
        $("#cancelFlag").val(oo.val());
     }else{
        $("#cancelFlag").val("nonull");
     }
}

//查询
$("#search_button").bind("click",function(){
	if(!$("#searchForm").validate().form()){
		return;
	}
	checkCancel();
	$("#searchForm").submit();
	
});
 
//编辑第2目的地
$("a.editDestAround").bind("click",function(){
	var destId = $(this).attr("data1");
	var destName = $(this).attr("data2");
	var url = "/vst_admin/front/destAround/showAddAndUpdateDestAround.do?destId="+destId;
	addAndUpdateDialog = new xDialog(url,{},{title:"编辑"+destName+":第2出发地",width:900,height:500});
	
});

</script>