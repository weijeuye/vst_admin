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
                <input type="hidden" id="productId" value="${productId}">
                <input type="hidden" id="productName" value="${productName}">
                <input type="hidden" id="productType" value="${productType}">
                <input type="hidden" id="categoryId" value="${categoryId}">
                <input type="hidden" id="categoryName" value="${categoryName}">
                <input type="hidden" id="routeFlag" value="${routeFlag}">
                <input type="hidden" id="visaDocFlag" value="${visaDocFlag}">
                <input type="hidden" id="saveRouteFlag" value="${saveRouteFlag}">
                <input type="hidden" id="saveTransportFlag" value="${saveTransportFlag}">
                <input type="hidden" id="bu" value="${bu}">
                <input type="hidden" id="groupType">
                <#-- 打包类型 --->
                <input type="hidden" id="packageType" value="${packageType}">
                <#-- 是否有大交通 --->
                <input type="hidden" id="transportType" value="${transportType}">
                </li>
                <#if categoryId == 15 || categoryId == 16 || categoryId==17 || categoryId == 18>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="prodFeature">产品特色</a></li>
                </#if>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="route">行程</a></li>
                <li class="cc1" id="transportLi"><a target="iframeMain" href='javascript:void(0);' id="transport">交通</a></li>
            <!--    <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="prodContractDetail">合同条款</a></li> -->
                 <li class="cc1">
                    <a target="iframeMain" href='javascript:void(0);' id="showPhoto" 
                    <#if categoryId == 11 || categoryId == 12>maxNum="5" minNum="5"</#if> 
                     logType="PROD_PRODUCT_PRODUCT_CHANGE">图片</a>
                 </li>
                <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showWirelessPhoto">
                	智能货架大图</a>
                </li>
                <#if (categoryId == 15 || categoryId == 16) && (productBu!'') == "LOCAL_BU">
                	<li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productVideo_local">视频</a></li>
                </#if>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productSubject">主题设置</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productPlayMethod">玩法设置</a></li>
            </ul>
            <div id="supplier" style="display:none">
            <h2 class="pg_line f16">商品维护</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="suppGoodsBase">商品基础设置</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="suppGoods">销售信息</a></li>
            </ul>
            <h2 class="pg_line f16">预定条款/提示</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="routeGroupSuggestion">条款</a></li>
            </ul>
            <h2 class="pg_line f16">运营</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' name="prodGoodsRe">关联销售</a></li>
                <#if productType == 'INNERLINE' || productType == 'INNERSHORTLINE' || productType == 'INNERLONGLINE'>
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGroup">产品关联</a></li>
                </#if>
                <#if (bu == 'LOCAL_BU' || bu == 'OUTBOUND_BU') && categoryId == 15 >
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="associationRecommend">关联推荐</a></li>
                </#if>
                <!-- <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="">促销</a></li> -->
            </ul>
            </div>
            <div id="lvmama" style="display:none">
            <h2 class="pg_line f16">组合设计</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="traffic">选择交通</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="hotel">选择酒店</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="line">选择线路</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="ticket">选择门票</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="prodFund1">退改规则</a></li>
            </ul>
            <h2 class="pg_line f16">预定条款/提示</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="routeGroupSuggestion">条款</a></li>
            </ul>
            <h2 class="pg_line f16">运营</h2>
            <ul class="pg_list J_list">
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' name="prodGoodsRe">关联销售</a></li>
                <#if productType == 'INNERLINE' || productType == 'INNERSHORTLINE' || productType == 'INNERLONGLINE'>
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGroup">产品关联</a></li>
                </#if>
               	<#if (bu == 'LOCAL_BU' || bu == 'OUTBOUND_BU') && categoryId == 15 >
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="associationRecommend">关联推荐</a></li>
                </#if>
                <!-- <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="">促销</a></li> -->
            </ul>
            </div>
        </div>
    </div>
    <!-- //工作区 -->
