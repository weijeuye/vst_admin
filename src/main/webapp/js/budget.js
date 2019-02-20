var Budget = {
		/**
		 * @param currentPage   当前页
		 * @param supplierId    供应商ID
		 * @param budgetFlag    是否绑定
         * @param suppGoodsId   商品ID
		 */
		param:function(){
			this.currentPage;
			this.supplierId;
			this.budgetFlag;
            this.suppGoodsId;
            this.productId;
            this.precontrolPolicyId;
            this.tradeEffectDate;
            this.tradeExpiryDate;
		},
        //绑定商品分页
        paginationOfBudget:function(param){
            var budgetFlag = param.budgetFlag;
			$.ajax({
				type: "post",
				url: "/vst_admin/percontrol/suppGoods/goodsList.do",
				data: param,
				dataType: 'html',
				success: function(data) {
                    if(JSON.parse(budgetFlag)){
                        $(".bound-product").html(data);
                    }else{
                        $(".unbind-product").html(data);
                    }
				}
			});
		},
        //订单列表分页
        paginationOfOrderBudget:function(param){
            $.ajax({
                type: "post",
                url: "/vst_admin/percontrol/suppGoods/orderList.do",
                data: param,
                dataType: 'html',
                success: function(data) {
                    $("#orderTable").html(data);
                }
            });
        },
        /**
         * 切换tab页（绑定资源预控商品Tab页切换）
         * @param supplierId
         * @param budgetFlag
         */
        convertTab:function(supplierId,currentPage,budgetFlag,precontrolPolicyId){
            $("#budgetFlag").val(budgetFlag);
            $("input[type='checkbox']").removeAttr('checked');
            $("#suppGoodsId").val("");
            $("#productId").val("");
            Budget.paginationOfBudget({supplierId:supplierId,currentPage:currentPage,budgetFlag:budgetFlag,precontrolPolicyId:precontrolPolicyId});
        },
        /**
         * 绑定
         */
        bindGoods:function(supplierId,policyId){
        	$(".btn-primary").hide();
            var goodsIds = new Array();
            var productIds = new Array();
            $(".unbind-product").find("input").each(function(i){
                if ("checked" == $(this).attr("checked")) {
                   if($(this).attr("goods-id")&&$(this).attr("product-id")){
                    goodsIds.push($(this).attr("goods-id"));
                    productIds.push($(this).attr("product-id"));
                   
                } 
            }
            });
            $.ajax({
                data:{
                    suppGoodsIds:goodsIds,
                    productIds:productIds,
                    supplierId:supplierId,
                    policyId:policyId
                },
                traditional: true,
                type:"GET",
                dataType: 'json',
                url:"/vst_admin/percontrol/suppGoods/bindSuppGoods.do",
                success:function(data){
                    alert(data.message);
                    if(data.code=="success"){
                       window.location = "/vst_admin/percontrol/suppGoods/index.do?supplierId="+supplierId+"&policyId="+policyId;
                       $(".btn-primary").show(); 
                    }
                    
                },
                error:function(data){
                	$(".btn-primary").show(); 
                },
                complete:function(){
                	$(".btn-primary").show();
                }
                
                
            });
        },
        /**
         *解绑
         */
        unBindGoods:function(supplierId, policyId){
        	var goodsIds = new Array();
        	var productIds = new Array();
        	var selectedNum = 0;
        	$(".bound-product").find("input").each(function(i){
                if ("checked" == $(this).attr("checked")) {
                   if($(this).attr("goods-id")&&$(this).attr("product-id")){
                    goodsIds.push($(this).attr("goods-id"));
                    productIds.push($(this).attr("product-id"));
                    selectedNum++;
             }
                }
            });
        	if (selectedNum == 0) {
        		 backstage.alert({
                     title: "系统提示",
                     content: "请先选择需要解绑的资源"
                 });
        		return;
        	}
        	
        	backstage.confirm({
        	    content: "确认解绑此" + selectedNum + "件商品吗？",
        	    determineCallback: function() {
        	    	$(".unBindingPreControl").hide();
        	        $.ajax({
        	            data: {
        	                suppGoodsIds: goodsIds,
        	                productIds: productIds,
        	                supplierId: supplierId,
        	                policyId: policyId
        	            },
        	            traditional: true,
        	            type: "GET",
        	            dataType: 'json',
        	            async: false,
        	            url: "/vst_admin/goods/recontrol/unBindSuppGoods.do",
        	            success: function(callback) {
        	                if (callback.code == 1) {
        	                    $("#search_button_suppgoods").click();
        	                    backstage.alert({
        	                        content: "解绑成功"
        	                    });
        	                    $(".unBindingPreControl").show();
        	                } else {
        	                    backstage.alert({
        	                        content: "解绑失败"
        	                    });
        	                    $(".unBindingPreControl").show();
        	                }
        	            }
        	        });
        	    }
        	});
        },
        /**
         * 查询商品列表数
         */
        searchBudgetGoodsCount:function(param){
            var count = 0;
            $.ajax({
                data:param,
                type:"GET",
                dataType: 'json',
                async:false,
                url:"/vst_admin/percontrol/suppGoods/searchBudgetGoodsCount.do",
                success:function(data){
                    count = data;
                }
            });
            return count;
        },
        
        /**
         * 推送历史资源
         */
        pushHistoryResource:function(param){
        	
        	$.ajax({
                data:{
                	pushDate:param.pushDate,
                	lastPushDate:param.lastPushDate,
                	preControlPolicyID:param.preControlPolicyID,
                	goodsID:param.goodsID,
                	saleEffectDate:param.saleEffectDate
                	},
                type:"POST",
                ContentType: 'application/json;charset=UTF-8',
                url:"/vst_admin/percontrol/suppGoods/pushHistoryResource.do",
                success:function(data){
                	var diaContainer = $("#pushHistoryResourceDialog").parent();
                    if(data=="OK"){
                    	pushDialog.appendErrorMsg('<div style="margin-left:100px;margin-top:20px;color:green;width:127px;">推送成功!3s后自动关闭</div>');
                    	setTimeout(function(){
                    		pushDialog.dialogInstance.destroy();
                    		//解决上次推送时间缓存问题
                    		window.location.reload();
                    	},3000);
                    }else{
                    	pushDialog.appendErrorMsg('<div style="margin-left:100px;margin-top:20px;color:red;width:127px;">'+data+'</div>');
                    }
                }
            });
        },
        /**
         * 查询某个预控-商品下的历史订单
         */
        viewHistoryResourceByPreControlAndGoods:function(context){
            var suppGoodsId = context.attr("goods-id");
            var policyId = context.attr("policy-id");
             var url = "/vst_admin/percontrol/suppGoods/getHistorySuppGoodsBudgetOrder.do?suppGoodsId="+suppGoodsId
             +"&preControlPolicyId="+policyId;
             var dialogViewOrder = backstage.dialog({
                 width: 775,
                 height: 450,
                 title: "查看已推送历史订单",
                 iframe: true,
                 url: url
             });
        },
        /**
         * 历史资源订单分页查看
         */
        paginationOfHisOrderBudget:function(param){
        	
        	var $this = $(this);
            var suppGoodsId = $(this).attr("goods-id");
            var policyId = $(this).attr("policy-id");
        	
        	$.ajax({
                type: "post",
                url: "/vst_admin/percontrol/suppGoods/historyOrderList.do",
                data: param,
                dataType: 'html',
                success: function(data) {
                    $("#orderTable").html(data);
                }
            });
        }
};

