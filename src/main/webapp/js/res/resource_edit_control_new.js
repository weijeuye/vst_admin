var $document = $(document);
// 新增子预控
$(function() {
	var $document = $(document);
	$document.on("click", ".JS_add_controlItem", viewRemainderHanlder);
	function viewRemainderHanlder() {
		var $this = $(this);
		var precontrolPolicyId = $("#id").val();
		var controlType = $("input[name='controlType']:checked").val();
		var url = "/vst_admin/goods/recontrol/goToAddResControlItem/view.do?precontrolPolicyId="
				+ precontrolPolicyId + "&controlType=" + controlType;
		window.dialogViewOrder = backstage.dialog({
			width : 650,
			height : 200,
			title : "新增子预控",
			iframe : true,
			url : url
		});
	}
});

// 修改子预控
$(function() {
	var $document = $(document);
	$document.on("click", ".JS_edit_control", editPolicyItemHanlder);
	function editPolicyItemHanlder() {
		var $this = $(this);
		var policyItemId = $(this).attr("data-param");
		var url = "/vst_admin/goods/recontrol/goToEditResPrecontrolPolicyItem/view.do?policyItemId="
				+ policyItemId;
		window.dialogViewOrder = backstage.dialog({
			width : 650,
			height : 200,
			title : "修改子预控",
			iframe : true,
			url : url
		});
	}
});
// 子预控日志详情页
$("a.JS_show_log")
		.live(
				"click",
				function() {
					var $this = $(this);
					var policyItemId = $(this).attr("data-param");
					var param = 'objectId='
							+ policyItemId
							+ '&objectType=RES_PRECONTROL_POLICY_POLICY_ITEM&sysName=VST';
					backstage.dialog({
						width : 750,
						height : 500,
						title : "日志详情页",
						iframe : true,
						url : "/lvmm_log/bizLog/showVersatileLogList?" + param
					});

				});

// 删除子预控
$(function() {
	var $document = $(document);
	$(".JS_delete_control")
			.click(
					function() {

						var thisTd = $(this);
						var policyItemId = $(this).attr("data-param");
						var precontrolPolicyId = $("#id").val();
						var url = "/vst_admin/goods/recontrol/deleteResouceControlItem.do?policyItemId="
								+ policyItemId;
						backstage
								.confirm({
									content : "确认删除吗？",
									determineCallback : function() {
										$
												.ajax({
													url : url,
													dataType : "json",
													async : false,
													success : function(callback) {
														if (callback.code == 1) {
															backstage
																	.alert({
																		content : "删除成功"
																	});
															// thisTd.parent().parent().remove();
															window.location.href = "/vst_admin/goods/recontrol/goToEditResPrecontrolPolicy/view.do?id="
																	+ precontrolPolicyId;
														} else {
															backstage
																	.alert({
																		content : "删除失败,"
																				+ callback.msg
																	});
														}
													}
												})
									}
								});
					});
});

// 预控名称blur事件
/**
 * $document.on("blur", ".JS_pre_name", function() { var
 * name=$("#ControlName").val(); $.ajax({
 * url:"/vst_admin/goods/recontrol/findresPrecontrolPolicyName.do",
 * dataType:"json", data:{name:name}, success:function(data){
 * if(data.name=="N"){ var name=$("#ControlName").val("");
 * $("#spanId").html("项目名不能重复").css("color","red"); }else{
 * $("#spanId").html(""); } } }); console.log(this); });
 */
$document.on("blur", ".JS_memo", function() {
	var name = $("#memo").val();
	var len = name.length;
	if (len > 300) {
		$("#spanMemo").html("*备注最多输入300字").css("color", "red");
	} else {
		$("#spanMemo").html("");
	}
});

