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
        <div class="aside_box" style="overflow-y: auto;">
            <h2 class="f16">产品维护</h2>
            <ul class="pg_list J_list">
                <li class="active"><a target="iframeMain" href='javascript:void(0);' id="product">基本信息</a>
                <input type="hidden" id="isView" value="${isView}">
                <input type="hidden" id="productId" value="${productId!''}">
                <input type="hidden" id="productName" value="${customizedProduct.productName!''}">
                <input type="hidden" id="categoryId" value="${categoryId}">
                <input type="hidden" id="categoryName" value="${categoryName}">
                <input type="hidden" id="visaDocFlag" value="${visaDocFlag}">
                <input type="hidden" id="productType" value="${productType}">
                <input type="hidden" id="routeFlag" value="${routeFlag}">
                </li>
                 <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productDetail">产品详情</a></li>
                  <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="route">行程</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productSubject">主题设置</a></li>
                 <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showPhoto" maxNum="4"
                	 logType="PROD_PRODUCT_PRODUCT_CHANGE">图片</a>
                </li>
            </ul>
            <h2 class="pg_line f16">预定条款/提示</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="routeHotelcombSuggestion">条款</a></li>
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
// 主题设置
		$("#productSubject").parent("li").click(function(){
			var productId = $("#productId").val();
			if(productId==""){
				$.alert("请先创建产品");
				return;
			}
			// 主题设置
			$.ajax({
				url : "/vst_admin/prod/prodbranch/showProductBranchCheckForCustomizedProduct.do?productId="+productId,
				type : "post",
				async: false,
				dataType : 'json',
				success : function(result) {
					if(result.code == "error"){
						$.alert(result.message);
					}else{
						$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
					 	$("#iframeMain").attr("src","/vst_admin/prod/customized/findProdSubjectListForCustomizedProduct.do?productId="+productId+"&no-cache="+Math.random());
					}
				},
				error : function(result) {
					$.alert(result.message);
				}
			});
		});	

<!--间隔 -->

	var categorySelectDialog;
	$(document).ready(function(){
	
	 var $LI = $(".J_list").find("li"), 
		 $IFRAME = $("#iframeMain"); 

        $LI.click(function () {
			$LI.removeClass("active"); 
			$(this).addClass("active");
			
        });
		
		checkAndJump();
		$("#product").parent("li").click(function(){
			checkAndJump();
		});
		});

	//判断是修改还是添加
	function checkAndJump(){
		//判断有没有产品ID
		var productId = $("#productId").val();
		//打开选择品类
		if(productId==""){
			$("#iframeMain").attr("src","/vst_admin/prod/customized/showAddProduct.do?timestamp="+Math.random(10));
		}else{
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"产品ID："+$("#productId").val());
		    $("#iframeMain").attr("src","/vst_admin/prod/customized/showUpdateProduct.do?customizedProdId="+productId+"&timestamp="+Math.random(10));
		}
	}
	
	
	$("#routeHotelcombSuggestion").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		 	$("#iframeMain").attr("src","/vst_admin/prod/customized/showProductSugg.do?productId="+$("#productId").val()+"&categoryId=-1&suggestionType=Y");
		 	
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
	
	$("#route").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		 	$("#iframeMain").attr("src","/vst_admin/prod/customizedProdLineInfo/showAddOrUpdateCustomizedProdLineInfo.do?productId="+$("#productId").val());
		 	
		}else { 
			$.alert("请先创建产品");
			return;
		}
	});
	
	$("#productDetail").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"产品ID："+$("#productId").val());
			//产品详情添加或修改页面
		 	$("#iframeMain").attr("src","/vst_admin/prod/customizedProdDetail/showAddOrUpdateProductDetail.do?productId="+$("#productId").val());
		 	
		}else { 
			$.alert("请先创建产品");
			return;
		}
	});
	
	//图片
	$("#showPhoto").parent("li").click(function(){
		var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
			return;
		}
		var url="/vst_admin/prod/customized/findComPhotoListForCustomized.do?objectId="+productId+"";
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
	
	
</script>