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
                <input type="hidden" id="categoryId" value="${categoryId}">
                <input type="hidden" id="subCategoryId" value="${subCategoryId}">
                <input type="hidden" id="categoryName" value="${categoryName}">
                <input type="hidden" id="visaDocFlag" value="${visaDocFlag}">
                <input type="hidden" id="productType" value="${productType}">
                <input type="hidden" id="routeFlag" value="${routeFlag}">
                <input type="hidden" id="saveTransportFlag" value="${saveTransportFlag}">
                <input type="hidden" id="packageType" value="${packageType}">
                <input type="hidden" id="transportType" value="">
                <input type="hidden" id="bu" value="${bu}">
                <input type="hidden" id="modelVersion" value="${modelVersion}">
                </li>
                <#if categoryId == 15 || categoryId == 16 || categoryId==17 || categoryId == 18>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="prodFeature">产品特色</a></li>
                </#if>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);'  id="route">行程</a></li>
                <li class="cc1" id="transportLi" style="display:none"><a target="iframeMain" href='javascript:void(0);' id="transport">交通</a></li>
                <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showPhoto" 
                	<#if categoryId == 11 || categoryId == 12>maxNum="5" minNum="5"</#if> 
                	 logType="PROD_PRODUCT_PRODUCT_CHANGE">图片</a>
                </li>
                <li class="cc1">
                	<a target="iframeMain" href='javascript:void(0);' id="showWirelessPhoto">
                	智能货架大图</a>
                </li>
                <#if packageType == "LVMAMA" && (productBU!'') == "DESTINATION_BU">
                	<li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productVideo">视频</a></li>
                </#if>
                <#if subCategoryId == 182 && (productBU!'') == "LOCAL_BU">
                	<li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productVideo_local">视频</a></li>
                </#if>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productSubject">主题设置</a></li>
                <li class="cc1"><a target="iframeMain" href='javascript:void(0);' id="productPlayMethod">玩法设置</a></li>
                
            </ul>
            <div id="supplier" style="display:none">
            <h2 class="pg_line f16">商品维护</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="suppGoodsBase">商品基础设置</a></li>
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="suppGoods">销售信息</a></li>
            </ul>
            <h2 class="pg_line f16">预定条款/提示</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="routeGroupSuggestion">条款</a></li>
            </ul>
            <h2 class="pg_line f16">运营</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGoodsRe">关联销售</a></li>
                <!-- <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="">促销</a></li> -->
                <#if (subCategoryId == 182 || subCategoryId== 183|| subCategoryId== 184) && 
                	(productType == 'INNERLINE' || productType == 'INNERSHORTLINE' || productType == 'INNERLONGLINE')>
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGroup">产品关联</a></li>
               	<#else>
               		<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGroup">产品关联</a></li>
                </#if>
                <#if bu == 'LOCAL_BU' || bu == 'OUTBOUND_BU' || bu == 'DESTINATION_BU'>
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="associationRecommend">关联推荐</a></li>
                </#if>
            </ul>
            </div>
            <div id="lvmama" style="display:none">
            <h2 class="pg_line f16">组合设计</h2>
            <ul class="pg_list J_list">           		
                <#if subCategoryId ?? &&subCategoryId == 181>
                <#else>
                	<#if auto_pack_traffic != 'Y'>
                	     <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="traffic">选择交通</a></li>
                	</#if>
                </#if>
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="hotel">选择酒店</a></li>
                <#if subCategoryId ?? &&subCategoryId == 184>
                <#else>
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="line">选择线路</a></li>
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="ticket">选择门票</a></li>
                </#if>
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="prodFund1">
                	<#if packageType=='LVMAMA' && (productType=='INNERLINE' || productType=='INNERLONGLINE' || productType=='INNERSHORTLINE')>团期维护<#else>退改规则</#if></a>
                </li>
            </ul>
            <h2 class="pg_line f16">预定条款/提示</h2>
            <ul class="pg_list J_list">           		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="routeGroupSuggestion">条款</a></li>
            </ul>
            <h2 class="pg_line f16">运营</h2>
            <ul class="pg_list J_list">      
            <#if subCategoryId ?? &&subCategoryId == 184>
            <#else>    		
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGoodsRe">关联销售</a></li>
            </#if>
                <!-- <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  id="">促销</a></li> -->
                <li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="prodGroup">产品关联</a></li>
                <#if bu == 'LOCAL_BU' || bu == 'OUTBOUND_BU' || bu == 'DESTINATION_BU'>
                	<li class="cc1"><a 	target="iframeMain" href='javascript:void(0);'  name="associationRecommend">关联推荐</a></li>
                </#if>
            </ul>
            </div>
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
    function isTraffic(autoPackTraffic){
        if(autoPackTraffic != undefined && autoPackTraffic == 'Y'){
            $("#traffic").parent("li").hide();
        }else{
            $("#traffic").parent("li").show();
        }
    }

	var categorySelectDialog,showPhotoDialog;
	$(document).ready(function(){
	
	 var $LI = $(".J_list").find("li"), 
		 $IFRAME = $("#iframeMain"); 

        $LI.click(function () {
			$LI.removeClass("active"); 
			$(this).addClass("active");
			
        });
		
		checkAndJump();
		$("#product").parent("li").click(function(){
			if(travelAlertHasChanges(this)){ return }
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
		var subCategoryId = $("#subCategoryId").val();
		//打开选择品类
		if(productId==""){
			$("#iframeMain").attr("src","/vst_admin/packageTour/prod/product/showAddProduct.do?categoryId="+categoryId+"&subCategoryId="+subCategoryId+"&timestamp="+Math.random(10));
		}else{
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		    $("#iframeMain").attr("src","/vst_admin/packageTour/prod/product/showUpdateProduct.do?productId="+productId+"&timestamp="+Math.random(10));
		}
	}
	//产品特色
    $("#prodFeature").parent("li").click(function(){
    	if(travelAlertHasChanges(this)){ return }
    	//判断有没有产品ID
        var productId = $("#productId").val();
        var categoryId = $("#categoryId").val();
        var packageType = $("#packageType").val();
        if($("#productId").val()!=null && $("#productId").val()!=""){
        	$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());$("#subCategoryId").val();
            $("#iframeMain").attr("src","/vst_admin/packageTour/prod/product/showUpdateProductFeature.do?productId="+productId+"&categoryId="+categoryId+"&packageType="+packageType+"&subCategoryId="+$("#subCategoryId").val()+"&timestamp="+Math.random(10));
        }else {
            $.alert("请先创建产品"); 
            return;
        }
    });
    
    // 玩法设置
    $("#productPlayMethod").parent("li").click(function(){
    	if(travelAlertHasChanges(this)){ return }
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

	$("#suppGoods").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
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
	
	
	//交通信息
	$("#transport").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
		if($("#productId").val()!=null && $("#productId").val()!=""){
			$("#iframeMain").attr("src","/vst_admin/prod/traffic/findProdTraffic.do?addFlag=false&productId="+$("#productId").val());
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
	
	$("a[name='prodGoodsRe']").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
		// 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
		if(!validateTraffic()){
			if(confirm("请先添加交通信息,确认添加交通信息吗？")){
				$("#transport").parent("li").trigger("click");
			}
			return;	
		}	
				
		if($("#productId").val()!=null && $("#productId").val()!=""){
		 	$("#iframeMain").attr("src","/vst_admin/tour/goods/goods/findGoodsSaleReList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
	
	//产品关联
	$("a[name='prodGroup']").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
		if($("#productId").val()!=null && $("#productId").val()!="" && $("#subCategoryId").val()=="182"){
			$("#iframeMain").attr("src","/vst_admin/selfTour/prod/product/flighthotel/findProdGroupList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
		}else if($("#productId").val()!=null && $("#productId").val()!="" && ($("#subCategoryId").val()=="183"||$("#subCategoryId").val()=="184")){
			$("#iframeMain").attr("src","/vst_admin/selfTour/prod/product/trafficservice/findProdGroupList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
		}else if($("#productId").val()!=null && $("#productId").val()!="" ){
		 	$("#iframeMain").attr("src","/vst_admin/selfTour/prodGroup/findProdGroupList.do?prodProductId="+$("#productId").val()+"&categoryId="+$("#categoryId").val());
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
	
	//关联推荐
	$("a[name='associationRecommend']").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
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
		if(travelAlertHasChanges(this)){ return }
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
	
	$("#prodFund1").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
		if($("#productId").val()!=null && $("#productId").val()!=""){
			 
			
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
		 	$("#iframeMain").attr("src","/vst_admin/prod/refund/showProductReFund.do?productId="+$("#productId").val());
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
	
	
	window.travelAlertHasChanges = function($this){
		//优先处理国内景酒
		var subCategoryId = $("#subCategoryId").val();
		var productType = $("#productType").val();
		var isLocalScenicHotel = subCategoryId == 181 && productType== "INNERLINE";
		var menuId = $($this).find("a").attr("id");
		if(isLocalScenicHotel && menuId != 'routeGroupSuggestion') {
			if(window.frames['iframeMain'].hasChanges ){
				var ret = window.frames['iframeMain'].hasChanges();
				if(!ret.isOK ){
					var hasChanges = confirm(ret.msg);
					if(hasChanges) {
						$this.removeClass("active");
						$("#routeGroupSuggestion").parent().addClass("active");
					}
					return hasChanges;
				}
			}
		}
		return false;
	}
	
	
   $("#routeGroupSuggestion,#traffic,#hotel,#line,#ticket").parent("li").click(function(){
   		if(travelAlertHasChanges(this)){ return }
		if($("#productId").val()!=null && $("#productId").val()!=""){
			//校验
			if(!validAll()){
			  return;
			}
			
			$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
			
			var menuId = $(this).children().eq(0).attr("id");
			var url = "";
			if(menuId == 'traffic'){
				$("#groupType").val("TRANSPORT");
				url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=TRANSPORT";
			}else if(menuId == 'hotel'){ 
				//自主打包 酒店
				$("#groupType").val("HOTEL");
				url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=HOTEL";
			}else if(menuId == 'line'){
				$("#groupType").val("LINE");
				url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=LINE";
			}else if(menuId == 'ticket'){
				$("#groupType").val("LINE_TICKET");
				url = "/vst_admin/productPack/line/showPackList.do?productId="+$("#productId").val() + "&groupType=LINE_TICKET";
			}else if(menuId == 'routeGroupSuggestion'){
				//优先处理国内景酒
				var subCategoryId = $("#subCategoryId").val();
				var productType = $("#productType").val();
				var isLocalScenicHotel = subCategoryId == 181 && productType== "INNERLINE";
				if(isLocalScenicHotel) {
					url = "/vst_admin/scenicHotel/loadTravelAlert.do?productId=" + $("#productId").val() + "&productType=" + productType ;
				} else if($("#modelVersion").val() == 'true'){
				  url = "/vst_admin/dujia/group/product/showUpdateProductSuggForSelfTour.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val()+"&suggestionType=Y"
				}else{
				  url = "/vst_admin/packageTour/prod/product/showUpdateProduct.do?productId="+$("#productId").val()+"&categoryId="+$("#categoryId").val()+"&suggestionType=Y"
				}
			}
		 	$("#iframeMain").attr("src",url);
		 	
		}else {
			$.alert("请先创建产品");
			return;
		}
	});
		
    $("#route").parent("li").click(function(){
    	if(travelAlertHasChanges(this)){ return }
	if($("#productId").val()!=null && $("#productId").val()!=""){
		$(".pg_title").html("修改产品"+"&nbsp;&nbsp;&nbsp;&nbsp;"+"产品名称："+$("#productName").val()+"   "+"品类:"+$("#categoryName").val()+"   "+"产品ID："+$("#productId").val());
	 	$("#iframeMain").attr("src","/vst_admin/packageTour/prod/product/showUpdateRoute.do?productId="+$("#productId").val());
	}else { 
		$.alert("请先创建产品");
		return;
	}
	});
	
	//图片
	$("#showPhoto").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
		var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
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
    	if(travelAlertHasChanges(this)){ return }
        var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
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
	
	// 视频
	$("#productVideo").parent("li").click(function() {
		if(travelAlertHasChanges(this)){ return }
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
	
	//国内视频
	$("#productVideo_local").parent("li").click(function(){
		if(travelAlertHasChanges(this)){ return }
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
		if(travelAlertHasChanges(this)){ return }
		var productId = $("#productId").val();
		if(productId==""){
			$.alert("请先创建产品");
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
	
	
	
	//校验行程
	function validRoute(){
	   var routeFlag = $('#routeFlag').val();
	   if(routeFlag=='false'|| routeFlag==''){
			return false;
		 }
	   return true;	 
	}
	
	// 验证交通信息，跟团游(必须先保存行程信息以后才能操作除基础信息，行程以外所有的菜单)
	function validateTraffic(){
		var packageType = $('#packageType').val();//打包类型
		var transportType = $('#transportType').val();//是否包含大交通
		if("SUPPLIER" == packageType && "Y" == transportType){
			var saveTransportFlag = $('#saveTransportFlag').val();
			if(saveTransportFlag=='false' || saveTransportFlag.length <= 0){
				return false;
			}
		}
		return true;
	}	
	
	//校验行程、签证
	function validAll(){
	      //行程校验
		    if(!validRoute()){
		       $("#route").parent("li").trigger("click");
				$.alert("请创建行程");
				return false;	
		    }
			
		    
		    if(!validateTraffic()){
		    	if(confirm("请先添加交通信息,确认添加交通信息吗？")){
					$("#transport").parent("li").trigger("click");
				}
				return false;
		    }
		    
			return true;
	}
	//刷新条款
	window.refreshRouteGroupSuggestion = function(){
		$("#routeGroupSuggestion").click();
	}
</script>