var pushDialog ={
	//弹出时间选择框
    $content: $('<div id="pushHistoryResourceDialog">'+
    			'<span><input id="selectPushDate" type="text"  style="width:130px;margin-left:100px;margin-top:60px;margin-right: 10px;"'+
    			'class="Wdate"></span>'+
    			'<span><a class="btn btn-primary" id="pushBtn">推送</a></span>'+
    			'<div id="errorContainer"></div>'+
    			'</div>'),
    dialogInstance:null,
    dialog: function(lastPushDate){
    	this.dialogInstance = backstage.dialog({
    		width:400,
    		height:250,
    		title:'点击选择推送时间',
    		$content:this.$content
    	});
    	this.clearErrMsg();
    	//清空时间输入框
    	$('#selectPushDate').val('');
    	
    	this.setPushDateRange(lastPushDate);
    },
    errDialog:function(){
    	var _$content = $('<div style="line-height: 150px;color:red;">预控ID或最后推送时间缺失</div>')
		backstage.dialog({
			width:250,
			height:150,
			title:'推送失败',
			$content:_$content
		});
    },
    appendErrorMsg:function(html){
    	this.clearErrMsg();
    	$('#errorContainer').append(html);
    },
    clearErrMsg: function(){
    	$('#errorContainer').empty();
    },
    setPushDateRange:function(lastPushDate){
    	var d = new Date(lastPushDate);
    	d.setDate(d.getDate()-2);
    	$('#selectPushDate').die('click').live('click',function(){
    		WdatePicker({lang:'zh-cn',readOnly:true,minDate:d.toLocaleDateString(),maxDate:lastPushDate});
    	});
    }
}
	
	