// 检出输入的数据是否有负数
$document.on("blur", ".JS_radio_disabled", function() {
	var suma = $("#amounta").val();
	var sumb = $("#amountb").val();
	var tt = /^\d+$/g;
	if (!tt.test(suma) && !tt.test(sumb)) {
		// alert("对不起，预控金额/库存请输入正整数")
		var suma = $("#amounta").val("");
		var sumb = $("#amountb").val("");
	}
});
// 校验输入的买断总成本是否是数字
$document.on("blur", ".JS_buyoutTotalCost", function() {
	var buyoutTotalCost = $("#buyoutTotalCostStr").val();
	// 校验非负数字（小数位不超过2位）
	var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	if (!tt.test(buyoutTotalCost)) {
		$("#spanBuyoutTotalCostStr").html("*买断总成本请输入非负的数字(最多两位小数)").css(
				"color", "red");
		var buyoutTotalCost = $("#buyoutTotalCostStr").val("");
	} else {
		$("#spanBuyoutTotalCostStr").html("");
	}
});
$document.on("blur", ".JS_forecastSales", function() {
	var forecastSales = $("#forecastSalesStr").val();
	var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	if (!tt.test(forecastSales)) {
		$("#spanForecastSalesStr").html("*预估营业额请输入非负的数字(最多两位小数)").css("color",
				"red");
		var forecastSales = $("#forecastSalesStr").val("");
	} else {
		$("#spanForecastSalesStr").html("");
	}
});
$document.on("blur", ".JS_depositAmount", function() {
	var depositAmount = $("#depositAmountStr").val();
	var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	if (!tt.test(depositAmount)) {
		$("#spanDepositAmountStr").html("*押金请输入非负的数字(最多两位小数)").css("color",
				"red");
		var depositAmount = $("#depositAmountStr").val("");
	} else {
		$("#spanDepositAmountStr").html("");
	}
});
$document.on("blur", ".JS_nameAmount", function() {
	var nameAmount = $("#nameAmountStr").val();
	var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
	if (!tt.test(nameAmount)) {
		$("#spanNameAmountStr").html("*冠名金额请输入非负的数字(最多两位小数)").css("color",
				"red");
		var nameAmount = $("#nameAmountStr").val("");
	} else {
		$("#spanNameAmountStr").html("");
	}
});