<div class="pg_main">
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
        $("#product").parent("li").click(function(){
            checkAndJump();
        });
    });

    //判断是修改还是添加
    function checkAndJump(){
        //判断有没有产品ID
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        //打开选择品类
        if(productId==""){
            $("#iframeMain").attr("src","/vst_admin/dujia/group/product/showAddProduct.do?categoryId="+categoryId+"&timestamp="+Math.random(10));
        }else{
            $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
            $("#iframeMain").attr("src","/vst_admin/dujia/group/product/showUpdateProduct.do?productId="+productId+"&timestamp="+Math.random(10));
        }
    }

	//产品特色
    $("#prodFeature").parent("li").click(function(){
    	//判断有没有产品ID
        var productId = $("#productId").val();
        var packageType = $("#packageType").val();
        var productType=$("#productType").val();
        if($("#productId").val()!=null && $("#productId").val()!=""){
        	$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
            $("#iframeMain").attr("src","/vst_admin/dujia/group/product/showUpdateProductFeature.do?productId="+productId+"&packageType="+packageType+"&productType="+productType+"&timestamp="+Math.random(10));
        }else {
            $.alert("请先创建产品"); 
            return;
        }
    });
    
    // 玩法设置
    $("#productPlayMethod").parent("li").click(function(){
    	//判断有没有产品ID
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        if($("#productId").val()!=null && $("#productId").val()!=""){
        	$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
            $("#iframeMain").attr("src","/vst_admin/connects/prod/playMethod/selectMainPlayMethodCategory.do?productId="+productId+"&categoryId="+categoryId+"&timestamp="+Math.random(10));
        }else {
            $.alert("请先创建产品"); 
            return;
        }
    });
    
    //销售信息
    $("#suppGoods").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            //校验
            if(!validAll()){
              return;
            }
            $("#iframeMain").attr("src","/vst_admin/lineMultiroute/goods/timePrice/showGoodsTimePrice.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val()+"&productType="+$("#productType").val()+"&packageType="+$("#packageType").val());
        }else {
            $.alert("请先创建产品"); 
            return;
        }
    });
