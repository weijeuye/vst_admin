<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<link rel="stylesheet"  href="/vst_admin/css/ticket/rescheduleTab.css" type="text/css"/>
</head>
<body>
<div class="iframe_header">
        <ul class="iframe_nav">
            <li><a href="#">${(suppGoods.prodProduct.bizCategory.categoryName)!''}</a> &gt;</li>
            <li><a href="#">商品维护</a> &gt;</li>
            <li class="active">供应商合同关联</li>
        </ul>
</div>
<div class="iframe_content mt10">
        <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
            <p class="pl15">1.景区门票品类维护的均是单品，当单景区套餐或跨景区的套餐时，请在“组合套餐”中创建。并维护该关联目的地。</p>
            <p class="pl15">2.商品中定义了大人和小孩的数量，标准票种的大人小孩数量是不允许修改的，自定义时才可以修改。</p>  
            <!-- 下面参数主要用于根据供应商进行门票商品信息查询使用 -->
             <input type="hidden" id="automaticQuery" name="automaticQuery" value="${automaticQuery!''}">
             <input type="hidden" id="supplierNameQuery" name="supplierNameQuery" value="${supplierNameQuery!''}">    
             <input type="hidden" id="supplierIdQuery" name="supplierIdQuery" value="${supplierIdQuery!''}">   
             <input type="hidden" id="categoryIdQuery" name="categoryIdQuery" value="${categoryIdQuery!''}">  
             <input type="hidden" id="productIdQuery" name="productIdQuery" value="${productIdQuery!''}">    
        </div>
        <div class="p_box box_info">
        <form method="post" action='/vst_admin/ticket/goods/goods/findSuppGoodsList.do' id="searchForm">
            <input type="hidden" name="prodProduct.bizCategory.categoryName" value="${suppGoods.prodProduct.bizCategory.categoryName!''}">
            <input type="hidden" name="prodProduct.productId" value="${suppGoods.prodProduct.productId!''}">
            <input type="hidden"  name="prodProduct.bizCategory.categoryId" value="${suppGoods.prodProduct.bizCategory.categoryId!''}">
        
            <table class="e_table form-inline">
            <tbody>             
                </tr>
                    <tr>
	                    <td width="150" class="e_label td_top"><i class="cc1">*</i>选择供应商：</td>
	                    <td class="w18" colspan='5'>
	                    <input type="hidden" name="productId" value="${suppGoods.prodProduct.productId!''}">
	                    <input type="text" placeholder="请输入供应商名称" class="w35 search" name="suppSupplier.supplierName" id="supplierName" <#if suppGoods != null && suppGoods.suppSupplier != null>value="${suppGoods.suppSupplier.supplierName}"</#if> >
                	    <input type="hidden"  name="supplierId" id="supplierId" value="${suppGoods.supplierId!''}" required=true>
                	    
	                    <!--<a class="btn btn_cc1" id="selectSupplierButton">选择供应商</a><span class="cc3">(仅针对供应商进行查询)</span>-->
	                    <a class="btn btn_cc1" id="search_button">查询供应商商品</a>
                    	<div class="cc3"> 注：下面的内容维护人员、商品默认合同，添加新商品时均为默认值。 </div></td>
                    </tr>
                    <tr>
	                    <td class="e_label td_top">内容维护人员：</td>
	                    <td class="w18" colspan='5'>
	                    
	                    <input type="text" name="contentManagerName" id="contentManagerName" class="w35 search" placeholder="请输入维护人员名称"
	                    <#if suppGoods!=null>value="${suppGoods.contentManagerName!''}"</#if> >
                    	<input type="hidden"  name="contentManagerId" id="contentManagerId"  
	                    	<#if suppGoods!=null>value="${suppGoods.contentManagerId!''}"</#if>>
	                    	<div class="cc3"> 注：后续会对其内容质量进行考核。 </div>
	                    </td>
                    </tr>
                    <tr>
	                    <td class="e_label td_top">商品默认合同：</td>
	                    <td class="w18" colspan='5'>
	                    	<label id="contractName" name="contractName"><#if suppGoods!=null && suppGoods.suppContract != null>${suppGoods.suppContract.contractName!''}</#if></label>
	                    	<input type="hidden" id="contractId" name="contractId"
	                    	<#if suppGoods!=null && suppGoods.suppContract != null>value="${suppGoods.suppContract.contractId!''}"</#if>><a id="change_button" href="javascript:void(0);">[更改]</a></td>
                    </tr>
                    <tr>
                        <td class="e_label">所属规格：</td>
                        <td colspan='1'>
                            <select id="productBranchId" name="productBranchId">
                            	<option value=""></option>
                            	<#list prodProductBranchList as prodProductBranch>
	            					<option value="${prodProductBranch.productBranchId!''}" <#if suppGoods?? && suppGoods.prodProductBranch?? && prodProductBranch.productBranchId == suppGoods.prodProductBranch.productBranchId> selected </#if>> ${prodProductBranch.branchName!''}</option>
	                			</#list>
					        </select>
                        </td>
						<td>有/无效：
							<select name="cancelFlag" id='cancelFlagBtn'>
                                <option value="ALL" <#if suppGoods.cancelFlag == "ALL">selected</#if>>全部</option>
								<option value="Y" <#if suppGoods.cancelFlag == "Y">selected</#if>>有效</option>
                                <option value="N" <#if suppGoods.cancelFlag == "N">selected</#if>>无效</option>
							</select>
						</td>
                    </tr>
                    <tr>
                        <td class="e_label"></td>
                        <td>
                        	<div class="fl operate">
                        		<a class="btn btn_cc1" name="new_button" data="N">添加普通商品</a>
                        	</div>
                        	<div class="fl operate">
                        		<a class="btn btn_cc1" name="new_button" data="Y">添加期票商品</a>
                        	</div>
                        </td>
                        <td>
                        	<div class="fl operate">
                        		<#if suppGoods.prodProduct.bizCategory.categoryId=='11'>
                        			<a class="btn btn_cc1" name="selectProdDestInfo" data1="${suppGoods.prodProduct.productName!''}" data="${suppGoods.prodProduct.productId!''}">查询POI关联产品</a>
                        		</#if>
                        	</div>                            	
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
        </div>
 <!-- 主要内容显示区域\\ -->        
                <#if suppGoodsMap??> 
	                <#list suppGoodsMap?keys as testKey>
	                	<#assign suppGoodsList=suppGoodsMap[testKey] >          
        
        <div class="p_box box_info">
            <div class="f16 mb10">${testKey?substring(1,testKey?last_index_of("_"))}
            </div>
            
            <table class="p_table table_center">
                <thead>
                    <tr>
                        <th>规格ID</th>
                        <th>规格名</th>
                        <th>商品分类</th>
                        <th>商品名称</th>
                        <th>商品编号</th>
						<th>门票票种</th>
                        <th>是否有效</th>                        
                        <th>支付对象</th>
                        <th>产品经理</th>
                        <th>内容维护人员</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <#if suppGoodsList?? && suppGoodsList?size &gt; 0>
                
                	<#list suppGoodsList as suppGoods> 
						<tr>
                            <td>${suppGoods.prodProductBranch.productBranchId}</td>
							<td>${suppGoods.prodProductBranch.branchName!''}</td>
							<td><#if suppGoods.aperiodicFlag =="Y">期票<#else>普通</#if></td>
							<td>${suppGoods.goodsName!''} </td>
							<td>${suppGoods.suppGoodsId!''} </td>
							<td>${suppGoods.goodsSpecName!''}</td>
							<td>
							<#if suppGoods.cancelFlag == "Y"> 
							<span style="color:green" class="cancelProp">有效</span>
							<#else>
							<span style="color:red" class="cancelProp">无效</span>
							</#if>
							</td>							
							<td>
								<#list payTargetList as list> 
				                    	<#if suppGoods?? && suppGoods.payTarget==list.code>${list.cnName!''}</#if>
				                </#list>
							</td>
							<td>${suppGoods.managerName!''} </td>
							<td>${suppGoods.contentManagerName!''} </td>
							<td class="oper">
                                	<a href="javascript:void(0);" class="editProp" data=${suppGoods.suppGoodsId} thisProductBranchId=${suppGoods.prodProductBranch.productBranchId}>编辑</a>
		                            <a href="javascript:void(0);" class="desc" data=${suppGoods.suppGoodsId}>商品描述</a>
		                            <a href="javascript:void(0);" class="timePrice" data=${suppGoods.suppGoodsId}>价格库存</a>
		                            <a href="javascript:void(0);" class="reservationLimit" data=${suppGoods.suppGoodsId}>下单必填项</a>
		                            <#if suppGoods.aperiodicFlag =="Y"><#else><a href="javascript:void(0);" class="blackList" data=${suppGoods.suppGoodsId}>预定限制</a></#if>
		                            <a href="javascript:void(0);" class="showLogDialog" param='objectId=${suppGoods.suppGoodsId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>操作日志</a>
		                            <a class="up" href="javascript:void(0);" <#if suppGoods_index=0> style="display:none"</#if>>向上</a> 
            						<a class="down" href="javascript:void(0);" <#if suppGoods_index=suppGoodsList?size-1> style="display:none"</#if>>向下</a> 
		                            <#if suppGoods.cancelFlag == "Y"> 
		                            <a href="javascript:void(0);" class="cancelProp" data="N" suppGoodsId=${suppGoods.suppGoodsId}>设为无效</a>
		                            <#else>
		                            <a href="javascript:void(0);" class="cancelProp" data="Y" suppGoodsId=${suppGoods.suppGoodsId} style="color:red" >设为有效</a>
		                            </#if>	
                            		<a href="javascript:void(0);" class="fillSmsContent" data=${suppGoods.suppGoodsId} smsContent=<#if suppGoods.suppGoodsAddition??>'${suppGoods.suppGoodsAddition.smsContent}'</#if> >自定义短信</a>
		                 	</td>
						</tr>
						</#list>
                <#else>
					<tr><td colspan=10><div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div></td></tr>
		    	</#if>
		    	</tbody>
            </table>
        </div>
					</#list>
				</#if>
 </div>