$document.on("blur", ".JS_payMemo", function() {
	var name = $("#payMemo").val();
	var len = name.length;
	if (len > 300) {
		$("#spanPayMemo").html("*付款备注最多输入300字").css("color", "red");
	} else {
		$("#spanPayMemo").html("");
	}
});
// TODO 开发维护
$(function() {
	var parent = window.parent;

	var $document = $(document);

	var $form = $(".main").find("form");
	var validateAdd = backstage.validate({
		$area : $form,
		REQUIRED : "不能为空",
		showError : true
	});
	// validateAdd.test();
	validateAdd.watch();

	$document
			.on(
					"click",
					".JS_btn_save",
					function() {
						validateAdd.refresh();
						validateAdd.watch();
						validateAdd.test();
						if (validateAdd.getIsValidate()) {
							var temp = $("#daily").is(":hidden");// 是否隐藏
							var temp1 = $("#cycle").is(":hidden");
							var temp2 = $("#initial").is(":hidden");
							if (temp) {
								$("#daily").html("");
							} else {
								var checkbox = $("#daily").find(
										":checkbox:checked");
								if (checkbox.length == 0) {
									alert("提醒设置不能为空")
									return;
								}
							}
							if (temp1) {
								$("#cycle").html("");
							} else {
								var checkbox = $("#cycle").find(
										":checkbox:checked");
								if (checkbox.length == 0) {
									alert("提醒设置不能为空")
									return;
								}

							}
							if (temp2) {
								$("#initial").html("");
							} else {
								var checkbox = $("#initial").find(
										":checkbox:checked");
								if (checkbox.length == 0) {
									alert("提醒设置不能为空")
									return;
								}
							}
							var buyoutTotalCost = $("#buyoutTotalCostStr")
									.val();
							var forecastSales = $("#forecastSalesStr").val();
							var depositAmount = $("#depositAmountStr").val();
							var nameAmount = $("#nameAmountStr").val();
							var memo = $("#memo").val();
							var payMemo = $("#payMemo").val();
							var payWay = $("input[name='payWay']:checked")
									.val();
							var buCode = $('#selBuCode option:selected').val();
							var area1 = $('#selArea1 option:selected').val();
							var area2 = $('#selArea2 option:selected').val();
							if (buCode != "BUSINESS_BU") {
								if (area1 == null || area1 == "") {
									alert("对不起，请选择所属大区");
									return;
								}
							}
							if (buCode == "TICKET_BU") {
								if (area2 == null || area2 == "") {
									alert("对不起，请选择所属分区");
									return;
								}
							}

							// 校验金额
							var tt = /^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2}))|[0])$/;
							if (!tt.test(buyoutTotalCost)) {
								alert("对不起，买断总成本请输入非负的数字(最多两位小数)");
								return;
							}
							if (!tt.test(forecastSales)) {
								alert("对不起，预估营业额请输入非负的数字(最多两位小数)");
								return;
							}
							if (!tt.test(depositAmount)) {
								alert("对不起，押金请输入非负的数字(最多两位小数)");
								return;
							}
							if (!tt.test(nameAmount)) {
								alert("对不起，冠名金额请输入非负的数字(最多两位小数)")
								return;
							}

							if (payWay == "more") {
								var lentrim = $.trim(payMemo).length;
								if (lentrim == 0) {
									alert("多次付款方式，请填写付款备注说明")
									$("#spanPayMemo").html("");
									return;
								}
							}
							var len = payMemo.length;
							if (len > 300) {
								alert("付款备注最多输入300字!");
								return;
							}
							// 校验备注长度
							var len1 = memo.length;
							if (len1 > 300) {
								alert("备注最多输入300字!");
								return;
							}
							console.log("提交表单");
							backstage
									.confirm({
										content : "确认提交吗？",
										determineCallback : function() {
											$
													.ajax({
														url : "/vst_admin/goods/recontrol/editNewResourceControl.do",
														type : "POST",
														cache : false,
														dataType : "json",
														async : false,
														data : $("#saveButton")
																.serialize(),
														success : function(
																result) {
															if (result.code == 1) {
																backstage
																		.alert({
																			content : "保存成功"
																		});
																parent.location.href = "/vst_admin/goods/recontrol/find/resPrecontrolPolicyList.do";
																parent.dialogViewOrder
																		.destroy();
															} else {
																backstage
																		.alert({
																			content : "保存失败,"
																					+ result.msg
																		});
															}
														}

													})
										}
									});

						}
					});
	$document.on("click", ".quxiao", function() {
		parent.dialogViewOrder.destroy();
	});

});

// 供应商名称自动完成
$(function() {
	backstage.autocomplete({
		"query" : ".JS_autocomplete_pn",
		"fillData" : fillData,
		"choice" : choice,
		"clearData" : clearData
	});
	function fillData(self) {
		var url = "/vst_admin/goods/recontrol/findSuppSupplier.do";
		var text = self.$input.val();
		console.log(text);
		self.loading();
		$.ajax({
			url : url,
			data : {
				name : text
			},
			dataType : "json",
			success : function(json) {
				var $ul = self.$menu.find("ul");
				$ul.empty();
				for (var i = 0; i < json.length; i++) {
					var $li = $('<li data-id="' + json[i].id + '">'
							+ json[i].name + '</li>');
					$ul.append($li)
				}

				self.loaded();
			}
		});
	}

	function choice(self, $li) {

		var id = $li.attr("data-id");
		var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
		$hidden.val(id);
	}
	function clearData(self) {
		var $hidden = self.$input.parent().find(".JS_autocomplete_pn_hidden");
		$hidden.val("");
	}
});

