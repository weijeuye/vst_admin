/*!
 * Author:      Jiang Sheng
 * Date:        2015-08-05
 * Version:     1.0.0.0
 * Description: 线路产品优化交通信息结构
 */

(function () {

	showAndHideSaveDetailTr();//显示还是隐藏保存交通详细按钮
	initTrafficContent();//初始化所有交通组信息

    //tab标签宽度
    var LI_WIDTH = 128;

    //tab标签
    var LI_NUM_OF_PAGES = 9;

    var LI_BUTTON_WIDTH = 25;

    //线路产品
    var $linePrd = $(".JS_line_prd");

    //交通信息
    var $traffics = $linePrd.find(".JS_traffics");

    //模板
    var $template = $(".JS_template");
    
    var loading;
    
    //模板对象
    var template = {
        //模板-交通
        $traffic: $template.find(".JS_traffic"),
        //选项卡
        $tab: $template.find(".lp-tab"),
    };
    
    //交通对象
    var traffics = {
        $dom: $traffics,
        $head: $traffics.find(".lp-head"),
        $tabs: $traffics.find(".lp-tabs"),
        $body: $traffics.find(".lp-body"),
        length: 0,
        count: 0,
        pos: 0,
        //当前页
        currPage: 0
    };
    
    /**
     * 添加交通组
     */
    traffics.add = function () {
        
        var unSaveConut = 0;//未保存交通组记录数
		
		traffics.$body.find(".lp-content").each(function(i, element) {
			if($(element).attr("data") == ''){
				unSaveConut = unSaveConut + 1;
			}
		});
		
		if(unSaveConut >= 1){
			saveTrafficDetail(true);//保存后在页面上加一个新交通组的页签
			return;
		}
		
		this.count++;
        this.pos = this.length;
        this.length++;
		
        var $tab = template.$tab.clone();
        $tab.find("span").html("交通信息" + traffics.count);

        traffics.$tabs.find(".lp-tab").removeClass("active");
        traffics.$tabs.append($tab);
        traffics.$body.find(".lp-content").removeClass("active");
        traffics.$body.append(template.$traffic.clone());

        var content = getTrafficTemplateContent();
        traffics.$body.find(".active .line_route_select").append(content.$selectLineRoute);
        traffics.$body.find(".active .JS_item_go_box").append(content.$go);
        traffics.$body.find(".active .JS_item_return_box").append(content.$return);
        
        this.refresh();
    };

    /**
     * 获取要填充的交通模板内容
     */
    function getTrafficTemplateContent() {
    	var content = {
            $selectLineRoute:'',
			$go : '',
			$return : ''
    	};

        //根据基本信息获取去程、返程交通
        var toTypeCode = $("#toTypeCode").val();
        var toBackCode = $("#toBackCode").val();

        if (toTypeCode != '') {
        	content.$go = $template.find(".JS_"+ toTypeCode.toLowerCase() +"_go");
        }

        if (toBackCode != '') {
        	content.$return = $template.find(".JS_"+ toBackCode.toLowerCase() +"_return");
        }

        content.$selectLineRoute = $template.find(".suitable_line_route_div_template").clone();
        content.$go = content.$go == '' ? '<h6>去程&nbsp;-&nbsp;无</h6>' : content.$go.clone();
        content.$return = content.$return == '' ? '<h6>反程&nbsp;-&nbsp;无</h6>' : content.$return.clone();

        return content;
    }

    //显示还是隐藏保存交通详细按钮
    function showAndHideSaveDetailTr() {
    	//是否显示保存交通信息按钮
    	var tabs = $(".lp-tabs").find(".lp-tab");

    	if (typeof(tabs) != 'undefined' && tabs.length > 0) {
    		$(".save_traffic_detail_tr").show();
    	} else {
    		$(".save_traffic_detail_tr").hide();
    	}
    }
    
    /**
     * 删除交通组html
     */
    traffics.del = function (pos) {

        this.length--;

        //删除当前
        this.$body.find(".lp-content").eq(pos).remove();
        this.$tabs.find(".lp-tab").eq(pos).remove();

        //显示上一个

        //删除的是当前显示的
        if (this.pos == pos) {
            this.pos--;
            this.show(this.pos);
        } else if (this.pos > pos) {  //删除的是显示的前面的元素
            this.pos--;
            this.show(this.pos);
        } else {  //删除的是显示的之后的元素
            this.show(this.pos);
        }

        //刷新
        this.refresh();

    };
    
    /**
     * 显示交通组html
     */
    traffics.show = function (pos) {

        if (pos <= 0) {
            pos = 0;
        } else if (pos >= this.length) {
            pos = this.length - 1;
        }
        this.pos = pos;

        //隐藏tab标签

        var $lis = this.$tabs.find(".lp-tab");
        $lis.removeClass("active");
        $lis.eq(pos).addClass("active");

        //隐藏之前元素
        var $contents = this.$body.find(".lp-content");
        $contents.removeClass("active");

        //显示当前元素
        $contents.eq(pos).addClass("active");
        this.refresh();
    };
    
    /**
     * 刷新交通组html
     */
    traffics.refresh = function () {
        //显示还是隐藏保存交通详细按钮
        showAndHideSaveDetailTr();

        var length = this.length;

        //如果没有元素
        if (length === 0) {
            this.$dom.hide();
        } else {
            this.$dom.show();
        }

        var $nav = this.$head.find(".lp-left,.lp-right");

        this.$tabs.css({
            "width": LI_WIDTH * length
        });

        var pageWidth = LI_NUM_OF_PAGES * LI_WIDTH;

        //最后页
        var maxPage = Math.ceil((this.length) / LI_NUM_OF_PAGES) - 1;
        //当前元素所在的页数
        var currPage = Math.ceil((this.pos + 1) / LI_NUM_OF_PAGES) - 1;


        var $prev = this.$head.find(".lp-left");
        var $next = this.$head.find(".lp-right");

        if (currPage === 0) {
            $prev.addClass("disabled");
        } else {
            $prev.removeClass("disabled");
        }
        if (currPage === maxPage) {
            $next.addClass("disabled");
        } else {
            $next.removeClass("disabled");
        }

        if (length > 9) {
            $nav.show();

            this.$tabs.stop(true, true).animate({
                "left": -pageWidth * currPage + LI_BUTTON_WIDTH
            }, 200);
        } else {
            $nav.hide();

            this.$tabs.stop(true, true).animate({
                "left": -pageWidth * currPage
            }, 200);
        }
        
      if(this.length <= 1){
	   	 traffics.$body.find(".lp-content&.active").find(".JS_btn_delete").hide();
	   }else{
	   	traffics.$body.find(".lp-content&.active").find(".JS_btn_delete").show();
	   }

    };

    /**
     * 上一页按钮
     */
    traffics.prev = function () {
        this.pos -= LI_NUM_OF_PAGES;
        this.show(this.pos);
        this.refresh();
    };

    /**
     * 下一页按钮
     */
    traffics.next = function () {
        this.pos += LI_NUM_OF_PAGES;
        this.show(this.pos);
        this.refresh();
    };

    //添加交通信息
    $linePrd.on("click", ".JS_btn_add", addHandle);
    function addHandle() {
        traffics.add();
    }

    //上一页
    $linePrd.on("click", ".lp-left", leftHandle);
    function leftHandle() {

        traffics.prev();

    }

    //下一页
    $linePrd.on("click", ".lp-right", rightHandle);
    function rightHandle() {

        traffics.next();

    }

    //切换标签页显示
    $linePrd.on("click", ".lp-tab", switchHandle);
    function switchHandle(e) {

        var $this = $(this);
        var $target = $(e.target);
        var index = $this.index();

        //如果是关闭按钮
        if ($target.hasClass("lp-close")) {
            return false;
        }
        traffics.show(index);

    }
    
    //删除标签页
    $linePrd.on("click", ".lp-close", delTabHandle);
    function delTabHandle() {
        var $this = $(this);
        var $tab = $this.parents(".lp-tab");
        var index = $tab.index();
        var indexBtn = $($('.lp-body .lp-content')[index]).find(".JS_btn_delete");
        delHandle(indexBtn,index);

    }

    //删除交通信息
    $linePrd.on("click", ".JS_btn_delete", delBtnHandle);
    function delBtnHandle() {
    	var $this = $(this);
    	var $content = $this.parents(".lp-content");
    	var index = $content.index();
    	delHandle(this,index);
    }
    
    /**
     * 删除某个交通组
     * @params delBtn 活动页签中的删除按钮
     * @params deleteIndex 页签的索引,从0开始计算
     */
    function delHandle(delBtn,deleteIndex) {
    	
        var $this = $(delBtn);
		var deleteLoading;
		var delFlag = false;//数据库中的数据是否最正在被删除
		var saveConut = 0;//数据库中记录数
		
		traffics.$body.find(".lp-content").each(function(i, element) {
			if($(element).attr("data") != ''){
				saveConut = saveConut + 1;
				if( deleteIndex == i ){
					delFlag = true;
				}
			}
		});
		
		if(delFlag && (saveConut <= 1)){
			alert('最后一组已保存过的交通信息无法删除！');
			return;
		}
		
		$.confirm("确定要删除吗?",function(){
			var id = $this.closest(".JS_traffic").attr("data");
			var type = $this.closest(".JS_traffic").attr("type");
			if(id ==''){
				traffics.del(deleteIndex);
				return;
			}
			
			deleteLoading = $.loading("正在删除...");
			$.ajax({
				url : "/vst_admin/prod/traffic/deleteProdTrafficDetail.do",
				type : "post",
				data : {"id":id,"type":type},
				success : function(result) {
					if(result.code=='success'){
						traffics.del(deleteIndex);
					}else {
						$.alert('删除失败');
					}
					deleteLoading.close();
				},
				error : function(result) {
					deleteLoading.close();
				}
			});
		});
    }

    //切换是否有参考信息（包含飞机、火车）
    $linePrd.on("click", ".JS_btn_has_not_reference", function(){
    	$(this).toggle(hasNotReferenceHandle,hasReferenceHandle);
    	$(this).trigger('click');
    });
    
    function hasNotReferenceHandle() {
        var $this = $(this);
        var $item = $this.parents(".lp-item");

        //获取当前要切换的交通类型
        var trafficType = $item.attr("type");
        if (trafficType == "FLIGHT") {
            $this.html("有参考航班");
            $this.attr("data","N");//标记填写内容是否是有参考航班的，Y：是 ，N：否

            var $flightNoInput = $item.find("input[name=flightNo]");
            var $flightNoCompleteButton = $item.find(".JS_btn_complete");
            $flightNoInput.addClass("disabled").attr("readonly","readonly");
            $flightNoCompleteButton.addClass("disabled");
        } else if (trafficType == "TRAIN"){
            $this.html("有参考车次");
            $this.attr("data","N");//标记填写内容是否是有参考车次的，Y：是 ，N：否

            var $trainNoInput = $item.find("input[name=trainNo]");
            var $trainNoCompleteButton = $item.find(".JS_btn_complete");
            $trainNoInput.addClass("disabled").attr("readonly","readonly");
            $trainNoCompleteButton.addClass("disabled");
        } else {
        	$.alert('切换失败');
        	return;
        }

        var $hasReference = $item.find(".JS_has_reference");
        var $hasNotReference = $item.find(".JS_has_not_reference");
        $hasReference.hide();
        $hasNotReference.show();
    }

    function hasReferenceHandle() {
        var $this = $(this);
        var $item = $this.parents(".lp-item");

        //获取当前要切换的交通类型
        var trafficType = $item.attr("type");
        if (trafficType == "FLIGHT") {
            $this.html("无参考航班");
            $this.attr("data","Y");//标记填写内容是否是有参考航班的，Y：是 ，N：否

            var $flightNoInput = $item.find("input[name=flightNo]");
            var $flightNoCompleteButton = $item.find(".JS_btn_complete");
            $flightNoInput.removeClass("disabled").removeAttr("readonly");
            $flightNoCompleteButton.removeClass("disabled");
        } else if (trafficType == "TRAIN"){
            $this.html("无参考车次");
            $this.attr("data","Y");//标记填写内容是否是有参考车次的，Y：是 ，N：否
            var $trainNoInput = $item.find("input[name=trainNo]");
            var $trainNoCompleteButton = $item.find(".JS_btn_complete");
            $trainNoInput.removeClass("disabled").removeAttr("readonly");
            $trainNoCompleteButton.removeClass("disabled");
        } else {
        	$.alert('切换失败');
        	return;
        }

        var $hasReference = $item.find(".JS_has_reference");
        var $hasNotReference = $item.find(".JS_has_not_reference");
        $hasReference.show();
        $hasNotReference.hide();
    }

    //添加中转
    $linePrd.on("click", ".JS_btn_add_transit", btnAddTransitHandle);
    function btnAddTransitHandle() {

        var $this = $(this);

        var $content = $this.parents(".lp-content");
        var transitType = $this.data("type");
        
        var $transits = "";
        if (transitType == "GO") {
        	$transits = $content.find(".JS_items_go_transits");
        } else {
           $transits = $content.find(".JS_items_return_transits");
        }

        var templateText = $this.data("template");
        var $transit = $template.find("." + templateText).clone();
        $transit.hide();
        $transits.append($transit);
        $transit.slideDown(200);
    }

    //删除中转
    $linePrd.on("click", ".JS_btn_del_transit", btnDelTransitHandle);
    function btnDelTransitHandle() {
        var $this = $(this);
        var $item = $this.parents(".lp-item");
		var deleteLoading;
		$.confirm("确定要删除吗?",function(){
			var id = $this.closest(".lp-item").attr("data");
			var type = $this.closest(".lp-item").attr("type");
			if(id==''){
				$item.slideUp(200, function () {
		            $item.remove();
		        });
				return;
			}
			deleteLoading = $.loading("正在删除...");
			$.ajax({
				url : "/vst_admin/prod/traffic/deleteProdTrafficDetail.do",
				type : "post",
				data : {"id":id,"type":type},
				success : function(result) {
					if(result.code=='success'){
						$item.slideUp(200, function () {
				            $item.remove();
				        });
					}else {
						$.alert('删除失败');
					}
					deleteLoading.close();
				},
				error : function(result) {
					deleteLoading.close();
				}
			});
		});
    }

    /**
     * 初始化所有交通组信息
     */
    function initTrafficContent() {
		var loading = $.loading("正在加载详细信息...");
		var productId = $("#productId").val();
		$.ajax({
			url : "/vst_admin/prod/traffic/getTrafficDetail.do",
			type : "get",
			data : {"productId":productId},
			success : function(result) {
				if (result.code=='success') {
		            loadTrafficDetail(result.attributes.trafficGroupList, result.attributes.traffic);
				} else {
					$.alert(result.message);
				}
				loading.close();
			},
			error : function(result) {
				loading.close();
			}
		});
    }

    //加载所有交通组信息
    function loadTrafficDetail(trafficGroupList, traffic) {
    	//没有组详细信息时，添加一个空组
    	if (trafficGroupList.length == 0) {
    		if (traffic != null) {
    			traffics.add();
    		}
    	} else {//否则循环遍历全部组信息
        	$.each(trafficGroupList, function(index, value) {
        		//加入基本架构html
        		traffics.add();
        		//为基本架构加入交通组详细信息
        		addTrafficDetailByGroup(value);
        	});
        	
        	if($("#addFlag").val() == "true"){
        		traffics.add();
        	}
    	}
    }

    //通过组添加交通详细信息
    function addTrafficDetailByGroup(group) {

    	var $content = $('.lp-body .lp-content&.active');
    	$content.$selectLineRoute = $content.find(".line_route_select");
    	$content.$go = $content.find(".JS_item_go_box");
    	$content.$return = $content.find(".JS_item_return_box");
    	$content.$goTransits = $content.find(".JS_items_go_transits");
    	$content.$returnTransits = $content.find(".JS_items_return_transits");

    	$content.attr("data", group.groupId);

        var prodLineRouteList = group.prodLineRouteList;
    	var prodTrafficFlightList = group.prodTrafficFlightList;
    	var prodTrafficTrainList = group.prodTrafficTrainList;
    	var prodTrafficShipList = group.prodTrafficShipList;
    	var prodTrafficBusList = group.prodTrafficBusList;


    	fillProdLineRouteHtml(prodLineRouteList,$content);//初始化行程选择框
    	fillTrafficDetailHtml(prodTrafficFlightList,"flight",$content);//初始化飞机详细数据
    	fillTrafficDetailHtml(prodTrafficTrainList,"train",$content);//初始化火车详细数据
    	fillTrafficDetailHtml(prodTrafficShipList,"ship",$content);//初始化轮船详细数据
    	fillTrafficDetailHtml(prodTrafficBusList,"bus",$content);//初始化汽车详细数据
    }

    /**
     * 初始化 行程选择框
     */
    function fillProdLineRouteHtml(prodLineRouteList,$content){
        var htmlText_start = '<div class="suitable_line_route_div"><td class="e_label"><i class="cc1">*</i>适用行程：</td><td class="suitable_line_route_td">';
        var htmlText_ck = '';
        $.each(prodLineRouteList, function(index, value) {
            // 有效且已选
            if(value.cancleFlag=='Y' && value.selected){
                htmlText_ck+='<input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value="'+value.lineRouteId+'" checked="checked">'+value.routeName+' &nbsp;&nbsp;';
            }

            // 无效且已选
            if(value.cancleFlag=='N' && value.selected){
                htmlText_ck+='<input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value="'+value.lineRouteId+'" checked="checked">'+value.routeName+' <i style="color: red">（无效）</i> &nbsp;&nbsp;';
            }

            // 有效且未选
            if(value.cancleFlag=='Y' && !value.selected){
                htmlText_ck+='<input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value="'+value.lineRouteId+'">'+value.routeName+' &nbsp;&nbsp;';
            }

            // 无效且未选
            if(value.cancleFlag=='N' && !value.selected){
                htmlText_ck+='<input type="checkbox" class="selectLineRouteCk" name="selectLineRouteCk" value="'+value.lineRouteId+'">'+value.routeName+' <i style="color: red">（无效）</i> &nbsp;&nbsp;';
            }
        });
        var htmlText_end = '</td></div>';
        $content.$selectLineRoute.empty().append(htmlText_start+htmlText_ck+htmlText_end);
    }

    /*
     <!-- 行程选择 开始-->
     <div class="suitable_line_route_div">
     <td class="e_label">适用行程：</td>
     <td class="suitable_line_route_td">
     <!--分销商遍历-->
     <input type="checkbox" class="selectLineRouteCk" name="distributorUserIds" value="10000-967"> 行程A &nbsp;&nbsp;

     <!--用于日志 -->
     <input type="checkbox" class="selectLineRouteCk" name="distUserNames" value="无线APP（个人）" >行程D <i style="color: red">（无效）</i>&nbsp;&nbsp;
     </td>
     </div>
     <!-- 行程选择 结束-->
    */

    /**
     * 填充详细数据的html与值
     */
    function fillTrafficDetailHtml(prodTrafficList,trafficType,$content){
    	var runFlag = (trafficType == 'bus' || trafficType == 'ship' || trafficType == 'flight' || trafficType == 'train') && ( prodTrafficList.length > 0);
    	
    	if (!runFlag) {
    		return;
    	}
    	var isGoTransit = false;//false为去程,true为去程中转
		var isReturnTransit = false;//false为返程,true为返程中转
    	$.each(prodTrafficList, function(index, value) {
			var $item = {};
			var $items = {};
			var $transit = $template.find(".JS_"+trafficType+"_transit").clone();
			if (value.tripType == 'TO') {
				$item = $content.$go;
				$items = $content.$goTransits;
				if(!isGoTransit){//去程
					if(trafficType != "" && trafficType == "flight"){
						$item.find(".JS_"+trafficType+"_go").attr("data", value.flightId);
						initFlightValue($item,value);//初始化去程汔车信息值
					}else if(trafficType != "" && trafficType == "train"){
						$item.find(".JS_"+trafficType+"_go").attr("data", value.trainId);
						initTrainValue($item,value);//初始化去程火车信息值
					}else if(trafficType != "" && trafficType == "ship"){
						$item.find(".JS_"+trafficType+"_go").attr("data", value.shipId);
						initShipValue($item,value);//初始化去程轮船信息值
					}else if(trafficType != "" && trafficType == "bus"){
						$item.find(".JS_"+trafficType+"_go").attr("data", value.busId);
						initBusValue($item,value);//初始化去程汔车信息值
					}
					isGoTransit = true;
				}else{//去程中转
					appendTransit($items, $transit, trafficType, value);//添加中转交通工具
				}
			} else if (value.tripType == 'BACK'){
				$item = $content.$return;
				$items = $content.$returnTransits;
				if(!isReturnTransit){
					if(trafficType != "" && trafficType == "flight"){
						$item.find(".JS_"+trafficType+"_return").attr("data", value.flightId);
						initFlightValue($item,value);//初始化返程飞机信息值
					}else if(trafficType != "" && trafficType == "train"){
						$item.find(".JS_"+trafficType+"_return").attr("data", value.trainId);
						initTrainValue($item,value);//初始化返程火车信息值
					}else if(trafficType != "" && trafficType == "ship"){
						$item.find(".JS_"+trafficType+"_return").attr("data", value.shipId);
						initShipValue($item,value);//初始化返程轮船信息值
					}else if(trafficType != "" && trafficType == "bus"){
						$item.find(".JS_"+trafficType+"_return").attr("data", value.busId);
						initBusValue($item,value);//初始化返程轮船信息值
					}
					isReturnTransit = true;
				}else{
					appendTransit($items, $transit, trafficType, value);//添加中转交通工具
				}
			}
    	});
    }
    
    /**
     * 添加中转交通工具
     */
    function appendTransit($items,$transit,trafficType,value){
    	$items.append($transit);
		if(trafficType != "" && trafficType == "flight"){
			$items.find(".JS_"+trafficType+"_transit:last").attr("data", value.flightId);
			initFlightValue($transit,value);//初始化去程中转火车信息值
		}else if(trafficType != "" && trafficType == "train"){
			$items.find(".JS_"+trafficType+"_transit:last").attr("data", value.trainId);
			initTrainValue($transit,value);//初始化去程中转火车信息值
		}else if(trafficType != "" && trafficType == "ship"){
			$items.find(".JS_"+trafficType+"_transit:last").attr("data", value.shipId);
			initShipValue($transit,value);//初始化去程中转轮船信息值
		}else if(trafficType != "" && trafficType == "bus"){
			$items.find(".JS_"+trafficType+"_transit:last").attr("data", value.busId);
			initBusValue($transit,value);//初始化去程上车点汔车信息值
		}
    }
    
    /**
     * 初始化飞机信息值
     */
    function initFlightValue($item,value){
    	if (value.flightNo != null && value.flightNo != "") {//有参考航班
			$item.find("input[name=flightNo]").val(value.flightNo);
			$item.find("a[name=fill_flight]").trigger("click");
			$item.find("input[name=cabin][value="+value.cabin+"]").attr("checked",'checked');
		} else {//无参考航班
			$item.find(".JS_btn_has_not_reference").trigger("click");
			//填充无参考航班时的初始化数据
			$item.find(".JS_has_not_reference").find("input[name=fromCity]").val(value.fromCityName);
			$item.find(".JS_has_not_reference").find("input[name=fromCityHidden]").val(value.fromCity);
			$item.find(".JS_has_not_reference").find("input[name=toCity]").val(value.toCityName);
			$item.find(".JS_has_not_reference").find("input[name=toCityHidden]").val(value.toCity);
			$item.find("input[name=cabin][value="+value.cabin+"]").attr("checked",'checked');
		}
    }
    
    /**
     * 初始化火车信息值
     */
    function initTrainValue($item,value){
    	if (value.trainNo != null && value.trainNo != "") {//有参考火车
			$item.find("input[name=trainNo]").val(value.trainNo);
			$item.find("a[name=fill_train]").trigger("click");
			$item.find("select[name=startStation]").val(value.startDistrict).trigger("change");
			$item.find("select[name=arriveStation]").val(value.endDistrict).trigger("change");
			$item.find("select[name=trainSeat]").val(value.trainSeatId);
		} else {//无参考火车
			$item.find(".JS_btn_has_not_reference").trigger("click");
			//填充无参考火车时的初始化数据
			$item.find(".JS_has_not_reference").find("input[name=fromCity]").val(value.fromCityName);
			$item.find(".JS_has_not_reference").find("input[name=fromCityHidden]").val(value.fromCity);
			$item.find(".JS_has_not_reference").find("input[name=toCity]").val(value.toCityName);
			$item.find(".JS_has_not_reference").find("input[name=toCityHidden]").val(value.toCity);
		}
    }
    
    /**
     * 初始化轮船信息值
     */
    function initShipValue($item,value){
    	$item.find("input[name=fromAddress]").val(value.fromAddress);
		$item.find("input[name=toAddress]").val(value.toAddress);
		$item.find("input[name=memo]").val(value.memo);
    }
    
    /**
     * 初始化汽车信息值
     */
    function initBusValue($item,value){
    	$item.find("input[name=adress]").val(value.adress);
    	/**
         * update by liuhua on 2016-9-5 begin
         * startTime为空过滤
         */
    	if(value.startTime){
    		$item.find("select[name=startTimeHour]").val(value.startTime.split(':')[0]);
    		$item.find("select[name=startTimeMinute]").val(value.startTime.split(':')[1]);
    	}
//		$item.find("select[name=startTimeHour]").val(value.startTime.split(':')[0]);
//		$item.find("select[name=startTimeMinute]").val(value.startTime.split(':')[1]);
		/**
         * update by liuhua on 2016-9-5 
         */
		$item.find("input[name=memo]").val(value.memo);
    }
    
    /**
     * 打开单选的选择行政区窗口
     */
    $("input[name=fromCity], input[name=toCity]").live("click", function(){
    	var item = $(this).closest(".lp-item");

    	//为每一个input选择城市框生成唯一的标记
    	var uniqueTag = new Date().getTime() + parseInt(Math.random()*100);
    	$(this).attr("data-tag", uniqueTag);

    	//存储此次查询的交通类型
    	var trafficType = "";
    	if (item.length > 0) {
    		trafficType = item.attr("type");
    	}

    	districtSelectDialog = new xDialog("/vst_admin/prod/traffic/selectCityList.do?uniqueTag="+uniqueTag+"&trafficType="+trafficType,{},{title:"选择城市",iframe:true,width:"860",height:"400"});
    });

    /**
     * 后台保存交通信息操作  
     * @param addFlag true为保存后在页面上加一个新交通组的页签,false仅仅进行保存操作作
     * @returns
     */
    function saveTrafficDetail(addFlag){
    	if ($(".lp-tabs").find(".lp-tab").length == 0) {
    		$.alert("请先添加交通信息!");
    		return;
    	}
    	$("#trafficDetailForm").empty();
    	try{
    		var to_type = $("#toType").val();
    		var back_type = $("#backType").val();


    		$(".JS_traffic").each(function(groupIndex){
    			var that = $(this);

                // 构建已选行程
                var selectedLineRouteContent=that.find("div[name=line_route_select]");
                createSelectedLineRouteObjects(groupIndex,selectedLineRouteContent);

    			var toContent = that.find("div[name=to]");//构建去程对象
    			if(to_type=='FLIGHT'){
    				createFlightObjects(groupIndex,toContent,'TO',0);
    			}else if(to_type=='TRAIN'){
    				createTrainObjects(groupIndex,toContent,'TO',0);
    			}else if(to_type=='BUS'){
    				createBusObjects(groupIndex,toContent,'TO',0);
    			}else if(to_type=='SHIP'){
    				createShipObjects(groupIndex,toContent,'TO',0);
    			}

    			var backContent = that.find("div[name=back]");//构建返程对象
    			if(back_type=='FLIGHT'){
    				createFlightObjects(groupIndex,backContent,'BACK',toContent.find(".lp-item").size());
    			}else if(back_type=='TRAIN'){
    				createTrainObjects(groupIndex,backContent,'BACK',toContent.find(".lp-item").size());
    			}else if(back_type=='BUS'){
    				createBusObjects(groupIndex,backContent,'BACK',toContent.find(".lp-item").size());
    			}else if(back_type=='SHIP'){
    				createShipObjects(groupIndex,backContent,'BACK',toContent.find(".lp-item").size());
    			}
    		});
    	}catch(e){
    		$.alert(e);
    		return;
    	}
    	var msg = '确认保存吗 ？';
        $.confirm(msg,function(){
    	    var saveLoading = $.loading("正在保存....");
    	    var skipUrl = "/vst_admin/prod/traffic/findProdTraffic.do?addFlag="+addFlag+"&productId="+$("#productId").val();
    		$.ajax({
    			url : "/vst_admin/prod/traffic/editProdTrafficDetail.do",
    			type : "post",
    			data : $("#trafficDetailForm").serialize(),
    			success : function(result) {
    				saveLoading.close();
    				parent.document.getElementById('saveTransportFlag').value="true";
    				$.alert(result.message,function(){
    					$(parent.document.getElementById("iframeMain")).attr("src",skipUrl);
    				});
    			},
    			error : function(result) {
    				$.alert(result.message);
    				saveLoading.close();
    			}
    		 });
    	});
    }

    /**
     * 构建已选行程
     */
    function createSelectedLineRouteObjects(groupIndex,content){
        content.find("input:checkbox[name=selectLineRouteCk]:checked").each(function(index,value){
            var that = $(this);
            var groupId = that.closest(".JS_traffic").attr("data");
            var lineRouteId = $(value).val();
            $("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficRouteRelationList['+index+'].trafficGroupId" value="'+groupId+'">');
            $("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficRouteRelationList['+index+'].lineRouteId" value="'+lineRouteId+'">');
        });
    }

    /**
     * 构建飞机对象
     * @param groupIndex
     * @param content
     * @param tripType
     * @param baseIndex
     * @returns
     */
    function createFlightObjects(groupIndex,content,tripType,baseIndex){
    	var toLog = '请填写去程飞机';
    	var backLog = '请填写返程飞机';
    	
    	content.find("div[name=template_flight]").each(function(index){
    		var that = $(this);

    		var productId = $("#productId").val();
    		var groupId = that.closest(".JS_traffic").attr("data");
    		var flightId = that.attr("data");

    		var cabinInput = that.find("input[name='cabin']:checked");
    		if (cabinInput.length == 0) {
//    			throw '舱位等级必选';
    			if(tripType == 'TO'){
    				throw toLog;
    			}else{
    				throw backLog;
    			}
    		}

    		//在是否参考航班切换按钮上，有data属性标记着当前填写内容是否为有参考的
    		var isHasReference = that.find(".JS_btn_has_not_reference").attr("data");
    		if (isHasReference == "Y") {

    			//input隐藏域标记是否已经补全
    			var isFill = that.find("input[name='isFill']").val();
    			if(isFill != 'Y'){
//    				throw '请使用[补全],补全航班信息';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			var inputFlightNo = that.find("input[name='flightNo']").val();
    			var flightNo = that.find("span[name='flightNo']").text();
    			if (typeof(flightNo) == 'undefined' || flightNo == null || flightNo.trim() == "" || flightNo != inputFlightNo) {
//    				throw '请使用[补全],补全航班信息';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			flightNo = flightNo.trim();
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].flightNo" value="'+flightNo+'">');
    		} else {
    			var fromCity = that.find("input[name='fromCityHidden']").val();
    			var toCity = that.find("input[name='toCityHidden']").val();
    			if (fromCity =="" || toCity == "") {
//    				throw '航班出发地、目的地必填';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].fromCity" value="'+fromCity+'">');
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].toCity" value="'+toCity+'">');
    		}

    		//舱位等级
    		var cabin = cabinInput.val();

    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].groupId" value="'+groupId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].flightId" value="'+flightId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].tripType" value="'+tripType+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficFlightList['+(index+baseIndex)+'].cabin" value="'+cabin+'">');
    	});
    }

    /**
     * 构建火车对象
     * @param groupIndex
     * @param content
     * @param tripType
     * @param baseIndex
     * @returns
     */
    function createTrainObjects(groupIndex,content,tripType,baseIndex){
    	
    	var toLog = '请填写去程火车';
    	var backLog = '请填写返程火车';
    	
    	content.find("div[name=template_train]").each(function(index){
    		var that = $(this);

    		var productId = $("#productId").val();
    		var groupId = that.closest(".JS_traffic").attr("data");
    		var trainId = that.attr("data");

    		//在是否参考车次切换按钮上，有data属性标记着当前填写内容是否为有参考的
    		var isHasReference = that.find(".JS_btn_has_not_reference").attr("data");
    		if (isHasReference == "Y") {

    			//input隐藏域标记是否已经补全
    			var isFill = that.find("input[name='isFill']").val();
    			if(isFill != 'Y'){
//    				throw '请使用[补全],补全车次信息';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			var inputTrainNo = that.find("input[name='trainNo']").val();
    			var trainNo = that.find("span[name='trainNo']").text();
    			if (typeof(trainNo) == 'undefined' || trainNo == null || trainNo.trim() == "" || trainNo != inputTrainNo) {
//    				throw '请使用[补全],补全车次信息';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			var trainSeatId = that.find("select[name='trainSeat']").val();
    			if (trainSeatId == "") {
//    				throw '未检测到坐席信息';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			var startStationSignId = that.find("select[name=startStation]").val();
    			var arriveStationSignId = that.find("select[name=arriveStation]").val();

    			if (startStationSignId == "" || startStationSignId == "null" || arriveStationSignId == "" || arriveStationSignId == "null") {
//    				throw '未检测到出发车站、到达车站';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}

    			trainNo = trainNo.trim();
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].trainNo" value="'+trainNo+'">');
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].trainSeatId" value="'+trainSeatId+'">');
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].startDistrict" value="'+startStationSignId+'">');
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].endDistrict" value="'+arriveStationSignId+'">');
    		} else {
    			var fromCity = that.find("input[name='fromCityHidden']").val();
    			var toCity = that.find("input[name='toCityHidden']").val();
    			if (fromCity =="" || toCity == "") {
//    				throw '火车出发地、目的地必填';
    				if(tripType == 'TO'){
        				throw toLog;
        			}else{
        				throw backLog;
        			}
    			}
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].fromCity" value="'+fromCity+'">');
    			$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].toCity" value="'+toCity+'">');
    		}

    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].groupId" value="'+groupId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].trainId" value="'+trainId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficTrainList['+(index+baseIndex)+'].tripType" value="'+tripType+'">');
    	});
    }

    /**
     * 构建汽车对象
     * @param groupIndex
     * @param content
     * @param tripType
     * @param baseIndex
     * @returns
     */
    function createBusObjects(groupIndex,content,tripType,baseIndex){
    	var toLog = '请填写去程汽车';
    	var backLog = '请填写返程汽车';
    	
    	content.find("div[name=template_bus]").each(function(index){
    		var that = $(this);
    		var productId = $("#productId").val();
    		var adress = that.find("input[name='adress']").val();
    		var startTimeHour = that.find("select[name='startTimeHour']").val();
    		var startTimeMinute = that.find("select[name='startTimeMinute']").val();
    		var startTime = startTimeHour+":"+startTimeMinute;
    		
    		if(adress == '' || startTimeHour == '' || startTimeMinute == ''){
    			if(tripType == 'TO'){
    				throw toLog;
    			}else{
    				throw backLog;
    			}
    		}
    		
    		var memo = that.find("input[name='memo']").val();
    		var busId = that.attr("data");
    		var groupId = that.closest(".JS_traffic").attr("data");
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].groupId" value="'+groupId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].busId" value="'+busId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].tripType" value="'+tripType+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].adress" value="'+adress+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].startTime" value="'+startTime+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficBusList['+(index+baseIndex)+'].memo" value="'+memo+'">');
    	});
    }

    /**
     * 构建轮船对象
     * @param groupIndex
     * @param content
     * @param tripType
     * @param baseIndex
     */
    function createShipObjects(groupIndex,content,tripType,baseIndex){
    	
    	var toLog = '请填写去程轮船';
    	var backLog = '请填写返程轮船';
    	
    	content.find("div[name=template_ship]").each(function(index){
    		var that = $(this);
    		var productId = $("#productId").val();
    		var fromAddress = that.find("input[name='fromAddress']").val();
    		var toAddress = that.find("input[name='toAddress']").val();
    		
    		if(fromAddress == '' || toAddress == ''){
    			if(tripType == 'TO'){
    				throw toLog;
    			}else{
    				throw backLog;
    			}
    		}
    		
    		var memo = that.find("input[name='memo']").val();
    		var shipId = that.attr("data");
    		var groupId = that.closest(".JS_traffic").attr("data");
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].groupId" value="'+groupId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].shipId" value="'+shipId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].productId" value="'+productId+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].tripType" value="'+tripType+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].fromAddress" value="'+fromAddress+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].toAddress" value="'+toAddress+'">');
    		$("#trafficDetailForm").append('<input type="hidden" name="prodTrafficGroupList['+groupIndex+'].prodTrafficShipList['+(index+baseIndex)+'].memo" value="'+memo+'">');
    	});
    }
    
    /**
     * 保存交通基本信息
     */
	$("#save_button").bind("click",function(){
		
		var newTo = $("#toType").val();
		var newBack = $("#backType").val();
		var oldTo = $("#toTypeCode").val();
		var oldBack = $("#toBackCode").val();
		
		
		if(newTo == "" && newBack == "" ){
			alert("至少选择一种交通工具");
			return;
		}
		
		if((oldTo == "" && oldBack == "") || (newTo == oldTo && newBack == oldBack)){
			if(newTo == oldTo && newBack == oldBack){
				saveProdTraffic(false);//保存交通工具,且saveTransportFlag维持原先状态
			}else{
				saveProdTraffic(true);//保存交通工具,且改变saveTransportFlag为false
			}
		}else{
			$.confirm("原交通信息将被删除，确认保存？",function(){
				saveProdTraffic(true);//保存交通工具,且改变saveTransportFlag为false
			});
		}
		
	});
	
	/**
	 * 保存交通工具
	 * @param isChangeSaveTransportFlag 是否改变saveTransportFlag的状态 
	 * true为saveTransportFlag应该改为false
	 * false为saveTransportFlag维持原先状态
	 */
	function saveProdTraffic(isChangeSaveTransportFlag){
		loading = $.loading("正在保存");
		$.ajax({
			url : "/vst_admin/prod/traffic/saveProdTraffic.do",
			type : "post",
			data : $("#dataForm").serialize(),
			success : function(result) {
				loading.close();
				if(result=='success'){
					if(isChangeSaveTransportFlag){
						parent.document.getElementById('saveTransportFlag').value="false";
					}
					$.alert('保存成功',function(){
						window.location.reload();
					});
				}else {
					$.alert('保存失败');
				}
			},
			error : function(result) {
				loading.close();
				$.alert('服务器错误');
			}
		});
	}

	/**
	 * 改变去程交通、返程交通
	 */
	$("#toType").change(function(){
		if($(this).val()=='BUS'){
			$("#cheseFlag2").show();
			$("#cheseFlag2 input").removeAttr("disabled");
		}else {
			$("#cheseFlag2").hide();
			$("#cheseFlag2 input").attr("disabled","disabled");
		}
	});

	/**
	 * 为按钮补全飞机绑定事件
	 */
	$("a[name=fill_flight]").live("click",function(){
		var parentObj = $(this).closest(".lp-item");//获得父对象
		var flightNo = parentObj.find("input[name=flightNo]").val();

		//清除数据
		parentObj.find("span").html("");
		parentObj.find("input[name=isFill]").val("N");

		fillFlight(parentObj,flightNo,function(res){
			if(res==null || res==''){
				parentObj.find("input[name=isFill]").val("N");
				$.alert('无该航班,请重新查询');
				return;
			}

			parentObj.find("input[name=isFill]").val("Y");
			parentObj.find("span[name=startAirport]").html(res.startAirportString);
			parentObj.find("span[name=arriveAirport]").html(res.arriveAirportString);
			parentObj.find("span[name=startTime]").html(res.startTime);
			parentObj.find("span[name=arriveTime]").html(res.arriveTime);
			parentObj.find("span[name=startTerminal]").html(res.startTerminal);
			parentObj.find("span[name=arriveTerminal]").html(res.arriveTerminal);
			parentObj.find("span[name=startDistrict]").html(res.startDistrictString);
			parentObj.find("span[name=arriveDistrict]").html(res.arriveDistrictString);
			parentObj.find("span[name=flightTime]").html(res.flightTime);
			parentObj.find("span[name=airplane]").html(res.airplaneString);
			parentObj.find("span[name=airline]").html(res.airlineString);
			parentObj.find("span[name=flightNo]").html(res.flightNo);
			if(res.stopCount == '0') {
				parentObj.find("span[name=isStop]").html("否");
			} else {
				parentObj.find("span[name=isStop]").html("是");
			}
			
		});
	});

	/**
	 * 填充航班信息
	 * @param $item
	 * @param flightNo
	 * @param fillData
	 * @returns
	 */
	function fillFlight($item, flightNo,fillData){
		var flightLoading;
		if(flightNo==''||flightNo==null){
			$.alert("请输入航班号");
			return;
		}
		flightLoading = $.loading("正在查询航班信息");
		$.ajax({
				url : "/vst_admin/prod/traffic/findFlight.do",
				type : "post",
				data : {"flightNo":flightNo},
				success : function(result) {
					if (result.code == "success") {
						fillData(result.attributes.flight);
					} else {
						$.dialog({
							mask: true, // 遮罩
							ok: function() {
								
							},// 确定按钮回调函数
						    cancel: function() {
						    	$item.find(".JS_btn_has_not_reference").trigger('click');
						    }, // 取消按钮回调函数
						    okValue: "重新查询", // 确定按钮文本
						    cancelValue: "手动输入",// 取消按钮文本
						    content : result.message
						});
					}
					flightLoading.close();
				},
				error : function(result) {
					flightLoading.close();
				}
		 });
	}

	/**
	 * 为按钮补全火车绑定事件
	 */
	$("a[name=fill_train]").live("click",function() {
		var parentObj = $(this).closest(".lp-item");//获得父对象
		var trainNo = parentObj.find("input[name=trainNo]").val();

		//清除数据
		parentObj.find("span").html("");
		parentObj.find("select").empty();
		parentObj.find("input[name=isFill]").val("N");
		parentObj.find("input[name=trainStopList]").val("");

		if(trainNo==''|| trainNo==null) {
			$.alert("请输入车次");
			return;
		}

		fillTrain(parentObj,trainNo,function(res) {
			if(res==null || res==''){
				parentObj.find("input[name=isFill]").val("N");
				$.alert('无该班次,请重新查询');
				return;
			}
			parentObj.find("input[name=isFill]").val("Y");

			var train = res.train;
			var trainSeatList = res.trainSeatList;
			var trainStopList = res.trainStopList;

			//填充坐席信息
			var trainSeatOptions = "";
			_.each(trainSeatList, function(value, index){
				if (value.isDefault == "Y") {
					trainSeatOptions += "<option value="+value.trainSeatId+" selected=selected>"+value.seatType+"</option>";
				} else {
					trainSeatOptions += "<option value="+value.trainSeatId+">"+value.seatType+"</option>";
				}
			});
			var trainSeatSelect = parentObj.find("select[name=trainSeat]");
			trainSeatSelect.empty();
			trainSeatSelect.html(trainSeatOptions);

			//将经停站信息放入隐藏域中
			var stopListString = JSON.stringify(trainStopList);
			parentObj.find("input[name=trainStopList]").val(stopListString);
			//将车次号显示在页面上
			parentObj.find("span[name=trainNo]").html(train.trainNo);

			//清空出发站到达站输入框
			parentObj.find("select[name=startStation]").empty();
			parentObj.find("select[name=arriveStationName]").empty();
			loadTrainVo(parentObj);
		});
	});

	/**
	 * 加载火车Vo信息（封装trainVo对象，加载页面信息）
	 * @param $item
	 * @returns
	 */
	function loadTrainVo($item) {
		//装载出发站、到达站select控件信息
		loadSelectContent($item);

		var startStationSignId = $item.find("select[name=startStation]").val();
		var arriveStationSignId = $item.find("select[name=arriveStation]").val();
		var trainStopListHidden =$item.find("input[name=trainStopList]").val();
		var stopListJson = JSON.parse(trainStopListHidden);

		var startStation = _.find(stopListJson, function(data){return (data.stopStation == startStationSignId);});
		var arriveStation = _.find(stopListJson, function(data){return (data.stopStation == arriveStationSignId);});

		if (typeof(startStation) == 'undefined' || typeof(arriveStation) == 'undefined') {
			$.alert("数据加载时错误, 请重新补全信息");
			$item.find("input[name=isFill]").val("N");
			return;
		}

		var trainVo = {};
		trainVo.startTime = startStation.departureTime;
		trainVo.arriveTime = arriveStation.arrivalTime;
		trainVo.startStationName = startStation.stopStationString;
		trainVo.arriveStationName = arriveStation.stopStationString;
		trainVo.fromCity = startStation.stopStationDistrictString;
		trainVo.toCity = arriveStation.stopStationDistrictString;
		trainVo.allTime = computingTime(startStation, arriveStation);

		$item.find("span[name=startTime]").html(trainVo.startTime);
		$item.find("span[name=arriveTime]").html(trainVo.arriveTime);
		$item.find("span[name=startStationName]").html(trainVo.startStationName);
		$item.find("span[name=arriveStationName]").html(trainVo.arriveStationName);
		$item.find("span[name=fromCity]").html(trainVo.fromCity);
		$item.find("span[name=toCity]").html(trainVo.toCity);
		$item.find("span[name=allTime]").html(trainVo.allTime);
	}

	/**
	 * 装载select控件信息（备注：火车的出发站与达到站有着一定的关联关系）
	 * @param $item
	 * @returns
	 */
	function loadSelectContent($item) {
		var trainStopListHidden =$item.find("input[name=trainStopList]").val();
		var stopListJson = JSON.parse(trainStopListHidden);

		//获取根据站点位置升序的停靠站列表(引入underscore.js中的sortBy方法进行排序)
		var ascTrainStopList = _.sortBy(stopListJson, function(data){return data.stopStep;});
		//获取根据站点位置降序的停靠站列表
		var descTrainStopList = _.sortBy(stopListJson, function(data){return -data.stopStep;});

		//startStopStep:出发站的站点位置（第X站），arriveStopStep:到达站的站点位置（第X站）
		var startStopStep = $item.find("select[name='startStation']").find("option:selected").attr("data");
		var arriveStopStep = $item.find("select[name='arriveStation']").find("option:selected").attr("data");

		//第一次加载时，无法找到对应的startStopStep、arriveStopStep
		if (typeof(startStopStep) == 'undefined' || typeof(arriveStopStep) == 'undefined') {
			startStopStep = _.first(ascTrainStopList).stopStep;
			arriveStopStep = _.last(ascTrainStopList).stopStep;
		}

		//对停靠站信息进行过滤（过滤目的：①对于出发站的列表信息将过滤掉到达车站以后的车站，②对于到达站的列表信息将过滤掉出发车站之前的车站）
		ascTrainStopList = _.filter(ascTrainStopList, function(value){ return value.stopStep < arriveStopStep; });
		descTrainStopList = _.filter(descTrainStopList, function(value){ return value.stopStep > startStopStep; });

		//填充出发车站select控件
		var startStationOptions = "";
		_.each(ascTrainStopList, function(value, index){
			if (startStopStep == value.stopStep) {
				startStationOptions += "<option value="+value.stopStation+" data="+value.stopStep+" selected=selected>"+value.stopStationString+"</option>";
			} else {
				startStationOptions += "<option value="+value.stopStation+" data="+value.stopStep+">"+value.stopStationString+"</option>";
			}
		});

		var startStationSelect = $item.find("select[name=startStation]");
		startStationSelect.empty();
		startStationSelect.html(startStationOptions);

		//填充到达车站select控件
		var arriveStationOptions = "";
		_.each(descTrainStopList, function(value, index){
			if (arriveStopStep == value.stopStep) {
				arriveStationOptions += "<option value="+value.stopStation+" data="+value.stopStep+" selected=selected>"+value.stopStationString+"</option>";
			} else {
				arriveStationOptions += "<option value="+value.stopStation+" data="+value.stopStep+">"+value.stopStationString+"</option>";
			}
		});

		var arriveStationSelect = $item.find("select[name=arriveStation]");
		arriveStationSelect.empty();
		arriveStationSelect.html(arriveStationOptions);
	}

	/**
	 * 计算耗时（火车）
	 * @param startStation
	 * @param arriveStation
	 * @returns
	 */
	function computingTime(startStation, arriveStation) {
		var allTime = "00小时00分";

		if (startStation == null || arriveStation == null || startStation == "" || arriveStation == "") {
			return allTime;
		}

		var startHm = startStation.departureTime.split(":");
		var arriveHm = arriveStation.arrivalTime.split(":");
		var runDays = arriveStation.runDays - startStation.runDays;

		if (startHm.length != 2 || arriveHm.length != 2) {
			//数据有误，计算失败
			return allTime;
		}

		var minutes = arriveHm[1] - startHm[1];
		var hours = arriveHm[0] - startHm[0];

		if (minutes < 0) {
			hours -= 1;
			minutes += 60;
		}

		if (hours < 0) {
			runDays -= 1;		
			hours += 24;
		}
		
		if (runDays < 0) {
			//数据有误，计算失败
			return allTime;
		}

		allTime = (runDays*24 + hours) + "小时" + minutes + "分";
		return allTime;
	}

	/**
	 * 选择火车的出发站OR到达站时触发（火车）
	 */
	$("select[name=startStation], select[name=arriveStation]").live("change", function() {
		var parentObj = $(this).closest(".lp-item");//获得父对象
		var startStopStep = parentObj.find("select[name='startStation']").find("option:selected").attr("data");
		var arriveStopStep = parentObj.find("select[name='arriveStation']").find("option:selected").attr("data");

		if (parseInt(startStopStep) >= parseInt(arriveStopStep)) {
			$.alert("出发站、到达站不匹配，已经重新加载信息");
			parentObj.find("a[name=fill_train]").trigger("click");
			return;
		}

		loadTrainVo(parentObj);
	});

	/**
	 * 填充火车信息
	 * @param $item
	 * @param trainNo
	 * @param fillData
	 * @returns
	 */
	function fillTrain($item,trainNo,fillData){
		var trainLoading = $.loading("正在查询车次信息");
		$.ajax({
				url : "/vst_admin/prod/traffic/findTrain.do",
				type : "post",
				async : false,
				data : {"trainNo":trainNo},
				success : function(result) {
					if (result.code == "success") {
						fillData(result.attributes);
					} else {
						$.dialog({
							mask: true, // 遮罩
							ok: function() {
								
							},// 确定按钮回调函数
						    cancel: function() {
						    	$item.find(".JS_btn_has_not_reference").trigger('click');
						    }, // 取消按钮回调函数
						    okValue: "重新查询", // 确定按钮文本
						    cancelValue: "手动输入",// 取消按钮文本
						    content : result.message
						});
					}
					trainLoading.close();
				},
				error : function(result) {
					trainLoading.close();
				}
		 });
	}

	/**
	 * 构建提交交通详细对象
	 */
	$("#save_traffic_detail").click(function(){
        //判断已选行程是否为空
        var flag=true;
        $(".lp-body").find(".JS_traffic").each(function(){
            var that=$(this);
            //判断是否为出境
            if($("#productType",window.parent.document).val()=="FOREIGNLINE"){
                if(that.find("input:checkbox[name=selectLineRouteCk]:checked").length==0){
                    flag=false;
                    $.alert("请选择适用行程!");
                    return false;
                }
            }
        });
        if(flag){
            saveTrafficDetail(false);
        }


	});

})();
