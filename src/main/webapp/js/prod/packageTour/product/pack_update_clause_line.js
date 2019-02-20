var global_dialog = null;

function kickoffClauseSettingStep(productId, productType) {
	var cancelFlag = $("#cancelFlag").val();
	var bizCategoryId = $("#categoryId").val();

	var deferred = $.Deferred();
	var isOK = true;
	if("Y" == cancelFlag) {
		var postUrl = "http://super.lvmama.com/vst_admin/prod/product/cancelProduct.do";
		$.ajax({
			url : postUrl,
			data : {productId:productId,cancelFlag:"N",bizCategoryId:bizCategoryId },
			dataType:'JSON',
			type: "POST",
			success : function(result){
				if(result && result.code == "success") {
					isOK = true;
				} else {
					$.alert("更新产品状态失败， 请联系管理员");
				}
			},
			error : function(){
				$.alert('服务器错误');
			},
			complete:function(){
				deferred.resolve();				
			}
		});
	} else {
		deferred.resolve();
	}
	
	deferred.done(function(){
		if(!isOK) {
			return ;
		}
		var url = "http://super.lvmama.com/vst_admin/scenicHotel/loadTravelAlert.do?embedFlag=Y&productId=" + productId + "&productType=" + productType;
		global_dialog = pandora.dialog({
			wrapClass: "dialog-big",
			width: "1000px",
			height: "450px",
			iframeHeight:"450px",
			title : "设置条款 如不保存，会造成页面信息缺失、产品无效！！！",
			content : url,
			okValue: "保存并下一步",
			ok:  function(){
				//保存条款
				var iframeWindow = $(".btn-ok").closest(".dialog-inner").find("iframe")[0].contentWindow;
				iframeWindow.trySubmit();
				return false;
			},
			dialogAuto:true,
			mask: true
		});
	});
}

//行程选择, 点击选择行程时触发kickoffLineEdit
function kickoffShowUpdateRoute(productId) {
	if(global_dialog) {
		global_dialog.close(); global_dialog = null;
	}
	var url = "http://super.lvmama.com/vst_admin/packageTour/prod/product/showUpdateRoute.do?embedFlag=Y&productId=" + productId;
	global_dialog = pandora.dialog({
		wrapClass: "dialog-big",
		width: "1000px",
		height: "450px",
		iframeHeight:"450px",
		title : "行程选择 如不保存，会造成页面信息缺失、产品无效！！！",
		content : url,
		dialogAuto:true,
		mask: true
	});
}



//行程编辑保存后的提交按钮
function kickoffLineEdit(lineRouteId, productId, productType) {
	if(global_dialog) {
		global_dialog.close(); global_dialog = null;
	}
	var url = "http://super.lvmama.com/vst_admin/prod/prodLineRoute/selectProdLineRoute.do?embedFlag=Y&productId=" + productId + "&lineRouteId=" + lineRouteId;
	global_dialog = pandora.dialog({
		wrapClass: "dialog-big",
		width: "1000px",
		height: "450px",
		iframeHeight:"450px",
		title : "行程设置 如不保存，会造成页面信息缺失、产品无效！！！",
		content : url,
		okValue: "保存并下一步",
		ok:  function(){
			//保存行程明细
			var iframeWindow = $(".btn-ok").closest(".dialog-inner").find("iframe")[0].contentWindow;
			iframeWindow.trySubmit();
			return false;
		},
		dialogAuto:true,
		mask: true
	});
}


//行程明细保存后的回调函数

function kickoffLineDetailEdit(lineRouteId, productId, productType) {
	if(global_dialog) {
		global_dialog.close(); global_dialog = null;
	}
	
	var url = "http://super.lvmama.com/vst_admin/prod/prodLineRoute/editprodroutedetail.do?embedFlag=Y&lineRouteId=" + lineRouteId + "&productId=" + productId;
	global_dialog=pandora.dialog({
		wrapClass: "dialog-big",
		width: "1000px",
		height: "450px",
		iframeHeight:"450px",
		title : "行程明细  如不保存，会造成页面信息缺失、产品无效！！！",
		content : url,
		okValue: "保存并下一步",
		ok:  function(){
			//保存行程明细
			var iframeWindow = $(".btn-ok").closest(".dialog-inner").find("iframe")[0].contentWindow;
			iframeWindow.trySubmit();
			return false;
		},
		dialogAuto:true,
		mask: true
	});
}

//费用说明

function kickoffCostEdit(lineRouteId, productId, productType) {
	if(global_dialog) {
		global_dialog.close(); global_dialog = null;
	}
	
	var url = "http://super.lvmama.com/vst_admin/scenicHotel/loadCost.do?embedFlag=Y&lineRouteId=" + lineRouteId + "&productId=" + productId + "&productType=" + productType;
	global_dialog = pandora.dialog({
		wrapClass: "dialog-big",
		width: "1000px",
		height: "450px",
		iframeHeight:"450px",
		title : "费用说明 如不保存，会造成页面信息缺失、产品无效！！！",
		content : url,
		okValue: "保存",
		ok:  function(){
			var iframeWindow = $(".btn-ok").closest(".dialog-inner").find("iframe")[0].contentWindow;
			iframeWindow.trySubmit();
			return false;
		},
		dialogAuto:true,
		mask: true
	});
}

function finishedCostEdit() {
	 if(global_dialog) {
		 global_dialog.close(); global_dialog = null;
	 }
	var cancelFlag = $("#cancelFlag").val();
	var bizCategoryId = $("#categoryId").val();
	var productId = $("#productId").val();

	var deferred = $.Deferred();
	var isOK = true;
	if("Y" == cancelFlag) { //虽然页面的状态仍然为有效，但是数据库已经被设置为无效了，恢复之。
		var postUrl = "http://super.lvmama.com/vst_admin/prod/product/cancelProduct.do";
		$.ajax({
			url : postUrl,
			data : {productId:productId,cancelFlag:"Y",bizCategoryId:bizCategoryId },
			dataType:'JSON',
			type: "POST",
			success : function(result){
				if(result && result.code == "success") {
					isOK = true;
				} else {
					$.alert("更新产品状态失败， 请联系管理员");
				}
			},
			error : function(){
				$.alert('服务器错误');
			},
			complete:function(){
				deferred.resolve();				
			}
		});
	} else {
		deferred.resolve();
	}
	 //刷新当前页面
	deferred.done(function(){
		if(isOK) {
			window.location.reload();
		}
	});
	 
}