// 产品经理自动完成
$(function() {
	backstage.autocomplete({
		"query" : ".JS_autocomplete_pm",
		"fillData" : fillData,
		"choice" : choice,
		"clearData" : clearData
	});
	function fillData(self) {
		var url = "/vst_admin/goods/recontrol/findMangement.do";
		var text = self.$input.val();
		self.loading();
		console.log(text);
		$.ajax({
			url : url,
			data : {
				name : text
			},
			dataType : "json",
			success : function(json) {
				var $ul = self.$menu.find("ul");
				$ul.empty();
				for (var i = 0; i < json.length; i++) {
					var $li = $('<li data-email="' + json[i].email
							+ '" data-id="' + json[i].id + '">' + json[i].name
							+ '</li>');
					$ul.append($li)
				}

				self.loaded();
			}
		});
	}

	function choice(self, $li) {
		var id = $li.attr("data-id");
		var email = $li.attr("data-email");
		var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
		var $email = self.$input.parent().find(
				".JS_autocomplete_pm_hidden_email");
		$hidden.val(id);
		$email.val(email);
	}
	function clearData(self) {
		var $email = self.$input.parent().find(
				".JS_autocomplete_pm_hidden_email");
		$email.val("");
		var $hidden = self.$input.parent().find(".JS_autocomplete_pm_hidden");
		$hidden.val("");
	}
});

// 抄送自动完成
$(function() {
	backstage.autocomplete({
		"query" : ".JS_autocomplete_cc",
		"fillData" : fillData,
		"choice" : choice,
		"clearData" : clearData
	});
	function fillData(self) {
		var url = "/vst_admin/goods/recontrol/findSend.do";
		self.loading();
		var text = self.$input.val();
		console.log(text);
		$.ajax({
			url : url,
			data : {
				name : text
			},
			dataType : "json",
			success : function(json) {
				var $ul = self.$menu.find("ul");
				$ul.empty();
				for (var i = 0; i < json.length; i++) {
					var $li = $('<li data-email="' + json[i].email
							+ '" data-id="' + json[i].id + '">' + json[i].name
							+ '</li>');
					$ul.append($li)
				}

				self.loaded();
			}
		});
	}
	function choice(self, $li) {
		var id = $li.attr("data-id");
		var email = $li.attr("data-email");
		var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
		var $hiddenEmail = self.$input.parent().find(
				".JS_autocomplete_cc_hidden_email");
		$hidden.val(id);
		$hiddenEmail.val(email);
	}
	function clearData(self) {
		var $hidden = self.$input.parent().find(".JS_autocomplete_cc_hidden");
		var $hiddenEmail = self.$input.parent().find(
				".JS_autocomplete_cc_hidden_email");
		$hidden.val("");
		$hiddenEmail.val("");
	}
});

$(function() {

	$("#initial").show();
	$("#cycle").hide();
	$("#daily").hide();
	$("input[name=controlClassification]").change(function() {
		showCont();
	});
});
function showCont() {
	switch ($("input[name=controlClassification]:checked").attr("id")) {
	case "Daily":

		$("#cycle").hide();
		if ("${resPrecontrolPolicy.controlClassification}" == "Daily") {
			$("#initial").show();
			$("#daily").hide();
		} else {
			$("#initial").hide();
			$("#daily").show();
		}
		break;
	case "Cycle":
		$("#daily").hide();

		if ("${resPrecontrolPolicy.controlClassification}" == "Cycle") {
			$("#initial").show();
			$("#cycle").hide();
		} else {
			$("#initial").hide();
			$("#cycle").show();
		}
		break;
	default:
		break;
	}
}

