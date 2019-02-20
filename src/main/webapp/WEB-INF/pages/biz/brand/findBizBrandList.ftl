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
	            <li><a href="#">品牌管理</a> &gt;</li>
	            <li class="active">品牌列表</li>
	        </ul>
	</div>
</#if>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/biz/bizBrand/findBizBrandList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">品牌名称：</td>
                <td class="w18"><input type="text" name="brandName" value="${brandName!''}"></td>
                <td class="s_label">品牌ID：</td>
                <td class="w18"><input type="text" name="brandId" value="${bizBrand.brandId!''}" digits=true number="true" maxLength="11"></td>
                <td class="s_label">品牌状态：</td>
                <td class="w18">
                	<select name="cancelFlag" >
		                <option value="" <#if cancelFlag == ''>selected="selected"</#if> >全部</option>
		                <option value="Y" <#if cancelFlag == 'Y'>selected="selected"</#if> >有效</option>
		                <option value="N" <#if cancelFlag == 'N'>selected="selected"</#if> >无效</option>
	                </select>
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
            	<td class=" operate mt10"><a class="btn btn_cc1" id="new_button">新增品牌</a></td>
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
        	<th>品牌ID</th>
            <th>品牌名称</th>
            <th>全称</th>
            <th>简称</th>
            <th>状态</th>
            <th>所属集团</th>
            <th>排序级别</th>
        	<th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizBrand> 
			<tr>
				<td>${bizBrand.brandId!''} </td>
				<td>${bizBrand.brandName!''} </td>
				<td>${bizBrand.brandFullName!''} </td>
				<td>${bizBrand.brandShortName!''} </td>
				<td>
					<#if bizBrand.cancelFlag == "Y"> 
						<span style="color:green" class="cancelProp">有效</span>
					<#elseif bizBrand.cancelFlag == "N">
						<span style="color:red" class="cancelProp">无效</span>
				    <#else>
				        <span style="color:red" class="cancelProp"></span>
					</#if>
				</td>
				<td>${bizBrand.groupName!''} </td>
				<td>${bizBrand.brandSeq!''} </td>
				<td class="oper">
	                <a href="javascript:void(0);" class="editProp" data=${bizBrand.brandId}>编辑</a>
	                <#if bizBrand.cancelFlag == "Y"> 
	                	 <a href="javascript:void(0);" class="editBrandFlag" data2="${bizBrand.cancelFlag!''}" data=${bizBrand.brandId}>设为无效</a>
	                <#else>
	               		 <a href="javascript:void(0);" class="editBrandFlag" data2="${bizBrand.cancelFlag!''}" data=${bizBrand.brandId}>设为有效</a>
	                </#if>
					<a href="javascript:void(0);" class="showLogDialog" param='objectId=${bizBrand.brandId}&objectType=BIZ_BRAND_EDIT&sysName=VST'>操作日志</a>
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
$(function(){
	var addDialog,updateDialog, editBrandSearchDialog;
	
	$("searchForm input[name='brandName']").focus();
	$("#search_button").bind("click",function(){
		if(!$("#searchForm").validate().form()){
			return false;
		}
		$("#searchForm").submit();
	});
	//新增品类
	$("#new_button").bind("click",function(){
		dialog("/vst_admin/biz/bizBrand/showUpdateBizBrand.do", "新增品牌", 800,"auto",function(){
			//验证
			
			if(!$("#dataForm").validate().form()){
				return false;
			}
			var resultCode; 
			$.ajax({
					url : "/vst_admin/biz/bizBrand/addBrand.do",
					type : "post",
					async: false,
					data : $(".dialog #dataForm").serialize(),
					dataType:'JSON',
					success : function(result) {
				         confirmAndRefresh(result);
					}
				});
			}, "保存");
	});
	
	//编辑基本属性
	$("a.editProp").bind("click",function(){
	    var brandId=$(this).attr("data");
	    var url = "/vst_admin/biz/bizBrand/showUpdateBizBrand.do?brandId="+brandId;
		dialog(url, "编辑基本属性", 800, "auto",function(){
			//验证
			
		    if(!$("#dataForm").validate().form()){
				return false;
			}
		    var resultCode; 
		    $.confirm("确认修改吗 ？", function () {
			$.ajax({
				url : "/vst_admin/biz/bizBrand/updateBrand.do",
				type : "post",
				async: false,
				data : $(".dialog #dataForm").serialize(),
				dataType:'JSON',
					success : function(result) {
			         confirmAndRefresh(result);
					}
				});
			},"保存");
			return false;
		});
	});
	
	
	$("a.editBrandFlag").bind("click",function(){
		 var bizBrandId=$(this).attr("data");
		 var cancelFlag=$(this).attr("data2") == "N" ? "Y": "N";
		 var url = "/vst_admin/biz/bizBrand/editFlag.do?bizBrandId="+bizBrandId+"&cancelFlag="+cancelFlag+"&newDate="+new Date();
		 msg = cancelFlag == "N" ? "确认设为无效  ？" : "确认设为有效  ？";
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