$(function(){
    $(".bindingPreControl").live("click",function(){
        Budget.bindGoods($(".supplier-name").attr("supplier-id"),$(".supplier-name").attr("policy-id"));
    });

    $(".unBindingPreControl").live("click",function(){
        Budget.unBindGoods($(".supplier-name").attr("supplier-id"),$(".supplier-name").attr("policy-id"));
    });
    
    $("#search_button_suppgoods").bind("click",function(){
        var budgetFlag = $("#budgetFlag").val();
        var supplierId = $(".supplier-name").attr("supplier-id");
        var suppGoodsId = $("#suppGoodsId").val();
        var precontrolPolicyId = $(".supplier-name").attr("policy-id");
        var productId = $("#productId").val();
        Budget.paginationOfBudget({supplierId:supplierId,currentPage:1,budgetFlag:budgetFlag,suppGoodsId:suppGoodsId,precontrolPolicyId:precontrolPolicyId,productId:productId});
    });
    
    $("#bindAllCheckbox").live("click",function(){
    	if(this.checked){
			$("input[type='checkbox']").attr("checked", "checked");
		
		}else{
		   $("input[type='checkbox']").removeAttr('checked');
		}
	});
    
    $("#unbindAllCheckbox").live("click",function(){
		if(this.checked){
			$("input[type='checkbox']").attr("checked", "checked");
		}else{
			 $("input[type='checkbox']").removeAttr('checked');
		}
	});
    //注册查看已推送历史订单事件
    
    $('a.JS_btn_view_His_order').live('click',function(){
    	Budget.viewHistoryResourceByPreControlAndGoods($(this));
    });
    
    //注册推送历史资源事件
    $("a.pushHistoryResource").live('click',function(){
    	var $this = $(this);
    	var precontrolid = $this.data('precontrolid');
    	var lastPushDate = $this.data('lastpushdate');
    	var goodsid = $this.data('goodsid');
    	var saleEffectDate = $this.data('saleeffectdate');
    	
    	if(!precontrolid||!lastPushDate||!goodsid||!saleEffectDate){
    		pushDialog.errDialog();
    		return;
    	}
    	pushDialog.dialog(lastPushDate);

    	//注册弹出框推送事件
    	//防止多次注册
    	$('#pushBtn').die('click').live('click',function(){
    		var pushDate = $('#selectPushDate').val();
    		if(!pushDate){
    			pushDialog.appendErrorMsg('<div  style="margin-left:100px;margin-top:20px;color:red;width:127px;">请选择时间</div>')
    			return;
    		}
    		var param = {
    				pushDate:pushDate,
    				lastPushDate:lastPushDate,
    				preControlPolicyID:precontrolid,
    				goodsID:goodsid,
    				saleEffectDate:saleEffectDate
    				};
    		Budget.pushHistoryResource(param);
    	});
    });
})