<!-- //主要内容显示区域 -->

<#include "/base/foot.ftl"/>
</body>
</html>

<script> 
vst_pet_util.superUserSuggest("#contentManagerName","input[name=contentManagerId]");
//vst_pet_util.commListSuggest("#supplierName", "#supplierId","/vst_back/supp/supplier/searchSupplierList.do? '${suppJsonList}');
vst_pet_util.commListSuggest("#supplierName", "#supplierId",'/vst_back/supp/supplier/searchSupplierList.do','${suppJsonList}');
</script>


<script>
		var selectContractDialog;
		//供应商合同回调函数
		function onSelectContract(params){
			if(params!=null){
				$("#contractName").text(params.contractName);
				$("#contractId").val(params.contractId);
			}
			selectContractDialog.close();
		}
		//打开选择供应商合同列表
		$("#change_button").click(function(){
			if($("#supplierId").val()!=null && $("#supplierId").val()!=""){			
				selectContractDialog = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?supplierId="+$("#supplierId").val(),{},{title:"选择供应商合同",width:"600"});

			}else{
				$.alert("请先选择供应商！");
			}
		});

		function querySuppGoods() {
			if($("#supplierId").val()!=null && $("#supplierId").val()!=""){
				$("#searchForm").submit();
			}else{
				$.alert("请先选择供应商！");
			}
		}

		$('#cancelFlagBtn').change(querySuppGoods);
		
		//查询
		$("#search_button").bind("click", querySuppGoods);
		
		//新建
		$("a[name=new_button]").bind("click",function(){
		if($("#supplierId").val()!=null && $("#supplierId").val()!=""){	
			new xDialog("/vst_admin/ticket/goods/goods/showAddSuppGoods.do",{productId:$("input[name='prodProduct.productId']").val(),supplierId:$("#supplierId").val(),contractName:$("#contractName").val(),contractId:$("#contractId").val(),contentManagerId:$("#contentManagerId").val(),contentManagerName:$("#contentManagerName").val(),categoryId:$("input[name='prodProduct.bizCategory.categoryId']").val(),productBranchId:$("#productBranchId").val(),aperiodicFlag:$(this).attr("data")},{title:"新增商品",width:965});
		}else{
			$.alert("请先选择供应商！");
		}	
		});
		
		//修改
		$("a.editProp").bind("click",function(){
			var suppGoodsId = $(this).attr("data");
            var thisProductBranchId=$(this).attr("thisProductBranchId");
			new xDialog("/vst_admin/ticket/goods/goods/showUpdateSuppGoods.do",{thisProductBranchId:thisProductBranchId,suppGoodsId:suppGoodsId,productId:$("input[name='prodProduct.productId']").val(),supplierId:$("#supplierId").val(),contractId:$("#contractId").val(),contentManagerId:$("#contentManagerId").val(),categoryId:$("input[name='prodProduct.bizCategory.categoryId']").val(),productBranchId:$("#productBranchId").val()},{title:"编辑商品",width:980});
		});
		
		//设置时间价格
		$("a.timePrice").bind("click",function(){
			var suppGoodsId = $(this).attr("data");
			location.href="/scenic_back/ticket/goods/timePrice/showGoodsTimePrice.do?suppGoodsId="+suppGoodsId+"&prodProduct.productId=${suppGoods.prodProduct.productId!''}";
		});
		
		//反黄牛
		$("a.blackList").live("click",function(){
			var suppGoodsId = $(this).attr("data");
			window.open("/vst_order/goods/goodsLimit/showBlackList.do?goodId="+suppGoodsId);
		});
		
		//设置预定限制
		$("a.reservationLimit").bind("click",function(){
			var suppGoodsId = $(this).attr("data");
			location.href="/vst_admin/ticket/goods/reservationLimit/showGoodsReservationLimit.do?suppGoodsId="+suppGoodsId+"&categoryId=${suppGoods.prodProduct.bizCategory.categoryId!''}";
		});
		
		//设置为有效或无效
		$("a.cancelProp").bind("click",function(){
			var entity = $(this);
			var cancelFlag = entity.attr("data");
			var suppGoodsId = entity.attr("suppGoodsId");
			$.ajax({
				url : "/vst_admin/ticket/goods/goods/cancelProduct.do",
				type : "post",
				dataType:"JSON",
				data : {"cancelFlag":cancelFlag,"suppGoodsId":suppGoodsId},
				success : function(result) {
				if (result.code == "success") {
					$.alert(result.message,function(){
						if(cancelFlag == 'N'){
							entity.attr("data","Y");
							entity.text("设为有效");
							$("span.cancelProp",entity.parents("tr")).css("color","red").text("无效");
                            entity.css("color","red")
						}else if(cancelFlag == 'Y'){
							entity.attr("data","N");
							entity.text("设为无效");
							$("span.cancelProp",entity.parents("tr")).css("color","green").text("有效");
                            entity.css("color","#0066cc")
						}
					});
				}else {
					$.alert(result.message);
				}
				}
			});
		});
		
		//供应商搜索

		
	function confirmAndRefresh(result){
		if (result.code == "success") {
			//，提示绑定二维码
			if((result.attributes != null) && (result.attributes.noticeType == 'QRCODE')){
				pandora.confirm('二维码对接商品需要绑定驴妈妈商品编号，现在去绑定？',function(){
					new xDialog("/vst_passport/passProduct/bindPassProductInit.do?suppGoodsId="+result.attributes.suppGoodsId, 
						{},
						{title:"绑定供应商产品",width:800, iframe:true}
					);
				},function(){
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
						$("#searchForm").submit();
					}});
				});
			}else{
				pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
					$("#searchForm").submit();
				}});
			}
			
		}else {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$.alert(result.message);
			}});
		}
	};
	
	//绑定通关点回调
	function onBindPassProduct(result){
		if (result.code == "SUCCESS") {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
				$("#searchForm").submit();
			}});
		}else {
			pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			}});
		}
	};
	
	$(".up").click(function () {
	 	var trLength = $(".down").length;  
        var $tr = $(this).parents("tr");
        if ($tr.index() != 0) {
        	var a = $tr.find("td:first").next().next().next().next().text();
        	var b = $tr.prev().find("td:first").next().next().next().next().text();
        	if(updateSeq(a,b)){
        		$tr.prev().before($tr);
        		if(trLength ==2){
        			//如果只有2条数据
        			$tr.next().find("td:last").find(".up").show(); 
        			$tr.next().find("td:last").find(".down").hide(); 
        			$tr.find("td:last").find(".down").show();
        			$tr.find("td:last").find(".up").hide();
        		}else{
	        		if($tr.index() == 0){
	        	 		$tr.next().find("td:last").find(".up").show(); 
	        	 		$tr.find("td:last").find(".up").hide();
	        	 	}else if($tr.index() == trLength - 2){
	        	 		$tr.next().find("td:last").find(".down").hide();
	        	 		$tr.find("td:last").find(".down").show();
	        	 	}
        		}
        	}
        }
     });
	
	$(".down").click(function () {
		var trLength = $(".down").length;   
        var $tr = $(this).parents("tr");
        if ($tr.index() != trLength - 1) {
	        var a = $tr.find("td:first").next().next().next().next().text();
	        var b = $tr.next().find("td:first").next().next().next().next().text();    
        	if(updateSeq(a,b)){
        		$tr.next().after($tr);
        		if(trLength ==2){
        			//如果只有2条数据
        			$tr.prev().find("td:last").find(".down").show(); 
        			$tr.prev().find("td:last").find(".up").hide(); 
        			$tr.find("td:last").find(".up").show();
        			$tr.find("td:last").find(".down").hide();
        		}else{
	        		if($tr.index() == 1){
	        	 		$tr.prev().find("td:last").find(".up").hide();
	        	 		$tr.find("td:last").find(".up").show();
	        	 	}else if($tr.index() == trLength - 1){
	        	 		$tr.prev().find("td:last").find(".down").show(); 
	        	 		$tr.find("td:last").find(".down").hide();
	        	 	}
        		}
        	}
        }
     });
     
     function updateSeq(a,b) {
        var result=true;
     	$.ajax({
				url : "/vst_admin/ticket/goods/goods/updateSeq.do",
				type : "post",
				dataType:"JSON",
				data : {"goodsIdA":a,"goodsIdB":b},
				success : function(result) {
					if (result.code == "success") {
					}else {
						result=false;
						$.alert(result.message);
					}
				}
		});
		return result;
     }
	
	// 查询POI关联产品
	$('a[name=selectProdDestInfo]').bind('click',function(){
		var productId = $(this).attr('data');
		var productName = $(this).attr('data1')+"--POI关联产品";
		new xDialog("/vst_back/combTicket/prod/product/findProdDestReByProductId.do?productId="+productId,{},{title:productName,iframe:true,width:1000,height:550});
	});

	var descDialog;
	
	
 	//desc
	$("a.desc").bind("click",function(){
		var suppGoodsId =$(this).attr("data");
		descDialog = new xDialog("/vst_admin/ticket/goods/goods/suppGoodsDescInit.do",{suppGoodsId:suppGoodsId},{title:"商品描述",width:1050});
	});

	
	$(".fillSmsContent").click(function(){
		suppGoodsId = $(this).attr("data");
		oldSmsContent = $(this).attr("smsContent");
		var htmlArray = [];
		htmlArray.push('<div id="fillSmsContentDiv">');
		htmlArray.push('<div style="margin:5px;"><i class="cc1">*</i>自定义短信：</div>');
		htmlArray.push('<div style="margin:5px;"><input name="smsContent" maxlength="200" onkeydown="checklength(this);" style="width:600px;height:30px;" value="'+ oldSmsContent+'"></input></div>');
		htmlArray.push('<div class="operate" style="margin-left:5px;margin-top:20px;"><a class="btn btn_cc1" id="smsContent_submit">提交</a><a class="btn btn_cc1" id="smsContent_cancel">取消</a></div>');
		htmlArray.push('</div>');
		
		smsContentDialog = pandora.dialog({
	        width: 650,
	        title: "自定义短信",
	        mask : true,
	        content: htmlArray.join('')
		 });
	});
	
	$("#smsContent_cancel").live("click",function(){
		smsContentDialog.close();
	});		

	$("#smsContent_submit").live("click",function(){
		var msg = "确定提交？";
		$.confirm(msg,function(){
			var smsContent = $("input[name='smsContent']").val();
			if(typeof(smsContent)=="undefined" || smsContent =="undefined"){
				$.alert("必须填写短信内容");
				return;
			}
			$.ajax({
				url : "/vst_admin/ticket/goods/goods/fillSmsContent.do",
				type : "post",
				dataType:"JSON",
				data : {"suppGoodsId":suppGoodsId, "content":smsContent},
				success : function(result) {
				if (result.code == "success") {
					$.alert(result.message,function(){
						smsContentDialog.close();
						//window.location.reload();
						if($("#supplierId").val()!=null && $("#supplierId").val()!=""){
							$("#searchForm").submit();
						}
					});
				}else {
					$.alert(result.message);
				}
				}
			});
		});
	});
	
	$( "#supplierName" ).change(function() {
		$("#contractName").text("");
        $("#contractId").val("");
	});
	
	function checklength(obj) {
        if(obj.value.length > 200) {
            obj.value=obj.value.substring(0, 199);
            return;
        }
    }
    
    
