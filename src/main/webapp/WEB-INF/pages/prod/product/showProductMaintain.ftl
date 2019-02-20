<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/ui-panel.css">
</head>
<body>
    <!-- 顶部导航\\ -->
    <div class="pg_topbar">
        <h1 class="pg_title">添加产品</h1>
    </div>
    <!-- 边栏\\ -->
    <div class="pg_aside">
        <div class="aside_box">
            <h2 class="f16">产品维护</h2>
            <ul class="pg_list J_list">
                <li class="active"><a target="iframeMain" href='javascript:void(0);' id="product">基本信息</a>
                <input type="hidden" id="isView" value="${isView}">
                <input type="hidden" id="productId" value="${productId}">
                <input type="hidden" id="productName" value="${productName}">
                <input type="hidden" id="categoryId" value="${categoryId}">
                <input type="hidden" id="categoryName" value="${categoryName}">
                </li>
                 <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showPhoto" 
                	<#if categoryId == 11 || categoryId == 12>maxNum="5" minNum="5"</#if> 
                	 logType="PROD_PRODUCT_PRODUCT_CHANGE">图片</a>
                </li>
                <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showWirelessPhoto">
                	智能货架大图</a>
                </li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productVideo">视频</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productBranch">产品规格</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productSubject">主题设置</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productProperty">产品属性</a></li>
                 <!--后期使用-->
                 <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="freebiePack">酒店赠品打包</a></li>
            </ul>
            <h2 class="pg_line f16">商品维护</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="suppGoods">销售信息</a></li>
                <!--<li class="cc1"><a target="iframeMain" href='javascript:void(0);'  id="suppInventorySharing">设置库存共享</a></li>-->
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);'  id="suppInventorySharingNew">设置总库存</a></li>
                
           		<!--<li class="cc1"><a target="iframeMain" href='javascript:void(0);'  id="suppGoodsRelation">设置主次关联</a></li>-->
            </ul>
        </div>
    </div>
    <!-- //工作区 -->
