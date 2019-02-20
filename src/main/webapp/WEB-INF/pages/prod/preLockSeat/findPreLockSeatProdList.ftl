<!DOCTYPE html>
<html>
<#include "/base/head_meta.ftl"/>
<body>
	<div class="iframe_search">		
		<form id="searchForm" method="post" action='/vst_admin/prod/preLockSeat/findPreLockSeatProdList.do'>
		<input type="hidden" id="redirectType" name="redirectType" value="${redirectType }"/>
	        <table class="s_table">
	            <tbody>
					<tr>
	                	<td class="s_label">产品ID：</td>
	                    <td class="w18" colspan="4">
	                    	<textarea placeholder="产品编号中可输入多个产品ID，ID间用“，”分隔，可同时查询多个产品" 
	                    	id="productIds" maxlength="4000" class="textWidth" name="productIds" style="height:40px;width:500px;" value="${productIds}">${productIds}</textarea>
	                    </td>
	                </tr>			
					<tr>
	                	<td class="s_label">品类：</td>
	                    <td class="w18">
	                    	<select name="categoryType" id="categoryType">
	                    		<option value="">全部</option>
	                    		<option value="inner_15" <#if (prodAdditionFlag?? && prodAdditionFlag.categoryType == "inner_15")>selected</#if>>国内-跟团游</option>
	                    		<option value="182" <#if (prodAdditionFlag?? && prodAdditionFlag.categoryType == "182")>selected</#if>>国内-机酒</option>
	                    	</select>	                    	
	                    </td>
	                 	<td class="s_label">供应商名称：</td>
	                    <td class="w18">
	                    	<input  class="searchInput" type="text" id="supplierName" name="supplierName" value="${supplierName}"/>
	                    </td>
	                 	<td class="s_label">供应商ID：</td>
	                    <td class="w18">
	                    	<input style="width:130px;" maxlength="100" id="supplierId" type="text" name="supplierId" value="${supplierId}" readonly = "true"/>
	                    </td>
	                </tr>   
	                      
					<tr>
	                	<td class="s_label">是否有效：</td>
	                    <td class="w18">
	                    	<select name="cancelFlag" id="cancelFlag">
	                    		<option value="Y" <#if (prodAdditionFlag?? && prodAdditionFlag.cancelFlag == "Y")>selected="selected"</#if> >是</option>
	                    		<option value="N" <#if (prodAdditionFlag?? && prodAdditionFlag.cancelFlag == "N")>selected="selected"</#if> >否</option>
	                    	</select>
	                    </td>
	                	<td class="s_label">是否可售：</td>
	                    <td class="w18">
	                    	<select name="saleFlag" id="saleFlag">
	                    		<option value="Y" <#if (prodAdditionFlag?? && prodAdditionFlag.saleFlag == "Y")>selected="selected"</#if>>是</option>
	                    		<option value="N" <#if (prodAdditionFlag?? && prodAdditionFlag.saleFlag == "N")>selected="selected"</#if>>否</option>
	                    	</select>
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
				<div style="margin-top: 10px;" class="delProdTag">
					<a class="btn btn_cc1" href="javascript:void(0);" id="batchCancleSeat">批量取消前置</a>
					<a class="btn btn_cc1" href="javascript:void(0);" id="batchMakeSeat">批量设为前置</a>
				</div>
				<!-- 主要内容显示区域\\ -->
				<div class="iframe-content">
					<span style="color:grey">提示：全选为选择当前页的所有产品</span>
				    <div class="p_box">
					    <table class="p_table table_center" style="margin-top: 10px;">
		                    <tr>
									<th width="60">&nbsp;<input type="checkbox" id="selectAllItems" class="selectAll"/></th>
									<th width="60">产品ID</th>
				                    <th width="300">产品名称</th>
				                    <th width="60">是否有效</th>								
				                    <th width="60">是否可售</th>								
				                    <th width="60">支付前置</th>								
		                    </tr>
							<#list pageParam.items as item> 
								<tr>
									<td><input type="checkbox" value="${item.productId}" name="objectIds"/></td>
									<td>${item.productId}</td>
									<td class="productName">
									<a style="cursor:pointer" 
										onclick="openProduct(${item.productId},'15')">
										${item.productName}
									</a></td>
									<td>${item.cancelFlag}</td>
									<td>${item.saleFlag}</td>
									<td>${item.seatFlag!'N'}</td>
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
				<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
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
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
$(function(){
		
	});

	//校验input合法
	function validateInput(){
		//产品id不得大于1000个
		var productIdsStr = $("#productIds").val();
		if(productIdsStr != null && productIdsStr != ""){
			var productIdsArr = productIdsStr.split(",");
			if(productIdsArr != null && productIdsArr.length>1000){
				alert("最多一次查询1000个产品！");
				return false;
			}
		}
		
		return true;
	}
	
	// 全选与取消
	$('.selectAll').bind('click',function(){
		 if($(this).attr('checked')=='checked'){
			 $("input[type=checkbox][name=objectIds]").attr('checked',true);			 	
		 }else{
		 	 $("input[type=checkbox][name=objectIds]").attr('checked',false);
		 }
	});
	
	// 查询
	$('#search_button').bind('click',function(){
		var validateFlag = validateInput();
		if(!validateFlag){
			return;
		}
		$("#searchForm").submit();
	});
	
	// 批量取消前置
	$('#batchCancleSeat').bind('click',function(){
		var size = $("input[type=checkbox][name=objectIds]:checked").size();
		if(size<=0){
			alert("请选择批量设置的产品");
			return false;
		} else {
			setProdSeatFlag("N");
		}				
	});
	
	// 批设为消前置
	$('#batchMakeSeat').bind('click',function(){
		var size = $("input[type=checkbox][name=objectIds]:checked").size();
		if(size<=0){
			alert("请选择批量设置的产品");
			return false;
		} else {
			setProdSeatFlag("Y");
		}				
	});
	
	function setProdSeatFlag(flag){
		if(flag == null || flag == "" || flag == "undefind"){
			alert("参数错误！");
		}
		var selectProductIds = new Array();
		$("input[type=checkbox][name=objectIds]:checked").each(function(){
		 	 var value = $(this).val();
			 selectProductIds.push(value);
		});
		$.confirm('确定批量设置选中产品吗？',function(){
			$.ajax({
				url : "/vst_admin/prod/preLockSeat/batchUpdatePreLockSeatProds.do",
				type : "post",
				data : "selectProductIds="+selectProductIds.toString()+"&seatFlag="+flag,
				success : function(result) {
					if(result.code=='success'){
			 	 	 	 $.alert(result.message,function(){
			 	 	 	 	$("#searchForm").submit();
			 	 	 	 });
			 	 	 }else{
						$.alert("设置失败，系统内部异常！");		 	 	 
			 	 	 }
				}
			});				
		});
		
		
	}
	
	function openProduct(productId, categoryId){
		window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId);
	}


</script>