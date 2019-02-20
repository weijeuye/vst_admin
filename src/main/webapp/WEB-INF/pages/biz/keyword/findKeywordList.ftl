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
        <li><a href="#">关键词管理</a> &gt;</li>
        <li class="active">关键词列表</li>
    </ul>
</div>

<div class="iframe_search">
	<form method="post" action='/vst_admin/biz/keyword/findKeywordList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">关键词：</td>
                <td class="w18"><input type="text" name="keywordName" value="${keywordName!''}"></td>
                <td class="s_label">行政区名称：</td>
                <td class="w18"><input type="text" name="districtName" value="${districtName!''}"></td>
                <td class="s_label">关键词状态：</td>
                <td class="w18">
                	<select name="cancelFlag">
                		<option value="">请选择</option>
                		<option value="Y" <#if cancelFlag=='Y'> selected="selected"</#if>>有效</option>
                		<option value="N" <#if cancelFlag=='N'> selected="selected"</#if>>无效</option>
                	</select>
                </td>
            </tr>
            <tr>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="new_button">新增</a></td>
                <input type="hidden" name="page" value="${page}">
            </tr>
        </tbody>
    </table>	
	</form>
</div>
	
<!-- 主要内容显示区域\\ -->
<div class="iframe_content">   
    <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
        	<th>编号</th>
            <th>关键词</th>
            <th>行政区编号</th>
            <th>关联行政区</th>
            <th>状态</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizKeyword> 
			<tr>
			<td>${bizKeyword.keywordId!''} </td>
			<td>&nbsp;&nbsp;${bizKeyword.keywordName!''} </td>
			<td>&nbsp;&nbsp;${bizKeyword.districtId!''} </td>
			<td>${bizKeyword.districtName!''} </td>
			<td>
				<#if bizKeyword.cancelFlag == 'Y'>
					<span style="color:green" class="cancelProp">有效</span>
				<#else>
					<span style="color:red" class="cancelProp">无效</span>
				</#if> 
			</td>
			<td class="oper">
                    <a class="editCate" href="javascript:void(0);" data="${bizKeyword.keywordId!''}" >编辑</a>
                    <a href="javascript:void(0);"  class="editKeywordFlag" data="${bizKeyword.keywordId!''}" data2="${bizKeyword.cancelFlag}">${(bizKeyword.cancelFlag=='N')?string("设为有效", "设为无效")}</a>					
                    <a class="showLogDialog" href="javascript:void(0);" param='objectId=${bizKeyword.keywordId!''}&objectType=BIZ_KEYWORD_EDIT&sysName=VST'>操作日志</a>
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
var keywordPropListDialog,keywordPropGroupsDialog,branchListDialog;
$(function(){

$("searchForm input[name='keywordName']").focus();
	$("#search_button").bind("click",function(){
		$("#searchForm").submit();
});
	
//新增品类
$("#new_button").bind("click",function(){
   dialog("/vst_admin/biz/keyword/showAddKeyword.do", "新增关键词", 800,"auto",function(){
		if(!$("#dataForm").validate().form()){
			return false;
		}
		var resultCode; 
		$.ajax({
				url : "/vst_admin/biz/keyword/addKeyword.do",
				type : "post",
				async: false,
				data : $(".dialog #dataForm").serialize(),
				dataType:'JSON',
				success : function(result) {
				    resultCode=result.code;
					confirmAndRefresh(result);
				}
			});
		},"保存");
});

//编辑基本属性
$("a.editCate").bind("click",function(){
    var keywordId=$(this).attr("data");
    var url = "/vst_admin/biz/keyword/showAddKeyword.do?keywordId="+keywordId;
	dialog(url, "编辑基本属性", 800, "auto",function(){
	    if(!$("#dataForm").validate().form()){
			return false;
		}
	    var resultCode; 
	    $.confirm("确认修改吗 ？", function () {
		$.ajax({
			url : "/vst_admin/biz/keyword/updateKeyword.do",
			type : "post",
			async: false,
			data : $(".dialog #dataForm").serialize(),
			dataType:'JSON',
			success : function(result) {
			    resultCode=result.code;
				confirmAndRefresh(result);
			}
		});
	},"保存");
	return false;
	});
});


$("a.editKeywordFlag").bind("click",function(){
	 var keywordId=$(this).attr("data");
	 var cancelFlag=$(this).attr("data2") == "N" ? "Y": "N";
	 var url = "/vst_admin/biz/keyword/editFlag.do?keywordId="+keywordId+"&cancelFlag="+cancelFlag+"&newDate="+new Date();
	 msg = cancelFlag === "N" ? "确认设为无效  ？" : "确认设为有效  ？";
	 $.confirm(msg, function () {
		 $.get(url, function(result){
	         confirmAndRefresh(result);
	     });
     });
	 return false;
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

