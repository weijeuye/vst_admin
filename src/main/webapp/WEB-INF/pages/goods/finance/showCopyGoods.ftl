<form id="copySuppGoodsForm">
    <input type="hidden" id="copySuppGoodsId" name="copySuppGoodsId" value="${suppGoodsId!''}">
    <input type="hidden" id="copyProductId" name="copyProductId" value="${productId!''}">
    <input type="hidden" id="copyCategoryId" name="copyCategoryId" value="${categoryId!''}">
    <input type="hidden" id="copySupplierId" name="copySupplierId" value="${oldSupplierId!''}">
    <input type="hidden" id="copySupplierName" name="copySupplierName" value="${oldSupplierName!''}">
    <input type="hidden" id="newContract" name="newContract" value="">
    <table class="p_table form-inline">
        <tbody>
        <tr>
            <td colspan="5">新商品是否复制到其他供应商下？</td>
        </tr>
        <tr>
            <td colspan="5">
                &nbsp;&nbsp;<input id='yc' type="radio" name="copyFlag" checked="checked" value="0">否，复制到原供应商下</br>
                &nbsp;&nbsp;<input type="radio" name="copyFlag" value="1" id='nc'>是，选择其他供应商
            </td>
        </tr>

        <tr id="choiceSupplier" style="display: none">
            <td width="95px" class="e_label td_top"><i class="cc1">*</i>选择供应商：</td>
            <td class="w18" colspan='4'>
                <input type="text" placeholder="请输入供应商名称" class="w160 search" name="newSupplierName" id="newSupplierName"
                       value="">
                <input type="hidden" name="newSupplierId" id="newSupplierId" value="" required=true>
            </td>
        </tr>
        <tr>
            <td width="95px" class="e_label td_top"><i class="cc1">*</i>商品合同：</td>
            <td class="w18" colspan='4'>
                <label id="newContractName" name="newContractName"></label>
                <input type="hidden" id="contractIdCopy" name="contractId">
                <a id="newChange_button" href="javascript:void(0);">[更改]</a>
            </td>
        </tr>
        <tr>
            <td width="95px" class="p_label"><i class="cc1">*</i>结算对象：</td>
            <td colspan=4 id="settlementEntityTd">
                <input type="text" name="settlementEntityName" id="settlementEntityName" value="" required=true>
                <input type="hidden" name="settlementEntityCode" id="settlementEntityCode" value="" required=true>
                <input type="hidden" value="" name="settlementEntityId" id="settlementEntityId" required=true>
                <span name="settlementEntityDesc" id="settlementEntityDesc"></span>
            </td>
        </tr>
        </tbody>
    </table>
</form>
<div class="p_box box_info clearfix mb20">
    <div class=" operate" style="margin-top:20px;text-align:center;">
        <a class="btn btn_cc1" id="confirmCopy">确认</a>
        <a style="margin-left:60px;" class="btn btn_cc1" id="btnCancel">取消</a>
    </div>
</div>
<script type="text/javascript" src="/vst_admin/js/vst_settlement_util.js"></script>
<script>
    vst_pet_util.commListSuggest("#newSupplierName", "#newSupplierId", '/vst_back/supp/supplier/searchSupplierList.do', '${supplierJsonList}');
    vst_settlement_util.settleEntityCommListSuggest("#contractIdCopy");
    vst_settlement_util.settlementEntityNameBlur();
    vst_settlement_util.settlementEntityNameFocus("#contractIdCopy");
</script>
<script>

    $(".dialog-content").css({"height": "" + 281});
    $("#confirmCopy").bind('click', function () {
        //校验
        if ($("input[name='copyFlag']:checked").val() == "1") {
            if ($("#newSupplierId").val() == null || $("#newSupplierId").val() == "") {
                $.alert("请选择供应商！");
                return false;
            }
        }
        if ($("#contractIdCopy").val() == null || $("#contractIdCopy").val() == "") {
            $.alert("请选择商品合同！");
            return false;
        }
        if ($("#settlementEntityCode").val() == null || $("#settlementEntityCode").val() == "") {
            $.alert("请选择结算对象！");
            return false;
        }

        $("#newContract").val($("#newContractName").text());
        var msg = '确认复制吗 ？';
        $.confirm(msg, function () {
            //遮罩层
            var loading = top.pandora.loading("正在努力复制中...");
            $.ajax({
                url: "/vst_admin/finance/goods/copyGoods.do",
                type: "post",
                data: $(".dialog #copySuppGoodsForm").serialize(),
                success: function (result) {
                    loading.close();
                    if (result.code == "success") {
                        confirmAndRefresh(result);
                    } else {
                        $.alert(result.message);
                    }
                }
            });
        });
    });
    $("#btnCancel").click(function () {
        window.descDialog.close();
    });
    $("#newSupplierName").change(function () {
        clearContractAndSettle();
    });

    $("input[name='copyFlag']").click(function () {
        var copyFlagVal = $("input[name='copyFlag']:checked").val();
        clearContractAndSettle();
        if (copyFlagVal == "1") {
            $("#choiceSupplier").show();
        } else {
            $("#choiceSupplier").hide();
            $("#newSupplierId").val("");
            $("#newSupplierName").val("");
        }
    });

    function clearContractAndSettle() {
        $("#newContractName").text("");
        $("#contractIdCopy").val("");
        $("#settlementEntityName").val("");
        $("#settlementEntityCode").val("");
        $("#settlementEntityId").val("");
        $("#settlementEntityDesc").text("");
    }

    var selectCopyContractDialog;

    //供应商合同回调函数
    function onSelectContractCopy(params) {
        if (params != null) {
            $("#newContractName").text(params.contractName);
            $("#contractIdCopy").val(params.contractId);
            vst_settlement_util.resetSelectSettleEntityNameInput();
        }
        selectCopyContractDialog.close();
    }

    //打开选择供应商合同列表
    $("#newChange_button").click(function () {
        var querysupplierId = "";
        if ($("input[name='copyFlag']:checked").val() == "1") {
            if ($("#newSupplierId").val() != null && $("#newSupplierId").val() != "") {
                querysupplierId = $("#newSupplierId").val();
            } else {
                $.alert("请先选择供应商！");
                return false;
            }
        } else {
            querysupplierId = $("#copySupplierId").val();
        }
        selectCopyContractDialog = new xDialog("/vst_back/supp/suppContract/selectContractListBySupplier.do?callback=onSelectContractCopy&supplierId=" + querysupplierId, {}, {
            title: "选择供应商合同", width: "600"
        });
        $("a.showContract").unbind();
    });
</script>