//点击产品关联
	$("a[name=prodGroup]").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		 	$("#iframeMain").attr("src","/vst_admin/dujia/group/product/findProdGroupList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
		 	
		}else { 
			$.alert("请先创建产品");
			return;
		}
	});
    //交通信息
    $("#transport").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
            if(!validateRoute()){
                $("#route").parent("li").trigger("click");
                $.alert("请先创建行程明细");
                return;
            }
            $("#iframeMain").attr("src","/vst_admin/prod/traffic/findProdTraffic.do?productId="+$("#productId").val());
        }else {
            $.alert("请先创建产品");
            return;
        }
    });

    $("a[name='prodGoodsRe']").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
            if(!validateRoute()){
                $("#route").parent("li").trigger("click");
                $.alert("请先创建行程明细");
                return;
            }
            // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
            if(!validateTraffic()){
                if(confirm("请先添加交通信息,确认添加交通信息吗？")){
                    $("#transport").parent("li").trigger("click");
                }
                return;
            }
             $("#iframeMain").attr("src","/vst_admin/tour/goods/goods/findGoodsSaleReList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
        }else {
            $.alert("请先创建产品");
            return;
        }
    });


	//关联推荐
	$("a[name='associationRecommend']").parent("li").click(function(){
		if($("#productId").val()!=null && $("#productId").val()!=""){
		 	var url = "/vst_admin/associationRecommend/findAssociationRecommendList.do?prodProductId="
				+ $("#productId").val()+"&categoryId="+$("#categoryId").val() + "&bu=" + $("#bu").val()
		 	$("#iframeMain").attr("src", url);
		}else {
			$.alert("请先创建产品");
			return;
		}
	});

    $("#suppGoodsBase").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            //校验
            if(!validAll()){
              return;
            }

            $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
             $("#iframeMain").attr("src","/vst_admin/tour/goods/goods/showBaseSuppGoods.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
        }else {
            $.alert("请先创建产品");
            return;
        }
    });

    $("#routeGroupSuggestion").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            //校验
            if(!validAll()){
              return;
            }
            $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
            var url = "/vst_admin/dujia/group/product/showUpdateProductSugg.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val()+"&suggestionType=Y"
             $("#iframeMain").attr("src",url);

        }else {
            $.alert("请先创建产品");
            return;
        }
    });

    $("#route").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){
            $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
             $("#iframeMain").attr("src","/vst_admin/packageTour/prod/product/showUpdateRoute.do?productId="+$("#productId").val());
        }else { 
            $.alert("请先创建产品");
            return;
        }
    });

    $("#prodFund1").parent("li").click(function(){
        if($("#productId").val()!=null && $("#productId").val()!=""){

            $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
             $("#iframeMain").attr("src","/vst_admin/prod/refund/showProductReFund.do?productId="+$("#productId").val());
        }else {
            $.alert("请先创建产品");
            return;
        }
    });
 
    //国内视频
    $("#productVideo_local").parent("li").click(function(){
	    var productId = $("#productId").val();
	    var categoryId = $("#categoryId").val();
		if(productId=="" || productId==null){
			$.alert("请先创建产品");
			return;
		}
	    $("#iframeMain").attr("src", "/vst_admin/prod/prodVideo/showProductVideo_local.do?productId="+ productId + "&categoryId=" + categoryId);
	});
	
    // 主题设置
    $("#productSubject").parent("li").click(function(){
        var productId = $("#productId").val();
        if(productId==""){
            $.alert("请先创建产品");
            return;
        }
        // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
        if(!validateRoute()){
            $("#route").parent("li").trigger("click");
            $.alert("请先创建行程明细");
            return;
        }
        // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
        if(!validateTraffic()){
            if(confirm("请先添加交通信息,确认添加交通信息吗？")){
                $("#transport").parent("li").trigger("click");
            }
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
                    $(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
                     $("#iframeMain").attr("src","/vst_admin/biz/prodSubject/findProdSubjectList.do?productId="+productId+"&no-cache="+Math.random());
                }
            },
            error : function(result) {
                $.alert(result.message);
            }
        });
    });

    //图片
    $("#showPhoto").parent("li").click(function(){
        var productId = $("#productId").val();
        if(productId==""){
            $.alert("请先创建产品");
            return;
        }
        // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
        if(!validateRoute()){
            $("#route").parent("li").trigger("click");
            $.alert("请先创建行程明细");
            return;
        }

        // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
        if(!validateTraffic()){
            if(confirm("请先添加交通信息,确认添加交通信息吗？")){
                $("#transport").parent("li").trigger("click");
            }
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
        // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
        if(!validateRoute()){
            $("#route").parent("li").trigger("click");
            $.alert("请先创建行程明细");
            return;
        }

        // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
        if(!validateTraffic()){
            if(confirm("请先添加交通信息,确认添加交通信息吗？")){
                $("#transport").parent("li").trigger("click");
            }
            return;
        }

        var url="/vst_admin/pub/comphoto/findComPhotoList.do?objectId="+productId+"&parentId="+productId+"&objectType=PRODUCT_ID_WIRELESS&logType=PROD_PRODUCT_PRODUCT_CHANGE&imgLimitType=LIMIT_1242_450";
        url += "&maxNum=1";
        $("#iframeMain").attr("src", url);
    });

    // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
    function validateRoute(){
        var categoryId = $('#categoryId').val();
        if(categoryId==15){
            var saveRouteFlag = $('#saveRouteFlag').val();
            if(saveRouteFlag=='false' || saveRouteFlag.length<=0){
                return false;
            }
        }

        return true;
    }

    // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
    function validateTraffic(){
        var categoryId = $('#categoryId').val();//品类
        var packageType = $('#packageType').val();//打包类型
        var transportType = $('#transportType').val();//是否包含大交通

        if(categoryId == 15 && "SUPPLIER" == packageType && "Y" == transportType){
            var saveTransportFlag = $('#saveTransportFlag').val();
            if(saveTransportFlag=='false' || saveTransportFlag.length <= 0){
                return false;
            }
        }

        return true;
    }

    //校验行程
    function validRoute(){
       var routeFlag = $('#routeFlag').val();
       if(routeFlag=='false'|| routeFlag==''){
           return false;
       }
       return true;
    }

    //校验行程、行程明细、签证
    function validAll(){
        //行程校验
        if(!validRoute()){
           $("#route").parent("li").trigger("click");
            $.alert("请创建行程");
            return false;
        }


        // 验证线路行程，跟团游(必须先保存行程以后才能操作除基础信息以外所有的菜单)
        if(!validateRoute()){
            $("#route").parent("li").trigger("click");
            $.alert("请先创建行程明细");
            return false;
        }

        // 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
        if(!validateTraffic()){
            if(confirm("请先添加交通信息,确认添加交通信息吗？")){
                $("#transport").parent("li").trigger("click");
            }
            return;
        }
        return true;
    }

</script>