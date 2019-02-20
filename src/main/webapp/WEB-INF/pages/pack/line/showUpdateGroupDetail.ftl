<#assign mis=JspTaglibs["/WEB-INF/pages//tld/lvmama-tags.tld"]>
<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>

<!-- 编辑时设置初始化值 -->
<#assign price = '' />
<#assign priceType = '' />
<#if packDetail ??>
	<#assign price = packDetail.price />
	<#assign priceType = packDetail.priceType />
</#if>

<body>
<div class="iframe_content">
    <div class="p_box box_info">
    <input type="hidden" id="oldAssociatedRouteProdId" value="${associatedRouteProdId }"/>
    <input type="hidden" id="oldAssociatedFeeIncludeProdId" value="${associatedFeeIncludeProdId }"/>
    <input type="hidden" id="oldAssociatedContractProdId" value="${associatedContractProdId }"/>
    <input type="hidden" id="oldFeeIncludeExtra" value="${feeIncludeExtra }">
    <input type="hidden" id="categoryId" value="${categoryId }"/>
    <input type="hidden" id="associatedFlag" value="${associatedFlag }"/>
	<form method="post" action='/vst_admin/productPack/line/updateGroupDetail.do' id="dataForm">
		<input type="hidden" id="groupId" name="toGroupId" value="${toGroupId }"/>
		<input type="hidden" id="groupId" name="backGroupId" value="${backGroupId }"/>
		<input type="hidden" id="groupType" name="groupType" value="${groupType }"/>
		<input type="hidden" id="price" name="price" value="${price }"/>
		<input type="hidden" id="detailIds" name=detailIds value="${detailIds }"/>
		<input type="hidden" id="productId" name="productId"/>
		<input type="hidden" id="autopackage" <#if packDetail??>value="${packDetail.autopackage}"</#if>/>
        <table class="s_table">
            <tbody>
            	<tr>
            	  <td class="s_label" colspan="3">设置规则：</td>
            	  </tr>
                <tr>
                    <td class="w18"><input type="radio" id="profit" name="priceType" value="MAKEUP_PRICE" checked="checked"/>基于商品利润设置，利润的：</td>
                    <td class="s_label"><input type="text" id="makeUpPrice" name="makeUpPrice" number="true"  value="100"/>%</td>
                     <td>&nbsp;</td>
                </tr>
                <tr>
                    <td class="w18"><input type="radio" id="fix" name="priceType" value="FIXED_PRICE"/>基于结算价恒定，加价：</td>
                    <td class="s_label"><input type="text"  id="fixPrice" name="fixPrice" number="true" readonly="true" />元</td>
                    <td class=" operate mt10"> <a class="btn btn_cc1" id="updatePackDetail">保存设置</a> </td>
                </tr>
            </tbody>
            
        </table>	
		</form>
	</div>
