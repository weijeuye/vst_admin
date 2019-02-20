<!DOCTYPE html>
<html>
<#include "/base/head_meta.ftl"/>
<body>
	<div class="iframe_search">		
		<form id="searchForm" method="post" action='/vst_admin/superfreetour/hotPlaceManage/findHotPlaceInfoList.do'>
            <input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
            <input type="hidden" name="page" value="${page}">
	        <table class="s_table">
	            <tbody>
					<tr>
	                 	<td class="s_label">目的地名称：</td>
	                    <td class="w18">
	                    	<input  type="text" id="destName" name="destName"  value="${hotPlaceInfo.destName}"/>
	                    </td>
	                 	<td class="s_label">行政区：</td>
	                    <td class="w18">
	                    	<input id="districtName" type="text" name="districtName"  value="${hotPlaceInfo.districtName}" />
	                    </td>
	                </tr>
					<tr>
	                	<td class="s_label">目的地类型：</td>
	                    <td class="w18">
	                    	<select name="destType" id="destType">
	                    		<option value="">请选择</option>
								<#list hotDestTypeList as destTypeItem>
								<#if destType == destTypeItem.code>
								<option value="${destTypeItem.code!''}" selected="selected">${destTypeItem.cnName!''}</option>
								<#else>
								<option value="${destTypeItem.code!''}">${destTypeItem.cnName!''}</option>
								</#if>
								</#list>
	                    	</select>
	                    </td>

	                	<td class="s_label">状态：</td>
	                    <td class="w18">
                            <select name="cancleFlag" id="cancleFlag">
                                <option value="">请选择</option>
                                <option value="Y" <#if (hotPlaceInfo?? && hotPlaceInfo.cancleFlag == "Y")>selected="selected"</#if>>有效</option>
                                <option value="N" <#if (hotPlaceInfo?? && hotPlaceInfo.cancleFlag == "N")>selected="selected"</#if>>无效</option>
                            </select>
	                    </td>
	                    <td class="operate mt10">
		                   	&nbsp;<a class="btn btn_cc1" id="search_button">查询</a> 
	                    </td>
						<td class="operate mt10">
		                   	&nbsp;<a class="btn btn_cc1" id="insert_button">新增</a>
	                    </td>
	                </tr>	            
	                              
	            </tbody>
	        </table>	
		</form>
		<#if pageParam??>
	    	<#if pageParam.items?? &&  pageParam.items?size &gt; 0>
				<!-- 主要内容显示区域\\ -->
				<div class="iframe-content">
				    <div class="p_box">
					    <table class="p_table table_center" style="margin-top: 10px;">
		                    <tr>
									<th width="30">序号</th>
				                    <th width="60">目的地名称</th>
				                    <th width="60">目的地类型</th>
				                    <th width="60">行政区</th>
				                    <th width="60">热度</th>
				                    <th width="60">状态</th>
				                    <th width="60">别名</th>
				                    <th width="60">操作</th>
		                    </tr>
							<#list pageParam.items as item> 
								<tr>
									<td>${item.hotPlaceId}</td>
									<td>${item.destName}</td>
									<td>${item.destType}</td>
									<td>${item.districtName}</td>
									<td>${item.hotNum}</td>
									<td>
										<#if item.cancleFlag == "Y">
                                            <span class="text-danger" data-tag="validFlagSpan" data-id="${item.hotPlaceId}">有效</span>
										<#else>
											<span class="text-danger" data-tag="validFlagSpan" data-id="${item.hotPlaceId}">无效</span>
										</#if>
									</td>
									<td>${item.hotPlaceAlias}</td>
									<td>
										<a href="javascript:void(0);" data-tag="edit_hotplace" data-id="${item.hotPlaceId}">编辑</a>
										<#if item.cancleFlag == "Y">
											<a href="javascript:void(0);" data-tag="set_flag" data-action="N" data-id="${item.hotPlaceId}">设为无效</a>
										<#else>
											<a href="javascript:void(0);" data-tag="set_flag" data-action="Y" data-id="${item.hotPlaceId}">设为有效</a>

										</#if>
									</td>
								</tr>
							</#list>
       				 	</table>
				    </div><!-- div p_box -->
				</div>
				<!-- //主要内容显示区域 -->
				<#if pageParam.items?exists> 
					<div class="paging" > 
						${pageParam.getPagination()}
					</div> 
				</#if>
			<#else>
				<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关热门目的地信息，重新输入相关条件查询！</div>
			</#if>
		</#if>		
    </div>
	<#include "/base/foot.ftl"/>
</body>
</html>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>
<script>
$(function(){

});

	
// 查询
$('#search_button').bind('click',function(){
	$("#searchForm").submit();
});

// 新增
var docEditDialog;
$('#insert_button').bind('click',function(){
    var url = "/vst_admin/superfreetour/hotPlaceManage/editHotPlaceManagePage.do";
    docEditDialog = new xDialog(url,{},{title:"新增热门目的地",iframe:true,width:"1100",height:"650"});
});


//编辑
$("a[data-tag='edit_hotplace']").click(function(){
    var url = "/vst_admin/superfreetour/hotPlaceManage/editHotPlaceManagePage.do?hotPlaceId="+$(this).attr("data-id");
    docEditDialog = new xDialog(url,{},{title:"编辑热门目的地",iframe:true,width:"1000",height:"1000"});
});

//设为有效/无效
$("a[data-tag='set_flag']").click(function(){
    loading = pandora.loading("正在努力保存中...");
    var theClick = $(this);
    var theSpan =$("span[data-tag='validFlagSpan'][data-id='"+$(this).attr("data-id")+"']");
    $.ajax({
        url : "/vst_admin/superfreetour/hotPlaceManage/changeHotPlaceCancleFlag.do",
        type : "post",
        dataType : 'json',
        data :{
            hotPlaceId:$(this).attr("data-id"),
            cancleFlag:$(this).attr("data-action")
        },
        success : function(result) {
            loading.close();
            if(result.code == "success"){
                if(theClick.attr("data-action")=="Y"){
                    theClick.attr("data-action","N");
                    theClick.text("设为无效");
                    theSpan.text("有效");
                    theSpan.removeClass("text-danger");
                    theSpan.addClass("text-success");
                }else{
                    theClick.attr("data-action","Y");
                    theClick.text("设为有效");
                    theSpan.text("无效");
                    theSpan.removeClass("text-success");
                    theSpan.addClass("text-danger");
                }
                pandora.dialog({wrapClass: "dialog-mini", content:result.message, mask:true,okValue:"确定",ok:function(){
                    }});
            }else {
                $.alert(result.message);
            }
        },
        error : function(){
            loading.close();
        }
    });
});

function confirmAndRefresh(result){
    if (result.code == "success") {
        pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                $("#searchForm").submit();
            }});
    }else {
        pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
            }});
    }

}



</script>