<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/front/channelArea/findChanleAreaList.do' id="searchForm">
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">站点编码:
                    <input type="text" name="areaCode" value="${(channelArea.areaCode)!''}">
                </td>
                <td class="s_label">站点名称:
                    <input type="text" name="areaName" value="${(channelArea.areaName)!''}">
                </td>
                <td class="s_label">站点类型:
	                <select name="areaType">
	                   	<option value="">全部</option>
				    	<#list areaTypeList as areaType> 
				           <option value="${(areaType.code)!''}" <#if  (channelArea.areaType)?? && areaType.code == channelArea.areaType>selected</#if>>${(areaType.cnName)!''}</option>
					    </#list>
				    </select>
                </td>
                <td class="operate mt10">
                    <a class="btn btn_cc1" id="search_button">查询</a>
                </td>
                <td class="operate mt10"><a class="btn btn_cc1" id="addButton">新增</a></td>
            </tr>
        </tbody>
    </table>	
	</form>
</div>
<div align="right">
	 <
</div>	
<!-- 主要内容显示区域 -->
<div class="iframe-content">   
   <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
	            <th>站点编码</th>
	            <th>站点类型</th>
	        	<th>站点名称</th>
	        	<th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as channelArea>
			<tr>
			<td>
				${(channelArea.areaCode)!''}
			</td>
			<td>
				 <#list areaTypeList as areaType>
					<#if areaType.code == channelArea.areaType>
					   ${areaType.cnName!''}
					</#if>
				</#list>
			</td>
			<td>
			    ${(channelArea.areaName)!''}
            </td>
            <td class="oper">
	           <a href="javascript:void(0);" class="editChannelArea" data="${(channelArea.areaCode)!''}">编辑</a>
	        </td>
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
var addAndUpdateChannelAreaDialog;
//查询
$("#search_button").unbind("click");
$("#search_button").bind("click", function() {
     trimInput();
	$("#searchForm").submit();
});

var addAndUpdateFromPlaceDialog = null;
$("#addButton").on('click', function() {
  var url="/vst_admin/front/channelArea/showAddChannelArea.do";
   addAndUpdateChannelAreaDialog = new xDialog(url, {}, {
        title: "新增频道站点",
        width: 900,
        height: 500
    });
});
$("a.editChannelArea").on('click', function() {
     var areaCode=$(this).attr("data");
    var url="/vst_admin/front/channelArea/showUpdateChannelArea.do?areaCode="+areaCode;
   addAndUpdateChannelAreaDialog = new xDialog(url, {}, {
        title: "编辑频道站点",
        width: 900,
        height: 500
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