<!-- 主要内容显示区域\\ -->
	已选择产品
	<span style="color:red;"><#if groupType == 'LINE_TICKET'  &&  isAvaliableBranch?? && isAvaliableBranch!="">注：${isAvaliableBranch}下没有可供打包商品</#if></span>
	
    <#if packDetailList?? &&  packDetailList?size &gt; 0>
    <div class="p_box box_info">
    <table class="p_table table_center">
                <thead>
                	<th width="80px">产品类型</th>
                    <th>产品ID</th>
                    <th>产品名称</th>
                    <th>规格ID</th>
                    <th >规格</th>
                    </tr>
                </thead>
                <tbody>
					<#if autopackage == 'Y'>
							<tr>
								<td>其他机票</td>
								<td></td>
								<td>全国对接机票</td>
								<td></td>
								<td></td>
							</tr>
					<#else>
						<#list packDetailList as packDetail> 
							 <#if packDetail ?? && packDetail.prodProductBranch ??>
							 	<tr>
									<td>${packDetail.prodProductBranch.categoryName!''}</td>
									<td>${packDetail.prodProductBranch.productId!''}</td>
									<input type="hidden" id="associationProductId" value="${packDetail.prodProductBranch.productId!''}"/>
									<td>
										<#if hotelOnlineFlag?? && hotelOnlineFlag == 'true'> 
										<a style="cursor:pointer" 
											onclick="openHotelProduct(${packDetail.prodProductBranch.productId!''},${packDetail.prodProductBranch.categoryId!''},'${packDetail.prodProductBranch.categoryName!''}')">
										<#else>
										<a style="cursor:pointer" 
											onclick="openProduct(${packDetail.prodProductBranch.productId!''},${packDetail.prodProductBranch.categoryId!''},'${packDetail.prodProductBranch.categoryName!''}')">
										</#if>
											${packDetail.prodProductBranch.productName!''} 
										</a>
									 </td>
									 <td>${packDetail.prodProductBranch.productBranchId!''}</td>
									<td>${packDetail.prodProductBranch.branchName!''}</td>
								</tr>
							 </#if>
						</#list>
					</#if>
                </tbody>
            </table>
	</div>
	<#if categoryId != 17 && associatedFlag == 'true'>
	<form id="associationForm">
	请选择关联内容:
	<input type="checkbox" id="associatedRouteProdId" name="associatedRouteProdId" value="${associatedRouteProdId }"/>行程明细
	<input type="checkbox" id="associatedFeeIncludeProdId" name="associatedFeeIncludeProdId" value="${associatedFeeIncludeProdId }"/>费用说明
	<input type="checkbox" id="associatedContractProdId" name="associatedContractProdId" value="${associatedContractProdId }"/>合同条款
	<br>
	费用包含补充说明:
	<textarea id="feeIncludeExtra" name="feeIncludeExtra" style="width:490px; height:100px"></textarea>
	</form>
	</#if>
	<#else>
		<div class="no_data mt20"><i class="icon-warn32"></i>暂无相关选择产品！</div>
    </#if>
        
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function(){
	$("#productId").val($("#productId",window.parent.document).val());
	
	$("input[name=priceType]").click(function(index,obj){
		if($(this).attr("checked") == "checked"){
			var id = $(this).attr("id");
			if(id=='profit'){
				$("#makeUpPrice").removeAttr("readonly");
				$("#fixPrice").attr("readonly","true");
				$("#fixPrice").val("");
			}
			if(id=='fix'){
				$("#fixPrice").removeAttr("readonly");
				$("#makeUpPrice").attr("readonly","true");
				$("#makeUpPrice").val("");
			}
		}
	});
	
	//设置修改单条记录时的价格规则
	if('${priceType}' != null && '${priceType}'.length > 0){
		if('${priceType}' == 'FIXED_PRICE'){
			$("#fix").attr("checked","checked");
			$("#fixPrice").val(parseFloat('${price}')/100);
			$("#fixPrice").removeAttr("readonly");
		}else if('${priceType}' == 'MAKEUP_PRICE'){
			$("#profit").attr("checked","checked");
			$("#makeUpPrice").val(parseFloat('${price}')/100);
			$("#makeUpPrice").removeAttr("readonly");
		}
	}
	
	$("#updatePackDetail").bind("click",function(){
		//验证
		if(!$("#dataForm").validate({
			rules : {},
			messages : {}
		}).form()){
			return;
		}
		
		var profit = $("#profit").attr("checked");
		if(profit){
			var makeUpPrice = $("#makeUpPrice").val();
			if(makeUpPrice == null || makeUpPrice == ''){
				$.alert("必须设置商品利润率");
				return;
			}
			//else if(parseInt(makeUpPrice) < 0){
			//	$.alert("设置商品利润率非法");
			//	return;
			//}
			else{
				var integerReg = /^(0|-?[1-9]\d*)$/;
				if(!integerReg.test(parseFloat(makeUpPrice))){
					$.alert("设置商品利润率非法(整数)");
					return;
				}
			}
		}
		
		var profit = $("#fix").attr("checked");
		if(profit){
			var fixPrice = $("#fixPrice").val();
			if(fixPrice == null || fixPrice == '' ){
				$.alert("必须设置恒定加价");
				return;
			}
			//else if(parseFloat(fixPrice) < 0){
			//	$.alert("设置恒定加价非法");
			//	return;
			//}
		}
		
		$("input[name=priceType]").each(function(index, obj){
			if($(this).attr("checked") == "checked"){
				var id = $(this).attr("id");
				if(id=='profit'){
					$("#price").val($("#makeUpPrice").val());
				}
				if(id=='fix'){
					$("#price").val($("#fixPrice").val());
				}
			}
		});
		
		if($("#price").val() == null || $("#price").val() == ''){
			$.alert("请设置价格规则");
			return;
		}
		
		$("#price").val(Math.round(parseFloat($("#price").val())*100)); 
		
		var loading;
		var feeExtra = $("#feeIncludeExtra").val();
		if($("#oldAssociatedFeeIncludeProdId").val() != '' && $("#oldAssociatedFeeIncludeProdId").val() != null && $("#oldAssociatedFeeIncludeProdId").val() != $("#associationProductId").val() && $("#associatedFeeIncludeProdId").attr("checked")!="checked"){
		    feeExtra = $("#oldFeeIncludeExtra").val();
		}
		var parameter = $("#dataForm").serialize()+ "&associatedRouteProdId=" + $("#associatedRouteProdId").val()+ "&associatedFeeIncludeProdId="+ $("#associatedFeeIncludeProdId").val()+ "&associatedContractProdId="+ $("#associatedContractProdId").val() + "&feeIncludeExtra=" + feeExtra;
		var msg = '已关联其它产品，确认覆盖?';
		if($("#associatedRouteProdId").val() != '' && $("#associatedRouteProdId").val() != null && $("#oldAssociatedRouteProdId").val() != '' && $("#oldAssociatedRouteProdId").val() != null && $("#associatedRouteProdId").val() != $("#oldAssociatedRouteProdId").val()){
		    msg = '行程明细、合同条款已关联其它产品，确认覆盖?';
		    $.confirm(msg,function(){
		        loading = top.pandora.loading("正在努力保存中...");
		        $.ajax({
			    url : "/vst_admin/productPack/line/updateAssociatedDetail.do",
			    type : "post",
			    dataType : 'json',
			    data : parameter,
			    success : function(result) {
				    loading.close();
				    if(result.code == "success"){
					    parent.onUpdatePackGroupDetail();
				    }
			    },
			    error : function(result) {
				    loading.close();
				    $.alert(result.message);
			    }
		     });
		   });
		}else if($("#associatedFeeIncludeProdId").val() != '' && $("#associatedFeeIncludeProdId").val() != null && $("#oldAssociatedFeeIncludeProdId").val() != '' && $("#oldAssociatedFeeIncludeProdId").val() != null && $("#associatedFeeIncludeProdId").val() != $("#oldAssociatedFeeIncludeProdId").val()){
		   msg = '费用说明已关联其它产品，确认覆盖?';
		   $.confirm(msg,function(){
		        loading = top.pandora.loading("正在努力保存中...");
		        $.ajax({
			    url : "/vst_admin/productPack/line/updateAssociatedDetail.do",
			    type : "post",
			    dataType : 'json',
			    data : parameter,
			    success : function(result) {
				    loading.close();
				    if(result.code == "success"){
					    parent.onUpdatePackGroupDetail();
				    }
			    },
			    error : function(result) {
				    loading.close();
				    $.alert(result.message);
			    }
		     });
		   });
		}else if($("#categoryId").val() == 17 || $("#associatedFlag").val() != 'true'){
		    loading = top.pandora.loading("正在努力保存中...");
		    var url = "";
		    var toGroupId = $("#toGroupId").val();
		    var backGroupId = $("#backGroupId").val();
		    if($("#autopackage").val() == "Y"){
		    	url = "/vst_admin/productPack/line/autopackageUpdateGroupDetail.do";
		    }else{
		    	url = "/vst_admin/productPack/line/updateGroupDetail.do";
		    }
		    $.ajax({
			url : url,
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize()+"&toGroupId="+toGroupId+"&backGroupId"+backGroupId,
			success : function(result) {
				loading.close();
				if(result.code == "success"){
					parent.onUpdatePackGroupDetail();
				}
			},
			error : function(result) {
				loading.close();
				$.alert(result.message);
			}
		 });
		}else{
		    if($("#oldAssociatedFeeIncludeProdId").val() != '' && $("#oldAssociatedFeeIncludeProdId").val() != null && $("#oldAssociatedFeeIncludeProdId").val() != $("#associationProductId").val()){
		        parameter = $("#dataForm").serialize()+ "&associatedRouteProdId=" + $("#associatedRouteProdId").val()+ "&associatedFeeIncludeProdId="+ $("#associatedFeeIncludeProdId").val()+ "&associatedContractProdId="+ $("#associatedContractProdId").val() + "&feeIncludeExtra=" + $("#oldFeeIncludeExtra").val();
		    }
		    loading = top.pandora.loading("正在努力保存中...");
		    $.ajax({
			url : "/vst_admin/productPack/line/updateAssociatedDetail.do",
			type : "post",
			dataType : 'json',
			data : parameter,
			success : function(result) {
				loading.close();
				if(result.code == "success"){
					parent.onUpdatePackGroupDetail();
				}
			},
			error : function(result) {
				loading.close();
				$.alert(result.message);
			}
		 });
	    }
	});
});

