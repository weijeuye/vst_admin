<!DOCTYPE html>
<html>
<#include "/base/head_meta.ftl"/>
<body>
	<div class="iframe_search">		
		<form id="searchForm" method="post" action='/vst_admin/superfreetour/errorManage/findErrorInfoList.do'>
            <input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
            <input type="hidden" id="page" name="page" value="${page }"/>
	        <table class="s_table">
	            <tbody>
					<tr>
	                	<td class="s_label">报错位置：</td>
	                    <td class="w18">
	                    	<select name="errorPlace" id="errorPlace">
	                    		<option value="">请选择</option>
	                    		<option value="SHOP_CART" <#if (errorInfo?? && errorInfo.errorPlace == "SHOP_CART")>selected="selected"</#if>>购物车</option>
	                    		<option value="FILL_ORDER" <#if (errorInfo?? && errorInfo.errorPlace == "FILL_ORDER")>selected="selected"</#if>>填单页</option>
	                    	</select>
	                    </td>
	                 	<td class="s_label">产品ID：</td>
	                    <td class="w18">
	                    	<input  type="text" id="productId" name="productId"  value="${errorInfo.productId}" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " ng-pattern="/[^a-zA-Z]/"/>
	                    </td>
	                 	<td class="s_label">商品ID：</td>
	                    <td class="w18">
	                    	<input id="suppGoodsId" type="text" name="suppGoodsId"  value="${errorInfo.suppGoodsId}" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " ng-pattern="/[^a-zA-Z]/"/>
	                    </td>
	                </tr>   
	                      
					<tr>
	                	<td class="s_label">错误信息：</td>
	                    <td class="w18">
                            <input style="width:130px;" maxlength="100" id="errorMessage" type="text" name="errorMessage" value="${errorInfo.errorMessage}" />
	                    </td>
	                    <td class="operate mt10">
		                   	&nbsp;<a class="btn btn_cc1" id="search_button">查询</a> 
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
				                    <th width="30">报错位置</th>
				                    <th width="60">产品ID</th>
				                    <th width="60">商品ID</th>
				                    <th width="60">会员ID</th>
				                    <th width="60">品类</th>
				                    <th width="30">错误码</th>
				                    <th width="100">错误信息</th>
				                    <th width="60">时间</th>
		                    </tr>
							<#list pageParam.items as item> 
								<tr>
									<td>${item.errorInfoId}</td>
									<td><#if item.errorPlace = "SHOP_CART">购物车<#else>填单页</#if></td>
									<td>${item.productId}</td>
									<td>${item.suppGoodsId}</td>
									<td>${item.userId}</td>
									<td>${item.categoryName}</td>
									<td>${item.errorCode}</td>
									<td>${item.errorMessage}</td>
									<td><#if item.createTime??>${item.createTime?string("yyyy-MM-dd HH:mm:ss")}</#if></td>
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
				<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关错误信息，重新输入相关条件查询！</div>
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



</script>