<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content">   
<div class="p_box">
<form method="post" action='/vst_admin/front/channelAreaFrom/findChanleAreaFromList.do' id="searchForm">
    <table class="s_table">
        <tbody>
                <tr>
                <td class="s_label">频道：</td>
                <td class="w13"><input type="text" name="channelPage" value="${(channelAreaFrom.channelPage)!''}"></td>
                <td class="s_label">站点：</td>
                <td class="w13"><input type="text" name="channelArea.areaName" value="${(channelAreaFrom.channelArea.areaName)!''}"></td>
                <td class="s_label">出发地：</td>
                <td class="w13"><input type="text" name="fromPlace.placeName" value="${(channelAreaFrom.fromPlace.placeName)!''}"></td>
                <td class="s_label">父级出发地：</td>
                <td class="w13"><input type="text" name="parentFromPlace.placeName" value="${(channelAreaFrom.parentFromPlace.placeName)!''}"></td>
                </tr>
                <tr>
                <td class="s_label">焦点图配置：</td>
                <td class="w13"><input type="text" name="focusPlaceCode" value="${(channelAreaFrom.focusPlaceCode)!''}"></td>
                <td class="s_label">有效状态：</td>
                <td class="w13">
                <select name="valid">
                <option value="">全部</option>
                <option <#if channelAreaFrom.valid == "Y">selected="selected"</#if> value="Y">有效</option>
                <option <#if channelAreaFrom.valid == "N">selected="selected"</#if> value="N">无效</option>
                </select>
                </td>
                 <td class=" operate mt10">&nbsp;&nbsp;&nbsp;</td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                 <input type="hidden" name="page" value="${page}">
                <td class=" operate mt10">&nbsp;&nbsp;&nbsp;</td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="add_button">新增</a></td>
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
        	<th>编号</th>
            <th>频道</th>
            <th>站点</th>
            <th>出发地</th>
            <th>父级出发地</th>
            <th>焦点图配置</th>
            <th>有效状态</th>
            <th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as channelAreaFrom> 
			<tr>
				<td>${(channelAreaFrom.configId)!''} </td>
				<td>${(channelAreaFrom.channelPage)!''} </td>
				<td>${(channelAreaFrom.channelArea.areaName)!''} </td>
				<td>${(channelAreaFrom.fromPlace.placeName)!''} </td>
				<td>${(channelAreaFrom.parentFromPlace.placeName)!''} </td>
				<td>${(channelAreaFrom.focusPlaceCode)!''}</td>
				<td>
					<#if channelAreaFrom.valid == "Y"> 
						<span style="color:green" class="cancelProp">有效</span>
					<#elseif channelAreaFrom.valid == "N">
						<span style="color:red" class="cancelProp">无效</span>
				    <#else>
				        <span style="color:red" class="cancelProp"></span>
					</#if>
				</td>
				<td class="oper">
	                <a href="javascript:void(0);" class="editChannelAreaFrom" data="${(channelAreaFrom.configId)!''}">设置</a>
	                <a href="javascript:void(0);" class="showLogDialog" param='parentId=${channelAreaFrom.configId}&parentType=CHANNEL_FROM&sysName=VST'>操作日志</a>
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
//新增频道区域出发地配置
$("#add_button").on("click", function() {
    var url = "/vst_admin/front/channelAreaFrom/showAddChannelAreaFrom.do";
    addAndUpdateDialog = new xDialog(url, {}, {
        title: "新增频道站点配置",
        width: 900,
        height: 800
    });
});

//查询道区域出发地配置列表
$("#search_button").on("click", function() {
       trimInput();
    if (!$("#searchForm").validate().form()) {
        return;
    }
    $("#searchForm").submit();
});

//编辑频道区域出发地配置
$("a.editChannelAreaFrom").bind("click", function() {
    var configId = $(this).attr("data");
    var url = "/vst_admin/front/channelAreaFrom/showUpdateChannelAreaFrom.do?configId=" + configId;
    addAndUpdateDialog = new xDialog(url, {}, {
        title: "编辑频道站点配置",
        width: 900,
        height: 800
    });

});
//去除前后空格
function trimInput() {
    $("input[type=text]").each(function() {
        var $this = $(this);
        $this.val($.trim($this.val()));
    });
}

</script>