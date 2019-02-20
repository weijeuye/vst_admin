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
	            <li><a href="#">目的地管理</a> &gt;</li>
	            <li class="active">目的地列表</li>
	        </ul>
	</div>
</#if>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/biz/dest/findDestList.do' id="searchForm">
	<input type="hidden" id="dictId" value="${dictId!''}" name="dictId" />
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
                <td class="s_label">目的地状态：</td>
                <td class="w18">
                <input type="checkbox" name="cancelFlags" value="Y" >有效
                <input type="checkbox" name="cancelFlags" value="N" >无效
                <input type="hidden" id="cancelFlag" name="cancelFlag" value="${cancelFlag!''}">
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <#if dictId == ''>
                	<td class=" operate mt10"><a class="btn btn_cc1" id="new_button">新增</a></td>
                </#if>
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
            <#if dictId??>
            	<th>选择</th>
            </#if>
        	<th>目的地编号</th>
            <th>目的地名称</th>
            <th>目的地类型</th>
            <th>所属行政关系</th>
            <th>父级目的地关系</th>
            <th>目的地状态</th>
            <#if dictId == ''>
            	<th>操作</th>
            </#if>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as bizDest> 
			<tr>
				<#if dictId??>
					<td>
						<input type="radio" name="destId" value="${bizDest.destId!''}">
						<input type="hidden" name="destName" value="${bizDest.destName!''}">
					</td>
				</#if>
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
				<#if dictId == ''>
					<td class="oper">
		                <a href="javascript:void(0);" class="editProp" data=${bizDest.destId}>编辑</a>
		                <a href="/vst_admin/pub/comCoordinate/modifyCoordinate.do?objectId=${bizDest.destId!''}&objectType=BIZ_DEST&coordType=BAIDU&searchKey=${bizDest.destName!''} ${bizDest.districtName!''}">设置百度经纬度</a>
	                    <a href="/vst_admin/pub/comCoordinate/modifyCoordinate.do?objectId=${bizDest.destId!''}&objectType=BIZ_DEST&coordType=GOOGLE&searchKey=${bizDest.destName!''} ${bizDest.districtName!''}">设置谷歌经纬度</a>
		                <#if bizDest.cancelFlag == "Y"> 
		                	 <a href="javascript:void(0);" class="cancelProp" data="N" destid=${bizDest.destId}>设为无效</a>
		                <#else>
		               		 <a href="javascript:void(0);" class="cancelProp" data="Y" destid=${bizDest.destId}>设为有效</a>
		                </#if>
		                <a href="javascript:void(0);" class="editDestSearch" data=${bizDest.destId}>搜索专用</a>
						<#if bizDest.destType = "HOTEL">
                            <a href="javascript:void(0);" class="showLogDialog" param='objectId=${bizDest.destId}&objectType=BIZ_DEST_HOTEL&sysName=VST'>操作日志</a>
						</#if>
		              </td>
	              </#if>
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
var addDialog,updateDialog, editDestSearchDialog;
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

//新建
$("#new_button").bind("click",function(){
	var url = "/vst_admin/biz/dest/showAddDest.do";
	addDialog = new xDialog(url, {}, {title:"新增目的地",height:"550",width:800});
});

//修改
$("a.editProp").bind("click",function(){
	var destId = $(this).attr("data");
	var url = "/vst_admin/biz/dest/showUpdateDest.do";
	updateDialog = new xDialog(url,{"destId":destId}, {title:"编辑目的地",height:"550",width:800});
});

//搜索专用维护
$("a.editDestSearch").bind("click",function(){
	var destId = $(this).attr("data");
	var url = "/vst_admin/biz/dest/showManageDestSearch.do";
	editDestSearchDialog = new xDialog(url,{"destId":destId}, {title:"目的地搜索关键字",height:"550",width:800});
});

//设置为有效或无效
$("a.cancelProp").bind("click",function(){
	var entity = $(this);
	var cancelFlag = entity.attr("data");
	var destId = entity.attr("destId");
	msg = cancelFlag === "N" ? "确认设为无效  ？" : "确认设为有效  ？";
 	$.confirm(msg, function () {	
	$.ajax({
		url : "/vst_admin/biz/dest/modiDestFlag.do",
		type : "post",
		data : {"cancelFlag":cancelFlag,"destId":destId},
		success : function(result) {
			if (result.code == "success") {
				pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
					if(cancelFlag == 'N'){
						entity.attr("data","Y");
						entity.text("设为有效");
						$("span.cancelProp",entity.parents("tr")).css("color","red").text("无效");
					}else if(cancelFlag == 'Y'){
						entity.attr("data","N");
						entity.text("设为无效");
						$("span.cancelProp",entity.parents("tr")).css("color","green").text("有效");
					}
				}});
			}else {
				pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				}});
			}		
		}
	});
	});
});

$("input[type='radio']").bind("click",function(){
	var obj = $(this).parent("td");
	var dest = {};
	dest.dictId = $("#dictId").val();
	dest.destId = $("input[name='destId']",obj).val();
    dest.destName = $("input[name='destName']",obj).val();
	parent.onSelectDest(dest);
});

</script>