<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_search">
<form method="post" action='/vst_admin/front/channelFromPlace/findChannelFromPlaceList.do' id="searchForm">
	<input type="hidden" value="${parent!''}" name="parent" />
	<input type="hidden" value="select" name="queryType" />
    <table class="s_table">
        <tbody>
            <tr>
                <td class="s_label">出发地编码:
                    <input type="text"  class="w10" name="placeCode" value="${(channelFromPlace.placeCode)!''}">
                </td>
                <td class="s_label">出发地名称:
                    <input type="text"  class="w10" name="placeName" value="${(channelFromPlace.placeName)!''}">
	                
                </td>
                <td class="operate mt10">
                	<a class="btn btn_cc1" id="search_button">查询</a>
                </td>
            </tr>
            <tr>
              <td class="operate mt10">
            	<a  class="btn btn_cc1" id="make_sure">确定</a>
	            <a  class="btn btn_cc1" id="cancel" >取消</a>
	          </td>
            </tr>
        </tbody>
    </table>	
	</form>
</div>
<!-- 主要内容显示区域 -->
<div class="iframe-content">   
   <div class="p_box">
	<table class="p_table table_center">
        <thead>
            <tr>
	            <th>选择</th>
	            <th>编号</th>
	            <th>出发地编码</th>
	        	<th>出发地名称</th>
            </tr>
        </thead>
        <tbody>
         <#if pageParam?? && pageParam.items?? >
			<#list pageParam.items as channelFromPlace>
			<tr>
			<td>
			  <input type="radio"  name="channelFromPlace" value="${(channelFromPlace.placeId)!''}" data-name="${(channelFromPlace.placeName)!''}"/>
			</td>
			<td>
				${(channelFromPlace.placeId)!''}
			</td>
			<td>
				${(channelFromPlace.placeCode)!''}
			</td>
			<td>
			    ${(channelFromPlace.placeName)!''}
            </td>
			</tr>
			</#list>
		  </#if>
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
$("#search_button").off("click");
$("#search_button").on("click", function() {
	 trimInput();
	$("#searchForm").submit();
});

//点击确定事件
$("#make_sure").on("click", function() {
	var $channelFromPlace = $('input[name="channelFromPlace"]:checked');
	if (!$channelFromPlace.val()) {
		$.alert("请选择一个出发地！");
	} else {
		var code = $channelFromPlace.val();
		var name = $channelFromPlace.attr("data-name");
		if ($("input[name=parent]").val() == "true") {
			$("input[name=parentPlaceName]", window.parent.document).val(name);
			$("input[name=parentPlaceId]", window.parent.document).val(code);
		} else {
			$("input[name=placeName]", window.parent.document).val(name);
			$("input[name=placeId]", window.parent.document).val(code);
		}
		window.parent.selectChannelFromPlaceDialog.close();
	}


});
//取消
$("#cancel").on("click", function() {
	window.parent.selectChannelFromPlaceDialog.close();
});
//去除前后空格
function trimInput() {
    $("input[type=text]").each(function() {
        var $this = $(this);
        $this.val($.trim($this.val()));
    });
}
</script>