function openProduct(productId, categoryId, categoryName){
	window.open("/vst_admin/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}

function openHotelProduct(productId, categoryId, categoryName){
	window.open("/lvmm_dest_back/prod/baseProduct/toUpdateProduct.do?productId="+productId+"&categoryId="+categoryId+"&categoryName="+categoryName);
}

$(function(){
    $("#feeIncludeExtra").attr("disabled","diasbled");
    if($("#associationProductId").val() == $("#oldAssociatedRouteProdId").val()){
        $("#associatedRouteProdId").attr("checked","checked");
    }
    if($("#associationProductId").val() == $("#oldAssociatedFeeIncludeProdId").val()){
        $("#associatedFeeIncludeProdId").attr("checked","checked");
        $("#feeIncludeExtra").removeAttr("disabled","diasbled");
        $("#feeIncludeExtra").val($("#oldFeeIncludeExtra").val());
    }
    if($("#associationProductId").val() == $("#oldAssociatedContractProdId").val()){
        $("#associatedContractProdId").attr("checked","checked");
    }
});

//行程明细与合同条款绑定，必须同时勾选
$("#associatedRouteProdId").click(function(){
    if($(this).attr("checked")=="checked"){
        $("#associatedRouteProdId").val($("#associationProductId").val());
        $("#associatedContractProdId").val($("#associationProductId").val());
        $("#associatedContractProdId").attr("checked","checked");
    }else{
        $("#associatedContractProdId").removeAttr("checked");
        $("#associatedRouteProdId").val($("#oldAssociatedRouteProdId").val());
        $("#associatedContractProdId").val($("#oldAssociatedContractProdId").val());
        if($("#oldAssociatedRouteProdId").val() == $("#associationProductId").val()){
            $("#associatedRouteProdId").val("");
            $("#associatedContractProdId").val("");
        }
    }
});	

$("#associatedFeeIncludeProdId").click(function(){
    if($(this).attr("checked")=="checked"){
        $("#feeIncludeExtra").removeAttr("disabled","diasbled");
        $("#associatedFeeIncludeProdId").val($("#associationProductId").val());
        
        if($("#feeIncludeExtra").val() == null || $("#feeIncludeExtra").val() == ""){
            $("#feeIncludeExtra").val("成人、2-12周岁儿童均含往返机票;以上报价已包含机票税和燃油附加费。");
        }else{
            if($("#oldAssociatedFeeIncludeProdId").val() == $("#associatedFeeIncludeProdId").val()){
               $("#feeIncludeExtra").val($("#oldFeeIncludeExtra").val());
            }
        }
    }else{
        $("#feeIncludeExtra").val("");
        $("#feeIncludeExtra").attr("disabled","diasbled");
        $("#associatedFeeIncludeProdId").val($("#oldAssociatedFeeIncludeProdId").val());
        if($("#oldAssociatedFeeIncludeProdId").val() == $("#associationProductId").val()){
            $("#associatedFeeIncludeProdId").val("");
        }
    }
});

$("#associatedContractProdId").click(function(){
    if($(this).attr("checked")=="checked"){
        $("#associatedRouteProdId").attr("checked","checked");
        $("#associatedContractProdId").val($("#associationProductId").val());
        $("#associatedRouteProdId").val($("#associationProductId").val());
    }else{
        $("#associatedRouteProdId").removeAttr("checked");
        $("#associatedRouteProdId").val($("#oldAssociatedRouteProdId").val());
        $("#associatedContractProdId").val($("#oldAssociatedContractProdId").val());
        if($("#oldAssociatedContractProdId").val() == $("#associationProductId").val()){
            $("#associatedRouteProdId").val("");
            $("#associatedContractProdId").val("");
        }
    }
});		

</script>
