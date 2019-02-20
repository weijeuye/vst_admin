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
        <li><a href="#">排序影响配置</a> &gt;</li>
        <li class="active">季节性影响排序设置</li>
    </ul>
</div>

<div class="iframe_search">
	<form method="post" action='/vst_admin/biz/seasoneffect/findSeasonEffectList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">所属品类：</td>
                <td class="w18">
                	<select name="seasonEffectType">
                		<option value="">不限</option>
                		<#list seasonEffectTypeList as seasonEffectTypeObj>
	                		<#if seasonEffect.seasonEffectType == seasonEffectTypeObj.code>
	                			<option value="${seasonEffectTypeObj.code!''}" selected="selected">${seasonEffectTypeObj.cnName!''}</option>
	                		<#else>
	                			<option value="${seasonEffectTypeObj.code!''}">${seasonEffectTypeObj.cnName!''}</option>
	                		</#if>
                		</#list>
                	</select>
                </td>
                <td class="s_label">季节ID：</td>
                <td class="w18">
                	<div class="col w170">
                	<div class="form-group">
                        <label>
                			<input class="form-control w90" type="text" name="seasonId" value="${seasonEffect.seasonId!''}" number="true" maxLength="11">
                		</label>
                    </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="s_label">季节名称：</td>
                <td class="w18"><input type="text" name="seasonName" value="${seasonEffect.seasonName!''}"></td>
                <td class="s_label">有效性：
                	<select name="effectStatus">
                		<option value="">不限</option>
                		<option value="1" <#if seasonEffect.effectStatus == 1>selected="selected"</#if>>有效</option>
                		<option value="0" <#if seasonEffect.effectStatus == 0>selected="selected"</#if>>无效</option>
                	</select>
                </td>
            </tr>
            <tr>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10">&nbsp;&nbsp;&nbsp;&nbsp;</td>                
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
        	<th>季节ID</th>
            <th>季节名称</th>
            <th>所属品类</th>
            <th>有效状态</th>
			<th>有效时间</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as seasonEffect> 
			<tr>
				<td>${seasonEffect.seasonId!''} </td>
				<td>&nbsp;&nbsp;${seasonEffect.seasonName!''} </td>
				<td>&nbsp;&nbsp;
					<#if seasonEffect.bizCategory ??>${seasonEffect.bizCategory.categoryName!''}</#if><#if seasonEffect.subCategory ??>-${seasonEffect.subCategory.categoryName!''}</#if>
				<td>
					<#if seasonEffect.effectStatus == '1'>
						<span style="color:green" class="cancelProp">有效</span>
					<#else>
						<span style="color:red" class="cancelProp">无效</span>
					</#if> 
				</td>
				
				<td>&nbsp;&nbsp;
					<#if seasonEffect.effectBeginDate??>${seasonEffect.effectBeginDate?string("yyyy.MM.dd")}</#if> - 
					<#if seasonEffect.effectEndDate??>${seasonEffect.effectEndDate?string("yyyy.MM.dd")}</#if>
				</td>
				<td class="oper">
	                    <a class="editSeasonEffect" href="javascript:void(0);" data="${seasonEffect.seasonId!''}" >修改</a>
	                    <a class="showLogDialog" href="javascript:void(0);"  param='objectId=${seasonEffect.seasonId!''}&objectType=SEASON_EFFECT_PORATE&sysName=VST'>操作日志</a>
	                    <a class="deleteSeasonEffect" href="javascript:void(0);" data="${seasonEffect.seasonId!''}">删除</a>
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
	
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
var seasonDialog;
$("input[name='seasonId']").keyup(function(){     
        var tmptxt=$(this).val();     
        $(this).val(tmptxt.replace(/\D|^0/g,''));     
    }).bind("paste",function(){     
        var tmptxt=$(this).val();     
        $(this).val(tmptxt.replace(/\D|^0/g,''));     
    }).css("ime-mode", "disabled");   
    
$(function(){

	$("searchForm input[name='categoryName']").focus();
		$("#search_button").bind("click",function(){
			$("#searchForm").submit();
	});
		
	//新增季节
	$("#new_button").bind("click",function(){
	    var url = "/vst_admin/biz/seasoneffect/showAddSeason.do";
	    seasonDialog = new xDialog(url,{},{title:"新增季节",width:"800",height:"800"});
	});
	
	//修改季节
	$("a.editSeasonEffect").bind("click",function(){
	    var seasonId=$(this).attr("data");
	    var editUrl = "/vst_admin/biz/seasoneffect/showAddSeason.do?seasonId="+seasonId;
	    seasonDialog = new xDialog(editUrl,{},{title:"修改季节",width:"800",height:"800"});
	});
	
	//删除
	$("a.deleteSeasonEffect").bind("click",function(){
	   var seasonId=$(this).attr("data");
	   $.confirm("您确定要删除吗？", function (){		
	        $.ajax({
				url : "/vst_admin/biz/seasoneffect/deleteSeasonEffect.do",
				type : "Post",
				data : {"seasonId":seasonId},
				dataType:'JSON',			
				success : function(result) {
					 if(result.code=="success"){
					 	$.alert("删除成功！",function(){
			   				window.location.reload();
			   			});
				     } else {
				     	$.alert(result.message);
				     }
				}
		    });
	   })
	});
});  // end $(function()

function refreshDialog(){
	seasonDialog.close();
	$("#searchForm").submit();
}

function closeDialog(){
	seasonDialog.close();
}

</script>

