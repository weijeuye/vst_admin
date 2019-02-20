<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/front/channelFromPlace/findChannelFromPlaceList.do' id="searchForm">

    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">出发地编码:
                    <input type="text" name="placeCode" value="${(channelFromPlace.placeCode)!''}">
                </td>
                <td class="s_label">出发地名称:
                    <input type="text" name="placeName" value="${(channelFromPlace.placeName)!''}">
                </td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="search_button">查询</a></td>
                <td class=" operate mt10"><a class="btn btn_cc1" id="addButton">新增</a></td>
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
	            <th>出发地ID</th>
	            <th>出发地编码</th>
	        	<th>出发地名称</th>
	        	<th>操作</th>
            </tr>
        </thead>
        <tbody>
			<#list pageParam.items as channelFromPlace>
			<tr>
			<td>
				${(channelFromPlace.placeId)!''}
			</td>
			<td>
				${(channelFromPlace.placeCode)!''}
			</td>
			<td>
			    ${(channelFromPlace.placeName)!''}
            </td>
            <td class="oper">
	           <a href="javascript:void(0);" class="editChannelFromPlace" data="${(channelFromPlace.placeId)!''}">编辑</a>
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

//查询
$("#search_button").unbind("click");
$("#search_button").bind("click", function() {
     trimInput();
	$("#searchForm").submit();
});

var addAndUpdateFromPlaceDialog;
$("#addButton").on('click', function() {
  var url="/vst_admin/front/channelFromPlace/showAddChannelFromPlace.do";
   addAndUpdateFromPlaceDialog = new xDialog(url, {}, {
        title: "新增出发地",
        width: 900,
        height: 500
    });
});
$("a.editChannelFromPlace").on('click', function() {
     var id=$(this).attr("data");
    var url="/vst_admin/front/channelFromPlace/showUpdateChannelFromPlace.do?placeId="+id;
   addAndUpdateFromPlaceDialog = new xDialog(url, {}, {
        title: "编辑出发地",
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