<div class="pg_main" style="height:93%;">
    <iframe id="iframeMain" name="iframeMain" src="" frameborder="0" style=" height:100%; background:#fff"></iframe>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
	var categorySelectDialog;
	$(document).ready(function(){
	
	 var $LI = $(".J_list").find("li"), 
		 $IFRAME = $("#iframeMain"); 

        $LI.click(function () {
			$LI.removeClass("active"); 
			$(this).addClass("active");
			
        });
		
		checkAndJump();
		gotoGoodsListPage();
		$("#product").parent("li").click(function(){
			checkAndJump();
		});
		
		//产品规格
		$("#productBranch").parent("li").click(function(){
			var productId = $("#productId").val();
			var categoryId = $("#categoryId").val();
			if(productId==""){
				$.alert("请先创建产品");
				return;
			}
			//验证产品
			$.ajax({
					url : "/vst_admin/prod/product/showProductBranchCheck.do?productId="+productId,
					type : "post",
					async: false,
					dataType : 'json',
					success : function(result) {
						if(result.code == "error"){
							$.alert(result.message);
						}else{
							$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
						 	$("#iframeMain").attr("src","/vst_admin/prod/prodbranch/findProductBranchList.do?productId="+productId+"&categoryId="+categoryId);
						}
					},
					error : function(result) {
						$.alert(result.message);
					}
				});
			});
		});
		
		// 主题设置
		$("#productSubject").parent("li").click(function(){
			var productId = $("#productId").val();
		   var  categoryId = $("#categoryId").val();
			if(productId==""){
				$.alert("请先创建产品");
				return;
			}
			// 主题设置
			$.ajax({
				url : "/vst_admin/prod/product/showProductBranchCheck.do?productId="+productId,
				type : "post",
				async: false,
				dataType : 'json',
				success : function(result) {
					if(result.code == "error"){
						$.alert(result.message);
					}else{
						/* $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val()); */
					 	 $("#iframeMain").attr("src","/vst_admin/biz/prodSubject/findProdSubjectList.do?productId="+productId+"&categoryId="+categoryId+"&no-cache="+Math.random());
					}
				},
				error : function(result) {
					$.alert(result.message);
				}
			});
		});	
		
		//产品属性
		$("#productProperty").parent("li").click(function(){
			var productId = $("#productId").val();
			var categoryId = $("#categoryId").val();
			if(productId==""){
				$.alert("请先创建产品");
				return;
			}
			//验证产品
			$.ajax({
				url : "/vst_admin/prod/product/showProductBranchCheck.do?productId="+productId,
				type : "post",
				async: false,
				dataType : 'json',
				success : function(result) {
					if(result.code == "error"){
						$.alert(result.message);
					}else{
						$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
					 	$("#iframeMain").attr("src","/vst_admin/prod/productAttr/findProdProductAttr.do?productId="+productId+"&categoryId="+categoryId);
					}
				},
				error : function(result) {
					$.alert(result.message);
				}
			});
		});

	//判断是修改还是添加
	function checkAndJump(){
		//判断有没有产品ID
		var productId = $("#productId").val();
		var categoryId = $("#categoryId").val();
		//打开选择品类
		if(productId==""){
			$("#iframeMain").attr("src","/vst_admin/prod/product/showAddProduct.do?categoryId="+categoryId+"&timestamp="+Math.random(10));
		}else{
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		    $("#iframeMain").attr("src","/vst_admin/prod/product/showUpdateProduct.do?productId="+productId+"&timestamp="+Math.random(10));
		}
	}
	//共享库存
	$("#suppInventorySharing").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$.ajax({
						url : "/vst_admin/goods/goods/showSuppGoodsListCheck.do?productId="+$("#productId").val(),
						type : "post",
						async: false,
						dataType : 'json',
						success : function(result) {
							if(result.code == "error"){
								$.alert(result.message);
							}else{
								$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
							 	$("#iframeMain").attr("src","/vst_admin/goods/goodsGroup/showSuppInventorySharingList.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
							}
						},
						error : function(result) {
							$.alert(result.message);
						}
					});
		}
	});
	
	//查询共享库存组列表New add by zhoudengyun
	$("#suppInventorySharingNew").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$.ajax({
						url : "/vst_admin/goods/goods/showSuppGoodsListCheck.do?productId="+$("#productId").val(),
						type : "post",
						async: false,
						dataType : 'json',
						success : function(result) {
							if(result.code == "error"){
								$.alert(result.message);
							}else{
								$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
							 	$("#iframeMain").attr("src","/vst_admin/goods/goodsGroup/showSuppInventorySharingList.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
							}
						},
						error : function(result) {
							$.alert(result.message);
						}
					});
		}
	});
	
	
	//设置主次关联
	$("#suppGoodsRelation").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$.ajax({
						url : "/vst_admin/goods/goods/showSuppGoodsListCheck.do?productId="+$("#productId").val(),
						type : "post",
						async: false,
						dataType : 'json',
						success : function(result) {
							if(result.code == "error"){
								$.alert(result.message);
							}else{
								$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
							 	$("#iframeMain").attr("src","/vst_admin/goods/goodsRelation/showGoodsRelationList.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
							}
						},
						error : function(result) {
							$.alert(result.message);
						}
					});
		}
	});
	
	$("#suppGoods").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$.ajax({
				url : "/vst_admin/goods/goods/showSuppGoodsListCheck.do?productId="+$("#productId").val(),
				type : "post",
				async: false,
				dataType : 'json',
				success : function(result) {
					if(result.code == "error"){
						$.alert(result.message);
					}else{
						$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
					 	$("#iframeMain").attr("src","/vst_admin/goods/goods/showSuppGoodsList.do?productId="+$("#productId").val());
					}
				},
				error : function(result) {
					$.alert(result.message);
				}
			});
		}
	});
	
	//图片
	$("#showPhoto").parent("li").click(function(){
		var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
			return;
		}
		var url="/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_3_2_3L";
		var maxNum = $(this).attr("maxNum");
		if(maxNum != null && maxNum.length > 0){
			url += "&maxNum=" + maxNum;
		}
		var minNum = $(this).attr("minNum");
		if(minNum != null && minNum.length > 0){
			url += "&minNum=" + minNum;
		}
		//showPhotoDialog = new xDialog(url,{},{title:"图片列表",iframe:false,width:"885px",height:"1000px"});
		$("#iframeMain").attr("src", url);
	});
	
	//智能货架大图
    $("#showWirelessPhoto").parent("li").click(function(){
        var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
			return;
		}
        var url="/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID_WIRELESS&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_1242_450";
        url += "&maxNum=1";
        $("#iframeMain").attr("src", url);
    });
	
	// 视频
	$("#productVideo").parent("li").click(function() {
		$.ajax({
			url: "/vst_admin/prod/product/showProductBranchCheck.do?productId=${productId}",
			type: "post",
			dataType: "json",
			async: false,
			success: function(result) {
				if(result.code == "error") {
					$.alert(result.message);
				}else {
					$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
					$("#iframeMain").attr("src", "/vst_admin/prod/prodVideo/showProductVideo.do?productId=${productId}&categoryId=${categoryId}");
				}
			},
			error: function(result) {
				$.alert(result.message);
			}
		});
	});// 视频END
	
//酒店套餐打包添加门票或酒店时链接到规格或商品页面	
function  gotoGoodsListPage(){
var windowherf = document.location.href;
	if(windowherf.indexOf("hotelCommbGotoPackegGoodPage")!=-1){
		var link = windowherf.substring(windowherf.lastIndexOf('?')+1,windowherf.length);
		if(link){
			var arr = link.split('&');
			var map = [];
			$.each(arr,function(i,n){
				var keyValue = n.split('=')
				map[keyValue[0]] = keyValue[1];
			
			});
			var falg = map["hotelCommbGotoPackegGoodPage"];
			if(falg){
				var htoelCommbparms = link;
				var url;
				if(falg == 'Y'){
					url = "/vst_admin/ticket/goods/goods/showSuppGoodsList.do?"+htoelCommbparms;
					$("#suppGoods").parent("li").attr("class","active");
				}else if(falg =='N'){
					url = "/vst_admin/prod/prodbranch/findProductBranchList.do?"+htoelCommbparms;
					$("#productBranch").parent("li").attr("class","active");
				}
				if(url !=null){
				$("#iframeMain").attr("src",url);
				$("#product").parent("li").attr("class","");
				
				}
			}
			
		}
	}
}
	
//酒店赠品打包
$("#freebiePack").parent("li").click(function(){
	var productId = $("#productId").val();
	var categoryId = $("#categoryId").val();
	if(productId==""){
		$.alert("请先创建产品");
		return;
	}
	$("#iframeMain").attr("src","/vst_admin/hotel/freebie/showFreebieList.do?productId="+productId+"&categoryId="+categoryId);
});
	
</script>