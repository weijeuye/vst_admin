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
        		<input type="hidden" value="select" name="queryType" />
            <tr>
           	    <td class="s_label">站点类型:
	                <select name="areaType" class="w10">
	                   	<option value="">全部</option>
				    	<#list areaTypeList as areaType> 
				           <option value="${(areaType.code)!''}" <#if areaType.code == channelArea.areaType>selected</#if>>${(areaType.cnName)!''}</option>
					    </#list>
				    </select>
                </td>
                <td class="s_label">站点编码:
                    <input type="text"  class="w10" name="areaCode" value="${(channelArea.areaCode)!''}">
                </td>
                <td class="s_label">站点名称:
                    <input type="text" class="w10"  name="areaName" value="${(channelArea.areaName)!''}">
                </td>
                <td class="operate mt10">
                 	<a class="btn btn_cc1" id="search_button">查询</a>
                </td>
            </tr>
            <tr>
            	<td class="operate mt10">
                      <a  class="btn btn_cc1" id="make_sure">确定</a>	
                      <a  class="btn btn_cc1" id="cancel">取消</a>
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
	            <th>站点编码</th>
	            <th>站点类型</th>
	        	<th>站点名称</th>
            </tr>
        </thead>
        <tbody>
          <#if pageParam?? && pageParam.items??>
			<#list pageParam.items as channelArea>
			<tr>
			<td>
			  <input type="radio"  name="channelArea" value="${(channelArea.areaCode)!''}" data-name="${(channelArea.areaName)!''}"/>
			</td>
			<td>
				${(channelArea.areaCode)!''}
			</td>
			<td>
			    <#list areaTypeList as areaType>
					<#if areaType.code == channelArea.areaType>
					   ${(areaType.cnName)!''}
					</#if>
				</#list>
			</td>
			<td>
			 ${(channelArea.areaName)!''}
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
	var $channelAra = $('input[name="channelArea"]:checked');
	if (!$channelAra.val()) {
		$.alert("请选择一个站点");
	} else {
		var code = $channelAra.val();
		var name = $channelAra.attr("data-name");
		$("#areaName", window.parent.document).val(name);
		$("#areaCode", window.parent.document).val(code);
		window.parent.selectChannelAreaDialog.close();
	}
});
//取消
$("#cancel").on("click", function() {
	window.parent.selectChannelAreaDialog.close();
});
//去除前后空格
function trimInput() {
    $("input[type=text]").each(function() {
        var $this = $(this);
        $this.val($.trim($this.val()));
    });
}
</script>


