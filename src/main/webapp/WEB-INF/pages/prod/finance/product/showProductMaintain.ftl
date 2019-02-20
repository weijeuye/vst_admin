<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<#include "/base/head_meta.ftl"/>
	<link rel="stylesheet" href="/vst_admin/css/ui-panel.css">
</head>
<body class="pg_body">
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
                <input type="hidden" id="groupType">
                <input type="hidden" id="saveRouteFlag" value="${saveRouteFlag}">
                <input type="hidden" id="saveTransportFlag" value="${saveTransportFlag}">
                <input type="hidden" id="visaDocFlag" value="${visaDocFlag}">
                <input type="hidden" id="productType" value="${productType}">
                <input type="hidden" id="routeFlag" value="${routeFlag}">
                <input type="hidden" id="packageType" value="${packageType}">
                <input type="hidden" id="transportType" value="">
                <input type="hidden" id="bu" value="${bu}">
                <input type="hidden" id="auto_pack_traffic" value="${auto_pack_traffic}">
                <input type="hidden" id="isuse_packed_route_details" value="${isuse_packed_route_details}">
                <input type="hidden" id="modelVersion" value="${modelVersion}">
                <input type="hidden" id="modelVersionToNew" value="${modelVersionToNew!''}"> 
            </li>
            <li><a target="iframeMain" id="showPhoto">图片</a></li>
            <!-- <li><a target="iframeMain" href="05-常见问题.html">常见问题</a></li> -->
        </ul>
        <h2 class="pg_line f16">商品维护</h2>
        <ul class="pg_list J_list">
            <li><a target="iframeMain" id="suppGoodsBtn">销售信息</a></li>
        </ul>

    </div>
</div>
<!-- //工作区 -->
<div class="pg_main" style="height:93%;">
    <iframe id="iframeMain" name="iframeMain" src="" frameborder="0" style=" height:100%; background:#fff"></iframe>
</div>
<#include "/base/foot.ftl"/>
<script type="text/javascript">
    $(function () {
        var $LI = $(".J_list").find("li"),
                $IFRAME = $("#iframeMain");

        $LI.click(function () {
            var url = $(this).find("a").attr("href");

            $LI.removeClass("active");
            $(this).addClass("active");
            $IFRAME.attr("src", url);
        });
    });
    
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
	
	function refreshProdFundLabel() {
		var productType = $("#productType").val();
		var packageType = $("#packageType").val();
		if (packageType=='LVMAMA' && (productType=='INNER_BORDER_LINE' || productType=='INNERLINE' || productType=='INNERLONGLINE' || productType=='INNERSHORTLINE')) {
			$("#prodFund1").html("团期维护");
		}
	}
	
	
	//判断是修改还是添加
	function checkAndJump(){
		//判断有没有产品ID
		var productId = $("#productId").val();
		var categoryId = $("#categoryId").val();
		//打开选择品类
		if(productId==""){
			$("#iframeMain").attr("src","/vst_admin/finance/prod/product/showAddProduct.do?categoryId="+categoryId+"&timestamp="+Math.random(10));
		}else{
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		    $("#iframeMain").attr("src","/vst_admin/finance/prod/product/showUpdateProduct.do?productId="+productId+"&timestamp="+Math.random(10));
		}
	}
	
	//图片
	$("#showPhoto").parent("li").click(function(){
		var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
			return;
		}
		
		var url="/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_3_2_3L";
		//showPhotoDialog = new xDialog(url,{},{title:"图片列表",iframe:false,width:"885px",height:"1000px"});
		$("#iframeMain").attr("src", url);
	});

    //销售信息
    leftMenuClickHandler("#suppGoodsBtn", function() {
        $("#iframeMain").attr("src","/vst_admin/finance/goods/showSuppGoodsList.do?productId="+$("#productId").val());
    });

    function isEmptyValue(val) {
        return val == null || val == "";
    }

    function leftMenuClickHandler(menuId, callFun) {
        $(menuId).parent("li").click(function () {
            var productId = $("#productId").val();
            if (isEmptyValue(productId)) {
                $.alert("请先创建产品");
                return;
            }
            var url = "/vst_admin/finance/goods/showSuppGoodsListCheck.do?productId="+productId;
            //验证产品
            $.ajax({
                url: url,
                type: "post",
                async: false,
                dataType: 'json',
                success: function (result) {
                    if (result.code == "error") {
                        $.alert(result.message);
                    } else {
                        callFun();
                    }
                },
                error: function (result) {
                    $.alert(result.message);
                }
            });
        });
    }
</script>
</body>
</html>