<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
    <style type="text/css">
        label {
            margin: 0px;
        }
    </style>
</head>
<body>
<div class="iframe_header">
    <div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
        <p class="pl15">1. 门票品类展示的优先级是景点门票》组合套餐票》其他票。</p>
        <p class="pl15">2. 门票票种展示的优先级：成人票》儿童票》学生票》亲子票》家庭票》情侣票》双人票》团体票》优待票（即“活动票”）》老人票》教师票》军人票》残疾票》相关票（即“自定义”）</p>
    </div>
    <ul class="iframe_nav">
        <li><a href="#">${(prodProduct.bizCategory.categoryName)!''}</a> &gt;</li>
        <li><a href="#">商品维护</a> &gt;</li>
        <li class="active">商品排序</li>
    </ul>
</div>
<div class="iframe_content mt10">
    <div class="p_box box_info">
        <form method="get" action='/vst_admin/ticket/goods/goods/showSuppGoodsOrder.do' id="searchForm">
            <input type="hidden" name="prodProduct.bizCategory.categoryName" value="${prodProduct.bizCategory.categoryName!''}">
            <input type="hidden" name="productId" value="${prodProduct.productId!''}">
            <input type="hidden" name="prodProduct.bizCategory.categoryId" value="${prodProduct.bizCategory.categoryId!''}">

            <div class="fl operate">
                <a class = "btn btn_cc1" id="save">保存</a>
            </div>
            <table>
                <tbody>
                <tr>
                    <td class="s_label">
                        <label>销售渠道：</label>
                    </td>
                    <td>
                        <select class="form-control w90" name="distributorId">
						<#list distributorList as distributor>
                            <option value=${distributor.distributorId!''} <#if distributor.distributorId == distributorId >selected</#if> >${distributor.distributorName!''}</option>
						</#list>
                        </select>
                    </td>
                    <td class="s_label">
                        <label>门票品类：</label>
                    </td>
                    <td>
                        <select class="form-control w90" name="categoryId">
						<#list bizCategoryList as bizCategory>
                            <option value=${bizCategory.categoryId!''} <#if bizCategory.categoryId == categoryId >selected</#if> >${bizCategory.categoryName!''}</option>
						</#list>
                        </select>
                    </td>
					<#if showGoodsSpec>
						<td class="s_label"><label>门票票种：</label></td>
						<td>
							<select class="form-control w90" name="goodsSpecCode">
							<#list goodsSpecList as goodsSpec>
								<option value=${goodsSpec.code!''} <#if goodsSpec.code == goodsSpecCode>selected</#if> >${goodsSpec.specName!''}</option>
							</#list>
							</select>
						</td>
					</#if>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <!-- 主要内容显示区域\\ -->
<#if suppGoodsOrderList??>
	<div class="p_box box_info">
		<#if suppGoodsOrderList?? && suppGoodsOrderList?size &gt; 0>
			<table class="p_table table_center" id="suppGoodsOrderList">
				<thead>
				<tr>
					<th>门票品类</th>
					<#if goodsSpecCode>
					<th>门票票种</th>
					</#if>
					<th>对象ID</th>
					<th>名称</th>
					<th>供应商</th>
					<th>支付方式</th>
					<th>排序</th>
				</tr>
				</thead>
				<tbody>
					<#list suppGoodsOrderList as suppGoodsOrder>
						<tr>
                            <td name="suppGoodsOrderId" style="display: none">${suppGoodsOrder.suppGoodsOrderId}</td>
							<td name="destId" style="display: none">${suppGoodsOrder.destId}</td>
                            <td name="distributorId" style="display: none">${suppGoodsOrder.distributorId}</td>
							<td>${suppGoodsOrder.bizCategory.categoryName}</td>
						<#if goodsSpecCode>
							<td>${suppGoodsOrder.goodsSpecName}</td>
						</#if>
                            <td name="objectId">${suppGoodsOrder.objectId!''}</td>
                            <td name="objectType" style="display: none">${suppGoodsOrder.objectType}</td>
                            <td name="categoryId" style="display: none">${suppGoodsOrder.categoryId}</td>
                            <td name="goodsSpec" style="display: none">${suppGoodsOrder.goodsSpec}</td>
							<td>${suppGoodsOrder.goodsName!''}</td>
							<td><#if  suppGoodsOrder.suppSupplier??>${suppGoodsOrder.suppSupplier.supplierName!''}</#if></td>
							<td>
								<#list payTargetList as list>
										<#if suppGoodsOrder?? && suppGoodsOrder.payTarget==list.code>${list.cnName!''}</#if>
								</#list>
							</td>
							<td>
								<input name="seq" value=${suppGoodsOrder.seq} type="number">
							</td>
						</tr>
					</#list>
                </tbody>
			</table>
		<#else>
                    <div class="no_data mt20"><i class="icon-warn32"></i>暂无相关产品，重新输入相关条件查询！</div>
		</#if>
	</div>