gotoGoodsListPage();

//酒店套餐跳转到打包门票商品下供应商下商品页面    
function  gotoGoodsListPage(){
	var windowherf = document.location.href;
	if(windowherf.lastIndexOf("dataId")!=-1 && windowherf.lastIndexOf("dataName")!=-1){
		var link = windowherf.substring(windowherf.lastIndexOf('?')+1,windowherf.length);
		if(link){
			var arr = link.split('&');
			var map = [];
			$.each(arr,function(i,n){
				var keyValue = n.split('=')
				map[keyValue[0]] = keyValue[1];
			
			});
			var dataId = map["dataId"];
			var dataName = decodeURIComponent(map["dataName"]);
			$("#supplierName").val(dataName);
			$("#supplierId").val(dataId);
			$("#search_button").trigger("click");
		}
		}
}
    
function queryBySupplierName()
{
	var automaticQuery = $("#automaticQuery").val();
	var supplierNameQuery = $("#supplierNameQuery").val();
	var supplierIdQuery = $("#supplierIdQuery").val();
	var categoryIdQuery = $("#categoryIdQuery").val();
	var productIdQuery = $("#productIdQuery").val();
	if(automaticQuery=="true" && supplierIdQuery!="")
	{
		$("#supplierName").val(supplierNameQuery);
		var url='/vst_admin/ticket/goods/goods/findSuppGoodsList.do?supplierId='+supplierIdQuery+"&categoryId="+categoryIdQuery+"&productId="+productIdQuery+'&supplierName='+supplierNameQuery;
		$("#searchForm").attr("action",url);
		$("#searchForm").submit();
	}
}
$( "#supplierName" ).change(function() {
    $("#contractName").text("");
    $("#contractId").val("");
}); 
queryBySupplierName(); 
</script>