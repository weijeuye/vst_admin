function hasChanges() {
	var newBlockes = $("#travelAlertForm").find("div.newDivIndicator").size();
	var modifiedFields = $("#travelAlertForm").find("span.nova-tip-form").size();
	if(newBlockes > 0 || modifiedFields > 0) {
		return {isOK:false, msg:"请先保存出行警示及说明的变动"};
	}
	return {isOK:true};
}

$(function(){
	$(".js_switcher").on("click", function(event){
		var $this = $(this);
		if($this.attr("checked") == "checked") {
			$this.parent().parent().find("textarea").removeAttr("disabled");
		} else {
			var $textarea = $this.parent().parent().find("textarea");
			$textarea.attr("disabled", "disabled");
		}
	});
	
	$("#save").on('click', function(event){
		trySubmit();
	});
	window.trySubmit = function() {
		
		 if(!$("#travelAlertForm").validate().form()){
			 $.alert("输入校验不过， 请根据提示修改后再次保存");
			return false;
		 }
		 
		var postUrl = $("#travelAlertForm").attr("action");
		var productId = $("[name='productDesc.productId']").val();
		var productType = $("[name='productDesc.productType']").val();
		var currPageUrl = "http://super.lvmama.com/vst_admin/scenicHotel/loadTravelAlert.do?productId=" + productId + "&productType=" + productType ;
		
		var saveCallback = function() {
			var loading = $.loading("保存中......");
			$.ajax({
				url : postUrl,
				data : $("#travelAlertForm").serialize(),
				dataType:'JSON',
				type: "POST",
				success : function(result){
					if(result && result.code == "success") {
						var embedFlag = $("[name=embedFlag]").val();
						if("Y" == embedFlag) {
							if(window.parent && window.parent.kickoffShowUpdateRoute) {
								window.parent.kickoffShowUpdateRoute(productId);
							}
						} else {
							$.alert(result.message, function(){						
								location.href = currPageUrl;
							});
						}
					} else {
						$.alert("保存失败， 请联系管理员");
					}
				},
				error : function(){
					$.alert('服务器错误');
				},
				complete:function(){
					loading.close();				
				}
			});
		};
		
		if(refreshSensitiveWord($("input[type=\"text\"],textarea"))){
			var message = "存在敏感词，继续保存？";
			$.confirm(message, function () {
				saveCallback();
			});
		} else {
			saveCallback();
		}
	}
	
	$("#viewLog").on("click", function(e){
		var param=$(this).attr("param");
		if(param.indexOf('&') != -1){
			new xDialog("/lvmm_log/bizLog/showVersatileLogList?"+param,{},{title:"查看日志",iframe:true,width:1000,hight:300,iframeHeight:680,scrolling:"yes"});
			return;
		}
		new xDialog("/vst_admin/pub/comLog/findComLogList.do?param="+param,{},{title:"日志详情页",iframe:true,width:1000,hight:500,scrolling:"yes"});
	});
	
	//酒店新增操作
	$(".js_add_hotel").on("click", function(e){
		var index = $(this).attr("index");
		index = parseInt(index) + 1;
		$(this).attr("index", index);
		
		//酒店最多10个
		var hotelSz = $(".JS_container_hotel_div").find("div.s_mt1").size();
		if(hotelSz >=10) {
			$.alert("酒店的上限为10个");
			return ;
		}
		
		var content =   "<div class=\"s_mt1\"> "
						+"	<div> "
						+"		<span class=\"label\">酒店名称：</span> "
						+"		<input type=\"hidden\" name=\"travelAlert.hotelList[" + index + "].id\" > "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].name\"  > "
						+"	</div> "
						+"	<div> "
						+"		<span class=\"label\">酒店地址：</span> "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].address\"  \> "
						+"	</div> "
						+"	<div> "
						+"		<span class=\"label\">前台电话：</span> "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].phone\"  \> "
						+"	</div> "
						+"	<div> "
						+"		<span class=\"label\">最早到店时间：</span> "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].arriveTime\"  \> "
						+"	</div> "
						+"	<div> "
						+"		<span class=\"label\">最晚离店时间：</span> "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].leaveTime\"  \> "
						+"	</div> "
						+"	<div> "
						+"		<span class=\"label\">入住方式：</span> "
						+"		<input type=\"text\" class=\"s_1\" name=\"travelAlert.hotelList[" + index + "].checkinStyle\"  \> "
						+"	</div> "
						+"	<div class=\"s_mt2\">"
						+"		<a href=\"javascript:void(0);\" class=\"btn btn_cc1\">删除</a>"
						+"	</div> "
						+"</div>" ;
		$(".JS_container_hotel_div").append(content);
	});
	
	//门票的新增操作
	$(".js_add_ticket").on("click", function(e){
		var index = $(this).attr("index");
		index = parseInt(index) + 1;
		$(this).attr("index", index);

		var ticketSz = $(".JS_container_ticket_div").find("div.s_mt1").size();
		if(ticketSz >=10) {
			$.alert("门票的上限为10个");
			$('html,body').animate({scrollTop: $(this).offset().top},'slow');
			return ;
		}
		

		
		var content = "	<div class=\"s_mt1\"> "
					+"		<div>  "
					+"			<span class=\"label\">景点名称：</span> "
					+"			<input type=\"hidden\" name=\"travelAlert.ticketList[" + index + "].id\" > "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].name\"  > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">景点地址：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].destName\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">免票政策：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].freePolicy\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">优惠政策：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].preferentialCrowd\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">重要说明：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].bookDescription\" > "
					+"		</div> "
					+"		<div class=\"ticketGoodsIndicator\"></div> "
					+"		<div> "
					+"			<span class=\"label\">门票名称：</span> "
					+"			<input type=\"hidden\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].id\" > "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].name\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">入园时间：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].limitTime\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\"\>取票地点：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].changeAddress\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">取票时间：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].changeTime\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">取票方式：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].entryStyle\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">有效期：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].expireDays\" > "
					+"		</div> "
					+"		<div> "
					+"			<span class=\"label\">重要提示：</span> "
					+"			<input type=\"text\" class=\"s_1\" name=\"travelAlert.ticketList[" + index + "].goodsList[0].importWarning\" > "
					+"		</div> "
					+"		<div class=\"s_mt2\">"
					+"			<a href=\"#\" class=\"btn btn_cc1\">删除</a>"
					+"		</div> "
 					+"	</div>";
		$(".JS_container_ticket_div").append(content);
		
		
		var v_top = $(this).offset().top;
		$('html,body').animate({scrollTop:  v_top - 100}, 50);
	});
	
	
	//模块删除
	$(".JS_container_ticket_div,.JS_container_hotel_div").on("click", ".s_mt2", function(e){
		var sz = $(this).closest(".container").find("div.s_mt1").size();
		if(sz == 1) {
			//酒店还是门票?
			var isTicket = $(this).closest(".container").hasClass("JS_container_ticket_div");
			$.alert("最后一个" + (isTicket?"门票":"酒店") + "模块不能删除");
			return ;
		}
		var $div = $(this).closest("div.s_mt1");
		$div.remove();
		$.alert("删除成功！");
	});
	
	
	$("div.JS_TICKET_CHECKBOX, div.JS_HOTEL_CHECKBOX").on("change", "input", function(e){
		var $this = $(this);
		if($this.closest("div.category_header").hasClass("JS_TICKET_CHECKBOX")) {
			if($this.is(":checked")){
				$(".JS_container_ticket_div").find("input:visible").removeAttr("disabled");
			} else {
				$(".JS_container_ticket_div").find("input:visible").attr("disabled", "disabled");
			}
		}
		if($this.closest("div.category_header").hasClass("JS_HOTEL_CHECKBOX")) {
			if($this.is(":checked")){
				$(".JS_container_hotel_div").find("input:visible").removeAttr("disabled");
			} else {
				$(".JS_container_hotel_div").find("input:visible").attr("disabled", "disabled");
			}
		}
	});
	
});


//刷新敏感词提示
$(function(){
	refreshSensitiveWord($("input[type=\"text\"],textarea"));
});