</#if>
</div>
<!-- //主要内容显示区域 -->

<#include "/base/foot.ftl"/>
</body>
</html>

<script>
	var suppGoodsOrderList = [];
    function querySuppGoods() {
        $('#searchForm').submit();
    }

	function indexOf(arr, item) {
        for (var i = 0; i < arr.length; i++) {
            var obj = arr[i];
			if (item.objectType == obj.objectType && item.objectId == obj.objectId) {
				return i;
			}
        }
		return -1;
	}

	function findValueInTdByName(tr, name) {
		return tr.find('td[name='+name+']').html().trim();
	}

	function getSeqInInput(input) {
		var val = input.val().trim();
		if (val == "") {
			return "该模块排序值不为空。";
		}
		if (val.indexOf(".") >= 0) {
			return "该模块排序值为整数。";
		}
		if (val == parseInt(val)) {
			return parseInt(val);
		}
		return "该模块排序值为整数。";
	}

	function fillWithNewOrder() {
		$('#suppGoodsOrderList tbody tr').each(function(i, tr) {
			var seqValue =getSeqInInput($(tr).find('input[name=seq]'));
			getAndValidateSuppGoodsOrder($(tr), seqValue, false);
		});
	}

	function getAndValidateSuppGoodsOrder(tr, seqValue, fromChangeEvent) {
        if (typeof seqValue == "string") {
			$.alert(seqValue);
			return;
        }
        var sgOrder = {
            suppGoodsOrderId: findValueInTdByName(tr, 'suppGoodsOrderId'),
            destId: findValueInTdByName(tr, 'destId'),
            distributorId: findValueInTdByName(tr, 'distributorId'),
            objectId: findValueInTdByName(tr, 'objectId'),
            objectType: findValueInTdByName(tr, 'objectType'),
            categoryId: findValueInTdByName(tr, 'categoryId'),
            goodsSpec: findValueInTdByName(tr, 'goodsSpec'),
            seq: seqValue
        }
        var foundSGOrder = indexOf(suppGoodsOrderList, sgOrder);
        if (foundSGOrder >= 0) {
			if (fromChangeEvent) {
                suppGoodsOrderList[foundSGOrder].seq = sgOrder.seq;
            }
        } else {
			if (fromChangeEvent || sgOrder.suppGoodsOrderId == "") {
                suppGoodsOrderList.push(sgOrder);
			}
        }
	}

    $(function () {
        $('#searchForm select').change(function(event) {
            querySuppGoods();
        });
		$('#suppGoodsOrderList input').change(function(event){
			var seqInput = $(this);
			var tr = seqInput.closest('tr');
			var seqValue = getSeqInInput(seqInput);
            getAndValidateSuppGoodsOrder(tr, seqValue, true);
		});
		$('#save').click(function() {
			fillWithNewOrder();
			if (suppGoodsOrderList.length == 0) {
				return;
			}
            console.log(suppGoodsOrderList);
            $.ajax({
                url : "/vst_admin/ticket/goods/goods/saveSuppGoodsOrder.do",
                type : "post",
                async: false,
                dataType : 'json',
				contentType: 'application/json',
				data:JSON.stringify(suppGoodsOrderList),
                success : function(result) {
                    if(result.code == "fail") {
                        $.alert(result.message);
                    } else {
						querySuppGoods();
					}
                },
                error : function(result) {
                    $.alert(result.message);
                }
            });
		});
    });
</script>