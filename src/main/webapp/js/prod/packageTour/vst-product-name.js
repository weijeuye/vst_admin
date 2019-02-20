 /**
 * Author：     yecheng
 * Date:        2016-08-24
 * Version:     1.0.0.0
 * Description: 产品名称结构化js
 */

$(function() {
	var product_name_version = '1.0';
    var $dialogs = $(".dialog");
    //遮罩层 
    var $baseInfoBg = $(".baseInfo_bg");
    var $productType= $("input[name=productType]");
    
    var $ltAddNameBtn = $(".lt-add-name-btn");//添加按钮
   
    var $ltDialogCloseBtn = $(".lt-dialog-close");
    var $ltInfoTemplate = $(".lt-info-template");
    // 产品类型提示
    var $ltCategoryNote1 = $(".info-category-note1");
    var $ltCategoryNote2 = $(".info-category-note2");
    // 产品名称显示区域
    var $ltProductNameDd = $(".lt-product-name-td");
    // 产品副标题显示区域
    var $ltProductSubNameDd = $(".lt-product-sub-name-td");
    
    //类别的上一个值
    var productTypeOldVal = "";
    //新增还是修改标志位
    var productId = $("#productId").val();
    
    //分类按钮点击事件
    $productType.on("click",function(){
    	if($("#categoryId").val()=="16"||$("#categoryId").val()=="15"||$("#categoryId").val()=="18"&&$("#subCategoryId").val()!="181"){//当地游、跟团游
    		if($("#productName").val()!=""){
    			$("input[name=productType][value='"+productTypeOldVal+"']").attr("checked", "checked");
    			$(".info-category-note1").hide();
    			$(".info-category-note2").show();
    		}else{
    			productTypeOldVal = $('input[name=productType]:checked').val();
    			$(".lt-add-name-btn").removeClass("lt-link-disabled");
    			$productType.removeAttr("disabled");
    			$(".info-category-note1").show();
    			$(".info-category-note2").hide();
    		}
    	}else if($("#categoryId").val()=="18"&&$("#subCategoryId").val()=="181"){//自由行 酒+景
    		console.log("这里处理  酒+景");
    		var productType = "";
        	if(productId!=""){//修改
        		productType = $('input[name=productType]').val();
        	}else{//新增
        		productType = $('input[name=productType]:checked').val();
        	}
        	if(productType=="INNERLINE"){//国内按照原来方式
        		$("#zyxJjGn").show().removeAttr("disabled").find(".JS_hidden_zyxJjGn").attr("name","productName").attr("required",true);
        		$("#zyxJjCj").hide().attr("disabled",true).find(".JS_hidden_main_product_name").removeAttr("name").removeAttr("required");
        		$ltProductSubNameDd.find(".lt-product-name-view-sub").hide();
        		$(".lt-add-name-btn").removeClass("lt-link-disabled");
        		$('.lt-product-name-view-main').hide();
        		$("#zyxJjCj").find('input').each(function(){
        	            $(this).attr("disabled",true);
        	        });
        		$("#zyxJjGn").find('input').each(function(){
    	            $(this).removeAttr("disabled");
    	        });
        		
        	}else if(productType=="FOREIGNLINE"){//出境按照新的方式
        		$("#zyxJjGn").hide().attr("disabled",true).find(".JS_hidden_zyxJjGn").removeAttr("name").removeAttr("required");
        		$("#zyxJjCj").show().removeAttr("disabled").find(".JS_hidden_main_product_name").attr("name","productName").attr("required",true);
        		$(".lt-add-name-btn").removeClass("lt-link-disabled");
    			$productType.removeAttr("disabled");
    			$ltProductSubNameDd.find(".lt-product-name-view-sub").show();
    			$(".info-category-note1").show();
    			$('.lt-product-name-view-main').show();
    			$("#zyxJjGn").find('input').each(function(){
    	            $(this).attr("disabled",true);
    	        });
	    		$("#zyxJjCj").find('input').each(function(){
		            $(this).removeAttr("disabled");
		        });
        	}
    	}else if($("#categoryId").val()=="17"){//自由行 酒+景
    		var productType = "";
        	if(productId!=""){//修改
        		productType = $('input[name=productType]').val();
        	}else{//新增
        		productType = $('input[name=productType]:checked').val();
        	}
        	if(productType=="INNERLINE"){//国内按照原来方式
        		$("#zyxJjGn").show().removeAttr("disabled").find(".JS_hidden_zyxJjGn").attr("name","productName").attr("required",true);
        		$(".lt-add-name-btn").removeClass("lt-link-disabled");
        		$("#zyxJjCj").hide().attr("disabled",true);
    		}else if(productType=="FOREIGNLINE"){
    			$("#zyxJjGn").hide().attr("disabled",true).find(".JS_hidden_zyxJjGn").removeAttr("name").removeAttr("required");
    			$("#zyxJjCj").show().removeAttr("disabled");
    		}
    	}
    	else{
    		productTypeOldVal = "";
    	}
    });
    
    // 删除产品名称
    $ltProductNameDd.on("click",".lt-pnv-delete",function(){
        $(this).parent().siblings("input").val("");
        $(this).parent().siblings("a").removeClass("lt-link-disabled");
        $(".JS_hidden_product_name_vo_div").find("input").attr("value","");
        $(this).parent().remove();
        $ltProductSubNameDd.find(".lt-product-name-view-sub").remove();
        
        $productType.removeAttr("disabled");
		$(".info-category-note1").hide();
		$(".info-category-note2").hide();
		
		//显示新增按钮
		//$ltAddNameBtn.addClass("lt-link-disabled");
        $ltAddNameBtn.show();
         
        //$(".lt-category").find("option").eq(0).attr("selected", true);
        /**清除所有弹出框内容**/
        var $addNameDialog = $(".addName_dialog");
        //清除数据
        $addNameDialog.find(".add-name-content").html("");
        $addNameDialog.find(":text").each(function() {
        	$(this).val("");
        });
        //清空hidden域的值
        $addNameDialog.find("input[type=hidden]").each(function() {
        	$(this).val("");
        });
        
        $addNameDialog.find("select").each(function() {
            $(this).find("option").eq(0).attr("selected", true);
        });
    });
    // 修改产品名称
    $ltProductNameDd.on("click",".lt-pnv-modify",function(){
        var $currentDialog = $($(this).attr("data-dialog"));
        //填入弹出模态窗口中的inputs值
        copyValueFromPageToDialog($currentDialog);

        showDialog($currentDialog);
        
        var $dialog = $($(this).attr("data-dialog"));
        var $header = $dialog.find(".dialog-header");
        var headerText = $header.html();
        headerText = headerText.replace("添加", "修改");
        $header.html(headerText);
        $dialog.find(".add-name-content").html("");
    });

    //显示增加名称窗口 
    $ltAddNameBtn.on("click", function(){
    	if(!$(this).hasClass("lt-link-disabled")){
    		var type = $('input[name=productType]:checked').val();
    		var $dialog = "";
    		if(type=="INNERSHORTLINE"||type=="INNERLONGLINE"||type=="INNER_BORDER_LINE"){
    			$dialog = $(".INNERLINE");
    		}else{
    			$dialog = $("." + type);
    		}
    		showDialog($dialog);
        	var $header = $dialog.find(".dialog-header");
            var headerText = $header.html();
            headerText = headerText.replace("修改", "添加");
            $header.html(headerText);
    	}
    });

    // 关闭窗口 
    $ltDialogCloseBtn.on("click", function(){
        closeDialog();
    });
    
    bindAddNameFuns($(".addName_zyx_gn_dialog"));//跟团游——绑定国内数据
    bindAddNameFuns($(".addName_zyx_cj_dialog"));//跟团游——绑定出境数据
    
    bindAddNameFuns($(".addName_gty_gn_dialog"));//跟团游——绑定国内数据
    bindAddNameFuns($(".addName_gty_cj_dialog"));//跟团游——绑定出境数据

    bindAddNameFuns($(".addName_gn_dialog"));//当地游——绑定国内数据
    bindAddNameFuns($(".addName_cj_dialog"));//当地游——绑定出境数据
    
    

    //添加产品名称
    function bindAddNameFuns($dialog){
        var $bzContent = $dialog.find(".bz-content");
        var $inputs = $dialog.find(".input-text");
        var $select = $dialog.find("select");
        var $viewNameBtn = $dialog.find(".name-view-btn");//名称预览btn
        var $addNameContent = $dialog.find(".add-name-content");//名称tips
        var $dialogConfirmBtn = $dialog.find(".lt-dialog-confirm");//名称确定btn
//        var illegalReg = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5]/;
        var illegalReg = /^[^\\\*\&\#\$\%\@\\^\!\~\+>\<\|\'\"\/]+$/;
//        var illegalRegDH = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5、]/;
//        var illegalRegTS = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5，]/;
        
        var mainTitle='';//主标题拼接
		var subTitle = '';//副标题拼接
		var subTitle4Tnt = '';

        $inputs.focus(function(){
            $bzContent.html($(this).attr("data-tip"));
        });

        $inputs.blur(function(){
            $(this).removeClass("input-red");
        });

        $select.focus(function(){
            $bzContent.html("");
        });

        //前台预览
        // TODO: 开发时需要判断输入数据的准确性
        $viewNameBtn.on("click", function(){
            $addNameContent.html("");
            if(getFullProductName()){
            	$bzContent.html("");
            	var content = "主标题："+mainTitle;
            	content+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            	content+="副标题："+subTitle;
            	$addNameContent.html(content);
            }
        });
        //dialog 确定 按钮
        $dialogConfirmBtn.on("click", function(){
        	if(getFullProductName()){
	        	//清除提示内容
	            $bzContent.html("");
	            // 先删除原来显示的名称!
	            $ltProductNameDd.find(".lt-product-name-view-main").remove();
	            $ltProductSubNameDd.find(".lt-product-name-view-sub").remove();
	            // 增加名称按钮disabled
	            $ltAddNameBtn.hide();
	            /**复制主标题**/
	            var $productNameMain = $ltInfoTemplate.find(".lt-product-name-view-main").clone();
	            /**复制副标题**/
	            var $productNameSub = $ltInfoTemplate.find(".lt-product-name-view-sub").clone();
	            //如果是产品的编辑页面移掉删除按钮
	            var productId = $("#productId").val();
	            if(typeof(productId) != undefined && !!productId ){
	            	$productNameMain.find('.lt-pnv-delete').remove();
	            }
	            //填入产品基础信息维护页面中的隐藏input
	            copyValueFromDialogToPage($dialog);
	            //主标题赋值
	            $productNameMain.find(".lt-pnv-content-main").html('主标题：'+$dialog.find(".add-main-title").val());
	            //副标题赋值
	            $productNameSub.find(".lt-pnv-content-sub").html('副标题：'+$dialog.find(".add-sub-title").val());
	            //修改按钮
	            $productNameMain.find(".lt-pnv-modify").attr("data-dialog",$dialog.selector);
	            $ltProductNameDd.prepend($productNameMain);
	            $ltProductSubNameDd.prepend($productNameSub);
	            //$ltCategory.attr("disabled",true);
	            $ltCategoryNote1.hide();
	            //$ltCategoryNote2.show();
	            closeDialog();
        	}
        });

        //产品名称  拼写全部名称
        function getFullProductName() {
        	//获取产品类型
        	var productType = "";
        	if(productId!=""){//修改
        		productType = $('input[name=productType]').val();
        	}else{//新增
        		productType = $('input[name=productType]:checked').val();
        	}
        	if((productType == "INNERLINE"||productType == "INNERSHORTLINE"||productType == "INNERLONGLINE")&&$("#categoryId").val()=="16"){//当地游-国内
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt = '';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $traffic = $dialog.find(".add-traffic");
        		var $playtype = $dialog.find(".add-playtype");
        		/**副标题**/
        		var $dxhd = $dialog.find(".add-dxhd");
        		var $cxxx = $dialog.find(".add-cxxx");
        		var $cpts = $dialog.find(".add-cpts");
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		if($traffic.val()!==""&&!illegalReg.test($traffic.val())){
        			$traffic.addClass("input-red");
                    $bzContent.html($traffic.attr("data-tip"));
                    return false;
        		}else if($traffic.val()!==""){
        			mainTitle+=$traffic.val();
        		}
        		
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		if($playtype.val()!==""){
        			mainTitle+=$playtype.find("option:selected").text();
        		}
        		mainTitle+="游";
        		/**副标题**/
        		if($dxhd.val()!==""&&!illegalReg.test($dxhd.val())){
        			$dxhd.addClass("input-red");
                    $bzContent.html($dxhd.attr("data-tip"));
                    return false;
        		}else if($dxhd.val()!==""){
        			subTitle+='['+$dxhd.val()+']';
        			subTitle4Tnt+='['+$dxhd.val()+']';
        		}
        		if($cxxx.val()!==""&&!illegalReg.test($cxxx.val())){
        			$cxxx.addClass("input-red");
                    $bzContent.html($cxxx.attr("data-tip"));
                    return false;
        		}else if($cxxx.val()!==""){
        			subTitle+=$cxxx.val();
        		}
        		if($cpts.val()===""||!illegalReg.test($cpts.val())){
        			$cpts.addClass("input-red");
                    $bzContent.html($cpts.attr("data-tip"));
                    return false;
        		}else if($cpts.val()!==""){
        			if($cxxx.val()===""){
        				subTitle+=$cpts.val();
        			}else{
        				subTitle+="，"+$cpts.val();
        			}
        			subTitle4Tnt+=$cpts.val();
        		}
        	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="16"){//当地-出境
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt = '';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		/**副标题**/
        		var $yhhd = $dialog.find(".add-yhhd");
        		var $thct = $dialog.find(".add-thct");
        		var $hotel = $dialog.find(".add-hotel");
        		var $tsmd = $dialog.find(".add-tsmd");
        		var levelStar = $dialog.find(".add-levelStar").val();//星级
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
	        mainTitle+= "游";
        		/**副标题**/
        		if($yhhd.val()!==""&&!illegalReg.test($yhhd.val())){
        			$yhhd.addClass("input-red");
                    $bzContent.html($yhhd.attr("data-tip"));
                    return false;
        		}else if($yhhd.val()!==""){
        			subTitle+='['+$yhhd.val()+']';
        		}
        		if($thct.val()!==""&&!illegalReg.test($thct.val())){
        			$thct.addClass("input-red");
                    $bzContent.html($thct.attr("data-tip"));
                    return false;
        		}else if($thct.val()!==""){
        			subTitle+=$thct.val();
        			subTitle4Tnt+=$thct.val();
        		}
        		if($hotel.val()!==""&&!illegalReg.test($hotel.val())){
        			$hotel.addClass("input-red");
                    $bzContent.html($hotel.attr("data-tip"));
                    return false;
        		}else if($hotel.val()!==""){
        			if($thct.val()!==""){
        				subTitle+="，"+$hotel.val();
        				subTitle4Tnt+="，"+$hotel.val();
        			}else{
        				subTitle+=$hotel.val();
        				subTitle4Tnt+=$hotel.val();
        			}
        			
        		}
        		if($tsmd.val()===""||!illegalReg.test($tsmd.val())){
        			$tsmd.addClass("input-red");
                    $bzContent.html($tsmd.attr("data-tip"));
                    return false;
        		}else{
        			if($thct.val()!==""||$hotel.val()!==""){
        				subTitle+="，"+$tsmd.val();
        				subTitle4Tnt+="，"+$tsmd.val();
        			}else{
        				subTitle+=$tsmd.val();
        				subTitle4Tnt+=$tsmd.val();
        			}
        		}
        		if(parseInt(levelStar)> 0 ){
            		//$dialog.find(".add-levelStar").attr("style","");
                	for(var i=0;i<parseInt(levelStar);i++){
                		subTitle += "★" ;
                		subTitle4Tnt+= "★" ;
                	}
            	}
        	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="15"){//跟团游——出境
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt='';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $playtype = $dialog.find(".add-playtype");
        		/**副标题**/
        		var $yhhd = $dialog.find(".add-yhhd");
        		var $thct = $dialog.find(".add-thct");
        		var $hotel = $dialog.find(".add-hotel");
        		var $tsmd = $dialog.find(".add-tsmd");
        		var levelStar = $dialog.find(".add-levelStar").val();//星级
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		if($playtype.val()!==""){
        			mainTitle+=$playtype.find("option:selected").text();
        		}
        		mainTitle+="游";
        		/**副标题**/
        		if($yhhd.val()!==""&&!illegalReg.test($yhhd.val())){
        			$yhhd.addClass("input-red");
                    $bzContent.html($yhhd.attr("data-tip"));
                    return false;
        		}else if($yhhd.val()!==""){
        			subTitle+='['+$yhhd.val()+']';
        		}
        		if($thct.val()!==""&&!illegalReg.test($thct.val())){
        			$thct.addClass("input-red");
                    $bzContent.html($thct.attr("data-tip"));
                    return false;
        		}else if($thct.val()!==""){
        			subTitle+=$thct.val();
        			subTitle4Tnt+=$thct.val();
        		}
        		if($hotel.val()!==""&&!illegalReg.test($hotel.val())){
        			$hotel.addClass("input-red");
                    $bzContent.html($hotel.attr("data-tip"));
                    return false;
        		}else if($hotel.val()!==""){
        			if($thct.val()!==""){
        				subTitle+="，"+$hotel.val();
        				subTitle4Tnt+="，"+$hotel.val();
        			}else{
        				subTitle+=$hotel.val();
        				subTitle4Tnt+=$hotel.val();
        			}
        			
        		}
        		if($tsmd.val()===""||!illegalReg.test($tsmd.val())){
        			$tsmd.addClass("input-red");
                    $bzContent.html($tsmd.attr("data-tip"));
                    return false;
        		}else{
        			if($thct.val()!==""||$hotel.val()!==""){
        				subTitle+="，"+$tsmd.val();
        				subTitle4Tnt+="，"+$tsmd.val();
        			}else{
        				subTitle+=$tsmd.val();
        				subTitle4Tnt+=$tsmd.val();
        			}
        		}
        		if(parseInt(levelStar)> 0 ){
                	for(var i=0;i<parseInt(levelStar);i++){
                		subTitle += "★" ;
                		subTitle4Tnt+= "★" ;
                	}
            	}
        	}else if((productType == "INNERSHORTLINE"||productType == "INNERLONGLINE"||productType == "INNER_BORDER_LINE")&&$("#categoryId").val()=="15"){//跟团游——国内3个
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt ='';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $traffic = $dialog.find(".add-traffic");
        		var $playtype = $dialog.find(".add-playtype");
        		/**副标题**/
        		var $dxhd = $dialog.find(".add-dxhd");
        		var $cxxx = $dialog.find(".add-cxxx");
        		var $cpts = $dialog.find(".add-cpts");
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		if($traffic.val()!==""&&!illegalReg.test($traffic.val())){
        			$traffic.addClass("input-red");
                    $bzContent.html($traffic.attr("data-tip"));
                    return false;
        		}else if($traffic.val()!==""){
        			mainTitle+=$traffic.val();
        		}
        		
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		
        		var mddjtfs = $mdd.val()+$traffic.val();
        		if(mddjtfs.length>20){
            		$bzContent.html('<i class="add-red">目的地+交通方式总和不能超过20个字（包含标点符号），请修改！</i>');
            		$mdd.addClass("input-red");
            		$traffic.addClass("input-red");
            		return false;
            	}
        		if($playtype.val()!==""){
        			mainTitle+=$playtype.find("option:selected").text();
        		}
        		mainTitle+="游";
        		/**副标题**/
        		if($dxhd.val()!==""&&!illegalReg.test($dxhd.val())){
        			$dxhd.addClass("input-red");
                    $bzContent.html($dxhd.attr("data-tip"));
                    return false;
        		}else if($dxhd.val()!==""){
        			subTitle+='['+$dxhd.val()+']';
        			subTitle4Tnt+='['+$dxhd.val()+']';
        		}
        		if($cxxx.val()!==""&&!illegalReg.test($cxxx.val())){
        			$cxxx.addClass("input-red");
                    $bzContent.html($cxxx.attr("data-tip"));
                    return false;
        		}else if($cxxx.val()!==""){
        			subTitle+=$cxxx.val();
        		}
        		if($cpts.val()===""||!illegalReg.test($cpts.val())){
        			$cpts.addClass("input-red");
                    $bzContent.html($cpts.attr("data-tip"));
                    return false;
        		}else if($cpts.val()!==""){
        			if($cxxx.val()===""){
        				subTitle+=$cpts.val();
        			}else{
        				subTitle+="，"+$cpts.val();
        			}
        			subTitle4Tnt+=$cpts.val();
        		}
        	}else if(productType == "INNERLINE"&&$("#categoryId").val()=="18" &&$("#subCategoryId").val()!="181"){//自由行——国内
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt='';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $traffic = $dialog.find(".add-traffic");
        		var $playtype = $dialog.find(".add-playtype");
        		/**副标题**/
        		var $dxhd = $dialog.find(".add-dxhd");
        		var $cxxx = $dialog.find(".add-cxxx");
        		var $hotel = $dialog.find(".add-hotel");
        		var $cpts = $dialog.find(".add-cpts");
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		if($traffic.val()!==""&&!illegalReg.test($traffic.val())){
        			$traffic.addClass("input-red");
                    $bzContent.html($traffic.attr("data-tip"));
                    return false;
        		}else if($traffic.val()!==""){
        			mainTitle+=$traffic.val();
        		}
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		var mddjtfs = $mdd.val()+$traffic.val();
        		if(mddjtfs.length>20){
            		$bzContent.html('<i class="add-red">目的地+交通方式总和不能超过20个字（包含标点符号），请修改！</i>');
            		$mdd.addClass("input-red");
            		$traffic.addClass("input-red");
            		return false;
            	}
        		if($playtype.val()!==""){
        			mainTitle+=$playtype.find("option:selected").text();
        		}
        		/**副标题**/
        		if($dxhd.val()!==""&&!illegalReg.test($dxhd.val())){
        			$dxhd.addClass("input-red");
                    $bzContent.html($dxhd.attr("data-tip"));
                    return false;
        		}else if($dxhd.val()!==""){
        			subTitle+='['+$dxhd.val()+']';
        			subTitle4Tnt+='['+$dxhd.val()+']';
        		}
        		if($cxxx.val()!==""&&!illegalReg.test($cxxx.val())){
        			$cxxx.addClass("input-red");
                    $bzContent.html($cxxx.attr("data-tip"));
                    return false;
        		}else if($cxxx.val()!==""){
        			subTitle+=$cxxx.val();
        		}
        		if($hotel.val()!==""&&!illegalReg.test($hotel.val())){
        			$cpts.addClass("input-red");
                    $bzContent.html($hotel.attr("data-tip"));
                    return false;
        		}else if($hotel.val()!==""){
        			if($cxxx.val()===""){
        				subTitle+=$hotel.val();
        			}else{
        				subTitle+="，"+$hotel.val();
        			}
        			subTitle4Tnt+=$hotel.val();
        		}
        		if($cpts.val()===""||!illegalReg.test($cpts.val())){
        			$cpts.addClass("input-red");
                    $bzContent.html($cpts.attr("data-tip"));
                    return false;
        		}else if($cpts.val()!==""){
        			if($cxxx.val()!==""||$hotel.val()!==""){
        				subTitle+="，"+$cpts.val();
        			}else{
        				subTitle+=$cpts.val();
        			}
        			if($hotel.val()!==""){
        				subTitle4Tnt+="，"+$cpts.val();
        			}else{
        				subTitle4Tnt+=$cpts.val();
        			}
        		}
        	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="18"){//自由行——出境
        		mainTitle='';
        		subTitle = '';
        		subTitle4Tnt ='';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		/**副标题**/
        		var $yhhd = $dialog.find(".add-yhhd");
        		var $thct = $dialog.find(".add-thct");
        		var $hotelorfeature = $dialog.find(".add-hotelorfeature");
        		var $flightfeature = $dialog.find(".add-flightfeature");
        		var $otherfeature = $dialog.find(".add-otherfeature");
        		var levelStar = $dialog.find(".add-levelStar").val();
        		
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		mainTitle+="自由行";
        		/**副标题**/
        		console.log("$yhhd.val():"+$yhhd.val());
        		if($yhhd.val()!==""&&!illegalReg.test($yhhd.val())){
        			$yhhd.addClass("input-red");
                    $bzContent.html($yhhd.attr("data-tip"));
                    return false;
        		}else if($yhhd.val()!==""){
        			subTitle+='['+$yhhd.val()+']';
        		}
        		if($thct.val()!==""&&!illegalReg.test($thct.val())){
        			$thct.addClass("input-red");
                    $bzContent.html($thct.attr("data-tip"));
                    return false;
        		}else if($thct.val()!==""){
        			subTitle+=$thct.val();
        			subTitle4Tnt+=$thct.val();
        		}
        		if($hotelorfeature.val()!==""&&!illegalReg.test($hotelorfeature.val())){
        			$hotelorfeature.addClass("input-red");
                    $bzContent.html($hotelorfeature.attr("data-tip"));
                    return false;
        		}else if($hotelorfeature.val()!==""){
        			if(!!$thct.val()){
        				subTitle+="，"+$hotelorfeature.val();
        				subTitle4Tnt+="，"+$hotelorfeature.val();
        			}else{
        				subTitle+=$hotelorfeature.val();
        				subTitle4Tnt+=$hotelorfeature.val();
        			}
        		}
        		if($flightfeature.val()!==""&&!illegalReg.test($flightfeature.val())){
        			$flightfeature.addClass("input-red");
                    $bzContent.html($flightfeature.attr("data-tip"));
                    return false;
        		}else if($flightfeature.val()!==""){
        			if(!!$thct.val()||!!$hotelorfeature.val()){
        				subTitle+="，"+$flightfeature.val();
        				subTitle4Tnt+="，"+$flightfeature.val();
        			}else{
        				subTitle+=$flightfeature.val();
        				subTitle4Tnt+=$flightfeature.val();
        			}
        		}
        		if($otherfeature.val()!==""&&!illegalReg.test($otherfeature.val())){
        			$otherfeature.addClass("input-red");
                    $bzContent.html($otherfeature.attr("data-tip"));
                    return false;
        		}else if($otherfeature.val()!==""){
        			if(!!$thct.val()||!!$hotelorfeature.val()||!!$flightfeature.val()){
        				subTitle+="，"+$otherfeature.val();
        				subTitle4Tnt+="，"+$otherfeature.val();
        			}else{
        				subTitle+=$otherfeature.val();
        				subTitle4Tnt+=$otherfeature.val();
        			}
        		}
        		if(parseInt(levelStar)> 0 ){
                	for(var i=0;i<parseInt(levelStar);i++){
                		subTitle += "★" ;
                		subTitle4Tnt+= "★" ;
                	}
            	}
        	}
        	$dialog.find(".add-main-title").val(mainTitle);
        	$dialog.find(".add-sub-title").val(subTitle);
        	$dialog.find(".add-sub-title-4-tnt").val(subTitle4Tnt);
        	
        	var totalTitle = mainTitle+subTitle;
        	if(totalTitle.length>140){
        		$bzContent.html('<i class="add-red">名称总字数不超过140，请修改！</i>');
        		return false;
        	}
        	return true;
        }
    }

    //获取产品基础页面中的关于名称的隐藏inputs
    function getBasePageInputs() {
        var $pageInputs = {};
        var $hiddenProductNameDiv = $(".JS_hidden_product_name_vo_div");

        //产品基础页面中隐藏输入框
        $pageInputs.mainProductName = $(".JS_hidden_main_product_name");
    	$pageInputs.mainTitle = $hiddenProductNameDiv.find(".JS_hidden_vo_main_title");
    	$pageInputs.subTitle = $hiddenProductNameDiv.find(".JS_hidden_vo_sub_title");
    	$pageInputs.subTitle4Tnt = $hiddenProductNameDiv.find(".JS_hidden_vo_sub_title_4_tnt");
    	
    	$pageInputs.destination = $hiddenProductNameDiv.find(".JS_hidden_vo_destination");
    	$pageInputs.nightNumber = $hiddenProductNameDiv.find(".JS_hidden_vo_night_number");
    	$pageInputs.dayNumber = $hiddenProductNameDiv.find(".JS_hidden_vo_day_number");
    	$pageInputs.playType = $hiddenProductNameDiv.find(".JS_hidden_vo_play_type");
    	$pageInputs.benefit = $hiddenProductNameDiv.find(".JS_hidden_vo_benefit");
    	$pageInputs.themeContent = $hiddenProductNameDiv.find(".JS_hidden_vo_theme_content");
    	$pageInputs.hotel = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel");
    	$pageInputs.mainFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_main_feature");
    	$pageInputs.levelStar = $hiddenProductNameDiv.find(".JS_hidden_vo_level_star");
    	$pageInputs.hotelOrFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_or_feature");
    	$pageInputs.flightFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_flight_feature");
    	$pageInputs.otherFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_other_feature");
    	$pageInputs.hotelPackage = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_package");
    	$pageInputs.hotelFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_feature");
    	$pageInputs.traffic = $hiddenProductNameDiv.find(".JS_hidden_vo_traffic");
    	$pageInputs.largeActivity = $hiddenProductNameDiv.find(".JS_hidden_vo_large_activity");
    	
    	$pageInputs.promotionOrHotel = $hiddenProductNameDiv.find(".JS_hidden_vo_promotion_or_hotel");
    	$pageInputs.productFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_product_feature");
    	$pageInputs.productName = $hiddenProductNameDiv.find(".JS_hidden_vo_product_name");
    	
    	$pageInputs.version = $hiddenProductNameDiv.find(".JS_hidden_vo_version");
    	
        return $pageInputs;
    }

    //复制值从弹出页面到基础页面
    function copyValueFromDialogToPage($dialog) {
    	$pageInputs = getBasePageInputs();
    	var productType = "";
    	if(productId!=""){//修改
    		productType = $('input[name=productType]').val();
    	}else{//新增
    		productType = $('input[name=productType]:checked').val();
    	}
//    	var productType = $productType.val();
    	var mainProductName = $dialog.find(".add-main-title").val();
    	if($dialog.find(".add-sub-title").val()!=""){
    		mainProductName += '('+$dialog.find(".add-sub-title").val()+')';
    	}
    	$pageInputs.mainProductName.val(mainProductName);
    	if((productType == "INNERLINE"||productType == "INNERSHORTLINE"||productType == "INNERLONGLINE")&&$("#categoryId").val()=="16"){//国内
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.traffic.val($dialog.find(".add-traffic").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.playType.val($dialog.find(".add-playtype").val());
    		$pageInputs.largeActivity.val($dialog.find(".add-dxhd").val());
    		$pageInputs.benefit.val($dialog.find(".add-cxxx").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-cpts").val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="16"){//出境
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.benefit.val($dialog.find(".add-yhhd").val());
    		$pageInputs.themeContent.val($dialog.find(".add-thct").val());
    		$pageInputs.hotel.val($dialog.find(".add-hotel").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-tsmd").val());
    		$pageInputs.levelStar.val($dialog.find(".add-levelStar").val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="15"){//跟团游——出境
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.playType.val($dialog.find(".add-playtype").val());
    		$pageInputs.benefit.val($dialog.find(".add-yhhd").val());
    		$pageInputs.themeContent.val($dialog.find(".add-thct").val());
    		$pageInputs.hotel.val($dialog.find(".add-hotel").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-tsmd").val());
    		$pageInputs.levelStar.val($dialog.find(".add-levelStar").val());
    	}else if((productType == "INNERSHORTLINE"||productType == "INNERLONGLINE"||productType == "INNER_BORDER_LINE")&&$("#categoryId").val()=="15"){//跟团游——国内
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.traffic.val($dialog.find(".add-traffic").val());
    		$pageInputs.playType.val($dialog.find(".add-playtype").val());
    		$pageInputs.largeActivity.val($dialog.find(".add-dxhd").val());
    		$pageInputs.benefit.val($dialog.find(".add-cxxx").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-cpts").val());
    	}else if(productType == "INNERLINE"&&$("#categoryId").val()=="18" &&$("#subCategoryId").val()!="181"){
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.traffic.val($dialog.find(".add-traffic").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.playType.val($dialog.find(".add-playtype").val());
    		$pageInputs.largeActivity.val($dialog.find(".add-dxhd").val());
    		$pageInputs.benefit.val($dialog.find(".add-cxxx").val());
    		$pageInputs.hotel.val($dialog.find(".add-hotel").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-cpts").val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="18"){
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.benefit.val($dialog.find(".add-yhhd").val());
    		$pageInputs.themeContent.val($dialog.find(".add-thct").val());
    		$pageInputs.hotelOrFeature.val($dialog.find(".add-hotelorfeature").val());
    		$pageInputs.flightFeature.val($dialog.find(".add-flightfeature").val());
    		$pageInputs.otherFeature.val($dialog.find(".add-otherfeature").val());
    		$pageInputs.levelStar.val($dialog.find(".add-levelStar").val());
    	}
    	$pageInputs.subTitle4Tnt.val($dialog.find(".add-sub-title-4-tnt").val());
    	$pageInputs.version.val(product_name_version);
    }

    //复制值从基础页面到弹出页面
    function copyValueFromPageToDialog($dialog) {
//    	var productType = $productType.val();
    	var productType = "";
    	if(productId!=""){//修改
    		productType = $('input[name=productType]').val();
    	}else{//新增
    		productType = $('input[name=productType]:checked').val();
    	}
    	$pageInputs = getBasePageInputs();
    	if((productType == "INNERLINE"||productType == "INNERSHORTLINE"||productType == "INNERLONGLINE")&&$("#categoryId").val()=="16"){//国内
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".add-traffic").val($pageInputs.traffic.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-category").val($pageInputs.playType.val());
    		$dialog.find(".add-dxhd").val($pageInputs.largeActivity.val());
    		$dialog.find(".add-cxxx").val($pageInputs.benefit.val());
    		$dialog.find(".add-cpts").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-playtype").val($pageInputs.playType.val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="16"){//出境
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-yhhd").val($pageInputs.benefit.val());
    		$dialog.find(".add-thct").val($pageInputs.themeContent.val());
    		$dialog.find(".add-hotel").val($pageInputs.hotel.val());
    		$dialog.find(".add-tsmd").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-levelStar").val($pageInputs.levelStar.val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="15"){//跟团游——出境
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-playtype").val($pageInputs.playType.val());
    		$dialog.find(".add-yhhd").val($pageInputs.benefit.val());
    		$dialog.find(".add-thct").val($pageInputs.themeContent.val());
    		$dialog.find(".add-hotel").val($pageInputs.hotel.val());
    		$dialog.find(".add-tsmd").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-levelStar").val($pageInputs.levelStar.val());
    	}else if((productType == "INNERSHORTLINE"||productType == "INNERLONGLINE"||productType == "INNER_BORDER_LINE")&&$("#categoryId").val()=="15"){
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-traffic").val($pageInputs.traffic.val());
    		$dialog.find(".add-category").val($pageInputs.playType.val());
    		$dialog.find(".add-dxhd").val($pageInputs.largeActivity.val());
    		$dialog.find(".add-cxxx").val($pageInputs.benefit.val());
    		$dialog.find(".add-cpts").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-playtype").val($pageInputs.playType.val());
    	}else if(productType == "INNERLINE"&&$("#categoryId").val()=="18" &&$("#subCategoryId").val()!="181"){
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-traffic").val($pageInputs.traffic.val());
    		$dialog.find(".add-category").val($pageInputs.playType.val());
    		$dialog.find(".add-dxhd").val($pageInputs.largeActivity.val());
    		$dialog.find(".add-cxxx").val($pageInputs.benefit.val());
    		$dialog.find(".add-hotel").val($pageInputs.hotel.val());
    		$dialog.find(".add-cpts").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-playtype").val($pageInputs.playType.val());
    	}else if(productType == "FOREIGNLINE"&&$("#categoryId").val()=="18"){
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-yhhd").val($pageInputs.benefit.val());
    		$dialog.find(".add-thct").val($pageInputs.themeContent.val());
    		$dialog.find(".add-hotelorfeature").val($pageInputs.hotelOrFeature.val());
    		$dialog.find(".add-flightfeature").val($pageInputs.flightFeature.val());
    		$dialog.find(".add-otherfeature").val($pageInputs.otherFeature.val());
    		$dialog.find(".add-levelStar").val($pageInputs.levelStar.val());
    	}
    	$dialog.find(".add-sub-title-4-tnt").val($pageInputs.subTitle4Tnt.val());
    	
    }

    function closeDialog(){
        $dialogs.hide();
        $baseInfoBg.hide();
    }
    
    //显示窗口 
    function showDialog($dialog) {
    	$dialog.show();
        $baseInfoBg.show();
    }
});