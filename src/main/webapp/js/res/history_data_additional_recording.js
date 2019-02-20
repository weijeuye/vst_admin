//TODO 开发维护
$(function() {

	var $document = $(document);

	// 添加
	$document
			.on(
					"click",
					"#addHDARBtnId",
					function() {
						var resourceControlId = $('#resourceControlId').val();
						if (null == resourceControlId
								|| '' == resourceControlId) {
							alert('预控ID不能为空');
							return;
						}
						var goodslId = $('#goodslId').val();
						if (null == goodslId || '' == goodslId) {
							alert('商品ID不能为空');
							return;
						}
						var startDate = $('#startDate').val();
						if (null == startDate || '' == startDate) {
							alert('补录起时间不能为空');
							return;
						}
						var endDate = $('#endDate').val();
						if (null == endDate || '' == endDate) {
							alert('补录止时间不能为空');
							return;
						}

						// 添加一行记录
						var trs = $('#resourceControlTableId').find('tbody')
								.find('tr');
						var isRepeat = false;
						$.each(trs, function(i, n) {
							if (resourceControlId == $(n).attr(
									'resourceControlId')
									&& goodslId == $(n).attr('goodslId')
									&& startDate == $(n).attr('startDate')
									&& endDate == $(n).attr('endDate')) {
								isRepeat = true;
								return false;
							}
						});
						if (isRepeat) {
							alert('补录数据不能重复添加');
							return;
						}
						// 校验是否符合要求
						var dataJsonObj = {};
						// 预控ID
						dataJsonObj['resId'] = resourceControlId;
						// 商品ID
						dataJsonObj['goodsId'] = goodslId;
						// 补录开始时间
						dataJsonObj['startDate'] = startDate;
						// 补录结束时间
						dataJsonObj['endDate'] = endDate;
						// 补录类型（已绑定商品补录bindGoods，无效产品补录invalidGoods）
						var $li = $('.JS_tab_main li').filter(".active");
						dataJsonObj['rcType'] = $li.attr('data');
						$
								.ajax({
									url : "/vst_admin/percontrol/checkHistoryDataAdditionalRecoding.do",
									type : "POST",
									cache : false,
									dataType : "json",
									async : false,
									data : dataJsonObj,
									success : function(result) {
										if (result.success) {
											// 添加一行记录
											$('#resourceControlTableId')
													.find('tbody')
													.append(
															'<tr resourceControlId='
																	+ resourceControlId
																	+ ' goodslId='
																	+ goodslId
																	+ ' startDate = '
																	+ startDate
																	+ ' endDate = '
																	+ endDate
																	+ '><td>'
																	+ resourceControlId
																	+ '</td><td>'
																	+ goodslId
																	+ '</td><td>'
																	+ startDate
																	+ '</td><td>'
																	+ endDate
																	+ '</td><td><a href="#" class="updateResControl" >修改</a>&nbsp;&nbsp;<a href="#" class="deleteResControl">删除</a></td></tr>');
											$('#resourceControlId').val(null);
											$('#goodslId').val(null);
											$('#startDate').val(null);
											$('#endDate').val(null);
										} else {
											alert(result.msg);
										}
									}
								});
					});

	// 删除
	$document.on("click", ".deleteResControl", function() {
		var $tr = $(this).parent().parent();
		backstage.confirm({
			content : "删除不能恢复，确认删除吗？",
			determineCallback : function() {
				$tr.remove();
			}
		});
	});

	// 修改
	$document.on("click", ".updateResControl", function() {
		var $tr = $(this).parent().parent();
		$('#resourceControlId').val($tr.attr('resourceControlId'));
		$('#goodslId').val($tr.attr('goodslId'));
		$('#startDate').val($tr.attr('startDate'));
		$('#endDate').val($tr.attr('endDate'));
		$tr.remove();
	});

	var parent = window.parent;

	// 提交
	$document
			.on(
					"click",
					"#hdSubmitId",
					function() {
						var $li = $('.JS_tab_main li').filter(".active");

						var trs = $('#resourceControlTableId').find('tbody')
								.find('tr');
						if (!trs || trs.length == 0) {
							alert('请添加需要补录的历史数据');
							return;
						}

						backstage
								.confirm({
									content : "确认提交吗？",
									determineCallback : function() {
										var dataJsonObj = {};
										var $li = $('.JS_tab_main li').filter(
												".active");
										dataJsonObj['arType'] = $li
												.attr('data');
										$
												.each(
														trs,
														function(i, n) {
															dataJsonObj['resPrecontrolBindGoodsVos['
																	+ i
																	+ '].precontrolPolicyId'] = $(
																	n)
																	.attr(
																			'resourceControlId');
															dataJsonObj['resPrecontrolBindGoodsVos['
																	+ i
																	+ '].goodsId'] = $(
																	n).attr(
																	'goodslId');
															dataJsonObj['resPrecontrolBindGoodsVos['
																	+ i
																	+ '].startDate'] = $(
																	n)
																	.attr(
																			'startDate');
															dataJsonObj['resPrecontrolBindGoodsVos['
																	+ i
																	+ '].endDate'] = $(
																	n).attr(
																	'endDate');
														});
										$
												.ajax({
													url : "/vst_admin/percontrol/historyDataAditionalRecording.do",
													type : "POST",
													cache : false,
													dataType : "json",
													async : false,
													data : dataJsonObj,
													success : function(result) {
														// 返回成功则关闭当前窗口
														if (result.success) {
															backstage
																	.alert({
																		content : '提交成功'
																	});
															parent.dialogViewOrder.destroy();
														} else {
															backstage
																	.alert({
																		content : "保存失败,"
																				+ result.msg
																	});
														}
													}
												});
									}
								});
					});

	// 取消
	$document.on("click", "#hdCancelId", function() {
		parent.dialogViewOrder.destroy();
	});

	// 已绑定商品、无效产品补录切换
	$document.on("click", ".JS_tab_main li", function() {
		var $th = $(this);
		var data = $th.attr('data');
		if (data == 'bindGoods') {
			// $th.siblings('li').removeAttr('data');
		} else {
			// $('#addHDARBtnId').hide();
		}
		var index = $(this).index();
		$(this).attr('class', 'active').siblings('li').removeAttr('class',
				'active');

		// $('.JS_tab_main').eq(index).show().siblings('.tabcontent').hide();
	});
});