$(function() {
	areaDataJson = [ {
		"buid" : "LOCAL_BU",
		"buname" : "国内游事业部",
		"area1" : [ {
			"aid" : "bjbranch",
			"aname" : "北京分公司"
		}, {
			"aid" : "cdbranch",
			"aname" : "成都分公司"
		}, {
			"aid" : "gzbranch",
			"aname" : "广州分公司"
		}, {
			"aid" : "shhead",
			"aname" : "上海总部"
		} ]
	}, {
		"buid" : "OUTBOUND_BU",
		"buname" : "出境游事业部",
		"area1" : [ {
			"aid" : "shout",
			"aname" : "上海出境"
		}, {
			"aid" : "bjout",
			"aname" : "北京出境"
		}, {
			"aid" : "gzout",
			"aname" : "广州出境"
		}, {
			"aid" : "cdout",
			"aname" : "成都出境"
		} ]
	}, {
		"buid" : "DESTINATION_BU",
		"buname" : "目的地事业部",
		"area1" : [ {
			"aid" : "bjbranch",
			"aname" : "北京分公司"
		}, {
			"aid" : "cdbranch",
			"aname" : "成都分公司"
		}, {
			"aid" : "gzbranch",
			"aname" : "广州分公司"
		}, {
			"aid" : "zenarea",
			"aname" : "浙东北大区"
		}, {
			"aid" : "zwnarea",
			"aname" : "浙西南大区"
		}, {
			"aid" : "scnarea",
			"aname" : "苏中北大区"
		}, {
			"aid" : "snarea",
			"aname" : "苏南大区"
		}, {
			"aid" : "sharea",
			"aname" : "上海大区"
		}, {
			"aid" : "hbarea",
			"aname" : "湖北大区"
		}, {
			"aid" : "aharea",
			"aname" : "安徽大区"
		}, {
			"aid" : "jxarea",
			"aname" : "江西大区"
		}, {
			"aid" : "outatea",
			"aname" : "境外大区"
		}, {
			"aid" : "hnarea",
			"aname" : "海南大区"
		} ]
	}, {
		"buid" : "TICKET_BU",
		"buname" : "景区玩乐事业群",
		"area1" : [ {
			"aid" : "eastarea",
			"aname" : "东区",
			"area2" : [ {
				"pid" : "shanghai",
				"pname" : "上海"
			}, {
				"pid" : "jaingsu",
				"pname" : "江苏"
			}, {
				"pid" : "zhejiang",
				"pname" : "浙江"
			}, {
				"pid" : "jiangxi",
				"pname" : "江西"
			}, {
				"pid" : "fujian",
				"pname" : "福建"
			} ]
		}, {
			"aid" : "southarea",
			"aname" : "南区",
			"area2" : [ {
				"pid" : "guangdong",
				"pname" : "广东"
			}, {
				"pid" : "hunan",
				"pname" : "湖南"
			}, {
				"pid" : "guangxi",
				"pname" : "广西"
			}, {
				"pid" : "hainan",
				"pname" : "海南"
			} ]
		}, {
			"aid" : "northarea",
			"aname" : "北区",
			"area2" : [ {
				"pid" : "beijing",
				"pname" : "北京"
			}, {
				"pid" : "tianjin",
				"pname" : "天津"
			}, {
				"pid" : "hebei",
				"pname" : "河北"
			}, {
				"pid" : "shandong",
				"pname" : "山东"
			}, {
				"pid" : "heilongjiang",
				"pname" : "黑龙江"
			}, {
				"pid" : "jilin",
				"pname" : "吉林"
			}, {
				"pid" : "liaoning",
				"pname" : "辽宁"
			}, {
				"pid" : "neimenggu",
				"pname" : "内蒙古"
			} ]
		}, {
			"aid" : "westarea",
			"aname" : "西区",
			"area2" : [ {
				"pid" : "chongqing",
				"pname" : "重庆"
			}, {
				"pid" : "sichuan",
				"pname" : "四川"
			}, {
				"pid" : "yunnan",
				"pname" : "云南"
			}, {
				"pid" : "guizhou",
				"pname" : "贵州"
			}, {
				"pid" : "xinjiang",
				"pname" : "新疆"
			}, {
				"pid" : "gansu",
				"pname" : "甘肃"
			}, {
				"pid" : "ningxia",
				"pname" : "宁夏"
			}, {
				"pid" : "qinghai",
				"pname" : "青海"
			}, {
				"pid" : "xizang",
				"pname" : "西藏"
			} ]
		}, {
			"aid" : "centralarea",
			"aname" : "中区",
			"area2" : [ {
				"pid" : "henan",
				"pname" : "河南"
			}, {
				"pid" : "shanxi",
				"pname" : "陕西"
			}, {
				"pid" : "anhui",
				"pname" : "安徽"
			}, {
				"pid" : "hubei",
				"pname" : "湖北"
			}, {
				"pid" : "shanxip",
				"pname" : "山西"
			} ]
		}, {
			"aid" : "outboundarea",
			"aname" : "出境",
			"area2" : [ {
				"pid" : "xinmayin",
				"pname" : "新马印"
			}, {
				"pid" : "oumeiaofei",
				"pname" : "欧美澳非"
			}, {
				"pid" : "taiyuejian",
				"pname" : "泰越柬"
			}, {
				"pid" : "riben",
				"pname" : "日本"
			}, {
				"pid" : "hanguo",
				"pname" : "韩国wifi"
			}, {
				"pid" : "gangao",
				"pname" : "港澳"
			} ]
		} ]
	}, {
		"buid" : "BUSINESS_BU",
		"buname" : "商旅定制事业部"
	} ];

	// 初始化BU
	var bucode = function() {
		console.log('初始化BU');
//		var selectBuName = $('#selBuCode option:selected').val();
//		$('#selBuCode option:selected').html('');
//		$.each(areaDataJson, function(i, bucode) {
//			var option = "<option value='" + bucode.buid + "'>" + bucode.buname
//					+ "</option>";
//			console.log(bucode.buname);
//			console.log(selectBuName);
//			if(bucode.buname == selectBuName){
//				option = "<option value='" + bucode.buid + "' selected='selected'>" + bucode.buname
//				+ "</option>";
//			}
//			$("#selBuCode").append(option);
//		});
//		area1(2);
	};
	// 赋值大区 changFlag 1:bu改变;2:初始化
	var area1 = function(changFlag) {
		$('#selArea2').val('');
		$('#selArea2 option:selected').val('')
		// $("#selArea2").css("display","none");
		// $("#selArea1 option:gt(0)").remove();
		var n1 = $("#selBuCode").get(0).selectedIndex;
		var n;
		// 获取初始化的bu的位置
		if (n1 == 0 && changFlag == 1) {
			var obj = $("#selBuCode").get(0);
			var firstBu = obj.options[0].value;
			for (var i = 0; i < obj.options.length; i++) {
				var tmp = obj.options[i].value;
				if (i > 0 && tmp == firstBu) {
					n = i - 1;
					break;
				}
			}
		} else {
			n = $("#selBuCode").get(0).selectedIndex - 1;
		}

		if (typeof (areaDataJson[n].area1) != "undefined") {
			var option;
			$.each(areaDataJson[n].area1, function(i, area1) {
				option += "<option value='" + area1.aid + "'>" + area1.aname
						+ "</option>";
			});
			$("#selArea1").html(option);
		} else {
			$("#selArea1").html("<option value=''>请选择大区</option>");
		}
		area2(changFlag);
	};
	// 赋值分区
	var area2 = function(changFlag) {
		// $("#selArea2 option:gt(0)").remove();
		// var m = $("#selBuCode").get(0).selectedIndex-1;
		var m;
		var n1 = $("#selBuCode").get(0).selectedIndex;
		if (n1 == 0 && changFlag == 1) {
			var obj = $("#selBuCode").get(0);
			var firstBu = obj.options[0].value;
			for (var i = 0; i < obj.options.length; i++) {
				var tmp = obj.options[i].value;
				if (i > 0 && tmp == firstBu) {
					m = i - 1;
					break;
				}
			}
		} else {
			m = $("#selBuCode").get(0).selectedIndex - 1;
		}
		var n = $("#selArea1").get(0).selectedIndex;
		if (areaDataJson[m].area1&&typeof (areaDataJson[m].area1[n].area2) != "undefined") {
			$("#selArea2").css("display", "inline");
			var option;
			$.each(areaDataJson[m].area1[n].area2, function(i, area2) {
				option += "<option value='" + area2.pid + "'>" + area2.pname
						+ "</option>";
			});
			$("#selArea2").html(option);
		} else {
			$("#selArea2").css("display", "none");
		}
		;
	};
	// 选择省改变市
	$("#selBuCode").change(function() {
		area1(1);
	});
	// 选择市改变县
	$("#selArea1").change(function() {
		area2(1);
	});
	bucode();
});